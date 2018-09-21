from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.composers import NS
from facturark.composers import DeliveryTermsComposer


@fixture
def composer():
    return DeliveryTermsComposer()


@fixture
def data_dict():
    return {
    }


def test_compose(composer, data_dict, schema):
    delivery_terms = composer.compose(data_dict)

    assert delivery_terms.tag == QName(NS.fe, "DeliveryTerms").text

    schema.assertValid(delivery_terms)
