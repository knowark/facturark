from hashlib import sha384
from lxml.etree import fromstring, tostring, Element, QName
from ..namespaces import NS
from .identifier import Identifier


class InvoiceIdentifier(Identifier):

    def __init__(self, technical_key, namespaces=None):
        self.technical_key = technical_key
        self.namespaces = namespaces

    def identify(self, invoice):
        uuid_dict = self._parse_invoice(invoice)
        uuid_dict['technical_key'] = self.technical_key
        uuid_hash = self._hash_uuid(uuid_dict)
        invoice = self._inject_uuid_hash(invoice, uuid_hash)

        return uuid_hash

    def _parse_invoice(self, invoice):
        invoice_number = invoice.find('./cbc:ID', self.namespaces).text
        issue_date = invoice.find('./cbc:IssueDate', self.namespaces).text
        issue_time = invoice.find('./cbc:IssueTime', self.namespaces).text

        invoice_value = invoice.find(
            './cac:LegalMonetaryTotal/cbc:LineExtensionAmount',
            self.namespaces).text

        tax_code_1, tax_value_1 = self._get_tax_values(invoice, '01')
        tax_code_2, tax_value_2 = self._get_tax_values(invoice, '04')
        tax_code_3, tax_value_3 = self._get_tax_values(invoice, '03')

        payable_value = invoice.find(
            './cac:LegalMonetaryTotal/cbc:PayableAmount', vars(NS)).text
        supplier_id = invoice.find(
            ('./cac:AccountingSupplierParty/cac:Party/'
             'cac:PartyTaxScheme/cbc:CompanyID'), vars(NS)).text
        customer_id = invoice.find(
            ('./cac:AccountingCustomerParty/cac:Party/'
             'cac:PartyTaxScheme/cbc:CompanyID'), vars(NS)).text

        profile = invoice.find('./cbc:ProfileExecutionID', vars(NS)).text

        return dict(locals())

    def _get_tax_values(self, invoice, code):
        tax_code = code
        tax_value = 0.00
        tax_element = invoice.xpath(
            ('./cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/'
             'cbc:ID[text()="{}"]'.format(code)), namespaces=self.namespaces)

        for element in tax_element:
            tax_code = element.text
            for tax_total in element.xpath(
                    'ancestor::cac:TaxTotal', namespaces=self.namespaces):
                tax_value = tax_total.find(
                    './cbc:TaxAmount', namespaces=self.namespaces).text

        return tax_code, tax_value

    def _hash_uuid(self, uuid_dict):
        uuid_list = [
            uuid_dict['invoice_number'],
            uuid_dict['issue_date'], uuid_dict['issue_time'],
            uuid_dict['invoice_value'],
            uuid_dict['tax_code_1'], uuid_dict['tax_value_1'],
            uuid_dict['tax_code_2'], uuid_dict['tax_value_2'],
            uuid_dict['tax_code_3'], uuid_dict['tax_value_3'],
            uuid_dict['payable_value'],
            uuid_dict['supplier_id'], uuid_dict['customer_id'],
            uuid_dict['technical_key'],
            uuid_dict['profile']
        ]

        uuid_bytes = bytes("".join(uuid_list).encode('utf-8'))

        return sha384(uuid_bytes).hexdigest()

    def _inject_uuid_hash(self, invoice, uuid_hash):
        uuid_element = invoice.find('cbc:UUID', vars(NS))
        uuid_element.text = uuid_hash
        return invoice


class BlankIdentifier(Identifier):

    def identify(self, document):
        return ''
