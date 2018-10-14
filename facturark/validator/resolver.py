from .validator import Validator
from .uuid_generator import InvoiceUuidGenerator


def resolve_validator(technical_key):
    uuid_generator = InvoiceUuidGenerator(technical_key)
    return Validator(uuid_generator)
