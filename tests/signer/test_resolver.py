from facturark.signer.composers import (
    SignatureComposer, SignedInfoComposer)
from facturark.signer.resolver import (
    resolve_signature_composer, resolve_signed_info_composer)


def test_resolve_signature_composer():
    assert isinstance(resolve_signature_composer(), SignatureComposer)


def test_resolve_signed_info_composer():
    assert isinstance(resolve_signed_info_composer(), SignedInfoComposer)
