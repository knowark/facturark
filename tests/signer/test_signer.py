import os
from base64 import b64decode, b64encode
from pytest import fixture
from lxml.etree import parse, QName, tostring
from OpenSSL import crypto
from facturark.signer.composers.namespaces import NS
from facturark.signer import (
    Signer, Canonicalizer, Hasher, Encoder, Identifier, Encrypter)
from facturark.signer.composers import (
    KeyInfoComposer, ObjectComposer,
    SignedInfoComposer, SignatureValueComposer)
from facturark.signer.composers.xades import (
    QualifyingPropertiesComposer, SignedPropertiesComposer)
from facturark.signer.resolver import (
    resolve_signature_composer, resolve_signed_info_composer)


@fixture
def signer(pkcs12_certificate):
    certificate, password = pkcs12_certificate
    canonicalizer = Canonicalizer()
    hasher = Hasher()
    encoder = Encoder()
    identifier = Identifier()
    encrypter = Encrypter()
    signature_composer = resolve_signature_composer()
    key_info_composer = KeyInfoComposer()
    object_composer = ObjectComposer()
    qualifying_properties_composer = QualifyingPropertiesComposer()
    signed_properties_composer = SignedPropertiesComposer()
    signed_info_composer = resolve_signed_info_composer()
    signature_value_composer = SignatureValueComposer()
    signer = Signer(canonicalizer, hasher, encoder, identifier, encrypter,
                    signature_composer, key_info_composer, object_composer,
                    qualifying_properties_composer, signed_properties_composer,
                    signed_info_composer, signature_value_composer,
                    pkcs12_certificate=certificate, pkcs12_password=password)
    return signer


@fixture
def unsigned_invoice():
    filename = 'unsigned_invoice.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element


def test_signer_instantiation(signer):
    assert signer is not None


def test_signer_parse_certificate(signer, pkcs12_certificate):
    certificate, password = pkcs12_certificate
    result = signer._parse_certificate(certificate, password)

    x509_certificate = result.get_certificate()
    private_key = result.get_privatekey()

    assert isinstance(result, crypto.PKCS12)
    assert isinstance(x509_certificate, crypto.X509)
    assert isinstance(private_key, crypto.PKey)


def test_signer_serialize_certificate(signer, pkcs12_certificate):
    certificate, password = pkcs12_certificate
    certificate_object = signer._parse_certificate(certificate, password)
    x509_certificate = certificate_object.get_certificate()

    result = signer._serialize_certificate(x509_certificate)

    assert b'BEGIN CERTIFICATE' not in result
    assert b"".join(b64encode(b64decode(result)).split()) == (
        b"".join(result.split()))


def test_signer_prepare_key_info(signer, pkcs12_certificate):
    certificate, password = pkcs12_certificate
    certificate_object = signer._parse_certificate(certificate, password)
    x509_certificate = certificate_object.get_certificate()

    uid = "xmldsig-8d0c0815-f905-4f6a-9a74-645460917dcc-keyinfo"
    key_info, key_info_digest = (
        signer._prepare_key_info(x509_certificate, uid))

    assert key_info.tag == QName(NS.ds, 'KeyInfo').text
    assert key_info_digest is not None
    assert 'keyinfo' in key_info.attrib.get('Id')


def test_signer_prepare_signed_properties(signer, pkcs12_certificate):
    certificate, password = pkcs12_certificate
    certificate_object = signer._parse_certificate(certificate, password)
    x509_certificate = certificate_object.get_certificate()

    uid = "xmldsig-a116f9ea-cbfa-4e45-b026-646e43b86df7-signedprops"
    signed_properties, signed_properties_digest = (
        signer._prepare_signed_properties(x509_certificate, uid))

    assert signed_properties.tag == QName(NS.xades, 'SignedProperties').text
    assert signed_properties_digest is not None
    assert 'signedprops' in signed_properties.attrib.get('Id')


def test_signer_prepare_document(signer, unsigned_invoice):
    document_element, document_digest = (
        signer._prepare_document(unsigned_invoice))

    assert document_element == unsigned_invoice
    assert document_digest is not None


def test_signer_prepare_signed_info(signer, unsigned_invoice):
    key_info_digest = (
        "3yWkQi9ul+9zHh4NwnTPk+LGMcp5ZBIb3SYIXWb3E2r9mThxbL"
        "RXV0s/CR7ERN231Gdu3V7wOkYtbjBye9KO2A==")
    document_digest = (
        "ICVBnSstvgKi5xp7Gmoj0os/BmzS4tAZqvcif5JEmHkLzQPRUT"
        "7sSn3fJYyhr1MT/WCB0zu6mGu3AKp3tcKTKg==")
    signed_properties_digest = (
        "1G/hxF2uFiArigAVd6E9S6m2/UrZ1xmHJR+mglGvHmT3TlTa/IZ"
        "qtXCB+fHeH8G+rYvWcCRJSjbIsYV3xOzzcA==")

    signed_info, signed_info_digest = signer._prepare_signed_info(
        document_digest, key_info_digest, signed_properties_digest)

    assert signed_info.tag == QName(NS.ds, 'SignedInfo').text
    assert signed_info_digest is not None


def test_signer_prepare_signature_value(signer):
    value = ("KhSG6Gats5f8HwyjC/3dG+GmkhwIVjIygwcA9SeiJkEtq6OQw5y"
             "Qb27y8DzmLRJ7tA/IlxzrnC9V 3MFgShGM+5MeazVoWVdr3jAqHV"
             "2vsm+INKefUvDjm/buCIxqn9HLuIDash9+hKJRTSaR0GZoRKQV f"
             "f07v4nnbE0uvhTYoaCR8KcCjk/Mrm4VfmgC8PRFKz9usRfmgQxdUp"
             "VZTXfy2aqSlkt4VpFhisjA WeQzzquDH/MsT/EtCuGMZEtngbMUYY"
             "ItRIBOgZ5qPJ9SMW1JIoraaBRdosLj0bSIXnsGhnS0nAYZ N0Trmt"
             "Bn8ypUGxkMK7KFXhPc2bBoINZxPGeIcw==")
    uid = "xmldsig-a116f9ea-cbfa-4e45-b026-646e43b86df7-signedprops"
    signature_value = (
        signer._prepare_signature_value(value, uid))

    assert signature_value.tag == QName(NS.ds, 'SignatureValue').text
    assert signature_value.text == value
    assert signature_value.attrib.get('Id') == uid


def test_create_signature_value_digest(signer, pkcs12_certificate):
    certificate, password = pkcs12_certificate
    certificate_object = signer._parse_certificate(certificate, password)
    private_key = certificate_object.get_privatekey()
    signed_info_digest = (
        b"d4OJpOqB2nxNMMYSFL8ZU0+3p1AGA1wHy7K21pktdRT5+FuVTJosq"
        b"f5sw88VuTyF6Auh4mtu4sE7DpBHCmX95Q==")

    signature_digest = signer._create_signature_value_digest(
        private_key, signed_info_digest)

    assert b"".join(b64encode(b64decode(signature_digest)).split()) == (
        b"".join(signature_digest.split()))


def test_signer_sign(signer, unsigned_invoice):
    signed_document = signer.sign(unsigned_invoice)

    assert 'Invoice' in signed_document.getroot().tag
    assert signed_document.find('.//ds:Signature', vars(NS)) is not None
