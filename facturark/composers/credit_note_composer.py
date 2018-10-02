from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from .namespaces import NS
from .composer import Composer


class CreditNoteComposer(Composer):

    def __init__(self, extension_composer, supplier_party_composer,
                 customer_party_composer, payment_composer,
                 tax_total_composer, monetary_total_composer,
                 credit_note_line_composer):
        self.extension_composer = extension_composer
        self.supplier_party_composer = supplier_party_composer
        self.customer_party_composer = customer_party_composer
        self.payment_composer = payment_composer
        self.tax_total_composer = tax_total_composer
        self.monetary_total_composer = monetary_total_composer
        self.credit_note_line_composer = credit_note_line_composer

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

        if data_dict.get('uuid'):
            make_child(root, QName(NS.cbc, "UUID"), data_dict['uuid'])

        make_child(root, QName(NS.cbc, "IssueDate"), data_dict['issue_date'])

        make_child(root, QName(NS.cbc, "IssueTime"), data_dict['issue_time'])

        if data_dict.get('document_currency_code'):
            make_child(root, QName(NS.cbc, "DocumentCurrencyCode"),
                       data_dict['document_currency_code'])

        root.append(self.supplier_party_composer.compose(
            data_dict['accounting_supplier_party'], 'AccountingSupplierParty'))

        root.append(self.customer_party_composer.compose(
            data_dict['accounting_customer_party'], 'AccountingCustomerParty'))

        root.append(self.monetary_total_composer.compose(
            data_dict['legal_monetary_total'], 'LegalMonetaryTotal'))

        credit_note_lines_list = data_dict['credit_note_lines']
        for credit_note_line_dict in credit_note_lines_list:
            root.append(self.credit_note_line_composer.compose(
                credit_note_line_dict, 'CreditNoteLine'))

        return root
