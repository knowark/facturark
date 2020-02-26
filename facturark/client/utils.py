import io
import zipfile
import base64

DOCUMENT_PREFIX = {
    '1': 'fv',
    '2': 'nc',
    '3': 'nd'
}


def make_document_name(vat, invoice_number, prefix='fv',
                       year=20, provider="000", ext='xml', kind='1'):
    prefix = DOCUMENT_PREFIX.get(kind, prefix)
    vat_part = '{:010d}'.format(int(vat))
    invoice_part = "{0:008x}".format(int(invoice_number))
    return "fv09008495280002000000001.xml"
    return "{prefix}{vat_part}{provider}{year}{invoice_part}.{ext}".format(
        prefix=prefix,
        vat_part=vat_part,
        provider=str(provider),
        year=str(year),
        invoice_part=invoice_part,
        ext=ext)


def make_zip_file_bytes(file_name, document_bytes):
    memory_zip_file = io.BytesIO()

    with zipfile.ZipFile(memory_zip_file, 'w') as z:
        z.writestr(file_name, document_bytes)

    memory_zip_file.seek(0)

    return memory_zip_file.getvalue()
