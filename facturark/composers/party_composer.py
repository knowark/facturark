from lxml.etree import Element, QName
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class PartyComposer(Composer):

    def __init__(self, party_tax_scheme_composer, party_legal_entity_composer,
                 person_composer, location_composer):
        self.party_tax_scheme_composer = party_tax_scheme_composer
        self.party_legal_entity_composer = party_legal_entity_composer
        self.person_composer = person_composer
        self.location_composer = location_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        party_identification_id = data_dict['party_identification']['id']
        party_identification = make_child(
            root, QName(NS.cac, 'PartyIdentification'), empty=True)
        make_child(party_identification, QName(NS.cbc, 'ID'),
                   party_identification_id['#text'],
                   party_identification_id['@attributes'])

        root.append(
            self.location_composer.compose(
                data_dict['physical_location'], 'PhysicalLocation'))

        root.append(
            self.party_tax_scheme_composer.compose(
                data_dict['party_tax_scheme']))

        party_legal_entity_dict = data_dict.get('party_legal_entity')
        root.append(self.party_legal_entity_composer.compose(
            party_legal_entity_dict))

        person_dict = data_dict.get('person')
        if person_dict:
            root.append(self.person_composer.compose(person_dict))

        return root
