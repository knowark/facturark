# -*- coding: utf-8 -*-
import io
from pytest import fixture, mark
from lxml.etree import QName, fromstring, tostring
from facturark.namespaces import NS
from facturark.composers.resolver import resolve_billing_reference_composer


@fixture
def composer():
    return resolve_billing_reference_composer()


@fixture
def data_dict():
    return {
        "additional_document_reference": {
            "id": "JD-11-2018",
            "issue_date": "2018-11-30",
            "document_type": u"Decisión de la JD"
        },
        "billing_reference_line": {
            "amount": {
                "@attributes": {
                    "currencyID": "COP"
                },
                "#text": "15031725.00"
            }
        },
        "invoice_document_reference": {
            "id": "PRUE980000094",
            "uuid": "3d5a434b014429b551864c49a84164d58b11ea02",
            "issue_date": "2018-11-30"
        }
    }


@fixture
def data_dict_empty():
    return {
    }


def test_compose(composer, data_dict, schema):
    billing_reference = composer.compose(data_dict)

    assert billing_reference.tag == QName(NS.cac, "BillingReference").text

    additional_document_reference = billing_reference.find(
        QName(NS.cac, "AdditionalDocumentReference"))
    assert additional_document_reference.find(
        QName(NS.cbc, "ID")).text == "JD-11-2018"
    assert additional_document_reference.find(
        QName(NS.cbc, "IssueDate")).text == "2018-11-30"
    assert additional_document_reference.find(
        QName(NS.cbc, "DocumentType")).text == u"Decisión de la JD"

    billing_reference_line = billing_reference.find(
        QName(NS.cac, "BillingReferenceLine"))
    assert billing_reference_line.find(QName(NS.cbc, "ID")) is not None
    assert billing_reference_line.find(
        QName(NS.cbc, "Amount")).text == (
            "15031725.00")
    assert billing_reference_line.find(
        QName(NS.cbc, "Amount")).attrib.get('currencyID') == 'COP'

    invoice_document_reference = billing_reference.find(
        QName(NS.cac, "InvoiceDocumentReference"))
    assert invoice_document_reference.find(
        QName(NS.cbc, "ID")).text == "PRUE980000094"
    assert invoice_document_reference.find(
        QName(NS.cbc, "UUID")).text == (
            "3d5a434b014429b551864c49a84164d58b11ea02")
    assert invoice_document_reference.find(
        QName(NS.cbc, "IssueDate")).text == "2018-11-30"

    schema.assertValid(billing_reference)


def test_compose_empty(composer, data_dict_empty, schema):
    billing_reference = composer.compose(data_dict_empty)
    schema.assertValid(billing_reference)
