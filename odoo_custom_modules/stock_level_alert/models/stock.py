# -*- coding: utf-8 -*-
from odoo import api, models, _
from odoo.tools import float_compare

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
                        'message' : _('%s is more than the available quantity') % (self.product_uom_qty)
                    }
                    return {'warning': warning_mess}
        return {}
        
class PurchaseOrderLine(models.Model):
    _inherit = 'purchase.order.line'
    
    @api.onchange('product_qty')
    def _onchange_product_qty(self):
        #########
        if not self.product_id or not self.product_qty or not self.product_uom:
            return
        if self.product_id.type == 'product':
            product_qty = self.product_uom._compute_quantity(self.product_qty, self.product_id.uom_po_id)
            orderpoint_id = self.env['stock.warehouse.orderpoint'].search([('product_id', '=', self.product_id.id)], limit=1)
            if orderpoint_id:
                if product_qty > orderpoint_id.product_max_qty:
                    warning_mess = {
                        'title': _('Maximum quantity allowed exceeded!'),
                        'message' : _('%s is more than the maximum quantity allowed') % (self.product_qty)
                    }
                    return {'warning': warning_mess}
        ##################
        
        if (self.state == 'purchase' or self.state == 'to approve') and self.product_id.type in ['product', 'consu'] and self.product_qty < self._origin.product_qty:
            warning_mess = {
                'title': _('Ordered quantity decreased!'),
                'message' : _('You are decreasing the ordered quantity!\nYou must update the quantities on the reception and/or bills.'),
            }
            return {'warning': warning_mess}
    
