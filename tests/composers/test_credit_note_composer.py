# -*- coding: utf-8 -*-
import io
from pytest import fixture, mark
from lxml.etree import QName, fromstring, tostring
from facturark.namespaces import NS
from facturark.resolver import resolve_credit_note_composer


@fixture
def composer():
    return resolve_credit_note_composer()


@fixture
def data_dict():
    return {
        'extensions': [
            {
                'extension_content': {}
            }
        ],
        "id": "F0001",
        "uuid": "a3d6c86a71cbc066aaa19fd363c0fe4b5778d4a0",
        "issue_date": "2018-09-13",
        "issue_time": "00:31:40",
        "document_currency_code": "COP",
        "accounting_supplier_party": {
            'additional_account_id': 1,
            'party': {
                'party_identification': {
                    'id': {
                        '@attributes': {
                            'schemeAgencyID': '123',
                            'schemeAgencyName': 'CIA',
                            'schemeID': '007'
                        },
                        '#text':  '900555666'
                    }
                },
                'party_tax_scheme': {
                    'tax_level_code': '0'
                },
                'party_legal_entity': {
                    'registration_name': '800777555'
                },
                'person': {
                    'first_name': "Gabriel",
                    'family_name': "Echeverry"
                },
                'physical_location': {
                    'address': {
                        'department': 'Valle',
                        'city_name': 'Cali',
                        'country': {
                            'identification_code': 'CO'
                        }
                    }
                }
            }
        },
        "accounting_customer_party": {
            'additional_account_id': "1",
            'party': {
                'party_identification': {
                    'id': {
                        '@attributes': {
                            'schemeAgencyID': '123',
                            'schemeAgencyName': 'CIA',
                            'schemeID': '007'
                        },
                        '#text':  '900555666'
                    }
                },
                'party_tax_scheme': {
                    'tax_level_code': '0'
                },
                'party_legal_entity': {
                    'registration_name': '800777555'
                },
                'person': {
                    'first_name': "Gabriel",
                    'family_name': "Echeverry"
                },
                'physical_location': {
                    'address': {
                        'department': 'Valle',
                        'city_name': 'Cali',
                        'country': {
                            'identification_code': 'CO'
                        }
                    }
                }
            }
        },
        "tax_totals": [
            {
                "tax_amount": {
                    "@attributes": {
                        "currencyID": "COP"
                    },
                    "#text": "4465.00"
                },
                "tax_evidence_indicator": "false",
                "tax_subtotal": {
                    "percent": "19.0000",
                    "taxable_amount": {
                        "@attributes": {
                            "currencyID": "COP"
                        },
                        "#text": "23500.00"
                    },
                    "tax_amount": {
                        "@attributes": {
                            "currencyID": "COP"
                        },
                        "#text": "4465.00"
                    },
                    "tax_category": {
                        "tax_scheme": {
                            "id": "01"
                        }
                    }
                }
            }
        ],
        "legal_monetary_total": {
            'line_extension_amount': {
                '@attributes': {'currencyID': 'COP'},
                '#text': "888888.00"
            },
            'tax_exclusive_amount': {
                '@attributes': {'currencyID': 'COP'},
                '#text': "55555.00"
            },
            'payable_amount': {
                '@attributes': {'currencyID': 'COP'},
                '#text': "4444.00"
            }
        },
        "credit_note_lines": [
            {
                "id": "113",
                "uuid": "abcd123",
                "credited_quantity": {
                    "@attributes": {
                        "unitCode": "P4"
                    },
                    "#text": "16985"
                },
                "line_extension_amount": {
                    "@attributes": {
                        "currencyID": "COP"
                    },
                    "#text": "15031725.00"
                },
                "discrepancy_response": {
                    "response_code": "2"
                },
                "billing_reference": {
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
                },
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
                        "El sistema de la DIAN indico que la firma "
                        "digital esta fallida")
                }
            }
        ]
    }


def test_compose(composer, data_dict, schema):
    credit_note = composer.compose(data_dict)

    assert credit_note.prefix == "fe"
    assert credit_note.tag == QName(NS.fe, "CreditNote").text
    assert credit_note.findtext(QName(NS.cbc, "UBLVersionID")) == "UBL 2.0"
    assert credit_note.findtext(QName(NS.cbc, "ProfileID")) == "DIAN 1.0"
    assert credit_note.findtext(QName(NS.cbc, "ID")) == "F0001"
    assert credit_note.findtext(QName(NS.cbc, "UUID")) == (
        "a3d6c86a71cbc066aaa19fd363c0fe4b5778d4a0")
    assert credit_note.findtext(QName(NS.cbc, "IssueDate")) == "2018-09-13"
    assert credit_note.findtext(QName(NS.cbc, "IssueTime")) == "00:31:40"
    assert credit_note.findtext(QName(NS.cbc, "DocumentCurrencyCode")) == "COP"

    schema.assertValid(credit_note)


def test_compose_no_uuid(composer, data_dict, schema):
    data_dict.pop('uuid')
    credit_note = composer.compose(data_dict)
    schema.assertValid(credit_note)
