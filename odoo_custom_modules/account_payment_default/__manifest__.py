# -*- coding: utf-8 -*-
{
    'name': 'Default Account Payment',
    'version': '10.0.1.0',
    'summary': 'This module helps to load default account payment',
    'sequence': 1,
    'description': """
    	This module helps to load default account payment

        * Cheque
        * Credit card / Debit card
        * Active deposit ( Deposit which can be utilized in any visit Type)
        * Orange Mobile Money
        * MTN Mobile Money
    """,
    'category': 'Accounting',
    'author': 'Satvix Informatics',
    'website': 'http://www.satvix.com',
    'images': [],
    'depends': ['account','base',],
    'data': [
        'data/account_payment_data.xml',
     ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
