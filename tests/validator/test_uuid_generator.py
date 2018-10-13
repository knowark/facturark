

def test_invoice_uuid_generator_generate_uuid(
        invoice, invoice_uuid_generator):

    result = invoice_uuid_generator.generate(invoice)
    assert result == 'fcb404ae5e74a0af2ba143bcbcf08bfdcde351e5'
