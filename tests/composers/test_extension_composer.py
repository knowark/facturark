from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.composers import NS, ExtensionComposer


@fixture
def composer():
    return ExtensionComposer()


@fixture
def data_dict():
    return {
        'extension_content': {}
    }


def test_compose(composer, data_dict, schema):
    extension = composer.compose(data_dict, 'UBLExtension')

    assert extension.tag == QName(NS.ext, "UBLExtension").text

    schema.assertValid(extension)
