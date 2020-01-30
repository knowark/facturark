from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class PartyLegalEntityComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cac, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'RegistrationName'),
                   data_dict['registration_name'])

        return root
