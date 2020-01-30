import os
from pytest import fixture
from lxml.etree import parse
from facturark.analyzer import Analyzer
from facturark.validator import Reviewer


@fixture
def mock_reviewer():
    class MockReviewer:
        def review(self, document):
            return None
    return MockReviewer()


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


@fixture
def load():
    def _loader(filename):
        directory = os.path.dirname(os.path.realpath(__file__))
        element = parse(os.path.join(directory, '..', 'data', filename))
        return element

    return _loader
