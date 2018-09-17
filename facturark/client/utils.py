import io
import zipfile


def make_document_name(vat, invoice_number, prefix='face_f', ext='xml'):
    vat_part = '{:010d}'.format(int(vat))
    invoice_part = "{0:010x}".format(int(invoice_number))
    return "{prefix}{vat_part}{invoice_part}.{ext}".format(
        prefix=prefix,
        vat_part=vat_part,
        invoice_part=invoice_part,
        ext=ext)


def make_zip_file(file_name, document_bytes):
    memory_zip_file = io.BytesIO()

    with zipfile.ZipFile(memory_zip_file, 'w') as z:
        z.writestr(file_name, document_bytes)

    memory_zip_file.seek(0)
    return memory_zip_file
