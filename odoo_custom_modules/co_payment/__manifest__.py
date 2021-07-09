# -*- coding: utf-8 -*-
{
    'name': 'co payment',
    'version': '1.0',
    'summary': 'This module use for Manage payment of third parties.',
    'sequence': 1,
    'description': """
This module use for Manage a repository of paying third parties
====================
""",
    'category': 'base',
    'author': 'Satvix Informatics',
    'website': 'http://www.satvix.com',
    'images': [],
    'depends': ['sale', 'bahmni_sale','base', 'product', 'account', 'bahmni_account'],
    'data': ['data/data.xml',
             'views/res_partner.xml',
             'views/sale_order.xml',
             'views/account_invoice.xml',
             'report/report_invoice_inherit.xml',
             ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
