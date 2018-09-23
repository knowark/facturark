from facturark.builder import InvoiceBuilder
from facturark.client import Client
from facturark.resolver import resolve_invoice_composer
from facturark.validator import Validator


def build_invoice(invoice_dict):
    invoice_composer = resolve_invoice_composer()
    validator = Validator()
    builder = InvoiceBuilder(invoice_composer, validator)
    return builder.build(invoice_dict)


def send_invoice(request_dict):
    client = Client(
        request_dict.pop("username"),
        request_dict.pop("password"),
        request_dict.pop("wsdl_url"))
    return client.send(**request_dict)
