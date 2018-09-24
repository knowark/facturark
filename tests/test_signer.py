from pytest import fixture
from facturark.signer import Signer


@fixture
def signer():
    signer = Signer()
    return signer


def test_signer_instantiation():
    assert signer is not None
