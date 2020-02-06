import zeep
from OpenSSL import crypto
from random import randint
from base64 import b64encode
from datetime import datetime
from lxml.etree import tostring, fromstring
from dateutil import parser
from .username import UsernameToken
from .transports import SoapTransport
from .utils import (
    make_zip_file_bytes, make_document_name)
from .date_plugin import DatePlugin
from .security import Security


class Client:

    def __init__(self, analyzer, wsdl_url,
                 pkcs12_keystore=None,
                 pkcs12_password=None,
                 plugins=[]):
        key_data, cert_data = self._load_keystore(
            pkcs12_keystore, pkcs12_password)

        self.analyzer = analyzer
        self.client = zeep.Client(
            wsdl_url,
            wsse=Security(
                key_data=key_data,
                cert_data=cert_data),
            # transport=SoapTransport(),
            # plugins=[DatePlugin()]
        )
        self.client.set_ns_prefix('wcf', "http://wcf.dian.colombia")
        self.client.set_ns_prefix('soap-env', (
            "http://www.w3.org/2003/05/soap-envelope"))
        self.client.set_ns_prefix('wsa', (
            "http://www.w3.org/2005/08/addressing"))
        self.client.set_ns_prefix('wsu', (
            "http://docs.oasis-open.org/wss/2004/01/"
            "oasis-200401-wss-wssecurity-utility-1.0.xsd"))

    def send(self, document):
        document = fromstring(document)
        # kind = self.analyzer.get_document_type(document)
        # vat = self.analyzer.get_supplier_id(document)
        # invoice_number = self.analyzer.get_document_number(document)
        # invoice_number_without_prefix = self.analyzer.get_document_number(
        #     document, without_prefix=True)
        # issue_date = self.analyzer.get_issue_date(document)
        # issue_date = datetime.strptime(
        #     issue_date, '%Y-%m-%dT%H:%M:%S')

        # filename = make_document_name(vat, invoice_number_without_prefix, kind)
        # zip_file_bytes = make_zip_file_bytes(filename, tostring(document))

        # response = self.client.service.EnvioFacturaElectronica(
        #     vat, invoice_number, issue_date, zip_file_bytes)

        response = self.client.service.GetStatus(
            trackId=123
        )

        print('Response:::', response)

        return zeep.helpers.serialize_object(response)

    def query(self, document):
        document = fromstring(document)

        document_type = self.analyzer.get_document_type(document)
        document_number = self.analyzer.get_document_number(document)
        vat = self.analyzer.get_supplier_vat(document)
        creation_date = self.analyzer.get_signing_time(document)
        creation_date = datetime.strptime(
            creation_date.split('.')[0], '%Y-%m-%dT%H:%M:%S')

        software_identifier = self.analyzer.get_software_identifier(document)
        uuid = self.analyzer.get_uuid(document)

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

    def _load_keystore(self, pkcs12_keystore, pkcs12_password):
        keystore = crypto.load_pkcs12(pkcs12_keystore, pkcs12_password)

        key_data = crypto.dump_privatekey(
            crypto.FILETYPE_PEM, keystore.get_privatekey())
        cert_data = crypto.dump_certificate(
            crypto.FILETYPE_PEM, keystore.get_certificate())

        return key_data, cert_data
