# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName
from facturark.namespaces import NS
from facturark.composers import (
    PartyComposer, PartyTaxSchemeComposer, PartyLegalEntityComposer,
    PersonComposer, LocationComposer, AddressComposer, DespatchComposer,
    DeliveryComposer)


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
    despatch_composer = DespatchComposer(address_composer, party_composer)
    return DeliveryComposer(address_composer, location_composer,
                            party_composer, despatch_composer)


@fixture
def data_dict():
    return {
        'delivery_address': {
            'department': u'Cauca',
            'city_name': u'Popayán',
            'address_line': {
                'line': u'Cra 22 # 33 - 44'
            },
            'country': {
                'identification_code': 'CO'
            }
        },
        'delivery_location': {
            'address': {
                'department': u'Valle',
                'city_name': u'Cali',
                'country': {
                    'identification_code': 'CO'
                }
            }
        },
        'delivery_party': {
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
            'physical_location': {
                'address': {
                    'department': u'Valle',
                    'city_name': u'Cali',
                    'country': {
                        'identification_code': 'CO'
                    }
                }
            }
        },
        'despatch': {
            'despatch_address': {
                'department': u'Cauca',
                'city_name': u'Popayán',
                'address_line': {
                    'line': u'Cra 22 # 33 - 44'
                },
                'country': {
                    'identification_code': 'CO'
                }
            },
            'despatch_party': {
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
    }


def test_compose(composer, data_dict, schema):
    delivery = composer.compose(data_dict)

    assert delivery.tag == QName(NS.fe, "Delivery").text

    schema.assertValid(delivery)


def test_compose_basic(composer, schema):
    data_dict = {}
    delivery = composer.compose(data_dict)

    assert delivery.tag == QName(NS.fe, "Delivery").text

    schema.assertValid(delivery)
