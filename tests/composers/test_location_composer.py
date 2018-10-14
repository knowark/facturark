from pytest import fixture
from lxml.etree import QName
from facturark.namespaces import NS
from facturark.composers import LocationComposer, AddressComposer


@fixture
def composer():
    address_composer = AddressComposer()
    return LocationComposer(address_composer)


@fixture
def data_dict():
    return {
        'address': {
            'department': u'Valle',
            'city_name': u'Cali',
            'country': {
                'identification_code': 'CO'
            }
        }
    }


def test_compose(composer, data_dict, schema):
    location = composer.compose(data_dict, 'DeliveryLocation')

    assert location.tag == QName(NS.fe, "DeliveryLocation").text
    address = location.find(QName(NS.fe, 'Address'))
    assert address.findtext(QName(NS.cbc, 'Department')) == 'Valle'
    assert address.findtext(QName(NS.cbc, 'CityName')) == 'Cali'

    schema.assertValid(location)
