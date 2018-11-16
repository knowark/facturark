from .values import (INVOICE_TYPES, IDENTITY_DOCUMENT_TYPES, PARTY_TYPES,
                     COUNTRIES, CURRENCIES, TAX_LEVELS, TAX_TYPES)


class Reviewer:

    def __init__(self, analyzer):
        self.analyzer = analyzer

    @staticmethod
    def check(valid_values, value, message=''):
        message = message or 'Invalid Value: {}'.format(value)
        if value not in valid_values:
            raise ValueError(message)

    @staticmethod
    def check_lower(upper_limit, value, message=''):
        message = message or (
            'Value ({}) exceeds upper limit {}.'.format(value, upper_limit))
        if value > upper_limit:
            raise ValueError(message)

    def review(self, element):
        self._review_id(element)
        self._review_supplier_type(element)
        self._review_customer_type(element)
        self._review_supplier_country(element)
        self._review_customer_country(element)
        self._review_document_currency(element)
        self._review_invoice_type(element)
        self._review_supplier_identification_type(element)
        self._review_customer_identification_type(element)
        self._review_supplier_tax_scheme(element)
        self._review_customer_tax_scheme(element)
        self._review_tax_total(element)
        self._review_tax_types(element)
        self._review_taxable_amounts(element)
        self._review_tax_amounts(element)
        self._review_supplier_id(element)
        self._review_customer_id(element)
        self._review_total_line_extension_amount(element)
        self._review_total_tax_exclusive_amount(element)
        self._review_total_payable_amount(element)
        self._review_software_id(element)
        self._review_software_provider_id(element)
        self._review_invoice_authorization(element)
        self._review_prefix(element)
        return True

    def _review_id(self, element):
        value = self.analyzer.get_id(element)
        self.check_lower(35, len(value))

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

    def _review_supplier_identification_type(self, element):
        value = self.analyzer.get_supplier_identification_type(element)
        self.check(IDENTITY_DOCUMENT_TYPES, value)

    def _review_customer_identification_type(self, element):
        value = self.analyzer.get_customer_identification_type(element)
        self.check(IDENTITY_DOCUMENT_TYPES, value)

    def _review_supplier_tax_scheme(self, element):
        value = self.analyzer.get_supplier_tax_scheme(element)
        self.check(TAX_LEVELS, value)

    def _review_customer_tax_scheme(self, element):
        value = self.analyzer.get_customer_tax_scheme(element)
        self.check(TAX_LEVELS, value)

    def _review_tax_total(self, element):
        values = self.analyzer.get_tax_total_amounts(element)
        for value in values:
            value = value if "." in value else value + ".0"
            integers, decimals = value.split('.')
            self.check_lower(14, len(integers))
            self.check_lower(4, len(decimals))

    def _review_tax_types(self, element):
        values = self.analyzer.get_tax_types(element)
        for value in values:
            self.check(TAX_TYPES, value)

    def _review_taxable_amounts(self, element):
        values = self.analyzer.get_taxable_amount(element)
        for value in values:
            value = value if "." in value else value + ".0"
            integers, decimals = value.split('.')
            self.check_lower(14, len(integers))
            self.check_lower(4, len(decimals))

    def _review_tax_amounts(self, element):
        values = self.analyzer.get_tax_amount(element)
        for value in values:
            value = value if "." in value else value + ".0"
            integers, decimals = value.split('.')
            self.check_lower(14, len(integers))
            self.check_lower(4, len(decimals))

    def _review_supplier_id(self, element):
        value = self.analyzer.get_supplier_id(element)
        self.check_lower(35, len(value))

    def _review_customer_id(self, element):
        value = self.analyzer.get_customer_id(element)
        self.check_lower(35, len(value))

    def _review_total_line_extension_amount(self, element):
        value = self.analyzer.get_total_line_extension_amount(element)
        self.check_lower(35, len(value))

    def _review_total_tax_exclusive_amount(self, element):
        value = self.analyzer.get_total_tax_exclusive_amount(element)
        self.check_lower(35, len(value))

    def _review_total_payable_amount(self, element):
        value = self.analyzer.get_total_payable_amount(element)
        self.check_lower(35, len(value))

    def _review_software_id(self, element):
        value = self.analyzer.get_software_id(element)
        self.check_lower(50, len(value))

    def _review_software_provider_id(self, element):
        value = self.analyzer.get_software_provider_id(element)
        self.check_lower(100, len(value))

    def _review_invoice_authorization(self, element):
        value = self.analyzer.get_invoice_authorization(element)
        if value is not None:
            self.check_lower(16, len(value))

    def _review_prefix(self, element):
        value = self.analyzer.get_prefix(element)
        if value is not None:
            self.check_lower(5, len(value))
