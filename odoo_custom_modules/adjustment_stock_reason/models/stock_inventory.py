# -*- coding: utf-8 -*-
from odoo import fields, models, api, _

class InventoryLine(models.Model):
    _inherit = "stock.inventory.line"
    
    reason = fields.Char('Reason')
    is_reason_req = fields.Boolean(string='Require')
    
    @api.onchange('product_qty')
    def _onchange_product_qty(self):
        if self.theoretical_qty != self.product_qty:
            self.is_reason_req = True
        else:
            self.is_reason_req = False
            self.reason = False
