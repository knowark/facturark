from pytest import fixture
from facturark.xsd_parser import parse_xsd


@fixture
def schema():
    return parse_xsd('XSD/DIAN/DIAN_UBL.xsd')
