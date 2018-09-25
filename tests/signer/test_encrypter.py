from pytest import fixture
from facturark.signer import Encrypter


@fixture
def encrypter():
    encrypter = Encrypter()
    return encrypter


def test_encrypter_instantiation(encrypter):
    assert encrypter is not None
