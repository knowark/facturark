from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.composers import NS, PartyTaxSchemeComposer


@fixture
def composer():
    return PartyTaxSchemeComposer()


@fixture
def data_dict():
    return {
        'tax_level_code': '0'
    }


def test_compose(composer, data_dict, schema):
    party_tax_scheme = composer.compose(data_dict)

    assert party_tax_scheme.tag == QName(NS.fe, "PartyTaxScheme").text
    assert party_tax_scheme.findtext(QName(NS.cbc, "TaxLevelCode")) == "0"
    assert party_tax_scheme.find(QName(NS.cac, "TaxScheme")) is not None
    schema.assertValid(party_tax_scheme)
