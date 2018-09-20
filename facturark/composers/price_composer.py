from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .composer import Composer


class PriceComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        SubElement(root, QName(
            NS.cbc, "PriceAmount"),
            currencyID=data_dict['price_amount']['@currency_id']).text = str(
                float(data_dict['price_amount']['#text']))

        return root
