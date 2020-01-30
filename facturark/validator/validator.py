from ..utils import parse_xsd


class Validator:

    def __init__(self, reviewer):
        self.schema = parse_xsd("XSD/DIAN/DIAN_UBL.xsd")
        self.reviewer = reviewer

    def validate(self, element):
        self.schema.assertValid(element)
        self.reviewer.review(element)
        return element
