from .validator import Validator
from ..analyzer import Analyzer
from .uuid_generator import InvoiceUuidGenerator
from .reviewer import Reviewer


def resolve_validator(technical_key):
    uuid_generator = InvoiceUuidGenerator(technical_key)
    analyzer = Analyzer()
    reviewer = Reviewer(analyzer)
    return Validator(uuid_generator, reviewer)
