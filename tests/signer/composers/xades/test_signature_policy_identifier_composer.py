# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring, tostring
from facturark.signer.composers import NS
from facturark.signer.composers.xades import SignaturePolicyIdentifierComposer


@fixture
def composer():
    return SignaturePolicyIdentifierComposer()


@fixture
def data_dict():
    return {
        'signature_policy_id': {
            'sig_policy_id': {
                'identifier': ('https://facturaelectronica.dian.gov.co/'
                               'politicadefirma/v1/politicadefirmav1.pdf')
            },
            'sig_policy_hash': {
                'digest_method': {
                    '@attributes': {
                        'Algorithm': "http://www.w3.org/2000/09/xmldsig#sha1"
                    }
                },
                'digest_value': '61fInBICBQOCBwuTwlaOZSi9HKc='
            }
        }
    }


def test_compose(composer, data_dict, schema):
    signature_policy_identifier = composer.compose(data_dict)

    assert signature_policy_identifier.prefix == "xades"
    assert signature_policy_identifier.tag == QName(
        NS.xades, "SignaturePolicyIdentifier").text

    signature_policy_id = signature_policy_identifier.find(
        QName(NS.xades, 'SignaturePolicyId'))
    assert signature_policy_id is not None

    sig_policy_id = signature_policy_id.find(QName(NS.xades, 'SigPolicyId'))
    assert sig_policy_id.findtext(QName(NS.xades, 'Identifier')) == (
        'https://facturaelectronica.dian.gov.co/'
        'politicadefirma/v1/politicadefirmav1.pdf')

    sig_policy_hash = signature_policy_id.find(
        QName(NS.xades, 'SigPolicyHash'))
    assert sig_policy_hash.findtext(QName(NS.ds, 'DigestValue')) == (
        '61fInBICBQOCBwuTwlaOZSi9HKc=')
    digest_method = sig_policy_hash.find(QName(NS.ds, 'DigestMethod'))
    assert digest_method.attrib.get('Algorithm') == (
        "http://www.w3.org/2000/09/xmldsig#sha1")

    schema.assertValid(signature_policy_identifier)
