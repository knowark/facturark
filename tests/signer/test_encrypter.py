from pytest import fixture
from cryptography.hazmat.primitives.asymmetric import rsa
from facturark.signer import Encrypter


@fixture
def encrypter():
    encrypter = Encrypter()
    return encrypter


@fixture
def certificate_pem():
    certificate_shell = (
        "-----BEGIN CERTIFICATE-----\n"
        "{}\n"
        "-----END CERTIFICATE-----")
    public_key = """
MIIGOTCCBCGgAwIBAgIIHEYIuHDx5XwwDQYJKoZIhvcNAQELBQAwgbQxIzAhBgkqhkiG9w0BCQEW
FGluZm9AYW5kZXNzY2QuY29tLmNvMSMwIQYDVQQDExpDQSBBTkRFUyBTQ0QgUy5BLiBDbGFzZSBJ
STEwMC4GA1UECxMnRGl2aXNpb24gZGUgY2VydGlmaWNhY2lvbiBlbnRpZGFkIGZpbmFsMRMwEQYD
VQQKEwpBbmRlcyBTQ0QuMRQwEgYDVQQHEwtCb2dvdGEgRC5DLjELMAkGA1UEBhMCQ08wHhcNMTgw
NjEyMjM0NzAwWhcNMTkwNjEyMjM0NzAwWjCCASExIjAgBgkqhkiG9w0BCQEWE2Vnb21lemJAZGlh
bi5nb3YuY28xGzAZBgoJkiaJk/IsZAEBEwtDQyAxOTMyODU1MzEjMCEGA1UEAxMaRWx0b24gQWx2
YXJvIEdvbWV6IEJvbmlsbGExGjAYBgNVBAsTEU9wZXJhZG9yIENvbnZlbmlvMSswKQYDVQQLEyJF
bWl0aWRvIHBvciBBbmRlcyBTQ0QgQ3JhIDI3IDg2IDQzMTswOQYDVQQKEzJVLkEuRS4gRElSRUND
SU9OIERFIElNUFVFU1RPUyBZIEFEVUFOQVMgTkFDSU9OQUxFUzEPMA0GA1UEBxMGQk9HT1RBMRUw
EwYDVQQIEwxDVU5ESU5BTUFSQ0ExCzAJBgNVBAYTAkNPMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAkNaGsfTYj+yFFJxLoO3HnN/yLlkrTblrVk+RcVGhGxxNPaCqUpNkhqGaFQdej1vz
evJkEYlMfP3/RJCZLkR75UaV55Clg3MKbW5IxRhF23okBq5SJPSsCy6o9Qljrd+HyLu4+vi+PGxV
oNYdjoGxXYVSry5kqlUMWfasLZl1CTKxAuBAnvhJVu+FdcE6z9ocgC4bsqOd6mSIQAIYzSZOMUy7
6amb6TXUow/J/q5b4XyXZqfhG2+rsuvc9W6ewsYhPR8g4ctKSySNp5Gxm08dyYO9PlbJw6No5+dc
cKD6HWWTeADhx8axLTvDj6/mf3btui+AxjcruMsPVfoZ0ecZ3QIDAQABo4HeMIHbMAwGA1UdEwEB
/wQCMAAwHwYDVR0jBBgwFoAUqEu09AuntlvUoCiFEJ0EEzPEp/cwHgYDVR0RBBcwFYETZWdvbWV6
YkBkaWFuLmdvdi5jbzATBgNVHSUEDDAKBggrBgEFBQcDAjBGBgNVHR8EPzA9MDugOaA3hjVodHRw
Oi8vd3d3LmFuZGVzc2NkLmNvbS5jby9pbmNsdWRlcy9nZXRDZXJ0LnBocD9jcmw9MTAdBgNVHQ4E
FgQUMhD/dq08dT3adgon3M2WoHMK+1gwDgYDVR0PAQH/BAQDAgXgMA0GCSqGSIb3DQEBCwUAA4IC
AQAkTjmtmKxU5nvDEL2PuUQxMAI4fZo3n8gIsMjHyj0rHNRUWepKEPf7+qwvorxld0orMs/KBhCb
sS0aGDKrNm6sKfGqlYN2uEGuRr8d5e4+9hn1rZy5K+ds8mKT1ukxZdID5jwTtP78Q1ICUqGydKzZ
No3KoyIyrGMT+/w4NvSWvlIABu0zO6SLXbnIg6CvUZF0eFcrYBRA0P7yvANgxrPhy/ydr3wTRUCA
peofvsAltaMPDT55FtvGR23K6uJ9oS9cr91QFARyXXEtOTjWcnn46CJRAI0gp2qpCwtGRRIqD4z7
+mLi+0P7mr+qXTUewgL54rRTc67htLV77ObEzMTyhyB+y7+DLVV7VYTbprX5Vp//YvXU93taP/IV
p0ayp7EOKZbHuTSbk+mGUcv6CG7sQ0CvA05Qv5KXbzCiox9Cu1MzMhevM8kDNkdB1/uMQxOsLLfo
U6+FOFmz6//sktE7aFD11W2bQbYGpEUkDgZ6Z62av/bSmxSOrLZMsAn3WUKKt9+EGSsS54qqLKHN
q9cqewsHs+JkSS93tE2IMLZNa6/QPH+DEqFfzs7OjRKWp2bUmHQSS06Lb96+jLdZ2PC3XZhPs4lb
ISVn3ush80FSEc2z2NomKWlOGnykLJXcVhTxT1drgnrU6qaAq9+CnqLX+jQfWmfKkQCwSIuLtELb
CA==
    """
    return certificate_shell.format(public_key.strip())


def test_encrypter_instantiation(encrypter):
    assert encrypter is not None


def test_encrypter_parse_public_key(encrypter, certificate_pem):
    certificate = encrypter._parse_certificate(certificate_pem)
    public_key = certificate.public_key()

    assert public_key is not None
    assert isinstance(public_key, rsa.RSAPublicKey)


def test_encrypter_verify_signature(encrypter, certificate_pem):
    digest_b64 = 'Q4H+bP65Y5RVbzAt3jRE2QdShrimTa4wAmpuZ4YxP1Y='
    signature_b64 = (
        "fLhaP8kDwoDfMiSZy3xOPjpEQIXaEfFWs+NY/AWIf0kddsra1rhh4A/JeJGufd3hkM"
        "2CEjx1p+rkA4QbPtJFzzzagf+td2QlHnpbviho7y2QOHRRy1Ioo/edp4r4+op2/fcPC"
        "Ev3tgyyjV3AaXljccHclivXKrfEQnrE2N9iQ3BDkKAX2QGmxLSH9KuuHF8lzWWPwoL+"
        "XsbTpSuoQQSjBb6A7KLGS8WNTSPbq8xiCvRGyzAEHonirgMK2vIXM9uJHvCoN1XZaxB"
        "57++FsuyLBiwn5T4ngb8ephNQMvIdofNsK4IrZXd9YhirV3sZ5bgXtR4Kcn1ughzLrx"
        "j8Y5XqGw==")

    result = encrypter.verify_signature(
        certificate_pem, signature_b64, digest_b64)

    assert result is True
