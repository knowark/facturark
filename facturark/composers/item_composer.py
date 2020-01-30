from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class ItemComposer(Composer):

    def compose(self, data_dict, root_name='Item'):
        root = Element(
            QName(NS.cac, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'Description'),
                   data_dict.get('description'), required=False)

        return root
