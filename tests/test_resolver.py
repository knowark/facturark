from facturark.composers import (
    InvoiceLineComposer, PartyComposer, DespatchComposer, DeliveryComposer,
    CustomerPartyComposer, SupplierPartyComposer, TaxTotalComposer,
    InvoiceComposer, CreditNoteComposer)
from facturark.resolver import (
    resolve_invoice_line_composer, resolve_party_composer,
    resolve_despatch_composer, resolve_delivery_composer,
    resolve_customer_party_composer, resolve_supplier_party_composer,
    resolve_tax_total_composer, resolve_invoice_composer,
    resolve_credit_note_composer)


def test_resolve_invoice_line_composer():
    assert isinstance(resolve_invoice_line_composer(), InvoiceLineComposer)


def test_resolve_party_composer():
    assert isinstance(resolve_party_composer(), PartyComposer)


def test_resolve_despatch_composer():
    assert isinstance(resolve_despatch_composer(), DespatchComposer)


def test_resolve_delivery_composer():
    assert isinstance(resolve_delivery_composer(), DeliveryComposer)


def test_resolve_customer_party_composer():
    assert isinstance(resolve_customer_party_composer(), CustomerPartyComposer)


def test_resolve_supplier_party_composer():
    assert isinstance(resolve_supplier_party_composer(), SupplierPartyComposer)


def test_resolve_tax_total_composer():
    assert isinstance(resolve_tax_total_composer(), TaxTotalComposer)


def test_resolve_invoice_composer():
    assert isinstance(resolve_invoice_composer(), InvoiceComposer)


def test_resolve_credit_note_composer():
    assert isinstance(resolve_credit_note_composer(), CreditNoteComposer)
