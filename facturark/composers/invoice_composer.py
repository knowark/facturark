from lxml.etree import Element, SubElement, QName, tostring
from facturark.utils import make_child
from .namespaces import NS
from .composer import Composer


class InvoiceComposer(Composer):

    def __init__(self, extension_composer, supplier_party_composer,
                 customer_party_composer, delivery_composer,
                 delivery_terms_composer, payment_composer,
                 allowance_charge_composer, tax_total_composer,
                 monetary_total_composer, invoice_line_composer):
        self.extension_composer = extension_composer
        self.supplier_party_composer = supplier_party_composer
        self.customer_party_composer = customer_party_composer
        self.delivery_composer = delivery_composer
        self.delivery_terms_composer = delivery_terms_composer
        self.payment_composer = payment_composer
        self.allowance_charge_composer = allowance_charge_composer
        self.tax_total_composer = tax_total_composer
        self.monetary_total_composer = monetary_total_composer
        self.invoice_line_composer = invoice_line_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        extensions_list = data_dict['extensions']
        extensions = make_child(
            root, QName(NS.ext, "UBLExtensions"), empty=True)
        for extension_dict in extensions_list:
            extensions.append(self.extension_composer.compose(
                extension_dict, "UBLExtension"))

        make_child(root, QName(NS.cbc, "UBLVersionID"), "UBL 2.0")

        make_child(root, QName(NS.cbc, "ProfileID"), "DIAN 1.0")

        make_child(root, QName(NS.cbc, "ID"), data_dict['id'])

        make_child(root, QName(NS.cbc, "UUID"), data_dict['uuid'])

        make_child(root, QName(NS.cbc, "IssueDate"), data_dict['issue_date'])

        make_child(root, QName(NS.cbc, "IssueTime"), data_dict['issue_time'])

        make_child(root, QName(NS.cbc, "InvoiceTypeCode"),
                   str(int(data_dict['invoice_type_code'])))

        make_child(root, QName(NS.cbc, "DocumentCurrencyCode"),
                   data_dict['document_currency_code'])

        root.append(self.supplier_party_composer.compose(
            data_dict['accounting_supplier_party'], 'AccountingSupplierParty'))

        root.append(self.customer_party_composer.compose(
            data_dict['accounting_customer_party'], 'AccountingCustomerParty'))

        root.append(self.monetary_total_composer.compose(
            data_dict['legal_monetary_total'], 'LegalMonetaryTotal'))

        invoice_lines_list = data_dict['invoice_lines']
        for invoice_line_dict in invoice_lines_list:
            root.append(self.invoice_line_composer.compose(invoice_line_dict))

        return root
