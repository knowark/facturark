from pytest import fixture
from lxml.etree import QName
from facturark.namespaces import NS
from facturark.composers import AmountComposer, PriceComposer


@fixture
def composer():
    return PriceComposer(AmountComposer())


@fixture
def data_dict():
    return {
        'price_amount': {
            '@attributes': {'currencyID': 'COP'},
            '#text':  "777.77"
        }
    }


def test_compose(composer, data_dict, schema):
    price = composer.compose(data_dict)

    assert price.tag == QName(NS.fe, "Price").text
    schema.assertValid(price)
