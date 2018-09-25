from pytest import fixture
from facturark.signer import Signer, Canonicalizer


@fixture
def signer():
    canonicalizer = Canonicalizer
    signer = Signer(canonicalizer)
    return signer


def test_signer_instantiation(signer):
    assert signer is not None
