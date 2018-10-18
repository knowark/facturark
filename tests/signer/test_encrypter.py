from pytest import fixture
from OpenSSL import crypto
from cryptography.hazmat.primitives.asymmetric import rsa
from facturark.signer import Encrypter


@fixture
def encrypter():
    encrypter = Encrypter()
    return encrypter


def test_encrypter_instantiation(encrypter):
    assert encrypter is not None


def test_encrypter_parse_public_key(encrypter, certificate_pem):
    certificate = encrypter._parse_certificate(certificate_pem)
    public_key = certificate.public_key()

    assert public_key is not None
    assert isinstance(public_key, rsa.RSAPublicKey)


def test_encrypter_verify_signature(encrypter, certificate_pem):
    digest_b64 = b'Q4H+bP65Y5RVbzAt3jRE2QdShrimTa4wAmpuZ4YxP1Y='
    signature_b64 = (
        b"fLhaP8kDwoDfMiSZy3xOPjpEQIXaEfFWs+NY/AWIf0kddsra1rhh4A/JeJGufd3hkM"
        b"2CEjx1p+rkA4QbPtJFzzzagf+td2QlHnpbviho7y2QOHRRy1Ioo/edp4r4+op2/fcPC"
        b"Ev3tgyyjV3AaXljccHclivXKrfEQnrE2N9iQ3BDkKAX2QGmxLSH9KuuHF8lzWWPwoL+"
        b"XsbTpSuoQQSjBb6A7KLGS8WNTSPbq8xiCvRGyzAEHonirgMK2vIXM9uJHvCoN1XZaxB"
        b"57++FsuyLBiwn5T4ngb8ephNQMvIdofNsK4IrZXd9YhirV3sZ5bgXtR4Kcn1ughzLrx"
        b"j8Y5XqGw==")
    algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"

    result = encrypter.verify_signature(
        certificate_pem, signature_b64, digest_b64, algorithm)

    assert result is True


def test_encrypter_create_signature(encrypter, pkcs12_certificate):
    certificate, password = pkcs12_certificate
    certificate = crypto.load_pkcs12(certificate, password)
    private_key = certificate.get_privatekey()

    digest_b64 = b'Q4H+bP65Y5RVbzAt3jRE2QdShrimTa4wAmpuZ4YxP1Y='

    result = encrypter.create_signature(private_key, digest_b64)

    assert result is not None
