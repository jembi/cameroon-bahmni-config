# -*- coding: utf-8 -*-
{
    'name': 'Openmrs Connector',
    'version': '1.0',
    'summary': 'This module use for odoo to openmrs connection',
    'sequence': 1,
    'description': """
This module use for odoo to openmrs connection
====================
""",
    'category': 'base',
    'author': 'Satvix Informatics',
    'website': 'http://www.satvix.com',
    'images': [],
    'depends': ['sale', 'bahmni_sale', 'base', 'bahmni_atom_feed', 'bahmni_stock'],
    'data': [
        'data/ir_config_parameter_data.xml',
        'data/syncable.units.csv',
        'wizard/openmrs_connector_view.xml',
        'views/sale_order.xml',
    ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
