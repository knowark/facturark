from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class BillingReferenceComposer(Composer):

    def __init__(self, amount_composer):
        self.amount_composer = amount_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cac, root_name), nsmap=vars(NS))

        invoice_document_reference_dict = data_dict.get(
            'invoice_document_reference')
        if invoice_document_reference_dict:
            invoice_document_reference = make_child(
                root, QName(NS.cac, "InvoiceDocumentReference"), empty=True)

            make_child(invoice_document_reference, QName(NS.cbc, "ID"),
                       invoice_document_reference_dict['id'])
            make_child(invoice_document_reference, QName(NS.cbc, "UUID"),
                       invoice_document_reference_dict['uuid'])
            make_child(invoice_document_reference,
                       QName(NS.cbc, "IssueDate"),
                       invoice_document_reference_dict['issue_date'])

        additional_document_reference_dict = data_dict.get(
            'additional_document_reference')
        if additional_document_reference_dict:
            additional_document_reference = make_child(
                root, QName(NS.cac, "AdditionalDocumentReference"), empty=True)

            make_child(additional_document_reference, QName(NS.cbc, "ID"),
                       additional_document_reference_dict['id'])
            make_child(additional_document_reference,
                       QName(NS.cbc, "IssueDate"),
                       additional_document_reference_dict['issue_date'])
            make_child(additional_document_reference,
                       QName(NS.cbc, "DocumentType"),
                       additional_document_reference_dict['document_type'])
            make_child(additional_document_reference,
                       QName(NS.cbc, "XPath"), empty=True)
            make_child(additional_document_reference,
                       QName(NS.cac, "Attachment"), empty=True)

        billing_reference_line_dict = data_dict.get('billing_reference_line')
        if billing_reference_line_dict:
            billing_reference_line = make_child(
                root, QName(NS.cac, "BillingReferenceLine"), empty=True)
            make_child(billing_reference_line,
                       QName(NS.cbc, "ID"), empty=True)
            billing_reference_line.append(
                self.amount_composer.compose(
                    billing_reference_line_dict['amount'], 'Amount'))

        return root
