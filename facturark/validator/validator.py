from ..utils import parse_xsd


class Validator:

    def __init__(self, uuid_generator):
        self.schema = parse_xsd("XSD/DIAN/DIAN_UBL.xsd")
        self.uuid_generator = uuid_generator

    def validate(self, element):
        element, uuid = self.uuid_generator.generate(element)
        self.schema.assertValid(element)
        return element, uuid
