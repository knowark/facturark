# -*- coding: utf-8 -*-

"""Top-level package for FacturArk."""

from .api import (build_document, send_document, verify_document,
                  query_document, generate_qrcode)

from . import analyzer
from . import client
from . import composers
from . import identifier
from . import imager
from . import signer
from . import validator

__author__ = """Nubark"""
__email__ = 'info@nubark.com'
__version__ = '0.3.0'
