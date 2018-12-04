from pytest import fixture
from lxml.etree import QName
from facturark.namespaces import NS
from facturark.composers import (
    DebitNoteLineComposer, AmountComposer, BillingReferenceComposer)


@fixture
def composer():
    amount_composer = AmountComposer()
    billing_reference_composer = BillingReferenceComposer(amount_composer)
    return DebitNoteLineComposer(amount_composer, billing_reference_composer)


@fixture
def data_dict():
    return {
        'id': '1',
        'uuid': 'abcd123',
        'line_extension_amount': {
            '@attributes': {'currencyID': 'COP'},
            '#text': "3456788.00"
        },
        "discrepancy_response": {
            "response_code": "2"
        },
        "billing_references": [{
            "invoice_document_reference": {
                "id": "PRUE980000094",
                "uuid": "3d5a434b014429b551864c49a84164d58b11ea02",
                "issue_date": "2018-11-30"
            },
            "billing_reference_line": {
                "amount": {
                    "@attributes": {
                        "currencyID": "COP"
                    },
                    "#text": "15031725.00"
                }
            },
            "additional_document_reference": {
                "id": "JD-11-2018",
                "issue_date": "2018-11-30",
                "document_type": "Decision de la JD",
                "xpath": "",
                "attachment": ""
            }
        }],
        "tax_total": {
            "tax_amount": {
                "@attributes": {
                    "currencyID": "COP"
                },
                "#text": "2856027.75"
            }
        },
        "item": {
            "description": "[CARD] Graphics Card",
            "additional_information": (
                "El sistema de la DIAN señalo que la firma digital "
                "está fallida")
        }
    }


def test_compose(composer, data_dict, schema):
    debit_note_line = composer.compose(data_dict)

    assert debit_note_line.tag == QName(NS.cac, "DebitNoteLine").text
    assert debit_note_line.findtext(QName(NS.cbc, 'ID')) == '1'
    assert debit_note_line.findtext(QName(NS.cbc, 'UUID')) == 'abcd123'

    line_extension_amount = debit_note_line.find(
        QName(NS.cbc, "LineExtensionAmount"))
    assert line_extension_amount.text == "3456788.00"
    assert line_extension_amount.attrib['currencyID'] == 'COP'

    discrepancy_response = debit_note_line.find(
        QName(NS.cac, "DiscrepancyResponse"))
    response_code = discrepancy_response.find(
        QName(NS.cbc, "ResponseCode"))
    assert response_code.text == "2"

    assert debit_note_line.find(
        QName(NS.cac, "BillingReference")) is not None

    tax_total = debit_note_line.find(QName(NS.cac, "TaxTotal"))
    assert tax_total.find(QName(NS.cbc, "TaxAmount")).text == "2856027.75"
    assert tax_total.find(QName(NS.cbc, "TaxAmount")
                          ).attrib.get('currencyID') == "COP"

    item = debit_note_line.find(QName(NS.cac, "Item"))
    assert item.find(QName(NS.cbc, "Description")).text == (
        "[CARD] Graphics Card")
    assert item.find(QName(NS.cbc, "AdditionalInformation")).text == (
        "El sistema de la DIAN señalo que la firma digital "
        "está fallida")

    schema.assertValid(debit_note_line)
