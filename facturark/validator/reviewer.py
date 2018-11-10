from .values import INVOICE_TYPES


class Reviewer:

    def __init__(self, analyzer):
        self.analyzer = analyzer

    def review(self, element):
        pass
