from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.composers import NS
from facturark.resolver import resolve_extensions_composer


@fixture
def composer():
    return resolve_extensions_composer()


@fixture
def data_dict_dian():
    return {
        'extension_content': {
            'dian_extensions': {
                'invoice_control': {
                    'invoice_authorization': '9000000500017960',
                    'authorization_period': {
                        'start_date': '2016-07-11',
                        'end_date': '2016-07-11'
                    },
                    'authorized_invoices': {
                        'prefix': 'PRUE',
                        'from': '980000000',
                        'to': '985000000'
                    }
                },
                'invoice_source': {
                    'identification_code': 'CO'
                },
                'software_provider': {
                    'provider_id': '900373115',
                    'software_id': '0d2e2883-eb8d-4237-87fe-28aeb71e961e'
                },
                'software_security_code': (
                    "bdaa51c9953e08dcc8f398961f7cd0717cd5fbea356e93766"
                    "0aa1a8abbe31f4c9b4eb5cf8682eaca4c8523953253dcce")
            }
        }
    }


def test_compose_dian(composer, data_dict_dian, schema):
    extension = composer.compose(data_dict_dian, 'UBLExtension')

    assert extension.tag == QName(NS.ext, "UBLExtension").text

    extension_content = extension.find(QName(NS.ext, 'ExtensionContent'))
    assert extension_content is not None

    schema.assertValid(extension)
