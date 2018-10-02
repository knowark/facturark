from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from .namespaces import NS
from .composer import Composer


class PersonComposer(Composer):

    def compose(self, data_dict, root_name='Person'):
        root = Element(
            QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'FirstName'),
                   data_dict.get('first_name'))
        make_child(root, QName(NS.cbc, 'FamilyName'),
                   data_dict.get('family_name'))

        return root
