# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.namespaces import NS
from facturark.signer.composers import (
    SignatureComposer, SignatureValueComposer,
    ReferenceComposer, SignedInfoComposer)


@fixture
def composer():
    reference_composer = ReferenceComposer()
    signed_info_composer = SignedInfoComposer(reference_composer)
    signature_value_composer = SignatureValueComposer()
    return SignatureComposer(signed_info_composer, signature_value_composer)


@fixture
def data_dict():
    return {
        "@attributes": {'Id': "xmldsig-88fbfc45-3be2-4c4a-83ac-0796e1bad4c5"},
        "signed_info": {
            "canonicalization_method": {
                "@attributes": {
                    "Algorithm": ("http://www.w3.org/TR/"
                                  "2001/REC-xml-c14n-20010315")
                }
            },
            "signature_method": {
                "@attributes": {
                    "Algorithm": "http://www.w3.org/2000/09/xmldsig#rsa-sha1"
                }
            },
            "references": [
                {
                    "transforms": [
                        {
                            "@attributes": {
                                "Algorithm": ("http://www.w3.org/2000/09/"
                                              "xmldsig#enveloped-signature")
                            },
                        }
                    ],
                    "digest_method": {
                        "@attributes": {
                            "Algorithm": ("http://www.w3.org/2000/"
                                          "09/xmldsig#sha1")
                        }
                    },
                    "digest_value": "6F5KPfMMBWPbl8ImvaG9z9NFSLE="
                }
            ]
        },
        "signature_value": {
            "@attributes": {"Id": "xmldsig-88fbfc45-3be2-4c4a"},
            "#text": ("KhSG6Gats5f8HwyjC/3dG+GmkhwIVjIygwcA9SeiJkEtq6OQw5y"
                      "Qb27y8DzmLRJ7tA/IlxzrnC9V 3MFgShGM+5MeazVoWVdr3jAqHV"
                      "2vsm+INKefUvDjm/buCIxqn9HLuIDash9+hKJRTSaR0GZoRKQV f"
                      "f07v4nnbE0uvhTYoaCR8KcCjk/Mrm4VfmgC8PRFKz9usRfmgQxdUp"
                      "VZTXfy2aqSlkt4VpFhisjA WeQzzquDH/MsT/EtCuGMZEtngbMUYY"
                      "ItRIBOgZ5qPJ9SMW1JIoraaBRdosLj0bSIXnsGhnS0nAYZ N0Trmt"
                      "Bn8ypUGxkMK7KFXhPc2bBoINZxPGeIcw==")
        },
    }


def test_compose(composer, data_dict, schema):
    signature = composer.compose(data_dict)

    assert signature.prefix == "ds"
    assert signature.tag == QName(NS.ds, "Signature").text
    schema.assertValid(signature)
