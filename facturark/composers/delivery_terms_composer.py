from lxml.etree import Element, QName
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class DeliveryTermsComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        return root
