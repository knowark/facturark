from lxml import etree, objectify
from .namespaces import NS


class InvoiceSerializer:

    def assemble(self, data_dict):
        root = objectify.Element("Invoice")
        root.UBLVersionID = "UBL 2.0"

        objectify.deannotate(
            root, xsi_nil=True, cleanup_namespaces=True)

        return root

    def serialize(self, data_dict):
        root = self.assemble(data_dict)
        document = etree.tostring(root,
                                  method='xml',
                                  encoding='utf-8',
                                  pretty_print=True,
                                  xml_declaration=True)
        return document
