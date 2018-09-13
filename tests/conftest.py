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
        "uuid": "3f7437b3-e473-41fe-9688-46cfba73584f",
        "issue_date": "2018-09-13",
        "issue_time": "00:31:40",
    }
    return invoice_dict
