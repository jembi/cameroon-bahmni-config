# -*- coding: utf-8 -*-
from odoo import fields, models, api, _
from odoo.tools import float_is_zero
from odoo.exceptions import UserError
import odoo.addons.decimal_precision as dp


class SaleAdvancePaymentInv(models.TransientModel):
    _inherit = "sale.advance.payment.inv"
    
    @api.model
    def _get_advance_payment_method(self):
        if self._count() == 1:
            sale_obj = self.env['sale.order']
            order = sale_obj.browse(self._context.get('active_ids'))[0]
            if all([line.product_id.invoice_policy == 'order' for line in order.order_line]) or order.invoice_count:
                return 'delivered'
        return 'delivered'
        
    advance_payment_method = fields.Selection([
        ('delivered', 'Invoiceable lines'),
        ], string='What do you want to invoice?', default=_get_advance_payment_method, required=True)

class SaleOrder(models.Model):
    _inherit = 'sale.order'
    
    care_voucher = fields.Char('Care Voucher')
    insurance_comp_id = fields.Many2one('res.partner', 'Insurance Company')
    co_pay = fields.Float("%Co-pay by client", default=100.0)
    care_voucher_date = fields.Date('Care Voucher Date')
    
    @api.multi
    @api.onchange('co_pay')
    def onchange_co_pay(self):
        if self.co_pay > 100:
            self.co_pay = 0
            raise UserError(_("Please check '%Co-pay by client' not more than 100."))
    
    @api.multi
    @api.onchange('partner_id','insurance_comp_id')
    def onchange_partner_id_insurance_comp_id(self):
        if self.insurance_comp_id:
            self.pricelist_id = self.insurance_comp_id.property_product_pricelist and self.insurance_comp_id.property_product_pricelist.id or False
        else:
            self.pricelist_id = self.partner_id.property_product_pricelist and self.partner_id.property_product_pricelist.id or False
    
    @api.multi
    def _prepare_invoice(self):
        """
        Prepare the dict of values to create the new invoice for a sales order. This method may be
        overridden to implement custom invoice generation (making sure to call super() to establish
        a clean extension chain).
        """
        if self._context.has_key('partner_invoice_id') and self._context.has_key('partner_shipping_id'):
            partner_rec = self.env['res.partner'].browse(self._context.get('partner_invoice_id'))
            account_id = partner_rec.property_account_receivable_id.id
            partner_id = self._context.get('partner_invoice_id')
            partner_shipping_id = self._context.get('partner_shipping_id')
            fiscal_position_id = partner_rec.property_account_position_id.id
        else:
            account_id = self.partner_invoice_id.property_account_receivable_id.id
            partner_id = self.partner_invoice_id.id
            partner_shipping_id = self.partner_shipping_id.id
            fiscal_position_id = self.partner_invoice_id.property_account_position_id.id
        ####
        sale_order_id = self.id
        discount = self.discount
        if partner_id == self.partner_id.id:
            co_pay = self.co_pay
            discount = (self.discount * co_pay) /100
        else:
            co_pay = 100 - self.co_pay
            discount = (self.discount * co_pay) /100
            
        ####    
        self.ensure_one()
        journal_id = self.env['account.invoice'].default_get(['journal_id'])['journal_id']
        if not journal_id:
            raise UserError(_('Please define an accounting sale journal for this company.'))
        invoice_vals = {
            'name': self.client_order_ref or '',
            'origin': self.name,
            'type': 'out_invoice',
            'account_id' : account_id,
            'partner_id': partner_id,
            'partner_shipping_id': partner_shipping_id,
            'journal_id': journal_id,
            'currency_id': self.pricelist_id.currency_id.id,
            'comment': self.note,
            'payment_term_id': self.payment_term_id.id,
            'fiscal_position_id': self.fiscal_position_id.id or fiscal_position_id,
            'company_id': self.company_id.id,
            'user_id': self.user_id and self.user_id.id,
            'team_id': self.team_id.id,
            'discount_type': self.discount_type,
            'discount_percentage': self.discount_percentage,
            'disc_acc_id': self.disc_acc_id.id,
            'discount': discount,
            'co_pay': co_pay,##
            'sale_order_id':sale_order_id,##
            'so_partner_id':self.partner_id.id##
        }
        if self.insurance_comp_id:
            care_voucher = self.care_voucher
            insurance_comp_id = self.insurance_comp_id.id
            care_voucher_date = self.care_voucher_date
            invoice_vals.update({'care_voucher': care_voucher, 'insurance_comp_id': insurance_comp_id, 'care_voucher_date': care_voucher_date,})
        return invoice_vals
        
    @api.multi
    def action_invoice_create(self, grouped=False, final=False):
        """
        Create the invoice associated to the SO.
        :param grouped: if True, invoices are grouped by SO id. If False, invoices are grouped by
                        (partner_invoice_id, currency)
        :param final: if True, refunds will be generated if necessary
        :returns: list of created invoices
        """
        inv_obj = self.env['account.invoice']
        precision = self.env['decimal.precision'].precision_get('Product Unit of Measure')
        invoices = {}
        references = {}
        invoices_origin = {}
        invoices_name = {}
        for order in self:
            if order.co_pay > 0 and order.co_pay != 100.0:
                partner_ids = []
                partner_ids.append(order.partner_id)
                partner_ids.append(order.insurance_comp_id)
                for partner_id in partner_ids:
                    addr = partner_id.address_get(['delivery', 'invoice'])
                    partner_invoice_id = addr['invoice'],
                    partner_shipping_id = addr['delivery'],
                    partner_invoice_id = partner_invoice_id[0]
                    partner_shipping_id = partner_shipping_id[0]
                    group_key = order.id if grouped else (partner_invoice_id, order.currency_id.id)
                    for line in order.order_line.sorted(key=lambda l: l.qty_to_invoice < 0):
                        ####same line of diff invoice
                        if order.partner_id != partner_id:
                            line.qty_to_invoice = line.product_uom_qty
                        ####
                        if float_is_zero(line.qty_to_invoice, precision_digits=precision):
                            continue
                        if group_key not in invoices:
                            inv_data = order.with_context(partner_invoice_id=partner_invoice_id, partner_shipping_id=partner_shipping_id)._prepare_invoice()
                            invoice = inv_obj.create(inv_data)
                            references[invoice] = order
                            invoices[group_key] = invoice
                            invoices_origin[group_key] = [invoice.origin]
                            invoices_name[group_key] = [invoice.name]
                        elif group_key in invoices:
                            if order.name not in invoices_origin[group_key]:
                                invoices_origin[group_key].append(order.name)
                            if order.client_order_ref and order.client_order_ref not in invoices_name[group_key]:
                                invoices_name[group_key].append(order.client_order_ref)
                        
                        if line.qty_to_invoice > 0:
                            line.with_context(invoice_id_pass=invoice).invoice_line_create(invoices[group_key].id, line.qty_to_invoice)
                        elif line.qty_to_invoice < 0 and final:
                            line.invoice_line_create(invoices[group_key].id, line.qty_to_invoice)
            else:
                if order.co_pay == 100.0:
                    partner_id = order.partner_id
                else:
                    partner_id = order.insurance_comp_id
                addr = partner_id.address_get(['delivery', 'invoice'])
                partner_invoice_id = addr['invoice'],
                partner_shipping_id = addr['delivery'],
                partner_invoice_id = partner_invoice_id[0]
                partner_shipping_id = partner_shipping_id[0]
                group_key = order.id if grouped else (partner_invoice_id, order.currency_id.id)
                for line in order.order_line.sorted(key=lambda l: l.qty_to_invoice < 0):
                    if float_is_zero(line.qty_to_invoice, precision_digits=precision):
                        continue
                    if group_key not in invoices:
                        inv_data = order.with_context(partner_invoice_id=partner_invoice_id, partner_shipping_id=partner_shipping_id)._prepare_invoice()
                        invoice = inv_obj.create(inv_data)
                        references[invoice] = order
                        invoices[group_key] = invoice
                        invoices_origin[group_key] = [invoice.origin]
                        invoices_name[group_key] = [invoice.name]
                    elif group_key in invoices:
                        if order.name not in invoices_origin[group_key]:
                            invoices_origin[group_key].append(order.name)
                        if order.client_order_ref and order.client_order_ref not in invoices_name[group_key]:
                            invoices_name[group_key].append(order.client_order_ref)

                    if line.qty_to_invoice > 0:
                        line.with_context(invoice_id_pass=invoice).invoice_line_create(invoices[group_key].id, line.qty_to_invoice)
                    elif line.qty_to_invoice < 0 and final:
                        line.invoice_line_create(invoices[group_key].id, line.qty_to_invoice)
            if references.get(invoices.get(group_key)):
                if order not in references[invoices[group_key]]:
                    references[invoice] = references[invoice] | order
        for group_key in invoices:
            invoices[group_key].write({'name': ', '.join(invoices_name[group_key]),
                                       'origin': ', '.join(invoices_origin[group_key])})
        if not invoices:
            raise UserError(_('There is no invoicable line.'))
        for invoice in invoices.values():
            invoice.compute_taxes()
            if not invoice.invoice_line_ids:
                raise UserError(_('There is no invoicable line.'))
            # If invoice is negative, do a refund invoice instead
            if invoice.amount_total < 0:
                invoice.type = 'out_refund'
                for line in invoice.invoice_line_ids:
                    line.quantity = -line.quantity
            # Use additional field helper function (for account extensions)
            for line in invoice.invoice_line_ids:
                line._set_additional_fields(invoice)
            # Necessary to force computation of taxes. In account_invoice, they are triggered
            # by onchanges, which are not triggered when doing a create.
            invoice.compute_taxes()
            invoice.message_post_with_view('mail.message_origin_link',
                values={'self': invoice, 'origin': references[invoice]},
                subtype_id=self.env.ref('mail.mt_note').id)
        return [inv.id for inv in invoices.values()]

   
class SaleOrderLine(models.Model):
    _inherit = 'sale.order.line'
    
    @api.depends('invoice_lines.invoice_id.state', 'invoice_lines.quantity')
    def _get_invoice_qty(self):
        """
        Compute the quantity invoiced. If case of a refund, the quantity invoiced is decreased. Note
        that this is the case only if the refund is generated from the SO and that is intentional: if
        a refund made would automatically decrease the invoiced quantity, then there is a risk of reinvoicing
        it automatically, which may not be wanted at all. That's why the refund has to be created from the SO
        """
        for line in self:
            qty_invoiced = 0.0
            for invoice_line in line.invoice_lines:
                if invoice_line.invoice_id.state != 'cancel':
                    if invoice_line.invoice_id.type == 'out_invoice':
                        qty_invoiced += invoice_line.uom_id._compute_quantity(invoice_line.quantity, line.product_uom)
                    elif invoice_line.invoice_id.type == 'out_refund':
                        qty_invoiced -= invoice_line.uom_id._compute_quantity(invoice_line.quantity, line.product_uom)
                if line.order_id.co_pay: 
                    if line.order_id.co_pay > 0 and line.order_id.co_pay < 100:
                        qty_invoiced = line.product_uom_qty
            line.qty_invoiced = qty_invoiced

    @api.multi
    def _prepare_invoice_line(self, qty):
        """
        Prepare the dict of values to create the new invoice line for a sales order line.

        :param qty: float quantity to invoice
        """
        invoice = False
        paid_percentage = False
        price_unit_cpy = False
        price_unit = False
        if self._context.has_key("invoice_id_pass"):
            invoice = self._context.get("invoice_id_pass")
        if invoice and self.price_unit > 0:
            if self.order_id.partner_id == invoice.partner_id:
                paid_percentage = invoice.co_pay
                price_unit_cpy = self.price_unit
                price_unit = (self.price_unit * paid_percentage)/100
            else:
                paid_percentage = invoice.co_pay
                price_unit_cpy = self.price_unit
                price_unit = (self.price_unit *invoice.co_pay)/100
        if not paid_percentage:
            paid_percentage = 0
        if not price_unit_cpy:
            price_unit_cpy = self.price_unit
        if not price_unit:
            price_unit = self.price_unit
        self.ensure_one()
        res = {}
        account = self.product_id.property_account_income_id or self.product_id.categ_id.property_account_income_categ_id
        if not account:
            raise UserError(_('Please define income account for this product: "%s" (id:%d) - or for its category: "%s".') %
                (self.product_id.name, self.product_id.id, self.product_id.categ_id.name))

        fpos = self.order_id.fiscal_position_id or self.order_id.partner_id.property_account_position_id
        if fpos:
            account = fpos.map_account(account)

        res = {
            'name': self.name,
            'sequence': self.sequence,
            'origin': self.order_id.name,
            'account_id': account.id,
            'price_unit': price_unit,
            'quantity': qty,
            'discount': self.discount,
            'uom_id': self.product_uom.id,
            'product_id': self.product_id.id or False,
            'layout_category_id': self.layout_category_id and self.layout_category_id.id or False,
            'invoice_line_tax_ids': [(6, 0, self.tax_id.ids)],
            'account_analytic_id': self.order_id.project_id.id,
            'analytic_tag_ids': [(6, 0, self.analytic_tag_ids.ids)],
            'price_unit_cpy': price_unit_cpy,
            'paid_percentage': paid_percentage,
        }
        return res
            
class AccountInvoiceLine(models.Model):
    _inherit = "account.invoice.line"
    
    price_unit = fields.Float(string='Pay Price', required=True, digits=dp.get_precision('Product Price'))
    paid_percentage = fields.Float(string='Pay percentage', digits=dp.get_precision('Product Price'))
    price_unit_cpy = fields.Float(string='Unit Price', digits=dp.get_precision('Product Price'))

    def _set_taxes(self):
        """ Used in on_change to set taxes and price."""
        if self.invoice_id.type in ('out_invoice', 'out_refund'):
            taxes = self.product_id.taxes_id or self.account_id.tax_ids
        else:
            taxes = self.product_id.supplier_taxes_id or self.account_id.tax_ids

        # Keep only taxes of the company
        company_id = self.company_id or self.env.user.company_id
        taxes = taxes.filtered(lambda r: r.company_id == company_id)

        self.invoice_line_tax_ids = fp_taxes = self.invoice_id.fiscal_position_id.map_tax(taxes, self.product_id, self.invoice_id.partner_id)

        fix_price = self.env['account.tax']._fix_tax_included_price
        if self.invoice_id.type in ('in_invoice', 'in_refund'):
            prec = self.env['decimal.precision'].precision_get('Product Price')
            if not self.price_unit or float_compare(self.price_unit, self.product_id.standard_price, precision_digits=prec) == 0:
                self.price_unit = fix_price(self.product_id.standard_price, taxes, fp_taxes)
                self.price_unit_cpy = self.price_unit##custom
                self._set_currency()
        else:
            self.price_unit = fix_price(self.product_id.lst_price, taxes, fp_taxes)
            self.price_unit_cpy = self.price_unit##custom
            self._set_currency()

    @api.multi
    @api.onchange('price_unit_cpy')
    def _onchange_price_unit_cpy(self):
        self.price_unit = self.price_unit_cpy
    
    
    @api.onchange('product_id')
    def _onchange_product_id(self):
        domain = {}
        if not self.invoice_id:
            return
        part = self.invoice_id.partner_id
        fpos = self.invoice_id.fiscal_position_id
        company = self.invoice_id.company_id
        currency = self.invoice_id.currency_id
        type = self.invoice_id.type
        if not part:
            warning = {
                    'title': _('Warning!'),
                    'message': _('You must first select a partner!'),
                }
            return {'warning': warning}
        if not self.product_id:
            if type not in ('in_invoice', 'in_refund'):
                self.price_unit = 0.0
                self.price_unit_cpy = self.price_unit##custom
            domain['uom_id'] = []
        else:
            if part.lang:
                product = self.product_id.with_context(lang=part.lang)
            else:
                product = self.product_id
            self.name = product.partner_ref
            account = self.get_invoice_line_account(type, product, fpos, company)
            if account:
                self.account_id = account.id
            self._set_taxes()
            if type in ('in_invoice', 'in_refund'):
                if product.description_purchase:
                    self.name += '\n' + product.description_purchase
            else:
                if product.description_sale:
                    self.name += '\n' + product.description_sale
            if not self.uom_id or product.uom_id.category_id.id != self.uom_id.category_id.id:
                self.uom_id = product.uom_id.id
            domain['uom_id'] = [('category_id', '=', product.uom_id.category_id.id)]
            if company and currency:
                if self.uom_id and self.uom_id.id != product.uom_id.id:
                    self.price_unit = product.uom_id._compute_price(self.price_unit, self.uom_id)
                    self.price_unit_cpy = self.price_unit##custom
        return {'domain': domain}
   

class AccountInvoice(models.Model):
    _inherit = "account.invoice"
    
    care_voucher = fields.Char('Care Voucher')
    insurance_comp_id = fields.Many2one('res.partner', 'Insurance Company')
    co_pay = fields.Float("Care Voucher % of Coverage")
    care_voucher_date = fields.Date('Care Voucher Date')
    sale_order_id = fields.Many2one('sale.order', 'Sale order')
    so_partner_id = fields.Many2one('res.partner', 'Sale Order Customer')
    check_visible = fields.Boolean(compute='_compute_check_visible', string="Check Visible")
    customer_same = fields.Boolean(string="Customer Same",compute='_compute_check_visible',)
    
    @api.multi
    def _compute_check_visible(self):
        for record in self:
            if record.so_partner_id.id == record.partner_id.id and record.co_pay == 100.0:
                record.check_visible = True
            else:
                record.check_visible = False
            if record.so_partner_id.id == record.partner_id.id:
                record.customer_same = True

    @api.multi
    def action_invoice_paid(self):
        res = super(AccountInvoice, self).action_invoice_paid()
        if self.sale_order_id:
            invoice_id = self.sale_order_id.invoice_ids.filtered(lambda rec: rec.state == 'draft' and rec.partner_id.id != self.sale_order_id.partner_id.id)
            if invoice_id:
                invoice_id.action_invoice_open()
        return res
