# -*- coding: utf-8 -*-
from odoo import fields, models, api, tools, _
from odoo.tools import DEFAULT_SERVER_DATETIME_FORMAT as DTF
from odoo.exceptions import Warning
from itertools import groupby
from datetime import date,datetime
import logging
_logger = logging.getLogger(__name__)
import json
import MySQLdb
import requests
from requests.auth import HTTPBasicAuth

class ProviderProvider(models.Model):
    _name = "provider.provider"
    _description = 'Provider'

    name = fields.Char('Name', required=True)
    uuid = fields.Char('UUID', help='Synced from Bahmni')
    
class ProductTempalte(models.Model):
    _inherit = "product.template"

    drug_type = fields.Selection([
        ('solid', 'Solid'),
        ('fluid', 'Fluid'),
        ('liquid', 'Liquid'),
        ], string='Drug Type', copy=False)

#class ProductProduct(models.Model):
#    _inherit = "product.product"
#
#    def get_onhand_qty(self):
#        qty_available = self.qty_available
#        return qty_available

class OrderSaveService(models.Model):
    _inherit = 'order.save.service'
    
    @api.model
    def _id_facture(self):
        data = requests.get('https://127.0.0.1/openmrs/ws/rest/v1/provider?v=custom:(display,uuid,person)',verify=False,auth=HTTPBasicAuth('superman', 'Admin123'),headers={'Content-Type':'application/json'})
        datatwo = data.json()
        for results in datatwo['results']:
            per = results.get("display")
            if(per):
                uuid = results.get("uuid")
                provider_name =results.get("person").get("display")
                provider_exit = self.env['provider.provider'].search([('name', '=', str(provider_name))], limit=1)
                if not provider_exit:
                    provider_vals = {'name': provider_name,'uuid': uuid}
                    provider_id = self.env['provider.provider'].sudo().create(provider_vals)

    @api.model
    def _create_sale_order_line_function(self, sale_order, order):
        stored_prod_ids = self._get_product_ids(order)

        if(stored_prod_ids):
            prod_id = stored_prod_ids[0]
            prod_obj = self.env['product.product'].browse(prod_id)
            sale_order_line_obj = self.env['sale.order.line']
            prod_lot = sale_order_line_obj.get_available_batch_details(prod_id, sale_order)

            actual_quantity = order['quantity']
            comments = " ".join([tools.ustr(actual_quantity), tools.ustr(order.get('quantityUnits', None))])

            default_quantity_total = self.env.ref('bahmni_sale.group_default_quantity')
            _logger.info("DEFAULT QUANTITY TOTAL")
            _logger.info(default_quantity_total)
            default_quantity_value = 1
            if default_quantity_total and len(default_quantity_total.users) > 0:
                default_quantity_value = -1

            order['quantity'] = self._get_order_quantity(order, default_quantity_value)
            product_uom_qty = order['quantity']
            if(prod_lot != None and order['quantity'] > prod_lot.stock_forecast):
                product_uom_qty = prod_lot.stock_forecast

            order_line_dispensed = True if order.get('dispensed') == 'true' or (order.get('dispensed') and order.get('dispensed') != 'false') else False
            sale_order_line = {
                'product_id': prod_id,
                'price_unit': prod_obj.list_price,
                'comments': comments,
                'product_uom_qty': product_uom_qty,
                'product_uom': prod_obj.uom_id.id,
                'order_id': sale_order,
                'external_id':order['encounterId'],
                'external_order_id':order['orderId'],
                'name': prod_obj.name,
                'type': 'make_to_stock',
                'state': 'draft',
                'dispensed': order_line_dispensed
            }

            if prod_lot != None:
                life_date = prod_lot.life_date and datetime.strptime(prod_lot.life_date, DTF)
                if self.env.ref('bahmni_sale.sale_price_basedon_cost_price_markup').value == '1':
                    sale_order_line['price_unit'] = prod_lot.sale_price if prod_lot.sale_price > 0.0 else sale_order_line['price_unit']
                sale_order_line['batch_name'] = prod_lot.name
                sale_order_line['batch_id'] = prod_lot.id
                sale_order_line['expiry_date'] = life_date and life_date.strftime(DTF)
            
            
            sale_obj = self.env['sale.order'].browse(sale_order)
            sale_line = sale_order_line_obj.create(sale_order_line)
            
            sale_line._compute_tax_id()
            if sale_obj.pricelist_id:
                line_product = prod_obj.with_context(
                    lang = sale_obj.partner_id.lang,
                    partner = sale_obj.partner_id.id,
                    quantity = sale_line.product_uom_qty,
                    date = sale_obj.date_order,
                    pricelist = sale_obj.pricelist_id.id,
                    uom = prod_obj.uom_id.id
                )
                price = self.env['account.tax']._fix_tax_included_price_company(sale_line._get_display_price(prod_obj), prod_obj.taxes_id, sale_line.tax_id, sale_line.company_id)
                sale_line.price_unit = price

            if product_uom_qty != order['quantity']:
                order['quantity'] = order['quantity'] - product_uom_qty
                self._create_sale_order_line_function(sale_order, order)
    
    @api.model
    def create_orders(self, vals):
        customer_id = vals.get("customer_id")
        location_name = vals.get("locationName")
        all_orders = self._get_openerp_orders(vals)

        if not all_orders:
            return ""

        customer_ids = self.env['res.partner'].search([('ref', '=', customer_id)])
        if customer_ids:
            cus_id = customer_ids[0]

            for orderType, ordersGroup in groupby(all_orders, lambda order: order.get('type')):

                order_type_def = self.env['order.type'].search([('name','=',orderType)])
                if (not order_type_def):
                    _logger.info("\nOrder Type is not defined. Ignoring %s for Customer %s",orderType,cus_id)
                    continue

                orders = list(ordersGroup)
                care_setting = orders[0].get('visitType').lower()
                provider_name = orders[0].get('providerName')
                # will return order line data for products which exists in the system, either with productID passed
                # or with conceptName
                unprocessed_orders = self._filter_processed_orders(orders)
                _logger.info("\n DEBUG: Unprocessed Orders: %s", unprocessed_orders)
                shop_id, location_id = self._get_shop_and_location_id(orderType, location_name, order_type_def)
                # shop_id = tup[0]
                # location_id = tup[1]

                if (not shop_id):
                    err_message = "Can not process order. Order type:{} - should be matched to a shop".format(orderType)
                    _logger.info(err_message)
                    raise Warning(err_message)
                    
                
                shop_obj = self.env['sale.shop'].search([('id','=',shop_id)])
                warehouse_id = shop_obj.warehouse_id.id
                _logger.warning("warehouse_id: %s"%(warehouse_id))

                name = self.env['ir.sequence'].next_by_code('sale.order')
                #Adding both the ids to the unprocessed array of orders, Separating to dispensed and non-dispensed orders
                unprocessed_dispensed_order = []
                unprocessed_non_dispensed_order = []
                for unprocessed_order in unprocessed_orders:
                    unprocessed_order['location_id'] = location_id
                    unprocessed_order['warehouse_id'] = warehouse_id
                    if(unprocessed_order.get('dispensed', 'false') == 'true'):
                        unprocessed_dispensed_order.append(unprocessed_order)
                    else:
                        unprocessed_non_dispensed_order.append(unprocessed_order)

                if(len(unprocessed_non_dispensed_order) > 0):
                    _logger.debug("\n Processing Unprocessed non dispensed Orders: %s", list(unprocessed_non_dispensed_order))
                    sale_order_ids = self.env['sale.order'].search([('partner_id', '=', cus_id.id),
                                                                    ('shop_id', '=', shop_id),
                                                                    ('state', '=', 'draft'),
                                                                    ('origin', '=', 'ATOMFEED SYNC')])
                    if(not sale_order_ids):
                        # Non Dispensed New
                        # replaced create_sale_order method call
                        _logger.debug("\n No existing sale order for Unprocessed non dispensed Orders. Creating .. ")
                        sale_order_vals = {'partner_id': cus_id.id,
                                           'location_id': unprocessed_non_dispensed_order[0]['location_id'],
                                           'warehouse_id': unprocessed_non_dispensed_order[0]['warehouse_id'],
                                           'care_setting': care_setting,
                                           'date_order': datetime.strftime(datetime.now(), DTF),
                                           'pricelist_id': cus_id.property_product_pricelist and cus_id.property_product_pricelist.id or False,
                                           'payment_term_id': shop_obj.payment_default_id.id,
                                           'project_id': shop_obj.project_id.id if shop_obj.project_id else False,
                                           'picking_policy': 'direct',
                                           'state': 'draft',
                                           'shop_id': shop_id,
                                           'origin': 'ATOMFEED SYNC',
                                           'location_name': location_name
                                           }
                        provider_exit = self.env['provider.provider'].search([('name', '=', provider_name)], limit=1)
                        if provider_exit:
                            sale_order_vals.update({'provider_name': provider_exit and provider_exit.id or False})
                        else:
                            provider_vals = {'name': provider_name}
                            provider_id = self.env['provider.provider'].sudo().create(provider_vals)
                            sale_order_vals.update({'provider_name': provider_id and provider_id.id or False})
                                    
                        if shop_obj.pricelist_id:
                            sale_order_vals.update({'pricelist_id': shop_obj.pricelist_id.id})
                        sale_order = self.env['sale.order'].create(sale_order_vals)
                        _logger.debug("\n Created a new Sale Order for non dispensed orders. ID: %s. Processing order lines ..", sale_order.id)
                        for rec in unprocessed_non_dispensed_order:
                            self._process_orders(sale_order, unprocessed_non_dispensed_order, rec)
                    else:
                        # Non Dispensed Update
                        # replaced update_sale_order method call
                        for order in sale_order_ids:
                            order.write({'care_setting': care_setting})
                            provider_exit = self.env['provider.provider'].search([('name', '=', provider_name)], limit=1)
                            if provider_exit:
                                order.write({'provider_name': provider_exit and provider_exit.id or False})
                            else:
                                provider_vals = {'name': provider_name}
                                provider_id = self.env['provider.provider'].sudo().create(provider_vals)
                                order.write({'provider_name': provider_id and provider_id.id or False})
                            for rec in unprocessed_non_dispensed_order:
                                self._process_orders(order, unprocessed_non_dispensed_order, rec)
                            # break from the outer loop
                            break


                if (len(unprocessed_dispensed_order) > 0):
                    _logger.debug("\n Processing Unprocessed dispensed Orders: %s", list(unprocessed_dispensed_order))
                    auto_convert_dispensed = self.env['ir.values'].search([('model', '=', 'sale.config.settings'),
                                                                           ('name', '=', 'convert_dispensed')]).value
                    auto_invoice_dispensed = self.env.ref('bahmni_sale.auto_register_invoice_payment_for_dispensed').value


                    sale_order_ids = self.env['sale.order'].search([('partner_id', '=', cus_id.id),
                                                                    ('shop_id', '=', shop_id),
                                                                    ('state', '=', 'draft'),
                                                                    ('origin', '=', 'ATOMFEED SYNC')])

                    if any(sale_order_ids):
                        _logger.debug("\n For exsiting sale orders for the shop, trying to unlink any openmrs order if any")
                        self._unlink_sale_order_lines_and_remove_empty_orders(sale_order_ids,unprocessed_dispensed_order)

                    sale_order_ids_for_dispensed = self.env['sale.order'].search([('partner_id', '=', cus_id.id),
                                                                                  ('shop_id', '=', shop_id),
                                                                                  ('location_id', '=', location_id),
                                                                                  ('state', '=', 'draft'),
                                                                                  ('origin', '=', 'ATOMFEED SYNC')])

                    if not sale_order_ids_for_dispensed:
                        _logger.debug("\n Could not find any sale_order at specified shop and stock location. Creating a new Sale order for dispensed orders")

                        sale_order_dict = {'partner_id': cus_id.id,
                                           'location_id': location_id,
                                           'warehouse_id': warehouse_id,
                                           'care_setting': care_setting,
                                           'date_order': datetime.strftime(datetime.now(), DTF),
                                           'pricelist_id': cus_id.property_product_pricelist and cus_id.property_product_pricelist.id or False,
                                           'payment_term_id': shop_obj.payment_default_id.id,
                                           'project_id': shop_obj.project_id.id if shop_obj.project_id else False,
                                           'picking_policy': 'direct',
                                           'state': 'draft',
                                           'shop_id': shop_id,
                                           'origin': 'ATOMFEED SYNC',
                                           'location_name': location_name,
                                           }
                        provider_exit = self.env['provider.provider'].search([('name', '=', provider_name)], limit=1)
                        if provider_exit:
                            sale_order_dict.update({'provider_name': provider_exit and provider_exit.id or False})
                        else:
                            provider_vals = {'name': provider_name}
                            provider_id = self.env['provider.provider'].sudo().create(provider_vals)
                            sale_order_dict.update({'provider_name': provider_id and provider_id.id or False})
                        if shop_obj.pricelist_id:
                            sale_order_dict.update({'pricelist_id': shop_obj.pricelist_id.id})
                        new_sale_order = self.env['sale.order'].create(sale_order_dict)
                        _logger.debug("\n Created a new Sale Order. ID: %s. Processing order lines ..", new_sale_order.id)
                        for line in unprocessed_dispensed_order:
                            self._process_orders(new_sale_order, unprocessed_dispensed_order, line)

                        if auto_convert_dispensed:
                            _logger.debug("\n Confirming delivery and payment for the newly created sale order..")
                            new_sale_order.auto_validate_delivery()
                            if auto_invoice_dispensed == '1':
                                new_sale_order.validate_payment()

                    else:
                        _logger.debug("\n There are other sale_orders at specified shop and stock location.")
                        sale_order_to_process = None
                        if not auto_convert_dispensed:
                            # try to find an existing sale order to add the openmrs orders to
                            if any(sale_order_ids_for_dispensed):
                                _logger.debug("\n Found a sale order to append dispensed lines. ID : %s",sale_order_ids_for_dispensed[0].id)
                                sale_order_to_process = sale_order_ids_for_dispensed[0]

                        if not sale_order_to_process:
                            # create new sale order
                            _logger.debug("\n Post unlinking of order lines. Could not find  a sale order to append dispensed lines. Creating .. ")
                            sales_order_obj = {'partner_id': cus_id.id,
                                               'location_id': location_id,
                                               'warehouse_id': warehouse_id,
                                               'care_setting': care_setting,
                                               'date_order': datetime.strftime(datetime.now(), DTF),
                                               'pricelist_id': cus_id.property_product_pricelist and cus_id.property_product_pricelist.id or False,
                                               'payment_term_id': shop_obj.payment_default_id.id,
                                               'project_id': shop_obj.project_id.id if shop_obj.project_id else False,
                                               'picking_policy': 'direct',
                                               'state': 'draft',
                                               'shop_id': shop_id,
                                               'origin': 'ATOMFEED SYNC'}
                            provider_exit = self.env['provider.provider'].search([('name', '=', provider_name)], limit=1)
                            if provider_exit:
                                sales_order_obj.update({'provider_name': provider_exit and provider_exit.id or False})
                            else:
                                provider_vals = {'name': provider_name}
                                provider_id = self.env['provider.provider'].sudo().create(provider_vals)
                                sales_order_obj.update({'provider_name': provider_id and provider_id.id or False})

                            if shop_obj.pricelist_id:
                                sales_order_obj.update({'pricelist_id': shop_obj.pricelist_id.id})
                            sale_order_to_process = self.env['sale.order'].create(sales_order_obj)
                            _logger.info("\n DEBUG: Created a new Sale Order. ID: %s", sale_order_to_process.id)

                        _logger.debug("\n Processing dispensed lines. Appending to Order ID %s", sale_order_to_process.id)
                        for line in unprocessed_dispensed_order:
                            self._process_orders(sale_order_to_process, unprocessed_dispensed_order, line)

                        if auto_convert_dispensed and sale_order_to_process:
                            _logger.debug("\n Confirming delivery and payment ..")
                            sale_order_to_process.auto_validate_delivery()
                            # TODO: payment validation checks
                            # TODO: 1) Should be done through a config "sale.config.settings"[auto_invoice_dispensed]"
                            # TODO: 2) Should check the invoice amount. Odoo fails/throws-error if the invoice amount is 0.
                            if auto_invoice_dispensed == '1':
                                sale_order_to_process.validate_payment()

        else:
            raise Warning("Patient Id not found in Odoo")

class SaleOrder(models.Model):
    _inherit = 'sale.order'
    
    location_name = fields.Char('Location Name')
    provider_name = fields.Many2one('provider.provider', string="Provider Name", required=True,  onchange="_onchange_provider_name")

    
    @api.onchange('provider_name')
    def _onchange_provider_name(self):
        data = requests.get('https://127.0.0.1/openmrs/ws/rest/v1/provider?v=custom:(display,uuid,person)',verify=False,auth=HTTPBasicAuth('superman', 'Admin123'),headers={'Content-Type':'application/json'})
        datatwo = data.json()
        for results in datatwo['results']:
            per = results.get("display")
            if(per):
                uuid = results.get("uuid")
                provider_name =results.get("person").get("display")
                provider_exit = self.env['provider.provider'].search([('name', '=', str(provider_name))], limit=1)
                if not provider_exit:
                    provider_vals = {'name': provider_name,'uuid': uuid}
                    provider_id = self.env['provider.provider'].sudo().create(provider_vals)


    @api.multi
    def action_confirm(self):
        res = super(SaleOrder,self).action_confirm()
        host = self.env.ref('odoo_openmrs_connector.host').value
        database = self.env.ref('odoo_openmrs_connector.database_name').value
        username = self.env.ref('odoo_openmrs_connector.username').value
        password = self.env.ref('odoo_openmrs_connector.password').value
        port = self.env.ref('odoo_openmrs_connector.port').value
        
        db = MySQLdb.connect(host=host, port=int(port), user=username, passwd=password, db=database)
        cursor = db.cursor()
        
        now = datetime.now()
        for line in self.order_line:
            if line.external_order_id:
                # For concept ID
                cursor.execute("select concept_id from concept_name where name='dispensed'")
                concept_result = cursor.fetchone()
                # For Orders
                cursor.execute("SELECT patient_id,encounter_id,order_id,creator,voided,order_type_id from orders where uuid='%s'"%line.external_order_id)
                order_result = cursor.fetchone()
                
                # For Order Type
                cursor.execute("SELECT name from order_type where order_type_id='%d'"%order_result[5])
                order_type_name = cursor.fetchone()
                
                if order_type_name[0] == 'Drug Order':
                    location_name = ''
                    if self.location_name:
                        location_name = self.location_name
                    # For Location ID
                    cursor.execute("SELECT location_id from location where name='%s'"%location_name)
                    location_name_result = cursor.fetchone()
                    if order_result and location_name_result:
                        # Insert in OBS Table
                        cursor.execute("INSERT INTO obs(person_id,concept_id,encounter_id,order_id,obs_datetime,status,uuid,creator, date_created,voided,value_coded,location_id) values (%d,%d,%d,%d,now(),'FINAL',UUID(),%d,now(),%d,1,%d) " %(order_result[0],concept_result[0],order_result[1],order_result[2],order_result[3],order_result[4],location_name_result[0]))
                        db.commit()
        #except MySQLdb.Error, e:
        #    _logger.error("Error %d: %s" % (e.args[0], e.args[1]))
        #finally:
        #    if cursor and db:
        #        cursor.close()
        #        db.close()
        return res
        
class StockProductionLot(models.Model):
    _inherit = 'stock.production.lot'
    
    @api.depends('product_id')
    def _get_future_stock_forecast(self):
        """ Gets stock of products for locations
        @return: Dictionary of values
        """
        for lot in self:
            if self._context is None:
                context = {}
            else:
                context = self._context.copy()
            if 'location_id' not in context or context['location_id'] is None:
                locations = self.env['stock.location'].search([('usage', '=', 'internal')])
            elif context.get('search_in_child', False):
                #locations = self.env['stock.location'].search([('location_id', 'child_of', context['location_id'])]) or [context['location_id']]
                locations = self.env['stock.location'].search([('location_id', 'child_of', context['location_id'])])
            else:
                context['location_id'] = 15
                locations = self.env['stock.production.lot'].browse(context.get('location_id'))
            if locations:
                self._cr.execute('''select
                        lot_id,
                        sum(qty)
                    from
                        stock_quant
                    where
                        location_id IN %s and lot_id = %s 
                        group by lot_id''',
                        (tuple(locations.ids), lot.id,))
                result = self._cr.dictfetchall()
                if result and result[0]:
                    lot.stock_forecast = result[0].get('sum')

                    product_uom_id = context.get('product_uom', None)
                    if(product_uom_id):
                        product_uom = self.env['product.uom'].browse(product_uom_id)
                        lot.stock_forecast = result[0].get('sum') * product_uom.factor
    


