import io
from pytest import fixture, mark
from lxml.etree import QName, fromstring, tostring
from facturark.namespaces import NS
from facturark.composers import InvoiceComposer
from facturark.resolver import resolve_invoice_composer


@fixture
def composer():
    return resolve_invoice_composer()


@fixture
def data_dict():
    return {
        'extensions': [{
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
        }, {
            'extension_content': {}
        }],
        "id": "F0001",
        "issue_date": "2018-09-13",
        "issue_time": "00:31:40",
        "invoice_type_code": 1,
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
                'party_tax_schemes': [{
                    'tax_level_code': '0'
                }],
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
                'party_tax_schemes': [{
                    'tax_level_code': '0'
                }],
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
                    "#text": "8934000.00"
                },
                "tax_evidence_indicator": "false",
                "tax_subtotal": {
                    "percent": "19.00",
                    "taxable_amount": {
                        "@attributes": {
                            "currencyID": "COP"
                        },
                        "#text": "11345892.00"
                    },
                    "tax_amount": {
                        "@attributes": {
                            "currencyID": "COP"
                        },
                        "#text": "2155719.48"
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
        "invoice_lines": [
            {
                'id': '1',
                'invoiced_quantity': '99',
                'line_extension_amount': {
                    '@attributes': {'currencyID': 'COP'},
                    '#text': "9876000.00"
                },
                'item': {
                    'description': "Line 1"
                },
                'price': {
                    'price_amount': {
                        '@attributes': {'currencyID': 'COP'},
                        '#text': "567.00"
                    }
                }
            }
        ]
    }


def test_compose(composer, data_dict, schema):
    invoice = composer.compose(data_dict)

    assert invoice.prefix == "fe"
    assert invoice.tag == QName(NS.fe, "Invoice").text
    assert invoice.findtext(QName(NS.cbc, "UBLVersionID")) == "UBL 2.0"
    assert invoice.findtext(QName(NS.cbc, "ProfileID")) == "DIAN 1.0"
    assert invoice.findtext(QName(NS.cbc, "ID")) == "F0001"
    assert invoice.findtext(QName(NS.cbc, "UUID")) == 'PLACEHOLDER'
    assert invoice.findtext(QName(NS.cbc, "IssueDate")) == "2018-09-13"
    assert invoice.findtext(QName(NS.cbc, "IssueTime")) == "00:31:40"
    assert invoice.findtext(QName(NS.cbc, "InvoiceTypeCode")) == "1"
    assert invoice.findtext(QName(NS.cbc, "DocumentCurrencyCode")) == "COP"

    schema.assertValid(invoice)
