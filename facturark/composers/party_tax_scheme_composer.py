from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class PartyTaxSchemeComposer(Composer):

    def compose(self, data_dict, root_name='PartyTaxScheme'):
        root = Element(
            QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'TaxLevelCode'),
                   data_dict.get('tax_level_code'), required=False)
        make_child(root, QName(NS.cac, 'TaxScheme'),
                   required=False, empty=True)

        return root
