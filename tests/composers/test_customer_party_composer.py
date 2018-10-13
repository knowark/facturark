import io
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.namespaces import NS
from facturark.composers import (
    AddressComposer, PartyTaxSchemeComposer, PartyLegalEntityComposer,
    CustomerPartyComposer, PartyComposer, PersonComposer, LocationComposer)


@fixture
def composer():
    party_tax_scheme_composer = PartyTaxSchemeComposer()
    party_legal_entity_composer = PartyLegalEntityComposer()
    person_composer = PersonComposer()
    address_composer = AddressComposer()
    location_composer = LocationComposer(address_composer)
    party_composer = PartyComposer(
        party_tax_scheme_composer, party_legal_entity_composer,
        person_composer, location_composer)
    return CustomerPartyComposer(party_composer)


@fixture
def data_dict():
    return {
        'additional_account_id': 1,
        'party': {
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
    }


def test_compose(composer, data_dict, schema):
    customer_party = composer.compose(data_dict, 'AccountingCustomerParty')

    assert customer_party.prefix == "fe"
    assert customer_party.tag == QName(NS.fe, "AccountingCustomerParty").text

    schema.assertValid(customer_party)
