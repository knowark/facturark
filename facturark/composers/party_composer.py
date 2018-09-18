from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS


class PartyComposer:

    def compose(self, data_dict):
        root = Element(
            QName(NS.fe, "Party"), nsmap=vars(NS))

        party_identification = SubElement(
            root, QName(NS.cac, "PartyIdentification"))
        SubElement(
            party_identification,
            QName(NS.cbc, "ID")
        ).text = data_dict['party_identification']

        party_name = SubElement(
            root, QName(NS.cac, "PartyName"))
        SubElement(
            party_name,
            QName(NS.cbc, "Name")
        ).text = data_dict['party_name']

        return root

    def serialize(self, data_dict):
        root = self.compose(data_dict)
        document = tostring(root,
                            method='xml',
                            encoding='utf-8',
                            pretty_print=True,
                            xml_declaration=True)
        print("\nDOC\n")
        print(document)
        return document
