# -*- coding: utf-8 -*-
import io
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.xsd_parser import parse_xsd
from facturark.composers import NS
from facturark.composers import AddressComposer


@fixture
def composer():
    return AddressComposer()


@fixture
def data_dict():
    return {
        'department': u'Cauca',
        'city_name': u'Popayán',
        'address_line': {
            'line': u'Cra 22 # 33 - 44'
        },
        'country': {
            'identification_code': 'CO'
        }
    }


def test_compose(composer, data_dict, schema):
    address = composer.compose(data_dict)

    assert address.prefix == "fe"
    assert address.findtext(QName(NS.cbc, "Department")) == "Cauca"
    assert address.findtext(QName(NS.cbc, "CityName")) == u'Popayán'
    address_line = address.find(QName(NS.cac, "AddressLine"))
    assert address_line.findtext(QName(NS.cbc, "Line")) == u'Cra 22 # 33 - 44'
    country = address.find(QName(NS.cac, "Country"))
    assert country.findtext(QName(NS.cbc, "IdentificationCode")) == u'CO'
    schema.assertValid(address)


def test_serialize(composer, data_dict):
    document = composer.serialize(data_dict)
    assert fromstring(document) is not None
