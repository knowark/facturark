from pytest import fixture
from lxml.etree import QName
from facturark.composers import NS, LocationComposer, AddressComposer


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
        }
    }


def test_compose(composer, data_dict, schema):
    location = composer.compose(data_dict, 'DeliveryLocation')

    assert location.tag == QName(NS.fe, "DeliveryLocation").text
    # assert location.findtext(QName(NS.cbc, 'Department')) == 'Valle'
    # assert location.findtext(QName(NS.cbc, 'CityName')) == 'Cali'

    schema.assertValid(location)
