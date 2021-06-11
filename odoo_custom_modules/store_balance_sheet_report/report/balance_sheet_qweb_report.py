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
        sale_records = self.env['sale.order'].sudo().search([('confirmation_date', '>=', start_date),('confirmation_date', '<=', end_date),('state', 'in', ['sale','done'])])
        if sale_records:
            so_lines = sale_records.mapped('order_line')
            lines_product_ids = so_lines.mapped('product_id')
            for line_product_id in lines_product_ids:
                vals = {}
                total = 0
                product_so_lines = so_lines.filtered(lambda r: r.product_id.id == line_product_id.id)
                currency = product_so_lines.mapped('currency_id').symbol
                if product_so_lines:
                    vals['product_id'] = line_product_id
                    lines_price_total = product_so_lines.mapped('price_total')
                    if lines_price_total:
                        product_total_amount = sum(lines_price_total)
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
        sale_records = self.env['sale.order'].sudo().search([('confirmation_date', '>=', start_date),('confirmation_date', '<=', end_date),('state', 'in', ['sale','done'])])
        if sale_records:
            so_lines = sale_records.mapped('order_line')
            currency = so_lines.mapped('currency_id').symbol
            lines_price_total = so_lines.mapped('price_total')
            if lines_price_total:
                grand_total = sum(lines_price_total)
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
