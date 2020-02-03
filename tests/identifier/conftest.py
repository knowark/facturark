import os
from pytest import fixture
from lxml.etree import parse
from facturark.identifier import Identifier, BlankIdentifier, InvoiceIdentifier


@fixture
def identifier():
    return Identifier()


@fixture
def invoice_identifier():
    technical_key = '693ff6f2a553c3646a063436fd4dd9ded0311471'
    namespaces = {
        "cac": ("urn:oasis:names:specification:ubl:"
                "schema:xsd:CommonAggregateComponents-2"),
        "cbc": ("urn:oasis:names:specification:ubl:"
                "schema:xsd:CommonBasicComponents-2")
    }
    return InvoiceIdentifier(technical_key, namespaces=namespaces)


@fixture
def blank_identifier():
    return BlankIdentifier()


@fixture
def invoice():
    filename = 'signed_invoice_sha512.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element


@fixture
def generic_invoice():
    filename = 'V18/Generica.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element
