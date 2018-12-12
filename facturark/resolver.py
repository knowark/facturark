from .identifier import InvoiceIdentifier, BlankIdentifier
from .composers import (
    AmountComposer, ItemComposer, PriceComposer, PartyTaxSchemeComposer,
    PartyLegalEntityComposer, PersonComposer, AddressComposer,
    LocationComposer, PartyComposer, DespatchComposer, DeliveryComposer,
    CustomerPartyComposer, SupplierPartyComposer, TaxSubtotalComposer,
    TaxTotalComposer, PaymentComposer, AllowanceChargeComposer,
    DeliveryTermsComposer, MonetaryTotalComposer, ExtensionComposer,
    InvoiceComposer, InvoiceLineComposer, CreditNoteComposer,
    CreditNoteLineComposer, DebitNoteComposer, DebitNoteLineComposer,
    DianExtensionsComposer, BillingReferenceComposer)


def resolve_extensions_composer():
    dian_extensions_composer = DianExtensionsComposer()
    return ExtensionComposer(dian_extensions_composer)


def resolve_invoice_line_composer(document_currency_code):
    amount_composer_doc_curr = AmountComposer(document_currency_code)
    item_composer = ItemComposer()
    price_composer = PriceComposer(amount_composer_doc_curr)
    return InvoiceLineComposer(
        amount_composer, item_composer, price_composer)


def resolve_party_composer():
    party_tax_scheme_composer = PartyTaxSchemeComposer()
    party_legal_entity_composer = PartyLegalEntityComposer()
    person_composer = PersonComposer()
    address_composer = AddressComposer()
    location_composer = LocationComposer(address_composer)
    return PartyComposer(
        party_tax_scheme_composer, party_legal_entity_composer,
        person_composer, location_composer)


def resolve_despatch_composer():
    party_tax_scheme_composer = PartyTaxSchemeComposer()
    party_legal_entity_composer = PartyLegalEntityComposer()
    person_composer = PersonComposer()
    address_composer = AddressComposer()
    location_composer = LocationComposer(address_composer)
    party_composer = PartyComposer(
        party_tax_scheme_composer, party_legal_entity_composer,
        person_composer, location_composer)
    return DespatchComposer(address_composer, party_composer)


def resolve_delivery_composer():
    party_tax_scheme_composer = PartyTaxSchemeComposer()
    party_legal_entity_composer = PartyLegalEntityComposer()
    person_composer = PersonComposer()
    address_composer = AddressComposer()
    location_composer = LocationComposer(address_composer)
    party_composer = PartyComposer(
        party_tax_scheme_composer, party_legal_entity_composer,
        person_composer, location_composer)
    despatch_composer = DespatchComposer(address_composer, party_composer)
    return DeliveryComposer(address_composer, location_composer,
                            party_composer, despatch_composer)


def resolve_customer_party_composer():
    party_composer = resolve_party_composer()
    return CustomerPartyComposer(party_composer)


def resolve_supplier_party_composer():
    party_composer = resolve_party_composer()
    return SupplierPartyComposer(party_composer)


def resolve_tax_total_composer(document_currency_code):
    amount_composer_doc_curr = AmountComposer(document_currency_code)
    tax_subtotal_composer = TaxSubtotalComposer(amount_composer_doc_curr)
    return TaxTotalComposer(amount_composer_doc_curr, tax_subtotal_composer)


def resolve_invoice_composer(document_currency_code):
    amount_composer_cop = AmountComposer()
    amount_composer_doc_curr = AmountComposer(document_currency_code)
    extension_composer = resolve_extensions_composer()
    invoice_line_composer = resolve_invoice_line_composer(document_currency_code)
    monetary_total_composer = MonetaryTotalComposer(amount_composer_cop)
    customer_party_composer = resolve_customer_party_composer()
    supplier_party_composer = resolve_supplier_party_composer()
    payment_composer = PaymentComposer(amount_composer_doc_curr)
    tax_total_composer = resolve_tax_total_composer(document_currency_code)
    delivery_composer = resolve_delivery_composer()
    allowance_charge_composer = AllowanceChargeComposer(amount_composer_doc_curr)
    delivery_terms_composer = DeliveryTermsComposer()
    return InvoiceComposer(
        extension_composer, supplier_party_composer, customer_party_composer,
        delivery_composer, delivery_terms_composer, payment_composer,
        allowance_charge_composer, tax_total_composer, monetary_total_composer,
        invoice_line_composer)


def resolve_billing_reference_composer():
    amount_composer_doc_curr = AmountComposer(document_currency_code)
    return BillingReferenceComposer(amount_composer_doc_curr)


def resolve_credit_note_composer(document_currency_code):
    amount_composer_cop = AmountComposer()
    amount_composer_doc_curr = AmountComposer(document_currency_code)
    extension_composer = resolve_extensions_composer()
    billing_reference_composer = resolve_billing_reference_composer(document_currency_code)
    credit_note_line_composer = CreditNoteLineComposer(
        amount_composer_doc_curr, billing_reference_composer)
    monetary_total_composer = MonetaryTotalComposer(amount_composer_cop)
    customer_party_composer = resolve_customer_party_composer()
    supplier_party_composer = resolve_supplier_party_composer()
    payment_composer = PaymentComposer(amount_composer_doc_curr)
    tax_total_composer = resolve_tax_total_composer(document_currency_code)
    return CreditNoteComposer(
        extension_composer, supplier_party_composer, customer_party_composer,
        payment_composer, tax_total_composer, monetary_total_composer,
        credit_note_line_composer)


def resolve_debit_note_composer(document_currency_code):
    amount_composer_cop = AmountComposer()
    amount_composer_doc_curr = AmountComposer(document_currency_code)
    extension_composer = resolve_extensions_composer()
    billing_reference_composer = resolve_billing_reference_composer(document_currency_code)
    debit_note_line_composer = DebitNoteLineComposer(
        amount_composer_doc_curr, billing_reference_composer)
    monetary_total_composer = MonetaryTotalComposer(amount_composer_cop)
    customer_party_composer = resolve_customer_party_composer()
    supplier_party_composer = resolve_supplier_party_composer()
    payment_composer = PaymentComposer(amount_composer_doc_curr)
    tax_total_composer = resolve_tax_total_composer(document_currency_code)
    return DebitNoteComposer(
        extension_composer, supplier_party_composer, customer_party_composer,
        payment_composer, tax_total_composer, monetary_total_composer,
        debit_note_line_composer)


def resolve_composer(kind, document_currency_code):
    if kind == 'invoice':
        return resolve_invoice_composer(document_currency_code)
    elif kind == 'credit_note':
        return resolve_credit_note_composer(document_currency_code)
    else:
        return resolve_debit_note_composer(document_currency_code)


def resolve_identifier(kind, technical_key=None):
    if kind == 'invoice':
        return InvoiceIdentifier(technical_key)
    else:
        return BlankIdentifier()
