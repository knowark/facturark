from pytest import fixture
from facturark.models import Invoice
from facturark.serializer import Serializer
from facturark.xml_serializer import XmlSerializer


def test_xml_serializer_implementation():
    assert issubclass(XmlSerializer, Serializer)


@fixture
def serializer():
    builder = XmlSerializer()
    return builder


def test_xml_serializer_serialize(serializer, invoice):
    result = serializer.serialize(invoice)





