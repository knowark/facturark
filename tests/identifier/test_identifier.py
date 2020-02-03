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


# def test_invoice_identifier_identify(
#         invoice, invoice_identifier):

#     expected_dict = {}

#     def mock_hash_uuid(uuid_dict):
#         expected_dict['invoice_number'] = uuid_dict['invoice_number']
#         expected_dict['technical_key'] = uuid_dict['technical_key']
#         return 'ABC'

#     invoice_identifier._hash_uuid = mock_hash_uuid
#     uuid_hash = invoice_identifier.identify(invoice)

#     assert uuid_hash == 'ABC'
#     assert expected_dict['invoice_number'] == '980007541'
#     assert expected_dict['technical_key'] == (
#         invoice_identifier.technical_key)


# def test_blank_identifier_identify(invoice, blank_identifier):
#     assert blank_identifier.identify(invoice) == ''


# def test_invoice_uuid_generator_parse_invoice(
#         invoice, invoice_identifier):

#     data_dict = invoice_identifier._parse_invoice(invoice)

#     assert data_dict['invoice_number'] == '980007541'
#     assert data_dict['issue_date'] == '2018-09-04'
#     assert data_dict['issue_time'] == '11:29:24'
#     assert data_dict['invoice_date'] == '20180904112924'
#     assert data_dict['invoice_value'] == '2000.00'
#     assert data_dict['tax_code_1'] == '01'
#     assert data_dict['tax_value_1'] == '380.00'
#     assert data_dict['tax_code_2'] == '02'
#     assert data_dict['tax_value_2'] == '0.00'
#     assert data_dict['tax_code_3'] == '03'
#     assert data_dict['tax_value_3'] == '0.00'
#     assert data_dict['payable_value'] == '2380.00'
#     assert data_dict['supplier_vat'] == '700085464'
#     assert data_dict['customer_type'] == '31d'
#     assert data_dict['customer_vat'] == '123456789.0'


# def test_invoice_identifier_get_tax_values(
#         invoice, invoice_identifier):
#     tax_code_1, tax_value_1 = invoice_identifier._get_tax_values(
#         invoice, '01')

#     assert tax_code_1 == '01'
#     assert tax_value_1 == '380.00'

#     tax_code_2, tax_value_2 = invoice_identifier._get_tax_values(
#         invoice, '02')

#     assert tax_code_2 == '02'
#     assert tax_value_2 == '0.00'

#     tax_code_3, tax_value_3 = invoice_identifier._get_tax_values(
#         invoice, '03')

#     assert tax_code_3 == '03'
#     assert tax_value_3 == '0.00'


# def test_invoice_identifier_hash_uuid(invoice_identifier):
#     uuid_dict = {
#         'invoice_number': '323200000129',
#         'invoice_date': '20150812061131',
#         'invoice_value': '1109376.00',
#         'tax_code_1': '01',
#         'tax_value_1': '0.00',
#         'tax_code_2': '02',
#         'tax_value_2': '45928.16',
#         'tax_code_3': '03',
#         'tax_value_3': '107165.72',
#         'payable_value': '1296705.20',
#         'supplier_vat': '700085371',
#         'customer_type': '31',
#         'customer_vat': '800199436',
#         'technical_key': '693ff6f2a553c3646a063436fd4dd9ded0311471'
#     }

#     result = invoice_identifier._hash_uuid(uuid_dict)

#     assert result == '77c35e565a8d8f9178f2c0cb422b067091c1d760'


# def test_invoice_identifier_hash_uuid_exportation(invoice_identifier):
#     uuid_dict = {
#         'invoice_number': '8110007869',
#         'invoice_date': '20150721000000',
#         'invoice_value': '20320910.90',
#         'tax_code_1': '01',
#         'tax_value_1': '0.00',
#         'tax_code_2': '02',
#         'tax_value_2': '0.00',
#         'tax_code_3': '03',
#         'tax_value_3': '0.00',
#         'payable_value': '20320910.90',
#         'supplier_vat': '900373076',
#         'customer_type': '',
#         'customer_vat': '',
#         'technical_key': '693ff6f2a553c3646a063436fd4dd9ded0311471'
#     }

#     result = invoice_identifier._hash_uuid(uuid_dict)

#     assert result == 'a356c87627fc074e950011070786d2c635596d4f'


# def test_invoice_identifier_inject_uuid_hash(
#         invoice, invoice_identifier):
#     uuid_hash = '77c35e565a8d8f9178f2c0cb422b067091c1d760'

#     injected_invoice = invoice_identifier._inject_uuid_hash(
#         invoice, uuid_hash)

#     assert injected_invoice.find('//cbc:UUID', vars(NS)).text == uuid_hash
