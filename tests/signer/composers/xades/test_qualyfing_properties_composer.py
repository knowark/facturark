# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring, tostring
from facturark.signer.composers import NS
from facturark.signer.composers.xades import QualifyingPropertiesComposer


@fixture
def composer():
    return QualifyingPropertiesComposer()


@fixture
def data_dict():
    return {
        '@attributes': {'Target': ("#xmldsig-88fbfc45-3be2-"
                                   "4c4a-83ac-0796e1bad4c5")}
    }


def test_compose(composer, data_dict, schema):
    qualifying_properties = composer.compose(data_dict)

    assert qualifying_properties.prefix == "xades"
    assert qualifying_properties.tag == QName(
        NS.xades, "QualifyingProperties").text

    schema.assertValid(qualifying_properties)
