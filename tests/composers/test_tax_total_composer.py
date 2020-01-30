from pytest import fixture
from lxml.etree import QName
from facturark.namespaces import NS
from facturark.composers import TaxTotalComposer, TaxSubtotalComposer
from facturark.composers.resolver import resolve_tax_total_composer


@fixture
def composer():
    return resolve_tax_total_composer()


@fixture
def data_dict():
    return {
        'tax_amount': {
            '@attributes': {'currencyID': 'COP'},
            '#text': "8934000.00"
        },
        'tax_evidence_indicator': 'false',
        'tax_subtotal': {
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
    }


def test_compose(composer, data_dict, schema):
    tax_total = composer.compose(data_dict)

    assert tax_total.tag == QName(NS.fe, "TaxTotal").text

    tax_amount = tax_total.find(
        QName(NS.cbc, "TaxAmount"))
    assert tax_amount.text == "8934000.00"
    assert tax_amount.attrib['currencyID'] == 'COP'

    assert tax_total.findtext(QName(NS.cbc, 'TaxEvidenceIndicator')) == 'false'

    schema.assertValid(tax_total)
