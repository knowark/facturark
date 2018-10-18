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
<<<<<<< HEAD
                        'department': u'Valle',
                        'city_name': u'Cali',
=======
                        'department': 'Valle',
                        'city_name': 'Cali',
>>>>>>> 6dfa19e9e6248f4a1e8dd6e1fb044c73e17d376a
                        'country': {
                            'identification_code': 'CO'
                        }
                    }
                }
            }
        },
        "accounting_customer_party": {
<<<<<<< HEAD
            'additional_account_id': 1,
=======
            'additional_account_id': "1",
>>>>>>> 6dfa19e9e6248f4a1e8dd6e1fb044c73e17d376a
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
<<<<<<< HEAD
                        'department': u'Valle',
                        'city_name': u'Cali',
=======
                        'department': 'Valle',
                        'city_name': 'Cali',
>>>>>>> 6dfa19e9e6248f4a1e8dd6e1fb044c73e17d376a
                        'country': {
                            'identification_code': 'CO'
                        }
                    }
                }
            }
        },
<<<<<<< HEAD
        "legal_monetary_total": {
            'line_extension_amount': {
                '@attributes': {'currencyID': 'COP'},
                '#text': 888888
            },
            'tax_exclusive_amount': {
                '@attributes': {'currencyID': 'COP'},
                '#text': 55555
            },
            'payable_amount': {
                '@attributes': {'currencyID': 'COP'},
                '#text': 4444
=======
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
>>>>>>> 6dfa19e9e6248f4a1e8dd6e1fb044c73e17d376a
            }
        },
        "invoice_lines": [
            {
                'id': '1',
                'invoiced_quantity': '99',
                'line_extension_amount': {
                    '@attributes': {'currencyID': 'COP'},
<<<<<<< HEAD
                    '#text': 9876000
=======
                    '#text': "9876000.00"
>>>>>>> 6dfa19e9e6248f4a1e8dd6e1fb044c73e17d376a
                },
                'item': {
                    'description': "Line 1"
                },
                'price': {
                    'price_amount': {
                        '@attributes': {'currencyID': 'COP'},
<<<<<<< HEAD
                        '#text': 567
=======
                        '#text': "567.00"
>>>>>>> 6dfa19e9e6248f4a1e8dd6e1fb044c73e17d376a
                    }
                }
            }
        ]
    }
