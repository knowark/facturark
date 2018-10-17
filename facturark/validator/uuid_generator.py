from hashlib import sha1
from lxml.etree import fromstring, tostring, Element, QName
from ..namespaces import NS


class InvoiceUuidGenerator:

    def __init__(self, technical_key):
        self.technical_key = technical_key

    def generate(self, invoice):
        uuid_dict = self._parse_invoice(invoice)
        uuid_dict['technical_key'] = self.technical_key
        uuid_hash = self._hash_uuid(uuid_dict)
        invoice = self._inject_uuid_hash(invoice, uuid_hash)
        return invoice, uuid_hash

    def _parse_invoice(self, invoice):
        invoice_number = invoice.find('cbc:ID', vars(NS)).text

        issue_date = invoice.find('cbc:IssueDate', vars(NS)).text
        issue_time = invoice.find('cbc:IssueTime', vars(NS)).text
        invoice_date = (issue_date + issue_time).replace(
            ':', '').replace('-', '')

        invoice_value = invoice.find(
            'fe:LegalMonetaryTotal/cbc:LineExtensionAmount', vars(NS)).text

        tax_code_1, tax_value_1 = self._get_tax_values(invoice, '01')
        tax_code_2, tax_value_2 = self._get_tax_values(invoice, '02')
        tax_code_3, tax_value_3 = self._get_tax_values(invoice, '03')

        payable_value = invoice.find(
            'fe:LegalMonetaryTotal/cbc:PayableAmount', vars(NS)).text

        supplier_vat = invoice.find(
            ('fe:AccountingSupplierParty/fe:Party/'
             'cac:PartyIdentification/cbc:ID'), vars(NS)).text

        customer_type = invoice.find(
            ('fe:AccountingCustomerParty/fe:Party/'
             'cac:PartyIdentification/cbc:ID'), vars(NS)).attrib['schemeID']

        customer_vat = invoice.find(
            ('fe:AccountingCustomerParty/fe:Party/'
             'cac:PartyIdentification/cbc:ID'), vars(NS)).text

        return dict(locals())

    def _get_tax_values(self, invoice, code):
        tax_code = code
        tax_value = '0.00'
        tax_element = invoice.xpath(
            ('fe:TaxTotal/fe:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/'
             'cbc:ID[text()="{}"]'.format(code)), namespaces=vars(NS))
        if tax_element:
            tax_code = tax_element[0].text
            tax_subtotal = tax_element[0].xpath(
                'ancestor::fe:TaxSubtotal', namespaces=vars(NS))[0]
            tax_value = tax_subtotal.find('cbc:TaxAmount', vars(NS)).text

        return tax_code, tax_value

    def _hash_uuid(self, uuid_dict):
        uuid_list = [
            uuid_dict['invoice_number'],
            uuid_dict['invoice_date'], uuid_dict['invoice_value'],
            uuid_dict['tax_code_1'], uuid_dict['tax_value_1'],
            uuid_dict['tax_code_2'], uuid_dict['tax_value_2'],
            uuid_dict['tax_code_3'], uuid_dict['tax_value_3'],
            uuid_dict['payable_value'], uuid_dict['supplier_vat'],
            uuid_dict['customer_type'], uuid_dict['customer_vat'],
            uuid_dict['technical_key']
        ]

        uuid_bytes = bytes("".join(uuid_list).encode('utf-8'))

        return sha1(uuid_bytes).hexdigest()

    def _inject_uuid_hash(self, invoice, uuid_hash):
        uuid_element = invoice.find('cbc:UUID', vars(NS))
        uuid_element.text = uuid_hash
        return invoice
