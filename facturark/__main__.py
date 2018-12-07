import io
import sys
import json
from argparse import ArgumentParser
from facturark import (
    build_document, send_document, verify_document, query_document,
    generate_qrcode)
from facturark.utils import json_serialize


def read_file(file_path):
    with io.open(file_path, 'rb') as f:
        return f.read()


def write_file(file_path, data):
    with io.open(file_path, 'wb') as f:
        f.write(data)


def resolve_document(options_dict):
    document_bytes = b''
    if options_dict.get('document_file'):
        document_bytes = read_file(options_dict.get('document_file'))
    return document_bytes


def cli_build_document(options_dict):
    invoice_bytes = read_file(options_dict.get('input_file'))
    invoice_dict = json.loads(invoice_bytes.decode('utf-8'))
    certificate = (read_file(options_dict.get('certificate'))
                   if options_dict.get('certificate') else None)
    password = options_dict.get('password')
    technical_key = options_dict.get('technical_key')
    kind = options_dict.get('kind')
    invoice_xml, _ = build_document(
        invoice_dict, certificate, password, technical_key, kind)
    output_file = options_dict.get('output_file')
    write_file(output_file, invoice_xml)


def cli_qrcode(options_dict):
    document_path = options_dict.get('document_file')
    document_bytes = read_file(document_path)
    image_bytes = generate_qrcode(document_bytes)
    output_file = options_dict.get('output_file')
    write_file(output_file, image_bytes)
    return True


def cli_send_document(options_dict):
    request_bytes = read_file(options_dict.get('request_file'))
    request_dict = json.loads(request_bytes.decode('utf-8'))

    document_bytes = resolve_document(options_dict)

    request_dict['document'] = request_dict.get('document') or document_bytes

    response_dict = send_document(request_dict)
    response_json = json.dumps(
        response_dict, default=json_serialize).encode('utf-8')
    output_file = options_dict.get('output_file')
    write_file(output_file, response_json)


def cli_verify_document(options_dict):
    document_path = options_dict.get('document_file')
    document_bytes = read_file(document_path)
    return verify_document(document_bytes)


def cli_query_document(options_dict):
    query_bytes = read_file(options_dict.get('query_file'))
    query_dict = json.loads(query_bytes.decode('utf-8'))

    document_bytes = resolve_document(options_dict)

    query_dict['document'] = query_dict.get('document') or document_bytes

    response_dict = query_document(query_dict)
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
    build_parser.add_argument('-t', '--technical_key')
    build_parser.add_argument('-k', '--kind', default='invoice')
    build_parser.set_defaults(func=cli_build_document)

    send_parser = subparsers.add_parser('send')
    send_parser.add_argument('request_file')
    send_parser.add_argument('-d', '--document_file')
    send_parser.add_argument('-o', '--output_file')
    send_parser.set_defaults(func=cli_send_document)

    qrcode_parser = subparsers.add_parser('qrcode')
    qrcode_parser.add_argument('document_file')
    qrcode_parser.add_argument('-o', '--output_file')
    qrcode_parser.set_defaults(func=cli_qrcode)

    verify_parser = subparsers.add_parser('verify')
    verify_parser.add_argument('document_file')
    verify_parser.set_defaults(func=cli_verify_document)

    query_parser = subparsers.add_parser('query')
    query_parser.add_argument('query_file')
    query_parser.add_argument('-d', '--document_file')
    query_parser.add_argument('-o', '--output_file')
    query_parser.set_defaults(func=cli_query_document)

    if len(arg_list) == 0:
        parser.print_help()
        parser.exit()

    args = parser.parse_args(arg_list)
    return args


def main(args):
    args_namespace = parse(args)
    args_namespace.func(vars(args_namespace))


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main(sys.argv[1:]))
