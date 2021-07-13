# -*- coding: utf-8 -*-
from odoo import models, api


class AccountInvoiceLine(models.Model):
    _inherit = 'account.invoice'

    @api.multi
    def print_payment(self):
        if self.payment_ids:
            payment_ids = self.payment_ids
            for payment_id in payment_ids:
                return self.env['report'].get_action(payment_id, 'bahmni_stock.report_account_payment_template')
