from pytest import fixture, mark
from xmlunittest import XmlTestCase
from facturark.models import Invoice
from facturark.serializer import Serializer
from facturark.xml_serializer import XmlSerializer


def test_xml_serializer_implementation():
    assert issubclass(XmlSerializer, Serializer)


@fixture
def serializer():
    builder = XmlSerializer()
    return builder


class TestXmlSerializer(XmlTestCase):

    @fixture(autouse=True)
    def inject_fixtures(self, invoice, serializer):
        self.invoice = invoice
        self.serializer = serializer

    def test_xml_document_returned(self):
        document = self.serializer.serialize(self.invoice)

        # Everything starts with `assertXmlDocument`
        root = self.assertXmlDocument(document)
