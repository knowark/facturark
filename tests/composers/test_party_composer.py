import io
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.composers import (
    NS, AddressComposer, PartyTaxSchemeComposer, PartyLegalEntityComposer,
    PartyComposer, PersonComposer, LocationComposer)


@fixture
def composer():
    party_tax_scheme_composer = PartyTaxSchemeComposer()
    party_legal_entity_composer = PartyLegalEntityComposer()
    person_composer = PersonComposer()
    address_composer = AddressComposer()
    location_composer = LocationComposer(address_composer)
    return PartyComposer(
        party_tax_scheme_composer, party_legal_entity_composer,
        person_composer, location_composer)


@fixture
def data_dict():
    return {
        'party_identification': {
            'id': {
                '@attributes': {
                    'schemeAgencyID': '123',
                    'schemeAgencyName': 'CIA',
                    'schemeID': '007'
                },
                '#text':  '900555666'
            }
        },
        'party_tax_scheme': {
            'tax_level_code': '0'
        },
        'party_legal_entity': {
            'registration_name': '800777555'
        },
        'person': {
            'first_name': "Gabriel",
            'family_name': "Echeverry"
        },
        'physical_location': {
            'address': {
                'department': u'Valle',
                'city_name': u'Cali',
                'country': {
                    'identification_code': 'CO'
                }
            }
        }
    }


def test_compose(composer, data_dict, schema):
    party = composer.compose(data_dict)

    assert party.prefix == "fe"
    assert party.tag == QName(NS.fe, "Party").text

    party_identification = party.find(
        QName(NS.cac, "PartyIdentification"))
    party_identification_id = party_identification.find(
        QName(NS.cbc, "ID"))
    assert party_identification_id.text == '900555666'
    assert (
        party_identification_id.attrib ==
        data_dict['party_identification']['id']['@attributes'])

    schema.assertValid(party)
