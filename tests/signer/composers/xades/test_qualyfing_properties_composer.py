# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring, tostring
from facturark.namespaces import NS
from facturark.signer.resolver import resolve_qualifying_properties_composer


@fixture
def composer():
    return resolve_qualifying_properties_composer()


@fixture
def data_dict():
    return {
        '@attributes': {'Target': ("#xmldsig-88fbfc45-3be2-"
                                   "4c4a-83ac-0796e1bad4c5")},
        'signed_properties': {
            '@attributes': {'Id': ("xmldsig-88fbfc45-3be2-"
                                   "4c4a-83ac-0796e1bad4c5-signedprops")},
            'signed_signature_properties': {
                'signing_time': '2016-07-12T11:17:38.639-05:00',
                'signing_certificate': {
                    'certs': [{
                        'cert_digest': {
                            'digest_method': {
                                '@attributes': {
                                    'Algorithm': (
                                        "http://www.w3.org/2000/"
                                        "09/xmldsig#sha1")}
                            },
                            'digest_value': '2el6MfWvYsvEaa/TV513a7tVK0g='
                        },
                        'issuer_serial': {
                            'X509_issuer_name': (
                                'C=CO,L=Bogota D.C.,O=Andes '
                                'SCD.,OU=Division de certificacion '
                                'entidad final,CN=CA ANDES SCD S.A. '
                                'Clase II,1.2.840.113549.1.9.1=#16146'
                                '96e666f40616e6465737363642e636f6d2e636f'),
                            'X509_serial_number': '9128602840918470673'
                        }
                    }]
                },
                'signature_policy_identifier': {
                    'signature_policy_id': {
                        'sig_policy_id': {
                            'identifier': (
                                'https://facturaelectronica.dian.gov.co/'
                                'politicadefirma/v1/politicadefirmav1.pdf')
                        },
                        'sig_policy_hash': {
                            'digest_method': {
                                '@attributes': {
                                    'Algorithm': (
                                        "http://www.w3.org/2000/"
                                        "09/xmldsig#sha1")
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
        }
    }


def test_compose(composer, data_dict, schema):
    qualifying_properties = composer.compose(data_dict)

    assert qualifying_properties.prefix == "xades"
    assert qualifying_properties.tag == QName(
        NS.xades, "QualifyingProperties").text

    assert qualifying_properties.find(
        QName(NS.xades, 'SignedProperties')) is not None

    schema.assertValid(qualifying_properties)
