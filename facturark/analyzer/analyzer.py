from lxml.etree import fromstring, QName
from ..namespaces import NS


class Analyzer:

    def get_supplier_vat(self, document):
        element = fromstring(document)
        supplier_vat = element.find(
            ('fe:AccountingSupplierParty/fe:Party/'
             'cac:PartyIdentification/cbc:ID'), vars(NS)).text
        return supplier_vat

    def get_document_number(self, document, without_prefix=False):
        element = fromstring(document)
        invoice_number = element.find('cbc:ID', vars(NS)).text
        prefix_element = element.find(
            ('.//sts:DianExtensions/sts:InvoiceControl/'
             'sts:AuthorizedInvoices/sts:Prefix'), vars(NS))
        prefix = ''
        if without_prefix and prefix_element is not None:
            prefix = prefix_element.text
        invoice_number = invoice_number.replace(prefix, '')

        return invoice_number

    def get_issue_date(self, document):
        element = fromstring(document)
        issue_date = element.find('cbc:IssueDate', vars(NS)).text
        issue_time = element.find('cbc:IssueTime', vars(NS)).text
        document_date = 'T'.join([issue_date, issue_time])

        return document_date

    def get_document_type(self, document):
        element = fromstring(document)
        if element.tag == QName(NS.fe, 'Invoice'):
            return '1'

    def get_signing_time(self, document):
        element = fromstring(document)
        signing_time = element.find(
            './/xades:SignedSignatureProperties/xades:SigningTime',
            vars(NS)).text
        return signing_time

    def get_software_identifier(self, document):
        element = fromstring(document)
        software_identifier = element.find(
            './/sts:DianExtensions/sts:SoftwareProvider/sts:SoftwareID',
            vars(NS)).text
        return software_identifier

    def get_uuid(self, document):
        element = fromstring(document)
        uuid = element.find(
            './/cbc:UUID', vars(NS)).text
        return uuid
