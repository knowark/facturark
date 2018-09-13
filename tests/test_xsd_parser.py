import os
from lxml import etree
from facturark.xsd_parser import parse_xsd


def test_xsd_parser_parse():
    xschema = parse_xsd("XSD/DIAN/DIAN_UBL.xsd")
    assert isinstance(xschema, etree.XMLSchema)


def test_xsd_parser_validate_correct_invoice():
    xschema = parse_xsd("XSD/DIAN/DIAN_UBL.xsd")
    directory = os.path.dirname(os.path.realpath(__file__))
    doc = etree.parse(os.path.join(directory, "data/factura_firmada.xml"))
    assert xschema.validate(doc)
