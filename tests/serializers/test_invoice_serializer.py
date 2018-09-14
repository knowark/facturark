import io
from pytest import fixture, mark
from lxml.etree import QName
from xmlunittest import XmlTestCase
from facturark.serializers import InvoiceSerializer
from facturark.xsd_parser import parse_xsd
from facturark.serializers import NS


@fixture
def serializer():
    return InvoiceSerializer()


class TestInvoiceSerializer(XmlTestCase):

    @fixture(autouse=True)
    def inject_fixtures(self, invoice_dict, serializer):
        self.invoice_dict = invoice_dict
        self.serializer = serializer

    def test_invoice_assemble(self):
        invoice = self.serializer.assemble(self.invoice_dict)

        assert invoice.prefix == "fe"
        assert invoice.tag == QName(NS.fe, "Invoice").text
        assert invoice.findtext(QName(NS.cbc, "UBLVersionID")) == "UBL 2.0"
        assert invoice.findtext(QName(NS.cbc, "ProfileID")) == "DIAN 1.0"
        assert invoice.findtext(QName(NS.cbc, "ID")) == "F0001"

    def test_invoice_serialize(self):
        document = self.serializer.serialize(self.invoice_dict)

        print("\n")
        print(document)

        self.assertXmlDocument(document)
