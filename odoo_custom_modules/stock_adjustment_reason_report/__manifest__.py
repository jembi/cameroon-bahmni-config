# -*- coding: utf-8 -*-
{
    'name': 'Stock Adjustment Reason Report',
    'version': '1.0',
    'summary': 'Add Reason field in Stock Adjustment pdf report',
    'sequence': 1,
    'description': """
Add Reason field in Stock Adjustment pdf report
====================
""",
    'category': 'Stock',
    'website': '',
    'images': [],
    'depends': ['stock', 'adjustment_stock_reason', 'report_header_fields_company', 'custom_header_footer_all_report'],
    'data': ['views/report_stock_inventory.xml',
             ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
