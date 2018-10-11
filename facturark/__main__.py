import io
import sys
import json
from argparse import ArgumentParser
from facturark import build_invoice, send_invoice
from facturark.utils import json_serialize


def read_file(file_path):
    with io.open(file_path, 'rb') as f:
        return f.read()


def write_file(file_path, data):
    with io.open(file_path, 'wb') as f:
        f.write(data)


def cli_build_invoice(options_dict):
    invoice_bytes = read_file(options_dict.get('input_file'))
    invoice_dict = json.loads(invoice_bytes.decode('utf-8'))
    certificate = (read_file(options_dict.get('certificate'))
                   if options_dict.get('certificate') else None)
    password = options_dict.get('password')
    invoice_xml = build_invoice(invoice_dict, certificate, password)
    output_file = options_dict.get('output_file')
    write_file(output_file, invoice_xml)


def cli_send_invoice(options_dict):
    request_bytes = read_file(options_dict.get('request_file'))
    request_dict = json.loads(request_bytes.decode('utf-8'))
    
    document_bytes = b''
    if options_dict.get('document_file'):
        document_bytes = read_file(options_dict.get('document_file'))

    request_dict['document'] = request_dict.get('document') or document_bytes

    response_dict = send_invoice(request_dict)
    response_json = json.dumps(
        response_dict, default=json_serialize).encode('utf-8')
    output_file = options_dict.get('output_file')
    write_file(output_file, response_json)


def parse(arg_list):
    parser = ArgumentParser(prog='Facturark')
    subparsers = parser.add_subparsers(dest='action')

    build_parser = subparsers.add_parser('build')
    build_parser.add_argument('input_file')
    build_parser.add_argument('-c', '--certificate')
    build_parser.add_argument('-p', '--password')
    build_parser.add_argument('-o', '--output_file')
    build_parser.set_defaults(func=cli_build_invoice)

    send_parser = subparsers.add_parser('send')
    send_parser.add_argument('request_file')
    send_parser.add_argument('-d', '--document_file')
    send_parser.add_argument('-o', '--output_file')
    send_parser.set_defaults(func=cli_send_invoice)

    args = parser.parse_args(arg_list)
    return args


def main(args):
    args_namespace = parse(args)
    args_namespace.func(vars(args_namespace))


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main(sys.argv[1:]))
