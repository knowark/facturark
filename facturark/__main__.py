import io
import sys
import json
from argparse import ArgumentParser
from facturark import build_invoice


def read_file(file_path):
    with io.open(file_path, 'rb') as f:
        return f.read()


def write_file(file_path, data):
    with io.open(file_path, 'wb') as f:
        f.write(data)


def cli(options_dict):
    action = options_dict.get('action')
    if action == 'build':
        invoice_bytes = read_file(options_dict.get('input_file'))
        invoice_dict = json.loads(invoice_bytes.decode('utf-8'))
        certificate = (read_file(options_dict.get('certificate'))
                       if options_dict.get('certificate') else None)
        password = (read_file(options_dict.get('password'))
                    if options_dict.get('password') else None)
        invoice_xml = build_invoice(invoice_dict, certificate, password)
        output_file = options_dict.get('output_file')
        write_file(output_file, invoice_xml)


def parse(arg_list):
    parser = ArgumentParser(prog='Facturark')
    subparsers = parser.add_subparsers(dest='action')

    build_parser = subparsers.add_parser('build')
    build_parser.add_argument('input_file')
    build_parser.add_argument('-c', '--certificate')
    build_parser.add_argument('-p', '--password')
    build_parser.add_argument('-o', '--output_file')

    send_parser = subparsers.add_parser('send')
    send_parser.add_argument('input_file')
    send_parser.add_argument('-o', '--output_file')

    args = parser.parse_args(arg_list)
    return args


def main(args):
    args_namespace = parse(args)
    cli(vars(args_namespace))


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main(sys.argv[1:]))
