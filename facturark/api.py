from .analyzer import Analyzer
from .builder import DocumentBuilder
from .client import Client
from .resolver import (
    resolve_invoice_composer, resolve_credit_note_composer,
    resolve_debit_note_composer, resolve_composer, resolve_identifier)
from .identifier import InvoiceIdentifier, BlankIdentifier
from .validator import Validator
from .signer.resolver import resolve_signer, resolve_verifier
from .validator.resolver import resolve_validator
from .imager import Imager


def build_document(document_dict, certificate=None, private_key=None,
                   technical_key=None, kind='invoice'):
    document_dict = document_dict.copy()
    composer = resolve_composer(kind)
    identifier = resolve_identifier(kind, technical_key)
    validator = resolve_validator()
    signer = resolve_signer(certificate, private_key)
    verifier = resolve_verifier()

    builder = DocumentBuilder(
        composer, identifier, validator, signer, verifier)
    return builder.build(document_dict)


def send_document(request_dict):
    request_dict = request_dict.copy()
    client = Client(
        Analyzer(),
        request_dict.pop("username"),
        request_dict.pop("password"),
        request_dict.pop("wsdl_url"))
    return client.send(**request_dict)


def generate_qrcode(document):
    document = document.copy()
    imager = Imager(Analyzer())
    return imager.qrcode(document)


def verify_document(document):
    document = document.copy()
    verifier = resolve_verifier()
    return verifier.verify_bytes(document)


def query_document(query_dict):
    query_dict = query_dict.copy()
    client = Client(
        Analyzer(),
        query_dict.pop("username"),
        query_dict.pop("password"),
        query_dict.pop("wsdl_url"))
    response = client.query(**query_dict)
    return response
