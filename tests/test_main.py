import facturark.__main__
from pytest import raises
from facturark.__main__ import (
    main, cli_build_document, cli_send_document, cli_verify_document,
    cli_query_document, parse, read_file, write_file, resolve_document,
    cli_qrcode)


def test_parse_help():
    arg_list = []
    with raises(SystemExit):
        parse(arg_list)


def test_parse_build():
    arg_list = ['build', '-o', 'invoice.xml', '-c', 'cert.pem',
                '-p', 'key.pem', '-t', 'tech_key', 'invoice.json']
    args = parse(arg_list)
    assert args.input_file == 'invoice.json'
    assert args.output_file == 'invoice.xml'
    assert args.certificate == 'cert.pem'
    assert args.private_key == 'key.pem'
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
    arg_list = ['query', '-o', 'query_response.json',
                '-d', 'document.xml', 'query.json']
    args = parse(arg_list)
    assert args.query_file == 'query.json'
    assert args.output_file == 'query_response.json'
    assert args.document_file == 'document.xml'


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


def test_cli_build_invoice(tmpdir, monkeypatch):
    test_data = {
        'test_invoice_dict': None,
        'test_certificate': None,
        'test_private_key': None,
        'test_technical_key': None
    }

    # Load Invoice File
    test_dir = tmpdir.mkdir("cli")
    input_pathlocal = test_dir.join("invoice.json")
    input_pathlocal.write(b'{"name": "Company XYX", "amount": 50}')

    def mock_build_document(invoice_dict,
                            certificate=None,
                            private_key=None,
                            technical_key=None,
                            kind='invoice'):

        test_data['test_invoice_dict'] = invoice_dict
        test_data['test_certificate'] = certificate
        test_data['test_private_key'] = private_key
        test_data['test_tecnical_key'] = technical_key

        return b'<Invoice><Id>777</Id><Invoice>', ''

    monkeypatch.setattr(
        facturark.__main__, 'build_document', mock_build_document)

    # Set Output File
    output_pathlocal = test_dir.join("invoice.xml")

    options_dict = {'action': 'build',
                    'input_file': str(input_pathlocal),
                    'output_file': str(output_pathlocal)}

    # Call The Cli
    cli_build_document(options_dict)

    assert isinstance(test_data['test_invoice_dict'], dict)
    assert test_data['test_certificate'] is None
    assert test_data['test_private_key'] is None
    assert test_data['test_technical_key'] is None
    assert output_pathlocal.read('rb') == b'<Invoice><Id>777</Id><Invoice>'


def xtest_cli_build_credit_note(tmpdir, monkeypatch):
    test_data = {
        'test_credit_note_dict': None,
        'test_certificate': None,
        'test_private_key': None,
        'test_technical_key': None
    }

    # Load Invoice File
    test_dir = tmpdir.mkdir("cli")
    input_pathlocal = test_dir.join("credit_note.json")
    input_pathlocal.write(b'{"name": "Company XYX", "amount": 50}')

    def mock_build_invoice(credit_note_dict,
                           certificate=None,
                           private_key=None,
                           technical_key=None):

        test_data['test_credit_note_dict'] = credit_note_dict
        test_data['test_certificate'] = certificate
        test_data['test_private_key'] = private_key
        test_data['test_technical_key'] = technical_key

        return b'<Invoice><Id>777</Id><Invoice>', ''

    monkeypatch.setattr(
        facturark.__main__, 'build_document', mock_build_document)

    # Set Output File
    output_pathlocal = test_dir.join("invoice.xml")

    options_dict = {'action': 'build',
                    'input_file': str(input_pathlocal),
                    'output_file': str(output_pathlocal)}

    # Call The Cli
    cli_build_invoice(options_dict)

    assert isinstance(test_data['test_credit_note_dict'], dict)
    assert test_data['test_certificate'] is None
    assert test_data['test_private_key'] is None
    assert test_data['test_technical_key'] is None
    assert output_pathlocal.read('rb') == b'<Invoice><Id>777</Id><Invoice>'


def test_cli_qrcode(tmpdir, monkeypatch):
    monkeypatch.setattr(
        facturark.__main__, 'generate_qrcode', lambda document: b'QRIMAGE')

    # Load Document File
    test_dir = tmpdir.mkdir("cli")
    document_pathlocal = test_dir.join("invoice.xml")
    document_pathlocal.write(b'<Invoice></Invoice>')

    # Set Output File
    output_pathlocal = test_dir.join("qrcode.png")

    options_dict = {'action': 'qrcode',
                    'document_file': str(document_pathlocal),
                    'output_file': str(output_pathlocal)}

    # Call The Cli
    result = cli_qrcode(options_dict)

    assert result is True


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

    def mock_send_document(request_dict):
        test_data['test_request_dict'] = request_dict

        return {"response": "success"}

    monkeypatch.setattr(
        facturark.__main__, 'send_document', mock_send_document)

    # Set Output File
    output_pathlocal = test_dir.join("response.json")

    options_dict = {'action': 'send',
                    'request_file': str(request_pathlocal),
                    'document_file': str(document_pathlocal),
                    'output_file': str(output_pathlocal)
                    }

    # Call The Cli
    cli_send_document(options_dict)

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
        "username": "USER",
        "password": "PASS",
        "wsdl_url": "URL",
        "document": ""
    }
    """)

    document_pathlocal = test_dir.join("document.xml")
    document_pathlocal.write(b"<Invoice>DATA</Invoice>")

    def mock_query_document(query_dict):
        test_data['test_query_dict'] = query_dict
        return {"response": "success"}

    monkeypatch.setattr(
        facturark.__main__, 'query_document', mock_query_document)

    # Set Output File
    output_pathlocal = test_dir.join("query_response.json")

    options_dict = {'action': 'query',
                    'query_file': str(query_pathlocal),
                    'document_file': str(document_pathlocal),
                    'output_file': str(output_pathlocal)}

    # Call The Cli
    cli_query_document(options_dict)

    assert isinstance(test_data['test_query_dict'], dict)
    assert output_pathlocal.read('rb') == b'{"response": "success"}'


def test_resolve_document(monkeypatch):
    data = {'called': False}

    def mock_read_file(file_path):
        data['called'] = True
        return b'DATA'

    monkeypatch.setattr(
        facturark.__main__, 'read_file', mock_read_file)

    result = resolve_document({'document_file': 'invoice.xml'})

    assert result == b'DATA'
    assert data['called'] is True


def test_resolve_document_empty():
    result = resolve_document({})
    assert result == b''
