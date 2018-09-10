from facturark.models import Invoice


def test_invoice_creation():
    invoice = Invoice()

    assert invoice
