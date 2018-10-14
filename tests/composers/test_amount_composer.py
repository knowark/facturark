from pytest import fixture
from lxml.etree import QName
from facturark.namespaces import NS
from facturark.composers import AmountComposer


@fixture
def composer():
    return AmountComposer()


@fixture
def data_dict():
    return {
        '@attributes': {'currencyID': 'COP'},
        '#text': 999999
    }


def test_compose(composer, data_dict, schema):
    amount = composer.compose(data_dict, 'LineExtensionAmount')

    assert amount.tag == QName(NS.cbc, "LineExtensionAmount").text
    assert float(amount.text) == 999999
    assert amount.attrib == data_dict['@attributes']

    schema.assertValid(amount)
