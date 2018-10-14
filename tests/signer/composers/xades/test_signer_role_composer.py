# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring, tostring
from facturark.namespaces import NS
from facturark.signer.composers.xades import SignerRoleComposer


@fixture
def composer():
    return SignerRoleComposer()


@fixture
def data_dict():
    return {
        'claimed_roles': [{
            'claimed_role': 'supplier'
        }]
    }


def test_compose(composer, data_dict, schema):
    signer_role = composer.compose(data_dict)

    assert signer_role.prefix == "xades"
    assert signer_role.tag == QName(
        NS.xades, "SignerRole").text
    assert signer_role.findtext(
        'xades:ClaimedRoles/xades:ClaimedRole',
        namespaces=vars(NS)) == 'supplier'

    schema.assertValid(signer_role)
