import os
from pytest import fixture
from lxml.etree import parse
from facturark.identifier import Identifier, InvoiceIdentifier, BlankIdentifier


@fixture
def identifier():
    return Identifier()


@fixture
def invoice_identifier():
    technical_key = '693ff6f2a553c3646a063436fd4dd9ded0311471'
    return InvoiceIdentifier(technical_key)


@fixture
def blank_identifier():
    return BlankIdentifier()


@fixture
def invoice():
    filename = 'signed_invoice_sha512.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element
