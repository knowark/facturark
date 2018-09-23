from pytest import fixture
from lxml.etree import QName
from facturark.composers import (
    NS, InvoiceLineComposer, PriceComposer, ItemComposer)
from facturark.resolver import resolve_invoice_line_composer


@fixture
def composer():
    return resolve_invoice_line_composer()


@fixture
def data_dict():
    return {
        'id': '1',
        'invoiced_quantity': '99',
        'line_extension_amount': {
            '@attributes': {'currencyID': 'COP'},
            '#text': 9876000
        },
        'item': {
            'description': "Line 1"
        },
        'price': {
            'price_amount': {
                '@attributes': {'currencyID': 'COP'},
                '#text': 567
            }
        }
    }


def test_compose(composer, data_dict, schema):
    invoice_line = composer.compose(data_dict)

    assert invoice_line.tag == QName(NS.fe, "InvoiceLine").text
    assert invoice_line.findtext(QName(NS.cbc, 'ID')) == '1'
    assert invoice_line.findtext(QName(NS.cbc, 'InvoicedQuantity')) == '99'

    line_extension_amount = invoice_line.find(
        QName(NS.cbc, "LineExtensionAmount"))
    assert float(line_extension_amount.text) == 9876000
    assert line_extension_amount.attrib['currencyID'] == 'COP'

    item = invoice_line.find(QName(NS.fe, 'Item'))
    assert item.findtext(QName(NS.cbc, 'Description')) == 'Line 1'

    price = invoice_line.find(QName(NS.fe, 'Price'))
    price_amount = price.find(QName(NS.cbc, "PriceAmount"))
    assert float(price_amount.text) == 567
    assert price_amount.attrib['currencyID'] == 'COP'

    schema.assertValid(invoice_line)
