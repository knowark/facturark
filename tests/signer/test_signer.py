import os
import io
from base64 import b64decode, b64encode
from pytest import fixture
from lxml.etree import parse
from OpenSSL import crypto
from facturark.signer import Signer, Canonicalizer, Hasher
from facturark.signer.resolver import resolve_signature_composer


@fixture
def signer():
    canonicalizer = Canonicalizer()
    hasher = Hasher()
    signature_composer = resolve_signature_composer()
    signer = Signer(canonicalizer, hasher, signature_composer)
    return signer


@fixture
def unsigned_invoice():
    filename = 'unsigned_invoice.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element


@fixture
def pkcs12_certificate():
    filename = 'certificate.p12'
    directory = os.path.dirname(os.path.realpath(__file__))
    path = os.path.join(directory, '..', 'data', filename)
    with io.open(path, 'rb') as f:
        certificate = f.read()
    password = 'test'
    return (certificate, password)


def test_signer_instantiation(signer):
    assert signer is not None


# def test_signer_sign(signer, unsigned_invoice, pkcs12_certificate):
#     certificate, password = pkcs12_certificate
#     result = signer.sign(unsigned_invoice, certificate, password)
#     assert result is True


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

    assert 'BEGIN CERTIFICATE' not in result
    assert "".join(b64encode(b64decode(result)).split()) == (
        "".join(result.split()))
