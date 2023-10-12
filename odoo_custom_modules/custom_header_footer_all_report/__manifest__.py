# -*- coding: utf-8 -*-
{
    'name': 'Custom Header Footer All Report',
    'version': '1.0',
    'summary': 'Change default header footer of report',
    'sequence': 1,
    'description': """
Change Header, Footer of all report who use default odoo's header footer
====================
""",
    'category': 'report',
    'website': '',
    'images': [],
    'depends': ['report',
                'report_header_fields_company',
                'stock',
                'bahmni_stock',
                ],
    'data': ['report/account_payment_report_layout.xml',
             'views/report_layout.xml',
             'report/report_stockpicking_operations.xml',
             'report/account_payment_report.xml',
             ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
