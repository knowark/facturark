from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS


class InvoiceComposer:

    def compose(self, data_dict):
        root = Element(
            QName(NS.fe, "Invoice"), nsmap=vars(NS))

        SubElement(root,
                   QName(NS.cbc, "UBLVersionID")).text = "UBL 2.0"
        SubElement(root,
                   QName(NS.cbc, "ProfileID")).text = "DIAN 1.0"
        SubElement(root,
                   QName(NS.cbc, "ID")).text = data_dict['id']
        SubElement(root,
                   QName(NS.cbc, "UUID")).text = data_dict['uuid']
        SubElement(root,
                   QName(NS.cbc, "IssueDate")).text = data_dict['issue_date']
        SubElement(root,
                   QName(NS.cbc, "IssueTime")).text = data_dict['issue_time']
        SubElement(root,
                   QName(NS.cbc, "InvoiceTypeCode")).text = data_dict.get(
                       'invoice_type_code', '1')
        SubElement(root,
                   QName(NS.cbc, "DocumentCurrencyCode")).text = data_dict.get(
                       'document_currency_code', 'COP')

        return root

    def serialize(self, data_dict):
        root = self.compose(data_dict)
        document = tostring(root,
                            method='xml',
                            encoding='utf-8',
                            pretty_print=True,
                            xml_declaration=True)
        return document
