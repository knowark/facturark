import io
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.xsd_parser import parse_xsd
from facturark.composers import NS
from facturark.composers import PartyComposer


@fixture
def composer():
    return PartyComposer()


@fixture
def data_dict():
    return {
        'party_identification': '900555666',
        'party_name': 'Company XYZ S.A.S'
    }


def test_compose(composer, data_dict, schema):
    party = composer.compose(data_dict)

    assert party.prefix == "fe"
    assert party.tag == QName(NS.fe, "Party").text

    party_identification = party.find(
        QName(NS.cac, "PartyIdentification"))
    assert party_identification.findtext(
        QName(NS.cbc, "ID")) == '900555666'

    party_name = party.find(
        QName(NS.cac, "PartyName"))
    assert party_name.findtext(
        QName(NS.cbc, "Name")) == 'Company XYZ S.A.S'
    # schema.assertValid(party)
