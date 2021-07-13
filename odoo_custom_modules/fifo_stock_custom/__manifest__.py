# -*- coding: utf-8 -*-
{
    'name': 'FIFO Stock Custom',
    'version': '1.0',
    'summary': 'Sort Batch No (or Lot Id) based on the expiry date',
    'sequence': 1,
    'description': """
This module sorts the Batch No (or Lot Id) based on the expiry date using the first-in first-out strategy
====================
""",
    'category': 'Stock',
    'website': '',
    'images': [],
    'depends': ['stock', 'bahmni_sale', 'bahmni_stock', 'product_expiry'],
    'data': [
            'views/sale_order_views.xml',
             ],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
