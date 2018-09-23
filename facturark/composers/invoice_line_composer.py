from lxml.etree import Element, QName, tostring
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class InvoiceLineComposer(Composer):

    def __init__(self, amount_composer, item_composer, price_composer):
        self.amount_composer = amount_composer
        self.item_composer = item_composer
        self.price_composer = price_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'ID'), data_dict['id'])
        make_child(root, QName(NS.cbc, 'InvoicedQuantity'),
                   data_dict['invoiced_quantity'])

        root.append(
            self.amount_composer.compose(data_dict['line_extension_amount'],
                                         'LineExtensionAmount'))
        root.append(self.item_composer.compose(data_dict['item']))
        root.append(self.price_composer.compose(data_dict['price']))

        return root
