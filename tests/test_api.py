import facturark


def test_api_build():
    invoice_dict = {}
    result = facturark.build(invoice_dict)
    assert result
