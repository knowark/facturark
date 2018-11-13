from ..utils import parse_xsd


class Validator:

    def __init__(self, uuid_generator, reviewer):
        self.schema = parse_xsd("XSD/DIAN/DIAN_UBL.xsd")
        self.uuid_generator = uuid_generator
        self.reviewer = reviewer

    def validate(self, element):
        element, uuid = self.uuid_generator.generate(element)
        self.schema.assertValid(element)
        self.reviewer.review(element)
        return element, uuid
