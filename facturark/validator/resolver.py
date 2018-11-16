from .validator import Validator
from ..analyzer import Analyzer
from .reviewer import Reviewer


def resolve_validator():
    analyzer = Analyzer()
    reviewer = Reviewer(analyzer)
    return Validator(reviewer)
