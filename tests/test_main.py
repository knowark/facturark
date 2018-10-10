import facturark.__main__
from facturark.__main__ import main, cli, parse, read_file, write_file


def test_parse_build():
    arg_list = ['build', 'invoice.json', '-o', 'invoice.xml']
    args = parse(arg_list)
    assert args.input_file == 'invoice.json'
    assert args.output_file == 'invoice.xml'


def test_parse_send():
    arg_list = ['send', 'request.json', '-o', 'response.json']
    args = parse(arg_list)
    assert args.input_file == 'request.json'
    assert args.output_file == 'response.json'


def test_main(monkeypatch):
    call_dict = None

    def mock_cli(options_dict):
        nonlocal call_dict
        call_dict = options_dict
    monkeypatch.setattr(facturark.__main__, 'cli', mock_cli)

    args = ['build', 'invoice.json', '-o', 'invoice.xml']
    main(args)

    assert isinstance(call_dict, dict)
    assert call_dict == {'action': 'build',
                         'input_file': 'invoice.json',
                         'certificate': None,
                         'password': None,
                         'output_file': 'invoice.xml'}


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
    test_invoice_dict = None
    test_pkcs12_certificate = None
    test_pkcs12_password = None

    # Load Invoice File
    test_dir = tmpdir.mkdir("cli")
    input_pathlocal = test_dir.join("invoice.json")
    input_pathlocal.write(b'{"name": "Company XYX", "amount": 50}')

    def mock_build_invoice(invoice_dict,
                           pkcs12_certificate=None,
                           pkcs12_password=None):

        nonlocal test_invoice_dict
        test_invoice_dict = invoice_dict
        nonlocal test_pkcs12_certificate
        test_pkcs12_certificate = pkcs12_certificate
        nonlocal test_pkcs12_password
        test_pkcs12_password = pkcs12_password

        return b'<Invoice><Id>777</Id><Invoice>'

    monkeypatch.setattr(
        facturark.__main__, 'build_invoice', mock_build_invoice)

    # Set Output File
    output_pathlocal = test_dir.join("invoice.xml")

    options_dict = {'action': 'build',
                    'input_file': str(input_pathlocal),
                    'output_file': str(output_pathlocal)}

    # Call The Cli
    cli(options_dict)

    assert isinstance(test_invoice_dict, dict)
    assert test_pkcs12_certificate is None
    assert test_pkcs12_password is None
    assert output_pathlocal.read('rb') == b'<Invoice><Id>777</Id><Invoice>'
