# -*- coding: utf-8 -*-
import io
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.namespaces import NS
from facturark.composers import DianExtensionsComposer


@fixture
def composer():
    return DianExtensionsComposer()


@fixture
def data_dict():
    return {
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


@fixture
def data_dict_without_some_data():
    return {
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


def test_compose(composer, data_dict, schema):
    dian_extensions = composer.compose(data_dict)

    assert dian_extensions.prefix == "sts"
    assert dian_extensions.tag == QName(NS.sts, "DianExtensions").text

    invoice_control = dian_extensions.find(QName(NS.sts, "InvoiceControl"))
    assert invoice_control is not None
    assert invoice_control.findtext(
        QName(NS.sts, "InvoiceAuthorization")) == '9000000500017960'

    authorization_period = invoice_control.find(
        QName(NS.sts, "AuthorizationPeriod"))
    assert authorization_period is not None

    authorized_invoices = invoice_control.find(
        QName(NS.sts, "AuthorizedInvoices"))
    assert authorized_invoices is not None

    schema.assertValid(dian_extensions)


def test_compose_without_some_data(composer,
                                   data_dict_without_some_data, schema):
    dian_extensions = composer.compose(data_dict_without_some_data)
    assert dian_extensions.prefix == "sts"
    schema.assertValid(dian_extensions)
