from .values import INVOICE_TYPES, PARTY_TYPES, COUNTRIES, CURRENCIES


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
        self._review_supplier_country(element)
        self._review_customer_country(element)
        self._review_document_currency(element)
        self._review_invoice_type(element)
        return True

    def _review_supplier_type(self, element):
        value = self.analyzer.get_supplier_type(element)
        self.check(PARTY_TYPES, value)

    def _review_customer_type(self, element):
        value = self.analyzer.get_customer_type(element)
        self.check(PARTY_TYPES, value)

    def _review_supplier_country(self, element):
        value = self.analyzer.get_supplier_country(element)
        self.check(COUNTRIES, value)

    def _review_customer_country(self, element):
        value = self.analyzer.get_customer_country(element)
        self.check(COUNTRIES, value)

    def _review_document_currency(self, element):
        value = self.analyzer.get_document_currency(element)
        self.check(CURRENCIES, value)

    def _review_invoice_type(self, element):
        value = self.analyzer.get_invoice_type(element)
        if value is not None:
            self.check(INVOICE_TYPES, value)
