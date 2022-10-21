import odoo.http as http
from odoo.http import Response
import json
from datetime import datetime, timedelta
import werkzeug
from odoo import models, fields, api, http
from odoo.http import Controller, route, request
import simplejson as json
import ssl
from pprint import pprint
import base64
import ast
import itertools as it
import requests
from requests.auth import HTTPBasicAuth
from flask import jsonify, make_response



class ProductApi(http.Controller):

    @http.route('/api/products', csrf=False, type='http', methods=["GET"], token=None, auth='none')
    # call like http://192.168.33.12:8069/api/products?uuid=26fd8c3e-2813-4464-9719-2bc3bd7b4633
    def get_users(self, **args):
        if args['uuid']:
            product_id = request.env['product.product'].sudo().search([('uuid', '=', str(args['uuid']))], limit=1)
            data = []
            qty_available = 0
            if product_id:
                data.append({
                    "qty_available":product_id.qty_available,
                })
        return json.dumps(data)
    