from pytest import fixture
from facturark.signer import Hasher


@fixture
def hasher():
    hasher = Hasher()
    return hasher


def test_hasher_instantiation(hasher):
    assert hasher is not None
