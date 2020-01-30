from . import (
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


def resolve_invoice_line_composer():
    amount_composer = AmountComposer()
    item_composer = ItemComposer()
    price_composer = PriceComposer(amount_composer)
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


def resolve_tax_total_composer():
    amount_composer = AmountComposer()
    tax_subtotal_composer = TaxSubtotalComposer(amount_composer)
    return TaxTotalComposer(amount_composer, tax_subtotal_composer)


def resolve_invoice_composer():
    amount_composer = AmountComposer()
    extension_composer = resolve_extensions_composer()
    invoice_line_composer = resolve_invoice_line_composer()
    monetary_total_composer = MonetaryTotalComposer(amount_composer)
    customer_party_composer = resolve_customer_party_composer()
    supplier_party_composer = resolve_supplier_party_composer()
    payment_composer = PaymentComposer(amount_composer)
    tax_total_composer = resolve_tax_total_composer()
    delivery_composer = resolve_delivery_composer()
    allowance_charge_composer = AllowanceChargeComposer(amount_composer)
    delivery_terms_composer = DeliveryTermsComposer()
    return InvoiceComposer(
        extension_composer, supplier_party_composer, customer_party_composer,
        delivery_composer, delivery_terms_composer, payment_composer,
        allowance_charge_composer, tax_total_composer, monetary_total_composer,
        invoice_line_composer)


def resolve_billing_reference_composer():
    amount_composer = AmountComposer()
    return BillingReferenceComposer(amount_composer)


def resolve_credit_note_composer():
    amount_composer = AmountComposer()
    extension_composer = resolve_extensions_composer()
    billing_reference_composer = resolve_billing_reference_composer()
    credit_note_line_composer = CreditNoteLineComposer(
        amount_composer, billing_reference_composer)
    monetary_total_composer = MonetaryTotalComposer(amount_composer)
    customer_party_composer = resolve_customer_party_composer()
    supplier_party_composer = resolve_supplier_party_composer()
    payment_composer = PaymentComposer(amount_composer)
    tax_total_composer = resolve_tax_total_composer()
    return CreditNoteComposer(
        extension_composer, supplier_party_composer, customer_party_composer,
        payment_composer, tax_total_composer, monetary_total_composer,
        credit_note_line_composer)


def resolve_debit_note_composer():
    amount_composer = AmountComposer()
    extension_composer = resolve_extensions_composer()
    billing_reference_composer = resolve_billing_reference_composer()
    debit_note_line_composer = DebitNoteLineComposer(
        amount_composer, billing_reference_composer)
    monetary_total_composer = MonetaryTotalComposer(amount_composer)
    customer_party_composer = resolve_customer_party_composer()
    supplier_party_composer = resolve_supplier_party_composer()
    payment_composer = PaymentComposer(amount_composer)
    tax_total_composer = resolve_tax_total_composer()
    return DebitNoteComposer(
        extension_composer, supplier_party_composer, customer_party_composer,
        payment_composer, tax_total_composer, monetary_total_composer,
        debit_note_line_composer)


def resolve_composer(kind):
    if kind == 'invoice':
        return resolve_invoice_composer()
    elif kind == 'credit_note':
        return resolve_credit_note_composer()
    else:
        return resolve_debit_note_composer()
