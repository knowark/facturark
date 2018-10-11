from lxml.etree import Element, SubElement, QName, tostring
from ....utils import make_child
from ..namespaces import NS
from ..composer import Composer


class SignedSignaturePropertiesComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.xades, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.xades, "SigningTime"),
                   data_dict['signing_time'])

        return root
