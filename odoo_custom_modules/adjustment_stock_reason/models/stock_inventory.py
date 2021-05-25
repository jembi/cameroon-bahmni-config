# -*- coding: utf-8 -*-
#from datetime import datetime

from odoo import fields, models, api, _

class Inventory(models.Model):
    _inherit = "stock.inventory"

    reason = fields.Char('Reason', required=True)
