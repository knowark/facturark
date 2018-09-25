from pytest import fixture
from facturark.utils import parse_xsd


@fixture(scope='session')
def schema():
    return parse_xsd('XSD/XADES/XAdES01903v132-201601.xsd')
