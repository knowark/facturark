from pytest import fixture
from facturark.builder import InvoiceBuilder
from facturark.composers import InvoiceComposer
from facturark.resolver import resolve_invoice_composer
from facturark.validator import Validator, InvoiceUuidGenerator


@fixture
def invoice_builder():
    class MockUuidGenerator:
        def generate(self, invoice):
            return invoice, ""

    invoice_composer = resolve_invoice_composer()
    validator = Validator(MockUuidGenerator())
    builder = InvoiceBuilder(invoice_composer, validator)
    return builder


def test_invoice_builder_creation(invoice_builder):
    assert invoice_builder


def test_invoice_builder_build(invoice_builder, invoice_dict):
    result = invoice_builder.build(invoice_dict)
    assert result is not None


def test_invoice_builder_build_and_sign(invoice_builder, invoice_dict):
    class MockSigner:
        def sign(self, element):
            return element
    
    class MockVerifier:
        def verify(self, element):
            return True

    invoice_builder.signer = MockSigner()
    invoice_builder.verifier = MockVerifier()
    result = invoice_builder.build(invoice_dict)
    assert result is not None
