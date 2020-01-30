from lxml.etree import Element, QName
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class AllowanceChargeComposer(Composer):

    def __init__(self, amount_composer):
        self.amount_composer = amount_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cac, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'ChargeIndicator'),
                   data_dict['charge_indicator'])
        make_child(root, QName(NS.cbc, 'MultiplierFactorNumeric'),
                   data_dict['multiplier_factor_numeric'])

        root.append(self.amount_composer.compose(data_dict['amount'],
                                                 'Amount'))

        return root
