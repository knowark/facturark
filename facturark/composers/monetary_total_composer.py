from lxml.etree import Element, QName
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class MonetaryTotalComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        line_extension_amount = data_dict['line_extension_amount']
        make_child(root, QName(NS.cbc, 'LineExtensionAmount'),
                   str(float(line_extension_amount['#text'])),
                   {'currencyID': line_extension_amount['@currency_id']},
                   required=True)

        tax_exclusive_amount = data_dict['tax_exclusive_amount']
        make_child(root, QName(NS.cbc, 'TaxExclusiveAmount'),
                   str(float(tax_exclusive_amount['#text'])),
                   {'currencyID': tax_exclusive_amount['@currency_id']},
                   required=True)

        payable_amount = data_dict['payable_amount']
        make_child(root, QName(NS.cbc, 'PayableAmount'),
                   str(float(payable_amount['#text'])),
                   {'currencyID': payable_amount['@currency_id']},
                   required=True)

        return root
