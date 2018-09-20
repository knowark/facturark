from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class ItemComposer(Composer):

    def compose(self, data_dict, root_name='Item'):
        root = Element(
            QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'Description'),
                   data_dict.get('description'), required=False)

        return root
