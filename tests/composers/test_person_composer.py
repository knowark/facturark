from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.namespaces import NS
from facturark.composers import PersonComposer


@fixture
def composer():
    return PersonComposer()


@fixture
def data_dict():
    return {
        'first_name': "Gabriel",
        'family_name': "Echeverry"
    }


def test_compose(composer, data_dict, schema):
    person = composer.compose(data_dict)

    assert person.tag == QName(NS.fe, "Person").text
    assert person.findtext(QName(NS.cbc, "FirstName")) == "Gabriel"
    assert person.findtext(QName(NS.cbc, "FamilyName")) == "Echeverry"
    schema.assertValid(person)
