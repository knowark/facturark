import zeep
from random import randint
from base64 import b64encode
from datetime import datetime
from lxml.etree import tostring, fromstring
from dateutil import parser
from .username import UsernameToken
from .transports import SoapTransport
from .utils import (
    make_zip_file_bytes, make_document_name)


class Client:

    def __init__(self, analyzer, username, password, wsdl_url, plugins=[]):
        self.analyzer = analyzer
        self.client = zeep.Client(
            wsdl_url,
            wsse=UsernameToken(username, password),
            transport=SoapTransport(),
            plugins=plugins)

    def send(self, document):
        document = fromstring(document)
        vat = self.analyzer.get_supplier_vat(document)
        invoice_number = self.analyzer.get_document_number(document)
        invoice_number_without_prefix = self.analyzer.get_document_number(
            document, without_prefix=True)
        issue_date = self.analyzer.get_issue_date(document)
        issue_date = datetime.strptime(
            issue_date, '%Y-%m-%dT%H:%M:%S')

        filename = make_document_name(vat, invoice_number_without_prefix)
        zip_file_bytes = make_zip_file_bytes(filename, tostring(document))

        response = self.client.service.EnvioFacturaElectronica(
            vat, invoice_number, issue_date, zip_file_bytes)

        return zeep.helpers.serialize_object(response)

    def query(self, query_dict):
        document_type = query_dict['document_type']
        document_number = query_dict['document_number']
        vat = query_dict['vat']
        creation_date = parser.parse(query_dict['creation_date'])
        software_identifier = query_dict['software_identifier']
        uuid = query_dict['uuid']

        response = self.client.service.ConsultaResultadoValidacionDocumentos(
            document_type, document_number, vat, creation_date,
            software_identifier, uuid)

        return zeep.helpers.serialize_object(response)

    def compose(self, document):
        document = fromstring(document)
        vat = self.analyzer.get_supplier_vat(document)
        invoice_number = self.analyzer.get_document_number(document)
        issue_date = self.analyzer.get_issue_date(document)
        issue_date = datetime.strptime(
            issue_date, '%Y-%m-%dT%H:%M:%S')

        root = self.client.create_message(
            self.client.service, 'EnvioFacturaElectronica',
            vat, invoice_number, issue_date, tostring(document))

        return root

    def serialize(self, document):
        root = self.compose(document)
        request_document = tostring(root, pretty_print=True)

        return request_document
