# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

from odoo import fields, models, _
from datetime import datetime
import base64
import xlwt


class ExcelBalanceSheetReport(models.TransientModel):
    _name = "excel.balance.sheet.report"

    excel_file = fields.Binary('Excel Report')
    file_name = fields.Char('Report File Name',size=64,readonly=True)
    
class balance_sheet_report_wizard(models.TransientModel):
    _name = "balance.sheet.report.wizard"

    start_date = fields.Date(string="Start Date", required=True)
    end_date = fields.Date(string="End Date", required=True)
    
    def print_pdf_report(self):
        data = {}
        self.ensure_one()
        data = {}
        data['ids'] = self.env.context.get('active_ids', [])
        data['model'] = self.env.context.get('active_model', 'ir.ui.menu')
        data['form'] = self.read(['start_date', 'end_date'])[0]
        return self.env['report'].get_action(self, 'store_balance_sheet_report.balance_sheet_report_tmpl_id', data=data)
        
    def print_excel_report(self):
        workbook = xlwt.Workbook()
        style = xlwt.XFStyle()
        style_title = xlwt.easyxf('font:height 300, bold on; align:horizontal center, vertical center; pattern: pattern solid, fore_color white; border: top thin, bottom thin, right thin, left thin; ')
        style_tax_report_title = xlwt.easyxf('font:height 250, bold on; align:horizontal center, vertical center; pattern: pattern solid, fore_color white; border: top thin, bottom thin, right thin, left thin; ')
        style_total_amount = xlwt.easyxf('font: bold on; align:horiz right; border: top thin, bottom thin, right thin, left thin;')
        style_amount = xlwt.easyxf('align:horiz right; border: top thin, bottom thin, right thin, left thin;')
        style_left = xlwt.easyxf('font:bold on; pattern: pattern solid, fore_colour gray25; border: top thin, bottom thin, right thin, left thin;')
        style_border = xlwt.easyxf('border: top thin, bottom thin, right thin, left thin;')
        font = xlwt.Font()
        font.name = 'Times New Roman'
        font.bold = True
        font.height = 250
        style.font = font
        worksheet = workbook.add_sheet('Sheet 1')
        #company name
        worksheet.write_merge(0,1,0,1,self.env.user.company_id.name,style_title)
        #title report
        worksheet.write_merge(2,3,0,1,'Cashier Closing Report',style_tax_report_title)
        #date
        start_date = False
        end_date = False
        if self.start_date and self.end_date:
            datetime_object = datetime.strptime(self.start_date, '%Y-%m-%d')
            start_date = datetime_object.strftime("%d/%m/%Y")
            datetime_object = datetime.strptime(self.end_date, '%Y-%m-%d')
            end_date = datetime_object.strftime("%d/%m/%Y")
            row = 4
            col = 0
            worksheet.write_merge(row,row,col,col+1,'Period of time : '+ start_date + ' to ' + end_date,xlwt.easyxf('font: bold on; align:vertical center, horizontal center; border: top thin, bottom thin, right thin, left thin;'))
        datetime_object = datetime.strptime(self.start_date, '%Y-%m-%d')
        start_date = datetime_object.strftime("%Y-%m-%d 00:00:00")
        datetime_object = datetime.strptime(self.end_date, '%Y-%m-%d')
        end_date = datetime_object.strftime("%Y-%m-%d 23:59:59")
        partner_id = self.env.user.partner_id
        
        ##get payments data
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
            row +=1
            col = 0
            #Title of table head
            worksheet.write(row, col, 'Billing Items', style_left)
            worksheet.col(col).width = 256 * 48
            col += 1
            worksheet.write(row, col, 'Amount', style_left)
            grand_total = 0
            #records
            for line_product_id in set(lines_product_ids):
                product_total_amount = 0
                product_invoice_lines = invoice_lines.filtered(lambda r: r.product_id.id == line_product_id.id)
                #values
                if product_invoice_lines:
                    lines_price_subtotal = product_invoice_lines.mapped('price_subtotal')
                    #product amount
                    if lines_price_subtotal:
                        product_total_amount = sum(lines_price_subtotal)
                    if product_total_amount:
                        row +=1
                        col=0
                        #product
                        worksheet.write(row, col, line_product_id.name, style_border)
                        #product amount
                        grand_total += product_total_amount
                        col += 1
                        worksheet.write(row, col, "{:,.2f}".format(product_total_amount,0.00), style_amount)
            #Grand total
            if grand_total:
                row +=1
                col = 0
                worksheet.write(row,col,'Total for the period' , xlwt.easyxf('font: bold on; align:horiz left; border: top thin, bottom thin, right thin, left thin;'))
                col += 1
                if grand_total:
                    worksheet.write(row, col, "{:,.2f}".format(grand_total,0.00), style_total_amount)
        
        filename = 'Balance Sheet Report.xls'
        workbook.save("/tmp/Balance Sheet Report.xls")
        file = open("/tmp/Balance Sheet Report.xls", "rb")
        file_data = file.read()
        out = base64.encodestring(file_data)
        export_id = self.env['excel.balance.sheet.report'].create({'excel_file':out, 'file_name':filename})
        return {
            'view_mode':'form', 'res_id':export_id.id, 'res_model':'excel.balance.sheet.report', 'view_type':'form', 'type':'ir.actions.act_window', 'context':self._context, 'target':'new',
        }

# vim:expandtab:smartindent:tabstop=4:softtabstop=4:shiftwidth=4:
