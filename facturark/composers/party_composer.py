from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .composer import Composer


class PartyComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

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
