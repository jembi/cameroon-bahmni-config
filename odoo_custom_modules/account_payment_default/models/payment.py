# -*- coding: utf-8 -*-

from odoo import models, api


class AccountPayment(models.Model):

    _inherit = "account.payment"

    @api.model
    def default_get(self, fields):
        res = super(AccountPayment, self).default_get(fields)
        cash_journal_id = self.env['account.journal'].search([('name', '=', 'Cash')], limit=1)
        if cash_journal_id:
            res.update({'journal_id': cash_journal_id and cash_journal_id.id or False})
        return res
