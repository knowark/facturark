from pytest import fixture
from lxml.etree import QName
from facturark.namespaces import NS
from facturark.composers import DebitNoteLineComposer, AmountComposer


@fixture
def composer():
    amount_composer = AmountComposer()
    return DebitNoteLineComposer(amount_composer)


@fixture
def data_dict():
    return {
        'id': '1',
        'line_extension_amount': {
            '@attributes': {'currencyID': 'COP'},
            '#text': 3456788
        }
    }


def test_compose(composer, data_dict, schema):
    debit_note_line = composer.compose(data_dict)

    assert debit_note_line.tag == QName(NS.cac, "DebitNoteLine").text
    assert debit_note_line.findtext(QName(NS.cbc, 'ID')) == '1'

    schema.assertValid(debit_note_line)
