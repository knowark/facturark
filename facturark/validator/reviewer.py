from .values import INVOICE_TYPES


class Reviewer:

    def __init__(self, analyzer):
        self.analyzer = analyzer

    @staticmethod
    def check(valid_values, value, message=''):
        if value not in valid_values:
            raise ValueError(message)

    def review(self, element):
        return True
