from lxml.etree import Element, QName
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class PriceComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        price_amount_dict = data_dict['price_amount']
        make_child(root, QName(NS.cbc, "PriceAmount"),
                   str(float(price_amount_dict['#text'])),
                   {'currencyID': price_amount_dict['@currency_id']})

        return root
