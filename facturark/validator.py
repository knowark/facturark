from .utils import parse_xsd


class Validator:

    def __init__(self):
        self.schema = parse_xsd("XSD/DIAN/DIAN_UBL.xsd")

    def validate(self, element):
        self.schema.assertValid(element)
