import io
from pytest import fixture, mark
from xmlunittest import XmlTestCase
from facturark.serializers import InvoiceSerializer
from facturark.xsd_parser import parse_xsd


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

        # assert invoice.tag == "Invoice"
        assert invoice.UBLVersionID == "UBL 2.0"

    def test_invoice_serialize(self):
        document = self.serializer.serialize(self.invoice_dict)

        print("\n")
        print(document)

        self.assertXmlDocument(document)
