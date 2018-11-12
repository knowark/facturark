from .values import INVOICE_TYPES, PARTY_TYPES


class Reviewer:

    def __init__(self, analyzer):
        self.analyzer = analyzer

    @staticmethod
    def check(valid_values, value, message=''):
        if value not in valid_values:
            raise ValueError(message)

    def review(self, element):
        self._review_supplier_type(element)
        self._review_customer_type(element)
        return True

    def _review_supplier_type(self, element):
        value = self.analyzer.get_supplier_type(element)
        self.check(PARTY_TYPES, value)

    def _review_customer_type(self, element):
        value = self.analyzer.get_customer_type(element)
        self.check(PARTY_TYPES, value)
