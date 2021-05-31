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
                'report_header_fields_company'
                ],
    'data': ['views/report_layout.xml',
             ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
