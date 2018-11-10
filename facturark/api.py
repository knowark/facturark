from .builder import InvoiceBuilder
from .client import Client, Analyzer, DatePlugin
from .resolver import resolve_invoice_composer
from .validator import Validator, InvoiceUuidGenerator
from .signer.resolver import resolve_signer, resolve_verifier
from .validator.resolver import resolve_validator


def build_invoice(invoice_dict, pkcs12_certificate=None,
                  pkcs12_password=None, technical_key=None):
    invoice_composer = resolve_invoice_composer()
    validator = resolve_validator(technical_key)
    signer = resolve_signer(pkcs12_certificate, pkcs12_password)
    verifier = resolve_verifier()

    builder = InvoiceBuilder(invoice_composer, validator, signer, verifier)
    return builder.build(invoice_dict)


def send_invoice(request_dict):
    client = Client(
        Analyzer(),
        request_dict.pop("username"),
        request_dict.pop("password"),
        request_dict.pop("wsdl_url"))
    return client.send(**request_dict)


def verify_document(document):
    verifier = resolve_verifier()
    return verifier.verify_bytes(document)


def query_document(query_dict):
    client = Client(
        Analyzer(),
        query_dict.pop("username"),
        query_dict.pop("password"),
        query_dict.pop("wsdl_url"),
        [DatePlugin()])
    response = client.query(query_dict)
    return response
