import facturark.__main__
from facturark.__main__ import (
    main, cli_build_invoice, cli_send_invoice,
    parse, read_file, write_file)


def test_parse_build():
    arg_list = ['build', 'invoice.json', '-o', 'invoice.xml']
    args = parse(arg_list)
    assert args.input_file == 'invoice.json'
    assert args.output_file == 'invoice.xml'


def test_parse_send():
    arg_list = ['send', 'request.json', '-o', 'response.json']
    args = parse(arg_list)
    assert args.request_file == 'request.json'
    assert args.output_file == 'response.json'


def test_main(monkeypatch):
    test_dict = {
        'call_dict': None
    }

    def mock_parse(args):
        class MockNamespace:
            def __init__(self):
                self.field = 'value'

            def func(self, options_dict):
                test_dict['call_dict'] = options_dict
        return MockNamespace()

    monkeypatch.setattr(facturark.__main__, 'parse', mock_parse)

    args = ['build', 'invoice.json', '-o', 'invoice.xml']
    main(args)

    assert isinstance(test_dict['call_dict'], dict)
    assert test_dict['call_dict'] == {'field': 'value'}


def test_read_file(tmpdir):
    invoice_pathlocal = tmpdir.mkdir("sub").join("invoice.json")
    invoice_pathlocal.write(b'{"name": "Company XYX", "amount": 50}')

    result = read_file(str(invoice_pathlocal))

    assert result == b'{"name": "Company XYX", "amount": 50}'


def test_write_file(tmpdir):
    invoice_pathlocal = tmpdir.mkdir("sub").join("invoice.xml")
    data = b'<Invoice></Invoice>'

    result = write_file(str(invoice_pathlocal), data)

    assert invoice_pathlocal.read('rb') == data


def test_cli_build(tmpdir, monkeypatch):
    test_data = {
        'test_invoice_dict': None,
        'test_pkcs12_certificate': None,
        'test_pkcs12_password': None
    }

    # Load Invoice File
    test_dir = tmpdir.mkdir("cli")
    input_pathlocal = test_dir.join("invoice.json")
    input_pathlocal.write(b'{"name": "Company XYX", "amount": 50}')

    def mock_build_invoice(invoice_dict,
                           pkcs12_certificate=None,
                           pkcs12_password=None):

        test_data['test_invoice_dict'] = test_invoice_dict = invoice_dict
        test_data['test_pkcs12_certificate'] = pkcs12_certificate
        test_data['test_pkcs12_password'] = pkcs12_password

        return b'<Invoice><Id>777</Id><Invoice>'

    monkeypatch.setattr(
        facturark.__main__, 'build_invoice', mock_build_invoice)

    # Set Output File
    output_pathlocal = test_dir.join("invoice.xml")

    options_dict = {'action': 'build',
                    'input_file': str(input_pathlocal),
                    'output_file': str(output_pathlocal)}

    # Call The Cli
    cli_build_invoice(options_dict)

    assert isinstance(test_data['test_invoice_dict'], dict)
    assert test_data['test_pkcs12_certificate'] is None
    assert test_data['test_pkcs12_password'] is None
    assert output_pathlocal.read('rb') == b'<Invoice><Id>777</Id><Invoice>'


def test_cli_send(tmpdir, monkeypatch):
    test_data = {
        'test_request_dict': None
    }

    # Load Invoice File
    test_dir = tmpdir.mkdir("cli")
    request_pathlocal = test_dir.join("request.json")
    request_pathlocal.write(b"""{
        "username": "USER",
        "password": "PASS",
        "issue_date": "2018-10-09T20:00:00",
        "wsdl_url": "URL",
        "invoice_number": "99999999",
        "vat": "99999999",
        "document": ""
    }
    """)
    document_pathlocal = test_dir.join("invoice.xml")
    document_pathlocal.write(b"<Invoice>DATA</Invoice>")

    def mock_send_invoice(request_dict):
        test_data['test_request_dict'] = request_dict

        return {"response": "success"}

    monkeypatch.setattr(
        facturark.__main__, 'send_invoice', mock_send_invoice)

    # Set Output File
    output_pathlocal = test_dir.join("response.json")

    options_dict = {'action': 'send',
                    'request_file': str(request_pathlocal),
                    'document_file': str(document_pathlocal),
                    'output_file': str(output_pathlocal)
                    }

    # Call The Cli
    cli_send_invoice(options_dict)

    assert isinstance(test_data['test_request_dict'], dict)
    assert test_data['test_request_dict']['username'] == 'USER'
    assert output_pathlocal.read('rb') == b'{"response": "success"}'
