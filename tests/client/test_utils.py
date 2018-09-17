import io
from zipfile import ZipFile
from facturark.client.utils import (
    make_zip_file_bytes, make_document_name)


def test_make_zip_file_bytes():
    file_name = 'face_f0098765432000000000b.xml'
    document_bytes = '<Invoice></Invoice>'

    zip_file = make_zip_file_bytes(file_name, document_bytes)

    assert isinstance(zip_file, bytes)


def test_make_document_name():
    vat = "98765432"
    invoice_number = "11"
    expected_name = "face_f0098765432000000000b.xml"
    name = make_document_name(vat, invoice_number)
    assert name == expected_name
