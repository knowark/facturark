from pytest import fixture
from lxml.etree import QName
from facturark.namespaces import NS
from facturark.composers import AmountComposer, PaymentComposer


@fixture
def composer():
    return PaymentComposer(AmountComposer())


@fixture
def data_dict():
    return {
        'paid_amount': {
            '@attributes': {'currencyID': 'COP'},
            '#text': "4567.00"
        },
        'paid_date': '2018-09-20'
    }


def test_compose(composer, data_dict, schema):
    payment = composer.compose(data_dict, 'PrepaidPayment')

    assert payment.tag == QName(NS.fe, "PrepaidPayment").text

    paid_amount = payment.find(
        QName(NS.cbc, "PaidAmount"))
    assert paid_amount.text == "4567.00"
    assert paid_amount.attrib['currencyID'] == 'COP'

    schema.assertValid(payment)
