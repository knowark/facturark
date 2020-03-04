from .analyzer import Analyzer
from .builder import DocumentBuilder
from .client import Client
from .composer import resolve_composer
# from .composers.resolver import (
#     resolve_invoice_composer, resolve_credit_note_composer,
#     resolve_debit_note_composer)
from .identifier.resolver import resolve_identifier
from .signer.resolver import resolve_signer, resolve_verifier
from .validator.resolver import resolve_validator
from .imager import Imager
from .namespaces import NS


def build_document(document_dict, pkcs12_keystore=None,
                   pkcs12_password=None, technical_key=None, kind='invoice'):
    composer = resolve_composer(namespaces=vars(NS))
    identifier = resolve_identifier(kind, technical_key, namespaces=vars(NS))
    validator = resolve_validator(kind)
    signer = resolve_signer(pkcs12_keystore, pkcs12_password)
    verifier = resolve_verifier()

    builder = DocumentBuilder(
        composer, identifier, validator, signer, verifier)
    return builder.build(document_dict)


def send_document(document, wsdl_url, pkcs12_keystore=None,
                  pkcs12_password=None):
    client = Client(
        analyzer=Analyzer(),
        wsdl_url=wsdl_url,
        pkcs12_keystore=pkcs12_keystore,
        pkcs12_password=pkcs12_password)
    return client.send(document)


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


def query_zip(zip_key, wsdl_url, pkcs12_keystore=None,
              pkcs12_password=None):
    client = Client(
        analyzer=Analyzer(),
        wsdl_url=wsdl_url,
        pkcs12_keystore=pkcs12_keystore,
        pkcs12_password=pkcs12_password)
    return client.query_zip(zip_key)
