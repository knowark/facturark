from facturark.builder import Builder
from facturark.client import Client
from facturark.composers import InvoiceComposer


def build(invoice_dict):
    invoice_composer = InvoiceComposer()
    builder = Builder(invoice_composer)
    return builder.build(invoice_dict)


def send(request_dict):
    client = Client(
        request_dict.pop("username"),
        request_dict.pop("password"),
        request_dict.pop("wsdl_url"))
    return client.send(**request_dict)
