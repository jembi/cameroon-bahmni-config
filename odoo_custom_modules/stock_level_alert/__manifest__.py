# -*- coding: utf-8 -*-
{
    'name': 'Stock Level Alert',
    'version': '10.0.1.0',
    'summary': 'This module helps to alert for maximum and 0 level stock',
    'sequence': 1,
    'description': """
    	This module helps to alert for below stock level.
    	
    	* Maximum level for purchase order. 		
        * 0 level for Sales Order/Quotation
    """,
    'category': 'Inventory',
    'author': 'Satvix Informatics',
    'website': 'http://www.satvix.com',
    'images': [],
    'depends': ['sale','base', 'sale_stock','purchase'],
    'data': [],
    'demo': [],
    'qweb': [],
    'installable': True,
    'application': True,
    'auto_install': False,
}
