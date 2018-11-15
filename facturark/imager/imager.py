from io import BytesIO
from textwrap import dedent
from lxml.etree import fromstring
from qrcode import make


class Imager:
    def __init__(self, analyzer):
        self.analyzer = analyzer

    def qrcode(self,  document):
        document = fromstring(document)
        message_dict = {}
        message_dict['invoice_number'] = self.analyzer.get_id(document)
        invoice_date = self.analyzer.get_issue_date(document).replace(
            '-', '').replace(':', '').replace('T', '')
        message_dict['invoice_date'] = invoice_date
        message_dict['supplier_id'] = self.analyzer.get_supplier_id(document)
        message_dict['customer_id'] = self.analyzer.get_customer_id(document)
        message_dict['invoice_amount'] = (
            self.analyzer.get_total_line_extension_amount(document))
        message_dict['tax_vat_amount'] = (
            self.analyzer.get_tax_vat(document))
        tax_other = '{0:.2f}'.format(
            sum(float(value) for value in
                self.analyzer.get_tax_other(document)))
        message_dict['tax_other_amount'] = tax_other
        message_dict['total_amount'] = (
            self.analyzer.get_total_payable_amount(document))
        message_dict['uuid'] = self.analyzer.get_uuid(document)
        message = self._build_message(message_dict)
        return self._generate_image(message)

    def _build_message(self, message_dict):
        return dedent((
            """
        NumFac: {invoice_number}
        FecFac: {invoice_date}
        NitFac: {supplier_id}
        DocAdq: {customer_id}
        ValFac: {invoice_amount}
        ValIva: {tax_vat_amount}
        ValOtroIm: {tax_other_amount}
        ValFacIm: {total_amount}
        CUFE: {uuid}
            """
        ).format(**message_dict)).strip()

    def _generate_image(self, message):
        image = make(message)
        image_memory_file = BytesIO()
        image.save(image_memory_file, format='PNG')
        return image_memory_file.getvalue()
