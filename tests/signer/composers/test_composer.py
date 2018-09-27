from pytest import fixture, raises
from lxml.etree import QName, fromstring
from facturark.signer.composers.composer import Composer


@fixture
def composer():
    return Composer()


def test_compose_not_implemented(composer):
    with raises(NotImplementedError):
        composer.compose({})
