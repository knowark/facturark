from ..utils import parse_xsd


class Validator:

    def __init__(self, reviewer, xsd_file="XSD/DIAN/DIAN_UBL.xsd"):
        self.schema = parse_xsd(xsd_file)
        self.reviewer = reviewer

    def validate(self, element):
        self.schema.assertValid(element)
        self.reviewer.review(element)
        return element
