from facturark.composers import (
    AmountComposer, ItemComposer, PriceComposer, PartyTaxSchemeComposer,
    PartyLegalEntityComposer, PersonComposer, AddressComposer,
    LocationComposer, PartyComposer, DespatchComposer, DeliveryComposer,
    CustomerPartyComposer, SupplierPartyComposer, TaxSubtotalComposer,
    TaxTotalComposer, PaymentComposer, AllowanceChargeComposer,
    DeliveryTermsComposer, MonetaryTotalComposer, ExtensionComposer,
    InvoiceComposer, InvoiceLineComposer, CreditNoteComposer,
    CreditNoteLineComposer, DebitNoteComposer, DebitNoteLineComposer)


def resolve_invoice_line_composer():
    item_composer = ItemComposer()
    price_composer = PriceComposer()
    return InvoiceLineComposer(item_composer, price_composer)


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
    tax_subtotal_composer = TaxSubtotalComposer()
    return TaxTotalComposer(tax_subtotal_composer)


def resolve_invoice_composer():
    extension_composer = ExtensionComposer()
    invoice_line_composer = resolve_invoice_line_composer()
    monetary_total_composer = MonetaryTotalComposer(AmountComposer())
    customer_party_composer = resolve_customer_party_composer()
    supplier_party_composer = resolve_supplier_party_composer()
    payment_composer = PaymentComposer()
    tax_total_composer = resolve_tax_total_composer()
    delivery_composer = resolve_delivery_composer()
    allowance_charge_composer = AllowanceChargeComposer()
    delivery_terms_composer = DeliveryTermsComposer()
    return InvoiceComposer(
        extension_composer, supplier_party_composer, customer_party_composer,
        delivery_composer, delivery_terms_composer, payment_composer,
        allowance_charge_composer, tax_total_composer, monetary_total_composer,
        invoice_line_composer)


def resolve_credit_note_composer():
    extension_composer = ExtensionComposer()
    credit_note_line_composer = CreditNoteLineComposer()
    monetary_total_composer = MonetaryTotalComposer(AmountComposer())
    customer_party_composer = resolve_customer_party_composer()
    supplier_party_composer = resolve_supplier_party_composer()
    payment_composer = PaymentComposer()
    tax_total_composer = resolve_tax_total_composer()
    return CreditNoteComposer(
        extension_composer, supplier_party_composer, customer_party_composer,
        payment_composer, tax_total_composer, monetary_total_composer,
        credit_note_line_composer)


def resolve_debit_note_composer():
    extension_composer = ExtensionComposer()
    debit_note_line_composer = DebitNoteLineComposer(AmountComposer())
    monetary_total_composer = MonetaryTotalComposer(AmountComposer())
    customer_party_composer = resolve_customer_party_composer()
    supplier_party_composer = resolve_supplier_party_composer()
    payment_composer = PaymentComposer()
    tax_total_composer = resolve_tax_total_composer()
    return DebitNoteComposer(
        extension_composer, supplier_party_composer, customer_party_composer,
        payment_composer, tax_total_composer, monetary_total_composer,
        debit_note_line_composer)
