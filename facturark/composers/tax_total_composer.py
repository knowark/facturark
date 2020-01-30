from lxml.etree import Element, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class TaxTotalComposer(Composer):

    def __init__(self, amount_composer, tax_subtotal_composer):
        self.amount_composer = amount_composer
        self.tax_subtotal_composer = tax_subtotal_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cac, root_name), nsmap=vars(NS))

        root.append(self.amount_composer.compose(
            data_dict['tax_amount'], 'TaxAmount'))

        make_child(root, QName(NS.cbc, 'TaxEvidenceIndicator'),
                   data_dict['tax_evidence_indicator'])

        root.append(self.tax_subtotal_composer.compose(
            data_dict['tax_subtotal']))

        return root
