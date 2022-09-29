# -*- coding: utf-8 -*-
from odoo import fields, models, api, _

class AccountInvoice(models.Model):
    _inherit = "account.invoice"

    overdue = fields.Boolean(string='Overdue ?', compute='_compute_overdue', help="It indicates that the due date passed.")

    def _compute_overdue(self):
        for rec in self:
            if rec.state == 'open' and rec.partner_id.company_type == 'insurance_company':
                if rec.date_due:
                    today_date = fields.Date.today()
                    if today_date > rec.date_due:
                        rec.overdue = True
                    else:
                        rec.overdue = False
            else:
                rec.overdue = False





