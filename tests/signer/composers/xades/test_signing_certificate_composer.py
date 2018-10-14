# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring, tostring
from facturark.namespaces import NS
from facturark.signer.composers.xades import SigningCertificateComposer


@fixture
def composer():
    return SigningCertificateComposer()


@fixture
def data_dict():
    return {
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
    }


def test_compose(composer, data_dict, schema):
    signing_certificate = composer.compose(data_dict)

    assert signing_certificate.prefix == "xades"
    assert signing_certificate.tag == QName(
        NS.xades, 'SigningCertificate').text

    cert = signing_certificate.find(QName(NS.xades, 'Cert'))
    assert cert.tag == QName(NS.xades, "Cert").text

    schema.assertValid(signing_certificate)
