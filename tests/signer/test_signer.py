import os
import io
from pytest import fixture
from lxml.etree import parse
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
