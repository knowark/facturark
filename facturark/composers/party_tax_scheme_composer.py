from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .utils import make_child


class PartyTaxSchemeComposer:

    def compose(self, data_dict, root_name='PartyTaxScheme'):
        root = Element(
            QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'TaxLevelCode'),
                   data_dict.get('tax_level_code'), required=False)
        make_child(root, QName(NS.cac, 'TaxScheme'),
                   required=False, empty=True)

        return root

    def serialize(self, data_dict, root_name='PartyTaxScheme'):
        root = self.compose(data_dict, root_name)
        document = tostring(root,
                            method='xml',
                            encoding='utf-8',
                            pretty_print=True,
                            xml_declaration=True)
        return document
