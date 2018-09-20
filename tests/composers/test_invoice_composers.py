import io
from pytest import fixture, mark
from lxml.etree import QName, fromstring
from facturark.xsd_parser import parse_xsd
from facturark.composers import NS
from facturark.composers import InvoiceComposer


@fixture
def composer():
    return InvoiceComposer()


@fixture
def data_dict():
    return {
        "id": "F0001",
        "uuid": "a3d6c86a71cbc066aaa19fd363c0fe4b5778d4a0",
        "issue_date": "2018-09-13",
        "issue_time": "00:31:40",
    }


def test_compose(composer, data_dict, schema):
    invoice = composer.compose(data_dict)

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
    # schema.assertValid(party)
