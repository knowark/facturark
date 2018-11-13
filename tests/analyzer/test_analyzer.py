from lxml.etree import fromstring, Element, QName
from facturark.namespaces import NS


def test_analyzer_get_supplier_vat(analyzer, document):
    result = analyzer.get_supplier_vat(document)
    assert result == '900373115'


def test_analyzer_get_document_number(analyzer, document):
    result = analyzer.get_document_number(document)
    assert result == 'PRUE980007161'


def test_analyzer_get_document_number_without_prefix(analyzer, document):
    result = analyzer.get_document_number(document, without_prefix=True)
    assert result == '980007161'


def test_analyzer_get_issue_date(analyzer, document):
    result = analyzer.get_issue_date(document)
    assert result == '2016-07-12T00:31:40'


def test_analyzer_get_document_type(analyzer):
    assert analyzer.get_document_type(
        Element(QName(NS.fe, 'Invoice'), nsmap=vars(NS))) == '1'
    assert analyzer.get_document_type(
        Element(QName(NS.fe, 'CreditNote'), nsmap=vars(NS))) == '2'
    assert analyzer.get_document_type(
        Element(QName(NS.fe, 'DebitNote'), nsmap=vars(NS))) == '3'
    assert analyzer.get_document_type(
        Element(QName(NS.fe, 'ApplicationResponse'), nsmap=vars(NS))) == '4'


def test_analyzer_get_signing_date(analyzer, document):
    result = analyzer.get_signing_time(document)
    assert result == '2016-07-12T11:17:38.639-05:00'


def test_analyzer_get_software_identifier(analyzer, document):
    result = analyzer.get_software_identifier(document)
    assert result == '0d2e2883-eb8d-4237-87fe-28aeb71e961e'


def test_analyzer_get_uuid(analyzer, document):
    result = analyzer.get_uuid(document)
    assert result == 'a3d6c86a71cbc066aaa19fd363c0fe4b5778d4a0'


def test_analyzer_get_supplier_type(analyzer, document):
    result = analyzer.get_supplier_type(document)
    assert result == '1'


def test_analyzer_get_customer_type(analyzer, document):
    result = analyzer.get_customer_type(document)
    assert result == '2'


def test_analyzer_get_supplier_country(analyzer, document):
    result = analyzer.get_supplier_country(document)
    assert result == 'CO'


def test_analyzer_get_customer_country(analyzer, document):
    result = analyzer.get_customer_country(document)
    assert result == 'CO'


def test_analyzer_get_document_currency(analyzer, document):
    result = analyzer.get_document_currency(document)
    assert result == 'COP'


def test_analyzer_get_invoice_type(analyzer, document):
    result = analyzer.get_invoice_type(document)
    assert result == '1'


def test_analyzer_get_invoice_type_none(analyzer):
    document = Element(QName(NS.fe, 'CreditNote'), nsmap=vars(NS))
    result = analyzer.get_invoice_type(document)
    assert result is None
