from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS


class PriceComposer:

    def compose(self, data_dict):
        root = Element(
            QName(NS.fe, "Price"), nsmap=vars(NS))

        SubElement(root, QName(
            NS.cbc, "PriceAmount"),
            currencyID=data_dict['price_amount']['@currency_id']).text = str(
                float(data_dict['price_amount']['#text']))

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
