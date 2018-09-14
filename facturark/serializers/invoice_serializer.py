from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS


class InvoiceSerializer:

    def assemble(self, data_dict):
        root = Element(
            QName(NS.fe, "Invoice"), nsmap=vars(NS))

        SubElement(root,
                   QName(NS.cbc, "UBLVersionID")).text = "UBL 2.0"
        SubElement(root,
                   QName(NS.cbc, "ProfileID")).text = "DIAN 1.0"
        SubElement(root,
                   QName(NS.cbc, "ID")).text = data_dict['id']

        return root

    def serialize(self, data_dict):
        root = self.assemble(data_dict)
        document = tostring(root,
                            method='xml',
                            encoding='utf-8',
                            pretty_print=True,
                            xml_declaration=True)
        return document
