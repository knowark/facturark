# -*- coding: utf-8 -*-
import io
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.composers import NS
from facturark.composers import DianExtensionsComposer


@fixture
def composer():
    return DianExtensionsComposer()


@fixture
def data_dict():
    return {

        'invoice_source': {
            'identification_code': 'CO'
        },
        'software_provider': {
            'provider_id': '900373115',
            'software_id': '0d2e2883-eb8d-4237-87fe-28aeb71e961e'
        },
        'software_security_code': (
            "bdaa51c9953e08dcc8f398961f7cd0717cd5fbea356e93766"
            "0aa1a8abbe31f4c9b4eb5cf8682eaca4c8523953253dcce")
    }


def test_compose(composer, data_dict, schema):
    dian_extensions = composer.compose(data_dict)

    assert dian_extensions.prefix == "sts"
    assert dian_extensions.tag == QName(NS.sts, "DianExtensions").text
    schema.assertValid(dian_extensions)
