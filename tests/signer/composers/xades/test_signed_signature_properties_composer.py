# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring, tostring
from facturark.signer.composers import NS
from facturark.signer.composers.xades import SignedSignaturePropertiesComposer


@fixture
def composer():
    return SignedSignaturePropertiesComposer()


@fixture
def data_dict():
    return {
        'signing_time': '2016-07-12T11:17:38.639-05:00'

    }


def test_compose(composer, data_dict, schema):
    signed_signature_properties = composer.compose(data_dict)

    assert signed_signature_properties.prefix == "xades"
    assert signed_signature_properties.tag == QName(
        NS.xades, "SignedSignatureProperties").text
    assert signed_signature_properties.findtext(
        QName(NS.xades, 'SigningTime')) == '2016-07-12T11:17:38.639-05:00'

    schema.assertValid(signed_signature_properties)
