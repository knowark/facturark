from lxml.etree import DocumentInvalid, fromstring
from pytest import fixture, raises
from facturark.checker import Checker


@fixture
def checker():
    return Checker()


def test_checker_instantiation(checker):
    assert checker
