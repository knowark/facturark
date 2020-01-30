from ..utils import parse_xsd
from .validator import Validator


class InvoiceValidator(Validator):
    def __init__(self, reviewer):
        super(InvoiceValidator, self).__init__(reviewer)
        self.schema = parse_xsd(
            'XSD/DIAN/V18/XSD/maindoc/UBL-Invoice-2.1.xsd')

    def validate(self, element):
        self.schema.assertValid(element)
        self.reviewer.review(element)
        return element
