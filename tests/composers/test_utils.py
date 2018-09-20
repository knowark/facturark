from pytest import raises
from lxml.etree import fromstring, tostring
from facturark.composers.utils import make_child


def test_create_child():
    parent = fromstring('<Root></Root>')
    tag = 'Child'
    text = 'Papa!'
    attributes = {'id': '123', 'color': 'yellow'}

    child = make_child(parent, tag, text, attributes)

    assert child.tag == tag
    assert child.attrib == attributes
    assert child.text == text


def test_create_child_required_missing():
    parent = fromstring('<Root></Root>')
    tag = 'Child'

    with raises(ValueError):
        child = make_child(parent, tag)


def test_create_child_empty():
    parent = fromstring('<Root></Root>')
    tag = 'Child'
    text = 'Fail!'

    child = make_child(parent, tag, empty=True)
    assert child is not None


def test_create_child_empty_with_values():
    parent = fromstring('<Root></Root>')
    tag = 'Child'
    text = 'Fail!'

    with raises(ValueError):
        child = make_child(parent, tag, text, empty=True)
