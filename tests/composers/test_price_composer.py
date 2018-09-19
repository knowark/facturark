from pytest import fixture
from lxml.etree import QName
from xmlunittest import XmlTestCase
from facturark.composers import PriceComposer
from facturark.xsd_parser import parse_xsd
from facturark.composers import NS


@fixture
def composer():
    return PriceComposer()


@fixture
def data_dict():
    return {
        'price_amount': 777.77,
    }


class TestPriceComposer(XmlTestCase):

    @fixture(autouse=True)
    def inject_fixtures(self, data_dict, composer):
        self.data_dict = data_dict
        self.composer = composer

    def test_party_compose(self):
        element = self.composer.compose(self.data_dict)
        schema = parse_xsd('XSD/DIAN/DIAN_UBL.xsd')

        assert element.tag == QName(NS.fe, "Price").text
        schema.assertValid(element)

    def test_party_serialize(self):
        document = self.composer.serialize(self.data_dict)
        self.assertXmlDocument(document)
