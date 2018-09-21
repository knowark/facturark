from pytest import fixture
from lxml.etree import QName
from facturark.composers import NS, PriceComposer


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
