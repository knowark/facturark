from lxml.etree import fromstring, QName
from ..namespaces import NS


class Analyzer:

    def get_supplier_vat(self, document):
        supplier_vat = document.find(
            ('fe:AccountingSupplierParty/fe:Party/'
             'cac:PartyIdentification/cbc:ID'), vars(NS)).text
        return supplier_vat

    def get_document_number(self, document, without_prefix=False):
        invoice_number = document.find('cbc:ID', vars(NS)).text
        prefix_element = document.find(
            ('.//sts:DianExtensions/sts:InvoiceControl/'
             'sts:AuthorizedInvoices/sts:Prefix'), vars(NS))
        prefix = ''
        if without_prefix and prefix_element is not None:
            prefix = prefix_element.text
        invoice_number = invoice_number.replace(prefix, '')

        return invoice_number

    def get_issue_date(self, document):
        issue_date = document.find('cbc:IssueDate', vars(NS)).text
        issue_time = document.find('cbc:IssueTime', vars(NS)).text
        document_date = 'T'.join([issue_date, issue_time])

        return document_date

    def get_document_type(self, document):
        if document.tag == QName(NS.fe, 'Invoice'):
            return '1'

    def get_signing_time(self, document):
        signing_time = document.find(
            './/xades:SignedSignatureProperties/xades:SigningTime',
            vars(NS)).text
        return signing_time

    def get_software_identifier(self, document):
        software_identifier = document.find(
            './/sts:DianExtensions/sts:SoftwareProvider/sts:SoftwareID',
            vars(NS)).text
        return software_identifier

    def get_uuid(self, document):
        uuid = document.find(
            './/cbc:UUID', vars(NS)).text
        return uuid

    def get_supplier_type(self, document):
        supplier_type = document.find(
            ('.//fe:AccountingSupplierParty/'
             'cbc:AdditionalAccountID'), vars(NS)).text
        return supplier_type
