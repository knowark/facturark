import facturark.__main__
from facturark.__main__ import (
    main, cli_build_invoice, cli_send_invoice, cli_verify_document,
    cli_query_document, parse, read_file, write_file)


def test_parse_build():
    arg_list = ['build', '-o', 'invoice.xml', '-c', 'certificate.p12',
                '-p', 'pass', '-t', 'tech_key', 'invoice.json']
    args = parse(arg_list)
    assert args.input_file == 'invoice.json'
    assert args.output_file == 'invoice.xml'
    assert args.certificate == 'certificate.p12'
    assert args.password == 'pass'
    assert args.technical_key == 'tech_key'


def test_parse_send():
    arg_list = ['send', 'request.json', '-o', 'response.json']
    args = parse(arg_list)
    assert args.request_file == 'request.json'
    assert args.output_file == 'response.json'


def test_parse_verify():
    arg_list = ['verify', './invoice.xml']
    args = parse(arg_list)
    assert args.document_file == './invoice.xml'


def test_parse_query():
    arg_list = ['query', '-t', '-o', 'query_response.json',  'query.json']
    args = parse(arg_list)
    assert args.query_file == 'query.json'
    assert args.output_file == 'query_response.json'
    assert args.test == True


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
        'test_pkcs12_password': None,
        'test_technical_key': None
    }

    # Load Invoice File
    test_dir = tmpdir.mkdir("cli")
    input_pathlocal = test_dir.join("invoice.json")
    input_pathlocal.write(b'{"name": "Company XYX", "amount": 50}')

    def mock_build_invoice(invoice_dict,
                           pkcs12_certificate=None,
                           pkcs12_password=None,
                           technical_key=None):

        test_data['test_invoice_dict'] = invoice_dict
        test_data['test_pkcs12_certificate'] = pkcs12_certificate
        test_data['test_pkcs12_password'] = pkcs12_password
        test_data['test_tecnical_key'] = technical_key

        return b'<Invoice><Id>777</Id><Invoice>', ''

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
    assert test_data['test_technical_key'] is None
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


def test_cli_verify_document(tmpdir, monkeypatch):
    monkeypatch.setattr(
        facturark.__main__, 'verify_document', lambda document: True)

    # Load Document File
    test_dir = tmpdir.mkdir("cli")
    document_pathlocal = test_dir.join("invoice.xml")
    document_pathlocal.write(b'<Invoice></Invoice>')

    options_dict = {'action': 'verify',
                    'document_file': str(document_pathlocal)}

    # Call The Cli
    result = cli_verify_document(options_dict)

    assert result is True


def test_cli_query(tmpdir, monkeypatch):
    test_data = {
        'test_query_dict': None
    }

    # Load Invoice File
    test_dir = tmpdir.mkdir("cli")
    query_pathlocal = test_dir.join("query.json")
    query_pathlocal.write(b"""{
        "document_type": "1",
        "document_number": "PRUE34",
        "vat": "800191678",
        "creation_date": "2017-11-16T08:18:35",
        "software_identifier": "98fcc80b-9f61-4fe2-aac3-13570df4a9e3",
        "uuid": "98fcc80b-9f61-4fe2-aac3-13570df4a9e3"
    }
    """)

    def mock_query_document(query_dict):
        test_data['test_query_dict'] = query_dict
        return {"response": "success"}

    monkeypatch.setattr(
        facturark.__main__, 'query_document', mock_query_document)

    # Set Output File
    output_pathlocal = test_dir.join("query_response.json")

    options_dict = {'action': 'query',
                    'query_file': str(query_pathlocal),
                    'output_file': str(output_pathlocal),
                    'test': True}

    # Call The Cli
    cli_query_document(options_dict)

    assert isinstance(test_data['test_query_dict'], dict)
    assert output_pathlocal.read('rb') == b'{"response": "success"}'
