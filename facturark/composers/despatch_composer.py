from lxml.etree import Element, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class DespatchComposer(Composer):

    def __init__(self, address_composer, party_composer):
        self.address_composer = address_composer
        self.party_composer = party_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cac, root_name), nsmap=vars(NS))

        despatch_address_dict = data_dict.get('despatch_address')
        root.append(self.address_composer.compose(
            despatch_address_dict, 'DespatchAddress'))

        despatch_party_dict = data_dict.get('despatch_party')
        root.append(self.party_composer.compose(
            despatch_party_dict, 'DespatchParty'))

        return root
