from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .utils import make_child


class ItemComposer:

    def compose(self, data_dict, root_name='Item'):
        root = Element(
            QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'Description'),
                   data_dict.get('description'), required=False)

        return root

    def serialize(self, data_dict, root_name='Item'):
        root = self.compose(data_dict, root_name)
        document = tostring(root,
                            method='xml',
                            encoding='utf-8',
                            pretty_print=True,
                            xml_declaration=True)
        return document
