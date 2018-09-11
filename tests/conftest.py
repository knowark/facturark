from pytest import fixture
from facturark.models import Invoice


@fixture
def invoice():
    invoice = Invoice(**{
        "type": "invoice"
    })

    return invoice
