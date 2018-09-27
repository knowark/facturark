from lxml.etree import Element, SubElement, QName, tostring
from facturark.utils import make_child
from .namespaces import NS
from .composer import Composer


class SignatureComposer(Composer):

    def __init__(self, signed_info_composer):
        self.signed_info_composer = signed_info_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.ds, root_name), nsmap=vars(NS))

        root.append(self.signed_info_composer.compose(
            data_dict['signed_info']))

        signature_value_dict = data_dict['signature_value']
        make_child(root, QName(NS.ds, 'SignatureValue'),
                   signature_value_dict.get('#text'),
                   attributes=signature_value_dict.get('@attributes'))

        return root
