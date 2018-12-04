# -*- coding: utf-8 -*-
from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class DebitNoteLineComposer(Composer):

    def __init__(self, amount_composer, billing_reference_composer):
        self.amount_composer = amount_composer
        self.billing_reference_composer = billing_reference_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cac, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, "ID"), data_dict['id'])
        make_child(root, QName(NS.cbc, "UUID"), data_dict['uuid'])

        root.append(self.amount_composer.compose(
            data_dict['line_extension_amount'], 'LineExtensionAmount'))

        discrepancy_response_dict = data_dict['discrepancy_response']
        discrepancy_response = make_child(
            root, QName(NS.cac, "DiscrepancyResponse"), empty=True)
        make_child(discrepancy_response, QName(NS.cbc, "ReferenceID"),
                   empty=True)
        make_child(discrepancy_response, QName(NS.cbc, "ResponseCode"),
                   discrepancy_response_dict['response_code'])

        for billing_reference_dict in data_dict.get('billing_references', []):
            root.append(self.billing_reference_composer.compose(
                billing_reference_dict))
        
        tax_total_dict = data_dict.get('tax_total')
        if tax_total_dict:
            tax_total = make_child(
                root, QName(NS.cac, "TaxTotal"), empty=True)
            tax_total.append(self.amount_composer.compose(
                tax_total_dict['tax_amount'], 'TaxAmount'))

        item_dict = data_dict.get('item')
        if item_dict:
            item = make_child(root, QName(NS.cac, "Item"), empty=True)
            make_child(item, QName(NS.cbc, "Description"),
                       item_dict['description'])
            make_child(item, QName(NS.cbc, "AdditionalInformation"),
                       item_dict.get('additional_information', ""),
                       required=False)

        return root
