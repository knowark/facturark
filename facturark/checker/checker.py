from ..utils import parse_schematron


class Checker:

    def __init__(self):
        self.schema = parse_schematron(
            'XSD/DIAN/V18/Schemes/DIAN-UBL21-model.sch')

    def check(self, element):
        self.schema.assertValid(element)
        self.reviewer.review(element)
        return element
