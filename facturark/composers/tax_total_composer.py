from lxml.etree import Element, QName, tostring
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class TaxTotalComposer(Composer):

    def __init__(self, tax_subtotal_composer):
        self.tax_subtotal_composer = tax_subtotal_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        tax_amount = data_dict['tax_amount']
        make_child(root, QName(NS.cbc, 'TaxAmount'),
                   str(float(tax_amount['#text'])),
                   {'currencyID': tax_amount['@currency_id']})

        make_child(root, QName(NS.cbc, 'TaxEvidenceIndicator'),
                   data_dict['tax_evidence_indicator'])

        root.append(self.tax_subtotal_composer.compose(
            data_dict['tax_subtotal']))

        return root
