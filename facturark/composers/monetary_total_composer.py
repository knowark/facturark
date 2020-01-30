from lxml.etree import Element, QName
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class MonetaryTotalComposer(Composer):

    def __init__(self, amount_composer):
        self.amount_composer = amount_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cac, root_name), nsmap=vars(NS))

        line_extension_amount = self.amount_composer.compose(
            data_dict['line_extension_amount'], 'LineExtensionAmount')
        root.append(line_extension_amount)

        root.append(self.amount_composer.compose(
            data_dict['tax_exclusive_amount'], 'TaxExclusiveAmount'))

        root.append(self.amount_composer.compose(
            data_dict['payable_amount'], 'PayableAmount'))

        return root
