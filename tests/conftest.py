from pytest import fixture
from facturark.models import Invoice


@fixture
def invoice():
    invoice = Invoice(**{
        "type": "invoice"
    })

    return invoice


@fixture
def invoice_dict():
    invoice_dict = {
        "id": "F0001",
        "uuid": "a3d6c86a71cbc066aaa19fd363c0fe4b5778d4a0",
        "issue_date": "2018-09-13",
        "issue_time": "00:31:40",
    }
    return invoice_dict
