from pytest import fixture
from lxml.etree import QName
from facturark.composers import NS, PaymentComposer


@fixture
def composer():
    return PaymentComposer()


@fixture
def data_dict():
    return {
        'paid_amount': {
            '@currency_id': 'COP',
            '#text': 4567
        },
        'paid_date': '2018-09-20'
    }


def test_compose(composer, data_dict, schema):
    payment = composer.compose(data_dict, 'PrepaidPayment')

    assert payment.tag == QName(NS.fe, "PrepaidPayment").text

    paid_amount = payment.find(
        QName(NS.cbc, "PaidAmount"))
    assert float(paid_amount.text) == 4567
    assert paid_amount.attrib['currencyID'] == 'COP'

    schema.assertValid(payment)
