# -*- coding: utf-8 -*-
from odoo import fields, models, api, _


class Partner(models.Model):
    _inherit = "res.partner"
    
    company_type = fields.Selection(string='Company Type',
        selection=[('person', 'Individual'), ('company', 'Company'),('insurance_company', 'Insurance Company')],
        compute='_compute_company_type', inverse='_write_company_type')
    is_insurance_company = fields.Boolean(string='Is a Insurance Company', default=False,
        help="Check if the contact is a company, otherwise it is a person")
        
    @api.depends('is_company')
    def _compute_company_type(self):
        for partner in self:
            if partner.is_company:
                partner.company_type = 'company' 
                partner.is_insurance_company = False
            if partner.is_insurance_company:
                partner.company_type = 'insurance_company'
                partner.is_company = False
                partner.property_product_pricelist = self.env.ref('co_payment.prvt_pricelist_data_id').id
                partner.customer = False
            if not partner.is_company and not partner.is_insurance_company: 
                partner.company_type = 'person'
                partner.property_product_pricelist = self.env.ref('product.list0').id
            
    def _write_company_type(self):
        for partner in self:
            partner.is_company = partner.company_type == 'company'
            partner.is_insurance_company = partner.company_type == 'insurance_company'
    
    @api.onchange('company_type')
    def onchange_company_type(self):
        if self.company_type == 'insurance_company':
            self.is_insurance_company = (self.company_type == 'insurance_company')
            self.is_company = False
        elif self.company_type == 'company':
            self.is_company = (self.company_type == 'company')
        else:
            self.is_insurance_company = False
            self.is_company = False
        
