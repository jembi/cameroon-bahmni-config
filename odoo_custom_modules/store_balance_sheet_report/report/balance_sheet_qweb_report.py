# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.
from odoo import api, models, _
from odoo.exceptions import UserError
from datetime import datetime


class ReportBy_tax_reportCs(models.AbstractModel):
    _name = 'report.store_balance_sheet_report.balance_sheet_report_tmpl_id'

    def get_report_vals(self, start_date, end_date):
        lines = []
        datetime_object = datetime.strptime(start_date, '%Y-%m-%d')
        start_date = datetime_object.strftime("%Y-%m-%d 00:00:00")
        datetime_object = datetime.strptime(end_date, '%Y-%m-%d')
        end_date = datetime_object.strftime("%Y-%m-%d 23:59:59")
        if not self.env.user.has_group('account.group_account_manager'):
            account_payments = self.env['account.payment'].sudo().search([('partner_type', '=', 'customer'),('create_uid', '=', self.env.user.id),('payment_date', '>=', start_date),('payment_date', '<=', end_date),('invoice_ids','!=', False)])
        else:
            account_payments = self.env['account.payment'].sudo().search([('partner_type', '=', 'customer'),('payment_date', '>=', start_date),('payment_date', '<=', end_date),('invoice_ids','!=', False)])
        
        invoice_ids = False
        if account_payments:
            invoice_ids = account_payments.mapped('invoice_ids')
        if invoice_ids:
            invoice_lines = invoice_ids.mapped('invoice_line_ids')
            lines_product_ids = invoice_lines.mapped('product_id')
            for line_product_id in lines_product_ids:
                vals = {}
                total = 0
                product_invoice_lines = invoice_lines.filtered(lambda r: r.product_id.id == line_product_id.id)
                currency = self.env.user.company_id.currency_id.symbol
                if product_invoice_lines:
                    vals['product_id'] = line_product_id
                    lines_price_subtotal = product_invoice_lines.mapped('price_subtotal')
                    if lines_price_subtotal:
                        product_total_amount = sum(lines_price_subtotal)
                        if product_total_amount:
                            total = product_total_amount
                    vals['amount'] = total
                    vals['currency_id'] = currency
                lines.append(vals)
        return lines
        
    def get_grand_total(self, start_date, end_date):
        grand_total = 0
        datetime_object = datetime.strptime(start_date, '%Y-%m-%d')
        start_date = datetime_object.strftime("%Y-%m-%d 00:00:00")
        datetime_object = datetime.strptime(end_date, '%Y-%m-%d')
        end_date = datetime_object.strftime("%Y-%m-%d 23:59:59")
        if not self.env.user.has_group('account.group_account_manager'):
            account_payments = self.env['account.payment'].sudo().search([('partner_type', '=', 'customer'),('create_uid', '=', self.env.user.id),('payment_date', '>=', start_date),('payment_date', '<=', end_date),('invoice_ids','!=', False)])
        else:
            account_payments = self.env['account.payment'].sudo().search([('partner_type', '=', 'customer'),('payment_date', '>=', start_date),('payment_date', '<=', end_date),('invoice_ids','!=', False)])
        
        invoice_ids = False
        if account_payments:
            invoice_ids = account_payments.mapped('invoice_ids')
        if invoice_ids:
            invoice_lines = invoice_ids.mapped('invoice_line_ids')
            currency = self.env.user.company_id.currency_id.symbol
            lines_price_subtotal = invoice_lines.mapped('price_subtotal')
            if lines_price_subtotal:
                grand_total = sum(lines_price_subtotal)
                grand_total = "{:,.2f}".format(grand_total,0.00) + currency
        return grand_total
            
    @api.model
    def render_html(self, docids, data=None):
        if not data.get('form') or not self.env.context.get('active_model') or not self.env.context.get('active_id'):
            raise UserError(_("Form content is missing, this report cannot be printed."))
        model = self.env.context.get('active_model')
        data = data if data is not None else {}
        docs = self.env[model].browse(self.env.context.get('active_id'))
        docargs = {
            'doc_ids': self.ids,
            'doc_model': model,
            'data': data,
            'docs' : docs,
            'get_report_vals': self.get_report_vals,
            'get_grand_total': self.get_grand_total,
        }
        return self.env['report'].render('store_balance_sheet_report.balance_sheet_report_tmpl_id', docargs)

# vim:expandtab:smartindent:tabstop=4:softtabstop=4:shiftwidth=4:
