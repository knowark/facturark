from lxml.etree import fromstring
from pytest import fixture
from facturark.client import Client


def test_client_instantiation(client):
    assert client


def test_client_send(client, request_dict):
    def mock_service(vat, invoice_number, issue_date, document):
        return {'response': 'success'}

    client.client.service.EnvioFacturaElectronica = mock_service
    response = client.send(**request_dict)
    assert response is not None


def test_client_query(client, query_dict):
    def mock_service(document_type, document_number, vat, creation_date,
                     software_identifier, uuid):
        return {'response': 'success'}

    client.client.service.ConsultaResultadoValidacionDocumentos = mock_service
    response = client.query(query_dict)
    assert response is not None


def test_client_compose(client, request_dict):
    request = client.compose(**request_dict)
    assert request is not None
    assert 'Envelope' in request.tag


def test_invoice_serialize(client, request_dict):
    document = client.serialize(**request_dict)
    root = fromstring(document)
    assert root is not None
