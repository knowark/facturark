from lxml.etree import fromstring
from pytest import fixture
from facturark.client import Client


@fixture
def client():
    username = "USER"
    password = "PASS"
    test_url = ("tests/data/electronic_invoice.wsdl")

    return Client(username, password, test_url)


@fixture
def request_dict():
    return dict(
        vat="900XXXYYY",
        invoice_number="F0001",
        issue_date="2018-09-14T05:23:31",
        document=b"<XML_DATA></XML_DATA>")


def test_client_instantiation(client):
    assert client


def test_client_send(client, request_dict):
    def mock_service(vat, invoice_number, issue_date, document):
        return fromstring(b"<Response></Response>")

    client.client.service.EnvioFacturaElectronica = mock_service
    response = client.send(**request_dict)
    assert response


def test_client_compose(client, request_dict):
    request = client.compose(**request_dict)
    assert request is not None
    assert 'Envelope' in request.tag


def test_invoice_serialize(client, request_dict):
    document = client.serialize(**request_dict)
    root = fromstring(document)
    assert root is not None
