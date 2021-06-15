# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

from odoo import fields, models, _
from time import strftime
from datetime import datetime
import base64
import xlwt


class ExcelBillSummaryReport(models.TransientModel):
    _name = "excel.bill.summary.report"
    _description = 'Excel Tax Report'

    excel_file = fields.Binary('Excel Report')
    file_name = fields.Char('Report File Name',size=64,readonly=True)
    
class bill_summary_report_wizard(models.TransientModel):
    _name = "bill.summary.report.wizard"

    start_date = fields.Date(string="Start Date", required=True)
    end_date = fields.Date(string="End Date", required=True)
        
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
        worksheet.write_merge(0,1,0,2,self.env.user.company_id.name,style_title)
        #title report
        worksheet.write_merge(2,3,0,2,'Billing Summary Report by Provider and Category',style_tax_report_title)
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
            #Period of time
            worksheet.write(row, col, 'Period of time', xlwt.easyxf('font: bold on; align:horiz left; border: top thin, bottom thin, right thin, left thin;'))
            worksheet.col(col).width = 256 * 24
            worksheet.write_merge(4,4,1,2,start_date + ' to ' + end_date,xlwt.easyxf('font: bold on; align:vertical center, horizontal center;'))
        datetime_object = datetime.strptime(self.start_date, '%Y-%m-%d')
        start_date = datetime_object.strftime("%Y-%m-%d 00:00:00")
        datetime_object = datetime.strptime(self.end_date, '%Y-%m-%d')
        end_date = datetime_object.strftime("%Y-%m-%d 23:59:59")
        sale_records = self.env['sale.order'].sudo().search([('confirmation_date', '>=', start_date),('confirmation_date', '<=', end_date),('state', 'in', ['sale','done'])])
        providers = sale_records.filtered(lambda l: l.provider_name).mapped('provider_name')
        grand_total = 0
        #records
        for provider in set(providers):
            total_provider = 0
            provider_so = sale_records.filtered(lambda r: r.provider_name == provider)
            provider_so_lines = provider_so.mapped('order_line')
            lines_products = provider_so_lines.mapped('product_id')
            lines_categories = lines_products.mapped('categ_id')
            row +=1
            col = 0
            #Title of table head
            worksheet.write(row, col, 'Details', style_left)
            worksheet.col(col).width = 256 * 24
            col += 1
            worksheet.write(row,col,'Category', style_left)
            worksheet.col(col).width = 256 * 24
            col += 1
            worksheet.write(row, col, 'Amount', style_left)
            #values
            if lines_categories and provider_so_lines:
                row +=1
                col=0
                #provider
                worksheet.write(row, col, provider, style_border)
                for lines_category in lines_categories:
                    categ_products = lines_products.filtered(lambda r: r.categ_id == lines_category)
                    if categ_products:
                        categ_so_lines = provider_so_lines.filtered(lambda r: r.product_id in categ_products)
                        col += 1
                        #category
                        worksheet.write(row, col, lines_category.name, style_border)
                        #category amount
                        categ_total_amount = 0.00
                        lines_price_total = categ_so_lines.mapped('price_total')
                        if lines_price_total:
                            categ_total_amount = sum(lines_price_total)
                        if categ_total_amount:
                            total_provider += categ_total_amount
                            col += 1
                            worksheet.write(row, col, "{:,.2f}".format(categ_total_amount,0.00), style_amount)
                        else:
                            col += 1
                            worksheet.write(row, col, "0.00", style_amount)
                        row +=1
                        col = 0
                        worksheet.write(row, col, '', style_border)
                #total_provider
                if total_provider:
                    grand_total += total_provider
                    col += 1
                    worksheet.write(row, col, 'Sub total ' + provider, xlwt.easyxf('font: bold on; align:horiz left; border: top thin, bottom thin, right thin, left thin;'))
                    col += 1
                    worksheet.write(row, col, "{:,.2f}".format(total_provider,0.00), style_total_amount)
        #Grand total
        row +=1
        col = 0
        worksheet.write_merge(row,row,col, col+1, 'Total for the period' , xlwt.easyxf('font: bold on; align:horiz left; border: top thin, bottom thin, right thin, left thin;'))
        col += 2
        if grand_total:
            worksheet.write(row, col, "{:,.2f}".format(grand_total,0.00), style_total_amount)
        filename = 'Billing Summary Report.xls'
        workbook.save("/tmp/Billing Summary Report.xls")
        file = open("/tmp/Billing Summary Report.xls", "rb")
        file_data = file.read()
        out = base64.encodestring(file_data)
        export_id = self.env['excel.bill.summary.report'].create({'excel_file':out, 'file_name':filename})
        return {
            'view_mode':'form', 'res_id':export_id.id, 'res_model':'excel.bill.summary.report', 'view_type':'form', 'type':'ir.actions.act_window', 'context':self._context, 'target':'new',
        }

# vim:expandtab:smartindent:tabstop=4:softtabstop=4:shiftwidth=4:
