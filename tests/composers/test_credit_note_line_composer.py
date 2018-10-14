from pytest import fixture
from lxml.etree import QName
from facturark.namespaces import NS
from facturark.composers import AmountComposer, CreditNoteLineComposer


@fixture
def composer():
    amount_composer = AmountComposer()
    return CreditNoteLineComposer(amount_composer)


@fixture
def data_dict():
    return {
        'id': '1'
    }


def test_compose(composer, data_dict, schema):
    credit_note_line = composer.compose(data_dict)

    assert credit_note_line.tag == QName(NS.cac, "CreditNoteLine").text
    assert credit_note_line.findtext(QName(NS.cbc, 'ID')) == '1'

    schema.assertValid(credit_note_line)
