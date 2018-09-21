from pytest import fixture
from lxml.etree import QName
from facturark.composers import NS, TaxTotalComposer, TaxSubtotalComposer


@fixture
def composer():
    tax_subtotal_composer = TaxSubtotalComposer()
    return TaxTotalComposer(tax_subtotal_composer)


@fixture
def data_dict():
    return {
        'tax_amount': {
            '@currency_id': 'COP',
            '#text': 8934000
        },
        'tax_evidence_indicator': 'false',
        'tax_subtotal': {
            'percent': 19,
            'taxable_amount': {
                '@currency_id': 'COP',
                '#text': 11345892
            },
            'tax_amount': {
                '@currency_id': 'COP',
                '#text': 2155719.48
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
    assert float(tax_amount.text) == 8934000
    assert tax_amount.attrib['currencyID'] == 'COP'

    assert tax_total.findtext(QName(NS.cbc, 'TaxEvidenceIndicator')) == 'false'

    schema.assertValid(tax_total)
