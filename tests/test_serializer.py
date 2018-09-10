from facturark.serializer import Serializer


def test_serializer():
    methods = Serializer.__abstractmethods__
    assert 'serialize' in methods
