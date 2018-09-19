from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.composers import NS
from facturark.composers import PriceComposer


@fixture
def composer():
    return PriceComposer()


@fixture
def data_dict():
    return {
        'price_amount': {
            '@currency_id': 'COP',
            '#text':  777.77
        }
    }


def test_compose(composer, data_dict, schema):
    price = composer.compose(data_dict)

    assert price.tag == QName(NS.fe, "Price").text
    schema.assertValid(price)


def test_serialize(composer, data_dict):
    document = composer.serialize(data_dict)
    assert fromstring(document) is not None
