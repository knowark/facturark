import io
from pytest import fixture, mark
from lxml.etree import QName
from xmlunittest import XmlTestCase
from facturark.composers import InvoiceComposer
from facturark.xsd_parser import parse_xsd
from facturark.composers import NS


@fixture
def composer():
    return InvoiceComposer()


class TestInvoiceComposer(XmlTestCase):

    @fixture(autouse=True)
    def inject_fixtures(self, invoice_dict, composer):
        self.invoice_dict = invoice_dict
        self.composer = composer

    def test_invoice_compose(self):
        invoice = self.composer.compose(self.invoice_dict)

        assert invoice.prefix == "fe"
        assert invoice.tag == QName(NS.fe, "Invoice").text
        assert invoice.findtext(QName(NS.cbc, "UBLVersionID")) == "UBL 2.0"
        assert invoice.findtext(QName(NS.cbc, "ProfileID")) == "DIAN 1.0"
        assert invoice.findtext(QName(NS.cbc, "ID")) == "F0001"
        assert invoice.findtext(QName(NS.cbc, "UUID")) == (
            "a3d6c86a71cbc066aaa19fd363c0fe4b5778d4a0")
        assert invoice.findtext(QName(NS.cbc, "IssueDate")) == "2018-09-13"
        assert invoice.findtext(QName(NS.cbc, "IssueTime")) == "00:31:40"
        assert invoice.findtext(QName(NS.cbc, "InvoiceTypeCode")) == "1"
        assert invoice.findtext(QName(NS.cbc, "DocumentCurrencyCode")) == "COP"

    def test_invoice_serialize(self):
        document = self.composer.serialize(self.invoice_dict)

        self.assertXmlDocument(document)
