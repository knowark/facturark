from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.namespaces import NS
from facturark.composers import AmountComposer, TaxSubtotalComposer


@fixture
def composer():
    return TaxSubtotalComposer(AmountComposer())


@fixture
def data_dict():
    return {
        'percent': "19.00",
        'taxable_amount': {
            '@attributes': {'currencyID': 'COP'},
            '#text': "11345892.00"
        },
        'tax_amount': {
            '@attributes': {'currencyID': 'COP'},
            '#text': "2155719.48"
        },
        'tax_category': {
            'tax_scheme': {
                'id': '03'
            }
        }
    }


def test_compose(composer, data_dict, schema):
    tax_subtotal = composer.compose(data_dict)

    assert tax_subtotal.tag == QName(NS.fe, "TaxSubtotal").text

    taxable_amount = tax_subtotal.find(
        QName(NS.cbc, "TaxableAmount"))
    assert float(taxable_amount.text) == 11345892
    assert taxable_amount.attrib['currencyID'] == 'COP'

    tax_amount = tax_subtotal.find(
        QName(NS.cbc, "TaxAmount"))
    assert float(tax_amount.text) == 2155719.48
    assert tax_amount.attrib['currencyID'] == 'COP'

    assert float(tax_subtotal.findtext(QName(NS.cbc, "Percent"))) == 19

    tax_category = tax_subtotal.find(QName(NS.cac, "TaxCategory"))
    tax_scheme = tax_category.find(QName(NS.cac, "TaxScheme"))
    assert tax_scheme.findtext(QName(NS.cbc, "ID")) == '03'

    schema.assertValid(tax_subtotal)
