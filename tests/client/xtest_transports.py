from lxml.etree import fromstring
from facturark.client.transports import SoapTransport


def test_soap_transport_instantiation():
    transport = SoapTransport()
    assert transport


def test_soap_transport_post_xml():
    transport = SoapTransport()

    class MockResponse:
        def __init__(self):
            self.headers = {'Content-Type': 'Multipart/Related'}

    def mock_post(address, message, headers):
        return MockResponse()

    transport.post = mock_post
    address = ""
    envelope = fromstring("<Envelope></Envelope>")
    headers = {}

    response = transport.post_xml(address, envelope, headers)

    assert 'multipart/related' in response.headers['Content-Type']
