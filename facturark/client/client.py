import zeep
from random import randint
from base64 import b64encode
from datetime import datetime
from lxml.etree import tostring
from .username import UsernameToken
from .transports import SoapTransport
from .utils import (
    make_zip_file_bytes, make_document_name)


class Client:

    def __init__(self, analyzer, username, password, wsdl_url):
        self.analyzer = analyzer
        nonce = b64encode(bytes(randint(0, 100000000)))
        created = datetime.now().isoformat(sep='T')

        self.client = zeep.Client(
            wsdl_url,
            wsse=UsernameToken(username, password),
            transport=SoapTransport())

    def send(self, document):
        vat = self.analyzer.get_supplier_vat(document)
        invoice_number = self.analyzer.get_document_number(document)
        issue_date = self.analyzer.get_issue_date(document)
        issue_date = datetime.strptime(
            issue_date, '%Y-%m-%dT%H:%M:%S')

        filename = make_document_name(vat, invoice_number)
        zip_file_bytes = make_zip_file_bytes(filename, document)

        response = self.client.service.EnvioFacturaElectronica(
            vat, invoice_number, issue_date, zip_file_bytes)

        return zeep.helpers.serialize_object(response)

    def compose(self, document):
        vat = self.analyzer.get_supplier_vat(document)
        invoice_number = self.analyzer.get_document_number(document)
        issue_date = self.analyzer.get_issue_date(document)
        issue_date = datetime.strptime(
            issue_date, '%Y-%m-%dT%H:%M:%S')

        root = self.client.create_message(
            self.client.service, 'EnvioFacturaElectronica',
            vat, invoice_number, issue_date, document)

        return root

    def serialize(self, document):
        vat = self.analyzer.get_supplier_vat(document)
        invoice_number = self.analyzer.get_document_number(document)
        issue_date = self.analyzer.get_issue_date(document)

        root = self.compose(document)
        request_document = tostring(root, pretty_print=True)

        return request_document
