from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class TaxSubtotalComposer(Composer):

    def __init__(self, amount_composer):
        self.amount_composer = amount_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        root.append(self.amount_composer.compose(
            data_dict['taxable_amount'], 'TaxableAmount'))

        root.append(self.amount_composer.compose(
            data_dict['tax_amount'], 'TaxAmount'))

        make_child(root, QName(NS.cbc, 'Percent'),
                   data_dict['percent'],
                   required=True)

        tax_category_dict = data_dict['tax_category']
        tax_scheme_dict = tax_category_dict['tax_scheme']
        tax_category = make_child(root, QName(NS.cac, 'TaxCategory'),
                                  required=True, empty=True)
        tax_scheme = make_child(tax_category, QName(NS.cac, 'TaxScheme'),
                                required=True, empty=True)
        make_child(tax_scheme, QName(NS.cbc, 'ID'), tax_scheme_dict['id'],
                   required=True)

        return root
