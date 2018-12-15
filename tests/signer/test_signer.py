import os
import cryptography
from base64 import b64decode, b64encode
from pytest import fixture
from lxml.etree import parse, QName, tostring
from facturark.utils import read_asset
from facturark.namespaces import NS
from facturark.signer import (
    Signer, Canonicalizer, Hasher, Encoder, Identifier, Encrypter)
from facturark.signer.composers import (
    KeyInfoComposer, ObjectComposer,
    SignedInfoComposer, SignatureValueComposer)
from facturark.signer.composers.xades import (
    QualifyingPropertiesComposer, SignedPropertiesComposer)
from facturark.signer.resolver import (
    resolve_signature_composer, resolve_signed_info_composer,
    resolve_signed_properties_composer,
    resolve_qualifying_properties_composer)


@fixture
def signer(certificate, private_key):
    canonicalizer = Canonicalizer()
    hasher = Hasher()
    encoder = Encoder()
    identifier = Identifier()
    encrypter = Encrypter()
    signature_composer = resolve_signature_composer()
    key_info_composer = KeyInfoComposer()
    object_composer = ObjectComposer()
    qualifying_properties_composer = resolve_qualifying_properties_composer()
    signed_properties_composer = resolve_signed_properties_composer()
    signed_info_composer = resolve_signed_info_composer()
    signature_value_composer = SignatureValueComposer()
    signer = Signer(canonicalizer, hasher, encoder, identifier, encrypter,
                    signature_composer, key_info_composer, object_composer,
                    qualifying_properties_composer, signed_properties_composer,
                    signed_info_composer, signature_value_composer,
                    certificate=certificate, private_key=private_key)
    return signer


@fixture
def unsigned_invoice():
    filename = 'unsigned_invoice.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element


def test_signer_instantiation(signer):
    assert signer is not None


def test_signer_parse_certificate(signer, certificate):
    result = signer._parse_certificate(certificate)

    assert isinstance(result,
        cryptography.hazmat.backends.openssl.x509._Certificate)


def test_signer_parse_private_key(signer, private_key):
    result = signer._parse_private_key(private_key)

    assert isinstance(result,
        cryptography.hazmat.primitives.asymmetric.rsa.RSAPrivateKey)

def test_signer_serialize_certificate(signer, certificate):
    certificate_object = signer._parse_certificate(certificate)

    result = signer._serialize_certificate(certificate_object)

    assert b'BEGIN CERTIFICATE' not in result
    assert b"".join(b64encode(b64decode(result)).split()) == (
        b"".join(result.split()))


def test_signer_prepare_key_info(signer, certificate):
    algorithm = "http://www.w3.org/2001/04/xmlenc#sha512"
    certificate_object = signer._parse_certificate(certificate)

    uid = "xmldsig-8d0c0815-f905-4f6a-9a74-645460917dcc-keyinfo"
    key_info, key_info_digest = (
        signer._prepare_key_info(certificate_object, uid, algorithm))

    assert key_info.tag == QName(NS.ds, 'KeyInfo').text
    assert key_info_digest is not None
    assert 'keyinfo' in key_info.attrib.get('Id')


def test_get_certificate_digest_value(signer, certificate_pem):
    algorithm = "http://www.w3.org/2001/04/xmlenc#sha512"
    result = signer._get_certificate_digest_value(certificate_pem, algorithm)
    assert result == (
        b"7HiEC/QH5hTNtrDLWp4jBzSqiEV3zLFOwCqvnTnXmPGe"
        b"E4uMmJWCDkPs6tkWAE3rbaIb6palIGsPPOjuetlF5Q==")


def test_signer_get_policy_hash(signer):
    algorithm = "http://www.w3.org/2001/04/xmlenc#sha512"
    result = signer._get_policy_hash(algorithm)
    assert result == (
        b"Zcjw1Z9nGQn2j6NyGx8kAaLbOfJGd/fJxRTCeirlqA"
        b"g7zRG27piJkJOpflGu7XACpMj9hC6dVMcCyzqHxxPZeQ==")


def test_signer_prepare_issuer_name(signer, certificate):
    certificate_object = signer._parse_certificate(certificate)
    certificate = certificate_object.get_certificate()
    issuer_name = signer._prepare_issuer_name(certificate)
    assert issuer_name == (
        b'1.2.840.113549.1.9.1=info@mit-xperts.com,CN=itv.mit-xperts.com,'
        b'OU=HBBTV-DEMO-CA,O=MIT-xperts GmbH,L=Munich,ST=Bavaria,C=DE')


def test_signer_prepare_signed_properties(signer, certificate):
    certificate_object = signer._parse_certificate(certificate)

    uid = b"xmldsig-a116f9ea-cbfa-4e45-b026-646e43b86df7-signedprops"
    signed_properties, signed_properties_digest = (
        signer._prepare_signed_properties(certificate_object, uid))

    assert signed_properties.tag == QName(NS.xades, 'SignedProperties').text
    assert signed_properties_digest is not None
    assert 'signedprops' in signed_properties.attrib.get('Id')


def test_signer_prepare_document(signer, unsigned_invoice):
    algorithm = "http://www.w3.org/2001/04/xmlenc#sha512"
    document_element, document_digest = (
        signer._prepare_document(unsigned_invoice, algorithm))

    assert document_digest is not None


def test_signer_prepare_signed_info(signer, unsigned_invoice):
    document_digest = (
        "ICVBnSstvgKi5xp7Gmoj0os/BmzS4tAZqvcif5JEmHkLzQPRUT"
        "7sSn3fJYyhr1MT/WCB0zu6mGu3AKp3tcKTKg==")
    key_info_digest = (
        "3yWkQi9ul+9zHh4NwnTPk+LGMcp5ZBIb3SYIXWb3E2r9mThxbL"
        "RXV0s/CR7ERN231Gdu3V7wOkYtbjBye9KO2A==")
    signed_properties_digest = (
        "1G/hxF2uFiArigAVd6E9S6m2/UrZ1xmHJR+mglGvHmT3TlTa/IZ"
        "qtXCB+fHeH8G+rYvWcCRJSjbIsYV3xOzzcA==")

    document_tuple = ('ABC123', '', document_digest)
    key_info_tuple = (None, 'keyinfo', key_info_digest)
    signed_properties_tuple = (None, 'signed_props', signed_properties_digest)

    signed_info, signed_info_digest = signer._prepare_signed_info(
        document_tuple, key_info_tuple, signed_properties_tuple)
    signed_properties_reference_type = (
        "http://uri.etsi.org/01903#SignedProperties")

    assert signed_info.tag == QName(NS.ds, 'SignedInfo').text
    assert signed_info_digest is not None

    document_reference = signed_info.find(
        './/ds:Reference[@Id="ABC123"]', vars(NS))
    assert document_reference.attrib['Id'] == 'ABC123'
    assert document_reference.attrib['URI'] == ''

    key_info_reference = signed_info.find(
        './/ds:Reference[@URI="#keyinfo"]', vars(NS))
    assert key_info_reference.attrib.get('Id') is None
    assert key_info_reference.attrib['URI'] == '#keyinfo'

    signed_properties_reference = signed_info.find(
        './/ds:Reference[@URI="#signed_props"]', vars(NS))
    assert signed_properties_reference.attrib.get('Id') is None
    assert signed_properties_reference.attrib['Type'] == (
        signed_properties_reference_type)
    assert signed_properties_reference.attrib['URI'] == '#signed_props'


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


def test_create_signature_value_digest(signer, certificate, private_key):
    certificate_object = signer._parse_certificate(certificate)
    private_key = signer._parse_private_key(private_key)
    signed_info_digest = (
        b"d4OJpOqB2nxNMMYSFL8ZU0+3p1AGA1wHy7K21pktdRT5+FuVTJosq"
        b"f5sw88VuTyF6Auh4mtu4sE7DpBHCmX95Q==")

    signer.signature_algorithm = (
        "http://www.w3.org/2001/04/xmldsig-more#rsa-sha512")
    signature_digest = signer._create_signature_value_digest(
        private_key, signed_info_digest)

    assert b"".join(b64encode(b64decode(signature_digest)).split()) == (
        b"".join(signature_digest.split()))


def test_signer_sign(signer, unsigned_invoice):
    signed_document = signer.sign(unsigned_invoice)

    assert 'Invoice' in signed_document.tag
    assert signed_document.find('.//ds:Signature', vars(NS)) is not None
