import os
import json
from datetime import datetime
from pytest import raises
from lxml import etree
from lxml.etree import parse, fromstring, tostring, XMLSchema
from facturark.utils import parse_xsd, make_child, json_serialize, read_asset


def test_xsd_parser_parse():
    xschema = parse_xsd("XSD/DIAN/DIAN_UBL.xsd")
    assert isinstance(xschema, XMLSchema)


def test_xsd_parser_validate_correct_invoice():
    xschema = parse_xsd("XSD/DIAN/DIAN_UBL.xsd")
    directory = os.path.dirname(os.path.realpath(__file__))
    doc = parse(os.path.join(directory, "data/signed_invoice.xml"))
    assert xschema.validate(doc)


def test_read_asset():
    policy = read_asset('politicadefirmav2.pdf')
    assert isinstance(policy, bytes)


def test_make_child():
    parent = fromstring('<Root></Root>')
    tag = 'Child'
    text = 'Papa!'
    attributes = {'id': '123', 'color': 'yellow'}

    child = make_child(parent, tag, text, attributes)

    assert child.tag == tag
    assert child.attrib == attributes
    assert child.text == text


def test_make_child_none():
    parent = fromstring('<Root></Root>')
    tag = 'Child'

    child = make_child(parent, tag, required=False)

    assert child is None


def test_make_child_required_missing():
    parent = fromstring('<Root></Root>')
    tag = 'Child'

    with raises(ValueError):
        child = make_child(parent, tag)


def test_make_child_empty():
    parent = fromstring('<Root></Root>')
    tag = 'Child'
    text = 'Fail!'

    child = make_child(parent, tag, empty=True)
    assert child is not None


def test_make_child_empty_with_values():
    parent = fromstring('<Root></Root>')
    tag = 'Child'
    text = 'Fail!'

    with raises(ValueError):
        child = make_child(parent, tag, text, empty=True)


def test_json_serial():
    data_dict = {'datetime': datetime(2020, 5, 17)}
    result = json.dumps(data_dict, default=json_serialize)
    assert '2020-05-17' in result
    with raises(TypeError):
        class Data:
            pass
        json.dumps(Data(), default=json_serialize)
