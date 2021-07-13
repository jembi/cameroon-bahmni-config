# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.
from odoo import _, api, exceptions, fields, models


class OpenmrsConnector(models.TransientModel):
    _inherit = 'res.config.settings'
    _name = 'openmrs.connector'

    host = fields.Char(string="Host")
    database = fields.Char(string="Database")
    username = fields.Char(string="Username")
    password = fields.Char(string="Password")
    port = fields.Integer(string='Port')
    
    @api.model
    def get_default_host(self, fields):
        host = self.env.ref('odoo_openmrs_connector.host').value
        return {'host': str(host)}

    @api.multi
    def set_default_host(self):
        for record in self:
            self.env.ref('odoo_openmrs_connector.host').write({'value': str(record.host)})
            
    @api.model
    def get_default_database(self, fields):
        database_name = self.env.ref('odoo_openmrs_connector.database_name').value
        return {'database': str(database_name)}

    @api.multi
    def set_default_database(self):
        for record in self:
            self.env.ref('odoo_openmrs_connector.database_name').write({'value': str(record.database)})
            
    @api.model
    def get_default_username(self, fields):
        username = self.env.ref('odoo_openmrs_connector.username').value
        return {'username': str(username)}

    @api.multi
    def set_default_username(self):
        for record in self:
            self.env.ref('odoo_openmrs_connector.username').write({'value': str(record.username)})
            
    @api.model
    def get_default_password(self, fields):
        password = self.env.ref('odoo_openmrs_connector.password').value
        return {'password': str(password)}

    @api.multi
    def set_default_password(self):
        for record in self:
            self.env.ref('odoo_openmrs_connector.password').write({'value': str(record.password)})
            
            
    @api.model
    def get_default_port(self, fields):
        port_number = self.env.ref('odoo_openmrs_connector.port').value
        return {'port': int(port_number)}

    @api.multi
    def set_default_port(self):
        for record in self:
            self.env.ref('odoo_openmrs_connector.port').write({'value': int(record.port)})
            
