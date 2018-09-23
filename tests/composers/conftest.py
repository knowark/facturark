from pytest import fixture
from facturark.utils import parse_xsd


@fixture(scope='session')
def schema():
    return parse_xsd('XSD/DIAN/DIAN_UBL.xsd')
