# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.signer.composers import (
    NS, SignedInfoComposer, ReferenceComposer)


@fixture
def composer():
    reference_composer = ReferenceComposer()
    return SignedInfoComposer(reference_composer)


@fixture
def data_dict():
    return {
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
    }


def test_compose(composer, data_dict, schema):
    signature = composer.compose(data_dict)

    assert signature.prefix == "ds"
    assert signature.tag == QName(NS.ds, "SignedInfo").text
    schema.assertValid(signature)
