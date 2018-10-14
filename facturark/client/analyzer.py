from lxml.etree import fromstring
from facturark.namespaces import NS


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
