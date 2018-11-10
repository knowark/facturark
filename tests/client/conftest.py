import os
import io
from pytest import fixture
from facturark.analyzer import Analyzer
from facturark.client import Client


@fixture
def analyzer():
    analyzer = Analyzer()
    return analyzer


@fixture
def client(analyzer):
    username = "USER"
    password = "PASS"
    test_url = ("tests/data/electronic_invoice.wsdl")

    return Client(analyzer, username, password, test_url)


@fixture
def document():
    filename = 'signed_invoice.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    file_path = os.path.join(directory, '..', 'data', filename)
    with io.open(file_path, 'rb') as f:
        return f.read()


@fixture
def request_dict(document):
    return dict(document=document)


@fixture
def query_dict(document):
    return {
        "document_type": "1",
        "document_number": "PRUE34",
        "vat": "800191678",
        "creation_date": "2017-11-16T08:18:35",
        "software_identifier": "98fcc80b-9f61-4fe2-aac3-13570df4a9e3",
        "uuid": "98fcc80b-9f61-4fe2-aac3-13570df4a9e3"
    }
