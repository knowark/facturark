from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class TaxSubtotalComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        taxable_amount_dict = data_dict['taxable_amount']
        make_child(root, QName(NS.cbc, 'TaxableAmount'),
                   str(float(taxable_amount_dict['#text'])),
                   {'currencyID': taxable_amount_dict['@currency_id']},
                   required=True)

        tax_amount_dict = data_dict['tax_amount']
        make_child(root, QName(NS.cbc, 'TaxAmount'),
                   str(float(tax_amount_dict['#text'])),
                   {'currencyID': tax_amount_dict['@currency_id']},
                   required=True)

        make_child(root, QName(NS.cbc, 'Percent'),
                   str(float(data_dict['percent'])),
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
