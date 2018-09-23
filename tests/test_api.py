import facturark


def test_api_build():
    invoice_dict = {}
    result = facturark.build_invoice(invoice_dict)
    assert result


def test_api_send(monkeypatch):
    request_dict = {
        "username": "USER",
        "password": "PASS",
        "wsdl_url": "tests/data/electronic_invoice.wsdl",
        "vat": "900XXXYYY",
        "invoice_number": "900000001",
        "issue_date": "2018-09-14T16:11:31",
        "document": "<Invoice></Invoice>"
    }
    with monkeypatch.context() as m:
        def mock_send(*args, **kwargs):
            return "<Response></Response>"

        m.setattr(facturark.client.Client, "send", mock_send)
        result = facturark.send_invoice(request_dict)
        assert result == "<Response></Response>"
