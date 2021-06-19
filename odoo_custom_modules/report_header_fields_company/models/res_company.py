# -*- coding: utf-8 -*-
from odoo import fields, models, _

class Company(models.Model):
    _inherit = "res.company"

    country_eng = fields.Char('Country Name', required=True)
    ministry_partner_eng = fields.Char('Ministry/Partner', required=True)
    hf_level_eng = fields.Char('Health Facility Level/Region')
    district_eng = fields.Char('District')
    area_eng = fields.Char('Area')
    hf_name_eng = fields.Char('Health Facility Name', required=True)
    country_frn = fields.Char('Country Name', required=True)
    ministry_partner_frn = fields.Char('Ministry/Partner', required=True)
    hf_level_frn = fields.Char('Health Facility Level/Region')
    district_frn = fields.Char('District')
    area_frn = fields.Char('Area')
    hf_name_frn = fields.Char('Health Facility Name', required=True)
