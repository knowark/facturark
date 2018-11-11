from .values import INVOICE_TYPES, PARTY_TYPES


class Reviewer:

    def __init__(self, analyzer):
        self.analyzer = analyzer

    @staticmethod
    def check(valid_values, value, message=''):
        if value not in valid_values:
            raise ValueError(message)

    def review(self, element):

        return True

    # def _review_supplier_type(self, element):
    #     value = self.analyzer.ge
    #     self.check(PARTY_TYPES, value)
