# -*- coding: utf-8 -*-

"""Top-level package for FacturArk."""

from .api import (build_document, build_credit_note, build_debit_note,
                  send_invoice, verify_document, query_document,
                  generate_qrcode)

__author__ = """Nubark"""
__email__ = 'info@nubark.com'
__version__ = '0.3.0'
