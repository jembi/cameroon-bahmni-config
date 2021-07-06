# -*- coding: utf-8 -*-
from odoo import models, fields, api, _
from odoo.tools import float_compare
import datetime
from odoo.exceptions import UserError



class StockProductionLot(models.Model):
    _inherit = 'stock.production.lot'
    _order = 'life_date asc'
    
    @api.model
    def name_search(self, name='', args=None, operator='ilike', limit=100):
        args = args or []
        if self._context.get('is_sale_order_line'):
            today_date = datetime.datetime.utcnow().date()
            today_start = fields.Datetime.to_string(today_date)
            args += [('life_date', '>=', today_start)]
        return super(StockProductionLot, self).name_search(name, args, operator=operator, limit=limit)
    

class SaleOrderLine(models.Model):
    _inherit = 'sale.order.line'

    @api.onchange('product_uom_qty', 'product_uom', 'route_id')
    def _onchange_product_id_check_availability(self):
        if not self.product_id or not self.product_uom_qty or not self.product_uom:
            self.product_packaging = False
            return {}
        if self.product_id.type == 'product':
            precision = self.env['decimal.precision'].precision_get('Product Unit of Measure')
            product_qty = self.product_uom._compute_quantity(self.product_uom_qty, self.product_id.uom_id)
            if float_compare(self.product_id.virtual_available, product_qty, precision_digits=precision) == -1:
                is_available = self._check_routing()
                if not is_available:
                    warning_mess = {
                        'title': _('Not enough inventory!'),
                        'message' : _('You plan to sell %s %s but you only have %s %s available!\nThe stock on hand is %s %s.') % \
                            (self.product_uom_qty, self.product_uom.name, self.product_id.virtual_available, self.product_id.uom_id.name, self.product_id.qty_available, self.product_id.uom_id.name)
                    }
                    return {'warning': warning_mess}
        if self.product_id.tracking	== 'lot' or self.product_id.tracking == 'serial':
            today_date = datetime.datetime.utcnow().date()
            today_start = fields.Datetime.to_string(today_date)
            lot_sr_id = self.env['stock.production.lot'].search([('product_id','=',self.product_id.id),('life_date', '>=',today_start)],limit=1, order='life_date asc')
            if lot_sr_id:
                self.lot_id = lot_sr_id.id
            else:
                self.lot_id = False
            find_lot_sr_id = self.env['stock.production.lot'].search([('product_id','=',self.product_id.id)])
            if find_lot_sr_id:
                if len(find_lot_sr_id) == 1:
                    if find_lot_sr_id.life_date < today_start:
                        raise UserError(_("The Product '%s' is currently not available in stock.") % (self.product_id.name))
        return {}
        
    @api.onchange('lot_id')
    def onchange_lot_id(self):
        if self.lot_id:
            self.expiry_date = self.lot_id.life_date
            if self.env.ref('bahmni_sale.sale_price_basedon_cost_price_markup').value == '1':
                self.price_unit = self.lot_id.sale_price if self.lot_id.sale_price > 0.0 else self.price_unit
        else:
            self.expiry_date = False
