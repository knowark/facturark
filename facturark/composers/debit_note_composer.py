# -*- coding: utf-8 -*-
from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class DebitNoteComposer(Composer):

    def __init__(self, extension_composer, supplier_party_composer,
                 customer_party_composer, payment_composer,
                 tax_total_composer, monetary_total_composer,
                 debit_note_line_composer):
        self.extension_composer = extension_composer
        self.supplier_party_composer = supplier_party_composer
        self.customer_party_composer = customer_party_composer
        self.payment_composer = payment_composer
        self.tax_total_composer = tax_total_composer
        self.monetary_total_composer = monetary_total_composer
        self.debit_note_line_composer = debit_note_line_composer

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

        make_child(root, QName(NS.cbc, "DocumentCurrencyCode"),
                   data_dict['document_currency_code'])

        root.append(self.supplier_party_composer.compose(
            data_dict['accounting_supplier_party'], 'AccountingSupplierParty'))

        root.append(self.customer_party_composer.compose(
            data_dict['accounting_customer_party'], 'AccountingCustomerParty'))

        tax_totals = data_dict.get('tax_totals', [])
        for tax_total in tax_totals:
            root.append(self.tax_total_composer.compose(
                tax_total, 'TaxTotal'))

        root.append(self.monetary_total_composer.compose(
            data_dict['legal_monetary_total'], 'LegalMonetaryTotal'))

        debit_note_lines_list = data_dict['debit_note_lines']
        for debit_note_line_dict in debit_note_lines_list:
            root.append(self.debit_note_line_composer.compose(
                debit_note_line_dict, 'DebitNoteLine'))

        return root
