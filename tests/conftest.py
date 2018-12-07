# -*- coding: utf-8 -*-

import os
import io
from pytest import fixture


@fixture
def invoice_dict():
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
        "invoice_type_code": "1",
        "document_currency_code": "COP",
        "accounting_supplier_party": {
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


@fixture
def signed_document_sha512():
    filename = 'signed_invoice_sha512.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    filepath = os.path.join(directory, 'data', filename)
    with io.open(filepath, 'rb') as f:
        return f.read()


@fixture
def credit_note_dict():
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
                        u"document_type": "Decisión de la JD",
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
                        u"El sistema de la DIAN señaló "
                        u"que la firma digital está fallida")
                }
            }
        ]
    }


@fixture
def debit_note_dict():
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
        "debit_note_lines": [
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
