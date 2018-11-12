from pytest import fixture
from facturark.signer import Identifier


@fixture
def identifier():
    identifier = Identifier()
    return identifier


def test_identifier_instantiation(identifier):
    assert identifier is not None


def test_identifier_generate_id(identifier):
    result = identifier.generate_id()
    assert result.startswith('xmldsig')


def test_identifier_generate_id_suffix(identifier):
    result = identifier.generate_id(suffix='sigvalue')
    assert result.endswith('sigvalue')


def test_identifier_generate_id_only_uuid(identifier):
    result = identifier.generate_id(prefix=None)
    assert not result.startswith('xmldsig')
    assert len(result) == 36


def test_identifier_generate_id_given_uuid(identifier):
    uuid = 'ABCD'
    result = identifier.generate_id(uuid=uuid, prefix=None)
    assert len(result) == 4
