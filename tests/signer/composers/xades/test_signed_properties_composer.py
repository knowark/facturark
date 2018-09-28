# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring, tostring
from facturark.signer.composers import NS
from facturark.signer.composers.xades import SignedPropertiesComposer


@fixture
def composer():
    return SignedPropertiesComposer()


@fixture
def data_dict():
    return {
        '@attributes': {'Id': ("xmldsig-88fbfc45-3be2-"
                               "4c4a-83ac-0796e1bad4c5-signedprops")}
    }


def test_compose(composer, data_dict, schema):
    signed_properties = composer.compose(data_dict)

    assert signed_properties.prefix == "xades"
    assert signed_properties.tag == QName(
        NS.xades, "SignedProperties").text
    assert signed_properties.attrib.get('Id') == (
        data_dict['@attributes']['Id'])

    schema.assertValid(signed_properties)
