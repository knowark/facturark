from facturark.signer import Signer
from facturark.signer.composers import (
    SignatureComposer, SignedInfoComposer)
from facturark.signer.resolver import (
    resolve_signature_composer, resolve_signed_info_composer,
    resolve_signer)


def test_resolve_signature_composer():
    assert isinstance(resolve_signature_composer(), SignatureComposer)


def test_resolve_signed_info_composer():
    assert isinstance(resolve_signed_info_composer(), SignedInfoComposer)


def test_resolve_signer(pkcs12_certificate):
    certificate, password = pkcs12_certificate
    assert isinstance(resolve_signer(certificate, password), Signer)


def test_resolve_signer_no_certificate(pkcs12_certificate):
    certificate, password = None, None
    assert resolve_signer(certificate, password) is None
