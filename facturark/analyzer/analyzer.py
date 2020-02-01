from lxml.etree import fromstring, QName, tostring
from ..namespaces import NS


class Analyzer:

    def get_id(self, document):
        id = document.find('./cbc:ID', vars(NS)).text
        return id

    def get_supplier_vat(self, document):
        supplier_vat = document.find(
            ('cac:AccountingSupplierParty/cac:Party/'
             'cac:PartyLegalEntity/cbc:CompanyID'), vars(NS)).text
        return supplier_vat

    def get_document_number(self, document, without_prefix=False):
        invoice_number = document.find('cbc:ID', vars(NS)).text

        if without_prefix:
            invoice_number = "".join(
                char for char in invoice_number if char.isdigit())

        return invoice_number

    def get_issue_date(self, document):
        issue_date = document.find('cbc:IssueDate', vars(NS)).text
        issue_time = document.find('cbc:IssueTime', vars(NS)).text
        document_date = 'T'.join([issue_date, issue_time])

        return document_date

    def get_document_type(self, document):
        if document.tag == 'Invoice':
            return '1'
        elif document.tag == 'CreditNote':
            return '2'
        elif document.tag == 'DebitNote':
            return '3'
        return '4'

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
        return document.find(
            ('.//cac:AccountingSupplierParty/'
             'cbc:AdditionalAccountID'), vars(NS)).text

    def get_customer_type(self, document):
        return document.find(
            ('.//cac:AccountingCustomerParty/'
             'cbc:AdditionalAccountID'), vars(NS)).text

    def get_supplier_country(self, document):
        return document.find(
            ('.//cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation/'
             'cac:Address/cac:Country/cbc:IdentificationCode'), vars(NS)).text

    def get_customer_country(self, document):
        return document.find(
            ('.//cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation/'
             'cac:Address/cac:Country/cbc:IdentificationCode'), vars(NS)).text

    def get_document_currency(self, document):
        return document.find(
            ('.//cbc:DocumentCurrencyCode'), vars(NS)).text

    def get_invoice_type(self, document):
        element = document.find(('.//cbc:InvoiceTypeCode'), vars(NS))
        if element is not None:
            return element.text

    def get_supplier_identification_type(self, document):
        return document.find(
            ('.//cac:AccountingSupplierParty/cac:Party/'
             'cac:PartyLegalEntity/cbc:CompanyID'
             ), vars(NS)).attrib.get('schemeName')

    def get_customer_identification_type(self, document):
        return document.find(
            ('.//cac:AccountingCustomerParty/cac:Party/'
             'cac:PartyLegalEntity/cbc:CompanyID'
             ), vars(NS)).attrib.get('schemeName')

    def get_supplier_tax_schemes(self, document):
        result = []
        for tax_level_code in document.findall(
            ('.//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/'
             'cbc:TaxLevelCode'), vars(NS)):
            result.append(tax_level_code.text)
        return result

    def get_customer_tax_schemes(self, document):
        result = []
        for tax_level_code in document.findall(
            ('.//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/'
             'cbc:TaxLevelCode'), vars(NS)):
            result.append(tax_level_code.text)
        return result

    def get_tax_total_amounts(self, document):
        result = []
        for tax_element in document.findall(
                ('./cac:TaxTotal/cbc:TaxAmount'), vars(NS)):
            result.append(tax_element.text)
        return result

    def get_tax_types(self, document):
        result = set()
        for tax_element in document.findall(
                ('./cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/'
                 'cac:TaxScheme/cbc:ID'), vars(NS)):
            result.add(tax_element.text)
        return list(result)

    def get_taxable_amount(self, document):
        result = []
        for tax_element in document.findall(
                ('./cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount'
                 ), vars(NS)):
            result.append(tax_element.text)
        return result

    def get_tax_amount(self, document):
        result = []
        for tax_element in document.findall(
                ('./cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount'), vars(NS)):
            result.append(tax_element.text)
        return result

    def get_supplier_id(self, document):
        id = document.find(
            './cac:AccountingSupplierParty/cac:Party/'
            'cac:PartyLegalEntity/cbc:CompanyID', vars(NS)).text
        return id

    def get_customer_id(self, document):
        id = document.find(
            './/cac:AccountingCustomerParty/cac:Party/'
            'cac:PartyLegalEntity/cbc:CompanyID', vars(NS)).text
        return id

    def get_total_line_extension_amount(self, document):
        return document.find(
            ('./cac:LegalMonetaryTotal/'
             'cbc:LineExtensionAmount'), vars(NS)).text

    def get_total_tax_exclusive_amount(self, document):
        return document.find(
            ('./cac:LegalMonetaryTotal/'
             'cbc:TaxExclusiveAmount'), vars(NS)).text

    def get_total_payable_amount(self, document):
        return document.find(
            ('./cac:LegalMonetaryTotal/'
             'cbc:PayableAmount'), vars(NS)).text

    def get_software_id(self, document):
        return document.find(
            ('.//sts:DianExtensions/'
             'sts:SoftwareProvider/sts:SoftwareID'), vars(NS)).text

    def get_software_provider_id(self, document):
        return document.find(
            ('.//sts:DianExtensions/'
             'sts:SoftwareProvider/sts:ProviderID'), vars(NS)).text

    def get_invoice_authorization(self, document):
        element = document.find(
            ('.//sts:DianExtensions/sts:InvoiceControl/'
             'sts:InvoiceAuthorization'), vars(NS))
        if element is not None:
            return element.text

    def get_prefix(self, document):
        element = document.find(
            ('.//sts:DianExtensions/sts:InvoiceControl/'
             'sts:AuthorizedInvoices/sts:Prefix'), vars(NS))
        if element is not None:
            return element.text

    def get_tax_vat(self, document):
        for tax_element in document.findall('.//cac:TaxSubtotal', vars(NS)):
            tax_id = tax_element.find(
                ('cac:TaxCategory/cac:TaxScheme/cbc:ID'), vars(NS))
            if tax_id is not None and tax_id.text == '01':
                tax_amount = tax_element.find('cbc:TaxAmount', vars(NS)).text
                return tax_amount
        return '0.00'

    def get_tax_other(self, document):
        result = []
        for tax_element in document.findall('.//cac:TaxSubtotal', vars(NS)):
            tax_id = tax_element.find(
                ('cac:TaxCategory/cac:TaxScheme/cbc:ID'), vars(NS))
            if tax_id is not None and tax_id.text != '01':
                tax_amount = tax_element.find('cbc:TaxAmount', vars(NS)).text
                result.append(tax_amount)
        return result
