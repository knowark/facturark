from pytest import raises
from facturark.namespaces import NS
from lxml.etree import tostring


def test_identifier_identify(identifier):
    with raises(NotImplementedError):
        identifier.identify(None)


def test_invoice_identifier_definition(identifier, invoice_identifier):
    assert isinstance(invoice_identifier, identifier.__class__)


def test_invoice_identifier_parse_invoice(
        invoice_identifier, generic_invoice):

    data_dict = invoice_identifier._parse_invoice(generic_invoice)

    assert isinstance(data_dict, dict)

    expected_values = [
        ('invoice_number', 'SETP990000002'),
        ('issue_date', '2019-06-20'),
        ('issue_time', '09:15:23-05:00'),
        ('invoice_value', '12600.06'),
        ('tax_code_1', '01'),
        ('tax_value_1', '2424.01'),
        ('tax_code_2', '04'),
        ('tax_value_2', '0.00'),
        ('tax_code_3', '03'),
        ('tax_value_3', '0.00'),
        ('payable_value', '14024.07'),
        ('supplier_id', '800197268'),
        ('customer_id', '900108281'),
        ('profile', '2')
    ]

    for key, expected in expected_values:
        assert data_dict[key] == expected


def test_invoice_identifier_identify(invoice_identifier, generic_invoice):

    expected_dict = {}

    def mock_hash_uuid(uuid_dict):
        expected_dict['invoice_number'] = uuid_dict['invoice_number']
        expected_dict['technical_key'] = uuid_dict['technical_key']
        return 'ABC'

    invoice_identifier._hash_uuid = mock_hash_uuid

    uuid_hash = invoice_identifier.identify(generic_invoice)

    assert uuid_hash == 'ABC'
    assert expected_dict['invoice_number'] == 'SETP990000002'
    assert expected_dict['technical_key'] == (
        invoice_identifier.technical_key)


def test_invoice_identifier_hash_uuid(invoice_identifier):
    technical_key = '693ff6f2a553c3646a063436fd4dd9ded0311471'
    uuid_dict = dict([
        ('invoice_number', 'SETP990000002'),
        ('issue_date', '2019-06-20'),
        ('issue_time', '09:15:23-05:00'),
        ('invoice_value', '12600.06'),
        ('tax_code_1', '01'),
        ('tax_value_1', '2424.01'),
        ('tax_code_2', '04'),
        ('tax_value_2', '0.00'),
        ('tax_code_3', '03'),
        ('tax_value_3', '0.00'),
        ('payable_value', '14024.07'),
        ('supplier_id', '800197268'),
        ('customer_id', '900108281'),
        ('technical_key', technical_key),
        ('profile', '2')
    ])

    result = invoice_identifier._hash_uuid(uuid_dict)

    assert result == (
        '953febf8b9fc43666789c019922c881f786b0012b77eb7ea2'
        'ad08c81bd7ace084cf6a0f3db0564abf8887060c854a287')


def test_invoice_identifier_inject_uuid_hash(
        invoice_identifier, generic_invoice):
    uuid_hash = (
        '953febf8b9fc43666789c019922c881f786b0012b77eb7ea2'
        'ad08c81bd7ace084cf6a0f3db0564abf8887060c854a287')

    injected_invoice = invoice_identifier._inject_uuid_hash(
        generic_invoice, uuid_hash)

    assert injected_invoice.find('//cbc:UUID', vars(NS)).text == uuid_hash
