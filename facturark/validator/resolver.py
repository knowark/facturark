from .validator import Validator
from .invoice_validator import InvoiceValidator
from ..analyzer import Analyzer
from .reviewer import Reviewer


def resolve_validator(kind='invoice'):
    analyzer = Analyzer()
    reviewer = Reviewer(analyzer)
    if kind == 'invoice':
        return InvoiceValidator(reviewer)
    elif kind == 'credit_note':
        return Validator(reviewer)
    else:
        return Validator(reviewer)
