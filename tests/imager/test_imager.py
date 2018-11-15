from textwrap import dedent


def test_imager_instantiation(imager):
    assert imager is not None


def test_imager_qrcode(imager, document):
    message = 'INVOICE DATA'
    result = imager.qrcode(document)
    assert isinstance(result, bytes)


def test_imager_generate_image(imager):
    message = 'INVOICE DATA'
    result = imager._generate_image(message)
    assert isinstance(result, bytes)


def test_imager_build_message(imager):
    message_dict = {}
    message_dict['invoice_number'] = "A02F-00117836"
    message_dict['invoice_date'] = "20140319105605"
    message_dict['supplier_id'] = "808183133"
    message_dict['customer_id'] = "8081972684"
    message_dict['invoice_amount'] = "1000.00"
    message_dict['tax_vat_amount'] = "160.00"
    message_dict['tax_other_amount'] = "0.00"
    message_dict['total_amount'] = "1160.00"
    message_dict['uuid'] = "2836a15058e90baabbf6bf2e97f05564ea0324a6"

    result = imager._build_message(message_dict)

    expected = dedent(
        """
    NumFac: A02F-00117836
    FecFac: 20140319105605
    NitFac: 808183133
    DocAdq: 8081972684
    ValFac: 1000.00
    ValIva: 160.00
    ValOtroIm: 0.00
    ValFacIm: 1160.00
    CUFE: 2836a15058e90baabbf6bf2e97f05564ea0324a6
    """).strip()

    assert result == expected
