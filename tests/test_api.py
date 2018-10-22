import facturark


def test_api_build(invoice_dict, monkeypatch):
    with monkeypatch.context() as m:
        def mock_resolve_validator(invoice):
            class MockValidator:
                def validate(self, invoice):
                    return invoice, ""
            return MockValidator()
        m.setattr(facturark.api, "resolve_validator", mock_resolve_validator)

        result = facturark.build_invoice(invoice_dict)

        assert result is not None


def test_api_verify(signed_document_sha512, monkeypatch):
    result = facturark.verify_document(signed_document_sha512)
    assert result is True


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


def test_api_query(monkeypatch):
    query_dict = {
        "username": "USER",
        "password": "PASS",
        "wsdl_url": "tests/data/electronic_invoice.wsdl",
        "document_type": "1",
        "document_number": "PRUE34",
        "vat": "800191678",
        "creation_date": "2017-11-16T08:18:35",
        "software_identifier": "98fcc80b-9f61-4fe2-aac3-13570df4a9e3",
        "uuid": "98fcc80b-9f61-4fe2-aac3-13570df4a9e3"
    }

    with monkeypatch.context() as m:
        def mock_query(*args, **kwargs):
            return "<Response></Response>"

        m.setattr(facturark.client.Client, "query", mock_query)
        result = facturark.query_document(query_dict)
        assert result == "<Response></Response>"
