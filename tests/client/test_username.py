from lxml.etree import fromstring, tostring
from facturark.client.username import UsernameToken


def test_username_token_apply():
    envelope = fromstring('<Envelope></Envelope>')
    headers = {}

    username = UsernameToken("USER", "PASS")
    envelope, headers = username.apply(envelope, headers)

    assert envelope is not None
    assert b'USER' in tostring(envelope)


def test_username_token_verify():
    envelope = fromstring('<Envelope></Envelope>')
    username = UsernameToken("USER", "PASS")

    result = username.verify(envelope)

    assert result is None
