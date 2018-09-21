from lxml.etree import Element, QName, tostring
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class InvoiceLineComposer(Composer):

    def __init__(self, item_composer, price_composer):
        self.item_composer = item_composer
        self.price_composer = price_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'ID'), data_dict['id'])
        make_child(root, QName(NS.cbc, 'InvoicedQuantity'),
                   data_dict['invoiced_quantity'])

        line_extension_amount = data_dict['line_extension_amount']
        make_child(root, QName(NS.cbc, 'LineExtensionAmount'),
                   str(float(line_extension_amount['#text'])),
                   {'currencyID': line_extension_amount['@currency_id']},
                   required=True)

        root.append(self.item_composer.compose(data_dict['item']))
        root.append(self.price_composer.compose(data_dict['price']))

        return root
