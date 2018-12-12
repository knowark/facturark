from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class AmountComposer(Composer):

    def __init__(self, currency_code="COP"):
        self.currency_code = currency_code

    def compose(self, data, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cbc, root_name), nsmap=vars(NS))

        root.text = data
        root.set("currencyID", self.currency_code)

        return root
