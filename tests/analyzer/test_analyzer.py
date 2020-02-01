from lxml.etree import fromstring, Element, QName
from facturark.namespaces import NS


def test_analyzer_get_supplier_vat(analyzer, document):
    result = analyzer.get_supplier_vat(document)
    assert result == '800197268'


def test_analyzer_get_document_number(analyzer, document):
    result = analyzer.get_document_number(document)
    assert result == 'SETP990000002'


def test_analyzer_get_document_number_without_prefix(analyzer, document):
    result = analyzer.get_document_number(document, without_prefix=True)
    assert result == '990000002'


def test_analyzer_get_issue_date(analyzer, document):
    result = analyzer.get_issue_date(document)
    assert result == '2019-06-20T09:15:23-05:00'


def test_analyzer_get_document_type(analyzer):
    assert analyzer.get_document_type(
        Element('Invoice', nsmap=vars(NS))) == '1'
    assert analyzer.get_document_type(
        Element('CreditNote', nsmap=vars(NS))) == '2'
    assert analyzer.get_document_type(
        Element('DebitNote', nsmap=vars(NS))) == '3'
    assert analyzer.get_document_type(
        Element('ApplicationResponse', nsmap=vars(NS))) == '4'


def test_analyzer_get_signing_date(analyzer, document):
    result = analyzer.get_signing_time(document)
    assert result == '2019-06-21T19:09:35.993-05:00'


def test_analyzer_get_software_identifier(analyzer, document):
    result = analyzer.get_software_identifier(document)
    assert result == '56f2ae4e-9812-4fad-9255-08fcfcd5ccb0'


def test_analyzer_get_uuid(analyzer, document):
    result = analyzer.get_uuid(document)
    assert result == ('941cf36af62dbbc06f105d2a80e9bfe683a90e84960eae'
                      '4d351cc3afbe8f848c26c39bac4fbc80fa254824c6369ea694')


def test_analyzer_get_supplier_type(analyzer, document):
    result = analyzer.get_supplier_type(document)
    assert result == '1'


def test_analyzer_get_customer_type(analyzer, document):
    result = analyzer.get_customer_type(document)
    assert result == '1'


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
    assert result == '01'


def test_analyzer_get_invoice_type_none(analyzer):
    document = Element('CreditNote', nsmap=vars(NS))
    result = analyzer.get_invoice_type(document)
    assert result is None


def test_analyzer_get_supplier_identification_type(analyzer, document):
    result = analyzer.get_supplier_identification_type(document)
    assert result == '31'


def test_analyzer_get_customer_identification_type(analyzer, document):
    result = analyzer.get_customer_identification_type(document)
    assert result == '31'


def test_analyzer_get_supplier_tax_scheme(analyzer, document):
    result = analyzer.get_supplier_tax_schemes(document)
    assert result == ['O-99']


def test_analyzer_get_customer_tax_scheme(analyzer, document):
    result = analyzer.get_customer_tax_schemes(document)
    assert result == ['O-99']


def test_analyzer_get_tax_total_amounts(analyzer, document):
    result = analyzer.get_tax_total_amounts(document)
    len(result) == 3
    assert result[0] == '2424.01'
    assert result[1] == '0.00'
    assert result[2] == '0.00'


def test_analyzer_get_tax_types(analyzer, document):
    result = analyzer.get_tax_types(document)
    assert len(result) == 3
    assert '01' in result
    assert '03' in result
    assert '04' in result


def test_analyzer_get_taxable_amount(analyzer, document):
    result = analyzer.get_taxable_amount(document)
    assert len(result) == 4
    assert result[0] == '12600.06'
    assert result[1] == '187.50'
    assert result[2] == '0.00'
    assert result[3] == '0.00'


def test_analyzer_get_tax_amount(analyzer, document):
    result = analyzer.get_tax_amount(document)
    assert len(result) == 4
    assert result[0] == '2394.01'
    assert result[1] == '30.00'
    assert result[2] == '0.00'
    assert result[3] == '0.00'


def test_analyzer_get_id(analyzer, document):
    result = analyzer.get_id(document)
    assert result == 'SETP990000002'


def test_analyzer_get_supplier_id(analyzer, document):
    result = analyzer.get_supplier_id(document)
    assert result == '800197268'


def test_analyzer_get_customer_id(analyzer, document):
    result = analyzer.get_customer_id(document)
    assert result == '900108281'


def test_analyzer_get_total_line_extension_amount(analyzer, document):
    result = analyzer.get_total_line_extension_amount(document)
    assert result == '12600.06'


def test_analyzer_get_total_tax_exclusive_amount(analyzer, document):
    result = analyzer.get_total_tax_exclusive_amount(document)
    assert result == '12787.56'


def test_analyzer_get_total_payable_amount(analyzer, document):
    result = analyzer.get_total_payable_amount(document)
    assert result == '14024.07'


def test_analyzer_get_software_id(analyzer, document):
    result = analyzer.get_software_id(document)
    assert result == '0d2e2883-eb8d-4237-87fe-28aeb71e961e'


def test_analyzer_get_software_provider_id(analyzer, document):
    result = analyzer.get_software_provider_id(document)
    assert result == '900373115'


def test_analyzer_get_invoice_authorization(analyzer, document):
    result = analyzer.get_invoice_authorization(document)
    assert result == '9000000500017960'


def test_analyzer_get_prefix(analyzer, document):
    result = analyzer.get_prefix(document)
    assert result == 'PRUE'


# def test_analyzer_get_tax_vat(analyzer, document_sha512):
#     result = analyzer.get_tax_vat(document_sha512)
#     assert result == '380.00'


def test_analyzer_get_tax_vat_without(analyzer, document):
    result = analyzer.get_tax_vat(document)
    assert result == '0.00'


def test_analyzer_get_tax_other(analyzer, document):
    result = analyzer.get_tax_other(document)
    assert isinstance(result, list)
    assert len(result) == 2
    assert result[0] == '109625.61'
    assert result[1] == '46982.4'
