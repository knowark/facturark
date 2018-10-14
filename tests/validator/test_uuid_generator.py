

def test_invoice_uuid_generator_generate(
        invoice, invoice_uuid_generator):

    expected_dict = {}

    def mock_hash_uuid(uuid_dict):
        expected_dict['invoice_number'] = uuid_dict['invoice_number']
        expected_dict['technical_key'] = uuid_dict['technical_key']
        return ''

    invoice_uuid_generator._hash_uuid = mock_hash_uuid
    result = invoice_uuid_generator.generate(invoice)

    assert expected_dict['invoice_number'] == '980007541'
    assert expected_dict['technical_key'] == (
        invoice_uuid_generator.technical_key)


def test_invoice_uuid_generator_parse_invoice(
        invoice, invoice_uuid_generator):

    data_dict = invoice_uuid_generator._parse_invoice(invoice)

    assert data_dict['invoice_number'] == '980007541'
    assert data_dict['issue_date'] == '2018-09-04'
    assert data_dict['issue_time'] == '11:29:24'
    assert data_dict['invoice_date'] == '20180904112924'
    assert data_dict['invoice_value'] == '2000.00'
    assert data_dict['tax_code_1'] == '01'
    assert data_dict['tax_value_1'] == '380.00'
    assert data_dict['tax_code_2'] == '02'
    assert data_dict['tax_value_2'] == '0.00'
    assert data_dict['tax_code_3'] == '03'
    assert data_dict['tax_value_3'] == '0.00'
    assert data_dict['payable_value'] == '2380.00'
    assert data_dict['supplier_vat'] == '700085464'
    assert data_dict['customer_type'] == '31d'
    assert data_dict['customer_vat'] == '123456789.0'


def test_get_tax_values(invoice, invoice_uuid_generator):
    tax_code_1, tax_value_1 = invoice_uuid_generator._get_tax_values(
        invoice, '01')

    assert tax_code_1 == '01'
    assert tax_value_1 == '380.00'

    tax_code_2, tax_value_2 = invoice_uuid_generator._get_tax_values(
        invoice, '02')

    assert tax_code_2 == '02'
    assert tax_value_2 == '0.00'

    tax_code_3, tax_value_3 = invoice_uuid_generator._get_tax_values(
        invoice, '03')

    assert tax_code_3 == '03'
    assert tax_value_3 == '0.00'


def test_hash_uuid(invoice_uuid_generator):
    uuid_dict = {
        'invoice_number': '323200000129',
        'invoice_date': '20150812061131',
        'invoice_value': '1109376.00',
        'tax_code_1': '01',
        'tax_value_1': '0.00',
        'tax_code_2': '02',
        'tax_value_2': '45928.16',
        'tax_code_3': '03',
        'tax_value_3': '107165.72',
        'payable_value': '1296705.20',
        'supplier_vat': '700085371',
        'customer_type': '31',
        'customer_vat': '800199436',
        'technical_key': '693ff6f2a553c3646a063436fd4dd9ded0311471'
    }

    result = invoice_uuid_generator._hash_uuid(uuid_dict)

    assert result == '77c35e565a8d8f9178f2c0cb422b067091c1d760'
