from pytest import fixture
from facturark.signer import Verifier, Canonicalizer


@fixture
def verifier():
    canonicalizer = Canonicalizer
    verifier = Verifier(canonicalizer)
    return verifier


def test_verifier_instantiation(verifier):
    assert verifier is not None
