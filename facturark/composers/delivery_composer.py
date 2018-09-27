from lxml.etree import Element, QName, tostring
from facturark.utils import make_child
from .namespaces import NS
from .composer import Composer


class DeliveryComposer(Composer):

    def __init__(self, address_composer, location_composer,
                 party_composer, despatch_composer):
        self.address_composer = address_composer
        self.location_composer = location_composer
        self.party_composer = party_composer
        self.despatch_composer = despatch_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        delivery_address_dict = data_dict.get('delivery_address')
        if delivery_address_dict:
            root.append(self.address_composer.compose(
                delivery_address_dict, 'DeliveryAddress'))

        delivery_location_dict = data_dict.get('delivery_location')
        if delivery_location_dict:
            root.append(self.location_composer.compose(
                delivery_location_dict, 'DeliveryLocation'))

        delivery_party_dict = data_dict.get('delivery_party')
        if delivery_party_dict:
            root.append(self.party_composer.compose(
                delivery_party_dict, 'DeliveryParty'))

        despatch_dict = data_dict.get('despatch')
        if despatch_dict:
            root.append(self.despatch_composer.compose(
                despatch_dict))

        return root
