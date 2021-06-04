# -*- coding: utf-8 -*-
from odoo import models, api, _

class AccountInvoice(models.Model):
    _inherit = "account.invoice"
    
    @api.model
    def create(self, vals):
        if vals.get('invoice_line_ids'):
            for invoice_line_id in vals.get('invoice_line_ids'):
                if invoice_line_id[2]:
                    if invoice_line_id[2].get('purchase_line_id') and invoice_line_id[2].get('invoice_line_tax_ids'):
                        po_line_id = invoice_line_id[2].get('purchase_line_id')
                        if po_line_id:
                            po_line_rec = self.env['purchase.order.line'].browse(po_line_id)
                        if po_line_rec:
                            taxes = po_line_rec.taxes_id
                            invoice_line_tax_ids = po_line_rec.order_id.fiscal_position_id.map_tax(taxes)
                            invoice_line_id[2].update({'invoice_line_tax_ids':invoice_line_tax_ids.ids})
        return super(AccountInvoice, self.with_context(mail_create_nolog=True)).create(vals)
        
    @api.multi
    def write(self, vals):
        if vals.get('invoice_line_ids'):
            for invoice_line_id in vals.get('invoice_line_ids'):
                if invoice_line_id[2]:
                    if invoice_line_id[2].get('purchase_line_id') and invoice_line_id[2].get('invoice_line_tax_ids'):
                        po_line_id = invoice_line_id[2].get('purchase_line_id')
                        if po_line_id:
                            po_line_rec = self.env['purchase.order.line'].browse(po_line_id)
                            if po_line_rec:
                                taxes = po_line_rec.taxes_id
                                invoice_line_tax_ids = po_line_rec.order_id.fiscal_position_id.map_tax(taxes)
                                invoice_line_id[2].update({'invoice_line_tax_ids':invoice_line_tax_ids.ids})
        return super(AccountInvoice, self).write(vals)
