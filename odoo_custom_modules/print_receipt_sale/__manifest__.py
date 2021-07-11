# -*- coding: utf-8 -*-
{
    'name': 'Print Receipt Sale',
    'version': '1.0',
    'summary': "Add Register Payment Button in Invoice ",
    'sequence': 1,
    'description': """
        Add 'Register Payment button' in Customer Invoice to print payment receipt.
====================
""",
    'category': 'Account',
    'website': '',
    'images': [],
    'depends': ['sale', 'bahmni_sale', 'account', 'bahmni_stock'],
    'data': [
        'views/account_invoice.xml'
             ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
