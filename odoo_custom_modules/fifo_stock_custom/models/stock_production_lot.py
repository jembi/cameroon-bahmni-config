# -*- coding: utf-8 -*-
#from datetime import datetime

from odoo import fields, models, api, _
from odoo.tools import DEFAULT_SERVER_DATETIME_FORMAT, float_compare

class StockProductionLot(models.Model):
    _inherit = 'stock.production.lot'
    _order = 'life_date asc'

class SaleOrderLine(models.Model):
    _inherit = 'sale.order.line'

    @api.onchange('product_uom_qty', 'product_uom', 'route_id')
    def _onchange_product_id_check_availability(self):
        if not self.product_id or not self.product_uom_qty or not self.product_uom:
            self.product_packaging = False
            return {}
        if self.product_id.type == 'product':
            precision = self.env['decimal.precision'].precision_get('Product Unit of Measure')
            product_qty = self.product_uom._compute_quantity(self.product_uom_qty, self.product_id.uom_id)
            if float_compare(self.product_id.virtual_available, product_qty, precision_digits=precision) == -1:
                is_available = self._check_routing()
                if not is_available:
                    warning_mess = {
                        'title': _('Not enough inventory!'),
                        'message' : _('You plan to sell %s %s but you only have %s %s available!\nThe stock on hand is %s %s.') % \
                            (self.product_uom_qty, self.product_uom.name, self.product_id.virtual_available, self.product_id.uom_id.name, self.product_id.qty_available, self.product_id.uom_id.name)
                    }
                    return {'warning': warning_mess}
        if self.product_id.tracking	 == 'lot' or self.product_id.tracking == 'serial':
            lot_sr_id = self.env['stock.production.lot'].search([('product_id','=',self.product_id.id)],limit=1, order='life_date asc')
            if lot_sr_id:
                self.lot_id = lot_sr_id.id 
        return {}
