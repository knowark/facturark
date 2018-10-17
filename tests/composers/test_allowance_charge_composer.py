from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.namespaces import NS
from facturark.composers import AmountComposer, AllowanceChargeComposer


@fixture
def composer():
    return AllowanceChargeComposer(AmountComposer())


@fixture
def data_dict():
    return {
        'charge_indicator': 'false',
        'multiplier_factor_numeric': "19.00",
        'amount': {
            '@attributes': {'currencyID': 'COP'},
            '#text': "777777.00"
        }

    }


def test_compose(composer, data_dict, schema):
    allowance_charge = composer.compose(data_dict)

    assert allowance_charge.tag == QName(NS.fe, "AllowanceCharge").text
    assert allowance_charge.findtext(
        QName(NS.cbc, "ChargeIndicator")) == 'false'
    assert allowance_charge.findtext(
        QName(NS.cbc, "MultiplierFactorNumeric")) == "19.00"
    assert allowance_charge.findtext(
        QName(NS.cbc, "Amount")) == "777777.00"

    schema.assertValid(allowance_charge)
