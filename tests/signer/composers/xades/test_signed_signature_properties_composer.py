# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring, tostring
from facturark.namespaces import NS
from facturark.signer.composers.xades import (
    SignedSignaturePropertiesComposer, SignaturePolicyIdentifierComposer,
    SignerRoleComposer, SigningCertificateComposer)


@fixture
def composer():
    signing_certificate_composer = SigningCertificateComposer()
    signature_policy_identifier_composer = (
        SignaturePolicyIdentifierComposer())
    signer_role_composer = SignerRoleComposer()
    return SignedSignaturePropertiesComposer(
        signing_certificate_composer,
        signature_policy_identifier_composer,
        signer_role_composer)


@fixture
def data_dict():
    return {
        'signing_time': '2016-07-12T11:17:38.639-05:00',
        'signing_certificate': {
            'certs': [{
                'cert_digest': {
                    'digest_method': {
                        '@attributes': {
                            'Algorithm': (
                                "http://www.w3.org/2000/09/xmldsig#sha1")}
                    },
                    'digest_value': '2el6MfWvYsvEaa/TV513a7tVK0g='
                },
                'issuer_serial': {
                    'X509_issuer_name': (
                        'C=CO,L=Bogota D.C.,O=Andes SCD.,OU=Division '
                        'de certificacion entidad final,CN=CA ANDES SCD '
                        'S.A. Clase II,1.2.840.113549.1.9.1=#1614696e666f'
                        '40616e6465737363642e636f6d2e636f'),
                    'X509_serial_number': '9128602840918470673'
                }
            }]
        },
        'signature_policy_identifier': {
            'signature_policy_id': {
                'sig_policy_id': {
                    'identifier': ('https://facturaelectronica.dian.gov.co/'
                                   'politicadefirma/v1/politicadefirmav1.pdf')
                },
                'sig_policy_hash': {
                    'digest_method': {
                        '@attributes': {
                            'Algorithm': (
                                "http://www.w3.org/2000/09/xmldsig#sha1")
                        }
                    },
                    'digest_value': '61fInBICBQOCBwuTwlaOZSi9HKc='
                }
            }
        },
        'signer_role': {
            'claimed_roles': [{
                'claimed_role': 'supplier'
            }]
        }
    }


def test_compose(composer, data_dict, schema):
    signed_signature_properties = composer.compose(data_dict)

    assert signed_signature_properties.prefix == "xades"
    assert signed_signature_properties.tag == QName(
        NS.xades, "SignedSignatureProperties").text
    assert signed_signature_properties.findtext(
        QName(NS.xades, 'SigningTime')) == '2016-07-12T11:17:38.639-05:00'

    schema.assertValid(signed_signature_properties)
