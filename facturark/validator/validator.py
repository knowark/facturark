from ..utils import parse_xsd


class Validator:

    def __init__(self, reviewer):
        self.schema = parse_xsd(
            'XSD/DIAN/V18/XSD/DIAN_UBL21_Compiled.xsd')
        self.reviewer = reviewer

    def validate(self, element):
        self.schema.assertValid(element)
        self.reviewer.review(element)
        return element
