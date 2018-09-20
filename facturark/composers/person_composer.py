from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .utils import make_child


class PersonComposer:

    def compose(self, data_dict, root_name='Person'):
        root = Element(
            QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'FirstName'),
                   data_dict.get('first_name'))
        make_child(root, QName(NS.cbc, 'FamilyName'),
                   data_dict.get('family_name'))

        return root

    def serialize(self, data_dict, root_name='Item'):
        root = self.compose(data_dict, root_name)
        document = tostring(root,
                            method='xml',
                            encoding='utf-8',
                            pretty_print=True,
                            xml_declaration=True)
        return document
