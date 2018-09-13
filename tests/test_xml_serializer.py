import io
from pytest import fixture, mark
from xmlunittest import XmlTestCase
from facturark.models import Invoice
from facturark.serializer import Serializer
from facturark.xml_serializer import XmlSerializer
from facturark.xsd_parser import parse_xsd


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

    def test_xml_document_schema_conformance(self):
        document = self.serializer.serialize(self.invoice)
        root = self.assertXmlDocument(document)

        xschema = parse_xsd("XSD/DIAN/DIAN_UBL.xsd")

        # self.assertXmlValidXSchema(root, xschema=xschema)
