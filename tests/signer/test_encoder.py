from pytest import fixture
from facturark.signer import Encoder


@fixture
def encoder():
    encoder = Encoder()
    return encoder


def test_encoder_instantiation(encoder):
    assert encoder is not None


def test_encoder_base64_encode(encoder):
    data = b'Binary'
    result = encoder.base64_encode(data)
    assert result == b'QmluYXJ5'


def test_encoder_base64_decode(encoder):
    data = b'QmluYXJ5'
    result = encoder.base64_decode(data)
    assert result == b'Binary'
