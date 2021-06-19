# -*- coding: utf-8 -*-
{
    'name': 'Store Balance Sheet Report',
    'version': '1.0',
    'summary': 'Generate Store Balance Sheet Report for a specific period',
    'sequence': 1,
    'description': """
Generate a closing report over a period of time displaying the collection per Product/Service category and the total for the period.
====================
""",
    'category': 'Account',
    'website': '',
    'images': [],
    'depends': ['sale', 'bahmni_sale', 'account',],
    'data': ["wizard/balance_sheet_report.xml",
             "report/report_menu.xml",
             "report/report.xml",
             ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
