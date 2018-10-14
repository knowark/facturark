import os
from lxml.etree import parse, QName
from pytest import fixture, raises
from facturark.namespaces import NS
from facturark.signer import (Verifier, Canonicalizer,
                              Encoder, Hasher, Encrypter)


@fixture
def verifier():
    canonicalizer = Canonicalizer()
    encoder = Encoder()
    hasher = Hasher()
    encrypter = Encrypter()
    verifier = Verifier(canonicalizer, encoder, hasher, encrypter)
    return verifier


@fixture
def signed_invoice():
    filename = 'signed_invoice.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element


@fixture
def signed_invoice_sha512():
    filename = 'signed_invoice_sha512.xml'
    directory = os.path.dirname(os.path.realpath(__file__))
    element = parse(os.path.join(directory, '..', 'data', filename))
    return element


def test_verifier_instantiation(verifier):
    assert verifier is not None


def test_verifier_verify(verifier, signed_invoice):
    # This invoice should raise an error as it has been modified (formatted.)
    with raises(ValueError):
        result = verifier.verify(signed_invoice)


def test_verifier_sha512(verifier, signed_invoice_sha512):
    result = verifier.verify(signed_invoice_sha512)
    assert result is True


def test_verifier_get_signature(verifier, signed_invoice):
    result = verifier._get_signature(signed_invoice)
    assert result.tag == QName(NS.ds, 'Signature').text


def test_verifier_get_canonical_signed_info(verifier, signed_invoice):
    result = verifier._get_canonical_signed_info(signed_invoice)
    assert result.tag == QName(NS.ds, 'SignedInfo').text


def test_verifier_get_signature_method(verifier, signed_invoice):
    signature_method = verifier._get_signature_method(signed_invoice)
    assert signature_method == "http://www.w3.org/2000/09/xmldsig#rsa-sha1"


def test_verifier_get_canonicalization_method(verifier, signed_invoice):
    canonicalization_method = (
        verifier._get_canonicalization_method(signed_invoice))
    assert canonicalization_method == (
        "http://www.w3.org/TR/2001/REC-xml-c14n-20010315")


def test_verifier_parse_references(verifier, signed_invoice):
    reference_dict_list = verifier._parse_references(signed_invoice)
    reference_elements = signed_invoice.findall(
        './/ds:Reference', namespaces=vars(NS))
    assert len(reference_dict_list) == 3

    for i, reference in enumerate(reference_elements):
        assert reference.attrib.get('Id') == reference_dict_list[i]['id']
        assert reference.attrib.get('URI') == reference_dict_list[i]['uri']


def test_verifier_digest_sha512_signed_properties(
        verifier, signed_invoice_sha512):
    uri = "#xmldsig-a05d47f2-d7a4-4964-8518-93b3bd2817d4-signedprops"
    method = "http://www.w3.org/2001/04/xmlenc#sha512"
    resource_digest = verifier._digest_resource(
        signed_invoice_sha512, uri, method)

    assert resource_digest == (
        b"wDZp1AgLv8VA1C+kenWwqU+Nc4etw/udNXet7zvLXSQEhs081"
        b"DCw3yk5Ir6YxZPp9y7QL4SYTw7ol5B0EkWInA==")


def test_verifier_digest_sha512_keyinfo(
        verifier, signed_invoice_sha512):
    uri = "#xmldsig-87d128b5-aa31-4f0b-8e45-3d9cfa0eec26-keyinfo"
    method = "http://www.w3.org/2001/04/xmlenc#sha512"
    resource_digest = verifier._digest_resource(
        signed_invoice_sha512, uri, method)

    assert resource_digest == (
        b"4ua9R6NcHUyDwrUMv9/URwx5aomERb8SgEimLkWxb9dQByijPJ"
        b"slLJhmw5q3dyTWSdFRnlQqOv37R0z99lN44A==")


def test_verifier_digest_sha512_document(
        verifier, signed_invoice_sha512):
    uri = ""
    method = "http://www.w3.org/2001/04/xmlenc#sha512"
    resource_digest = verifier._digest_resource(
        signed_invoice_sha512, uri, method)

    assert resource_digest == (
        b"zeO2I35ESFbtHIm1y3vG25gm1wa80VTP+JZzHt0HrW1bq1kNpd"
        b"cD0KY+pQVnShAOU/QyN6tNZiAJXm4K3RhWhg==")


def test_verifier_digest_sha512_signed_info(verifier, signed_invoice_sha512):
    method = "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"
    signed_info_digest = verifier._digest_signed_info(
        signed_invoice_sha512, method)

    assert signed_info_digest is not None


def test_verifier_extract_certificate(verifier, signed_invoice_sha512,
                                      certificate_pem):

    extracted_certificate = verifier._extract_certificate(
        signed_invoice_sha512)

    assert extracted_certificate == certificate_pem


def test_verifier_extract_signature_value(verifier, signed_invoice_sha512,
                                          signature_value):

    extracted_signature = verifier._extract_signature_value(
        signed_invoice_sha512)

    assert extracted_signature == signature_value


def test_verifier_extract_signature_method(verifier, signed_invoice_sha512):
    signature_method = b"http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"
    extracted_signature = verifier._extract_signature_method(
        signed_invoice_sha512)

    assert extracted_signature == signature_method


def test_verifier_compare_mismatched_digests(verifier):
    digest_a = ("zeO2I35ESFbtHIm1y3vG25gm1wa80VTP+JZzHt0HrW1bq1kNpdcD0KY+"
                "pQVnShAOU/QyN6tNZiAJXm4K3RhWhg==")
    digest_b = ("4ua9R6NcHUyDwrUMv9/URwx5aomERb8SgEimLkWxb9dQByijPJslLJhm"
                "w5q3dyTWSdFRnlQqOv37R0z99lN44A==")

    with raises(ValueError):
        verifier._compare_digests(digest_a, digest_b)
