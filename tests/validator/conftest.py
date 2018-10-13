import os
from pytest import fixture
from lxml.etree import parse
from facturark.validator import Validator, InvoiceUuidGenerator


@fixture
def invoice_uuid_generator():
    return InvoiceUuidGenerator()


@fixture
def validator(invoice_uuid_generator):
    return Validator(invoice_uuid_generator)


@fixture
def invoice():
    filename = 'signed_invoice_sha512.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element
