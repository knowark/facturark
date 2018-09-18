import io
from pytest import fixture, mark
from lxml.etree import QName
from xmlunittest import XmlTestCase
from facturark.composers import PartyComposer
from facturark.xsd_parser import parse_xsd
from facturark.composers import NS


@fixture
def composer():
    return PartyComposer()


@fixture
def party_dict():
    return {
        'party_identification': '900555666',
        'party_name': 'Company XYZ S.A.S'
    }


class TestPartyComposer(XmlTestCase):

    @fixture(autouse=True)
    def inject_fixtures(self, party_dict, composer):
        self.party_dict = party_dict
        self.composer = composer

    def test_party_compose(self):
        party = self.composer.compose(self.party_dict)

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

    def test_party_serialize(self):
        document = self.composer.serialize(self.party_dict)

        self.assertXmlDocument(document)
