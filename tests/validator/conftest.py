import os
from pytest import fixture
from lxml.etree import parse
from facturark.analyzer import Analyzer
from facturark.validator import Validator, InvoiceUuidGenerator, Reviewer


@fixture
def invoice_uuid_generator():
    technical_key = '693ff6f2a553c3646a063436fd4dd9ded0311471'
    return InvoiceUuidGenerator(technical_key)


@fixture
def validator(invoice_uuid_generator):
    class MockUuidGenerator:
        def generate(self, invoice):
            return invoice, ""
    return Validator(MockUuidGenerator())


@fixture
def invoice():
    filename = 'signed_invoice_sha512.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element


@fixture
def credit_note():
    filename = 'signed_credit_note_sha512.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element


@fixture
def reviewer():
    return Reviewer(Analyzer())
