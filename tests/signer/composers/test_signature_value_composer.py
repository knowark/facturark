# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.namespaces import NS
from facturark.signer.composers import SignatureValueComposer


@fixture
def composer():
    return SignatureValueComposer()


@fixture
def data_dict():
    return {
        "@attributes": {"Id": "xmldsig-88fbfc45-3be2-4c4a"},
        "#text": ("KhSG6Gats5f8HwyjC/3dG+GmkhwIVjIygwcA9SeiJkEtq6OQw5y"
                  "Qb27y8DzmLRJ7tA/IlxzrnC9V 3MFgShGM+5MeazVoWVdr3jAqHV"
                  "2vsm+INKefUvDjm/buCIxqn9HLuIDash9+hKJRTSaR0GZoRKQV f"
                  "f07v4nnbE0uvhTYoaCR8KcCjk/Mrm4VfmgC8PRFKz9usRfmgQxdUp"
                  "VZTXfy2aqSlkt4VpFhisjA WeQzzquDH/MsT/EtCuGMZEtngbMUYY"
                  "ItRIBOgZ5qPJ9SMW1JIoraaBRdosLj0bSIXnsGhnS0nAYZ N0Trmt"
                  "Bn8ypUGxkMK7KFXhPc2bBoINZxPGeIcw==")
    }


def test_compose(composer, data_dict, schema):
    signature_value = composer.compose(data_dict)

    assert signature_value.prefix == "ds"
    assert signature_value.tag == QName(NS.ds, "SignatureValue").text
    assert signature_value.text == data_dict['#text']
    assert signature_value.attrib['Id'] == data_dict['@attributes']['Id']
    schema.assertValid(signature_value)
