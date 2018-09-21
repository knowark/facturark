from lxml.etree import Element, QName
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class PaymentComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        paid_amount = data_dict['paid_amount']
        make_child(root, QName(NS.cbc, 'PaidAmount'),
                   str(float(paid_amount['#text'])),
                   {'currencyID': paid_amount['@currency_id']})

        make_child(root, QName(NS.cbc, 'PaidDate'), data_dict['paid_date'])

        return root
