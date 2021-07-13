# -*- coding: utf-8 -*-
{
    'name': 'Bill Summary Report by Provider',
    'version': '1.0',
    'summary': 'Generate Billing Summary Report by Provider and Category',
    'sequence': 1,
    'description': """
Generate a summary report over a period of time displaying the billing per product/service category and per provider
====================
""",
    'category': 'Account',
    'website': '',
    'images': [],
    'depends': ['sale', 'bahmni_sale', 'account',],
    'data': ["wizard/bill_summary_report.xml",
             ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
