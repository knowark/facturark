from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS


class PriceComposer:

    def compose(self, data_dict, root_name='Price'):
        root = Element(
            QName(NS.fe, root_name), nsmap=vars(NS))

        SubElement(root, QName(
            NS.cbc, "PriceAmount"),
            currencyID=data_dict['price_amount']['@currency_id']).text = str(
                float(data_dict['price_amount']['#text']))

        return root

    def serialize(self, data_dict, root_name='Price'):
        root = self.compose(data_dict, root_name)
        document = tostring(root,
                            method='xml',
                            encoding='utf-8',
                            pretty_print=True,
                            xml_declaration=True)
        return document
