from lxml.etree import Element, QName
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class PriceComposer(Composer):

    def __init__(self, amount_composer):
        self.amount_composer = amount_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        root.append(self.amount_composer.compose(
            data_dict['price_amount'], 'PriceAmount'))

        return root
