from facturark.signer import Signer, Verifier
from facturark.signer.composers import (
    SignatureComposer, SignedInfoComposer)
from facturark.signer.resolver import (
    resolve_signature_composer, resolve_signed_info_composer,
    resolve_signer, resolve_verifier)


def test_resolve_signature_composer():
    assert isinstance(resolve_signature_composer(), SignatureComposer)


def test_resolve_signed_info_composer():
    assert isinstance(resolve_signed_info_composer(), SignedInfoComposer)


def test_resolve_signer(certificate, private_key):
    assert isinstance(resolve_signer(certificate, private_key), Signer)


def test_resolve_signer_no_certificate():
    certificate, private_key = None, None
    assert resolve_signer(certificate, private_key) is None


def test_resolve_verifier():
    assert isinstance(resolve_verifier(), Verifier)
