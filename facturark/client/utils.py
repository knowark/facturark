import io
import zipfile
import base64


DOCUMENT_PREFIX = {
    '1': 'face_f',
    '2': 'face_c',
    '3': 'face_d'
}


def make_document_name(vat, invoice_number, prefix='face_f',
                       ext='xml', kind='1'):
    prefix = DOCUMENT_PREFIX.get(kind, prefix)
    vat_part = '{:010d}'.format(int(vat))
    invoice_part = "{0:010x}".format(int(invoice_number))
    return "{prefix}{vat_part}{invoice_part}.{ext}".format(
        prefix=prefix,
        vat_part=vat_part,
        invoice_part=invoice_part,
        ext=ext)


def make_zip_file_bytes(file_name, document_bytes):
    memory_zip_file = io.BytesIO()

    with zipfile.ZipFile(memory_zip_file, 'w') as z:
        z.writestr(file_name, document_bytes)

    memory_zip_file.seek(0)

    return memory_zip_file.getvalue()
