from .analyzer import Analyzer
from .builder import DocumentBuilder
from .client import Client
from .resolver import (
    resolve_invoice_composer, resolve_credit_note_composer,
    resolve_debit_note_composer, resolve_composer)
from .identifier.resolver import resolve_identifier
from .validator import Validator
from .signer.resolver import resolve_signer, resolve_verifier
from .validator.resolver import resolve_validator
from .imager import Imager


def build_document(document_dict, pkcs12_certificate=None,
                   pkcs12_password=None, technical_key=None, kind='invoice'):
    composer = resolve_composer(kind)
    identifier = resolve_identifier(kind, technical_key)
    validator = resolve_validator()
    signer = resolve_signer(pkcs12_certificate, pkcs12_password)
    verifier = resolve_verifier()

    builder = DocumentBuilder(
        composer, identifier, validator, signer, verifier)
    return builder.build(document_dict)


def send_document(request_dict):
    client = Client(
        Analyzer(),
        request_dict.pop("username"),
        request_dict.pop("password"),
        request_dict.pop("wsdl_url"))
    return client.send(**request_dict)


def generate_qrcode(document):
    imager = Imager(Analyzer())
    return imager.qrcode(document)


def verify_document(document):
    verifier = resolve_verifier()
    return verifier.verify_bytes(document)


def query_document(query_dict):
    client = Client(
        Analyzer(),
        query_dict.pop("username"),
        query_dict.pop("password"),
        query_dict.pop("wsdl_url"))
    response = client.query(**query_dict)
    return response
