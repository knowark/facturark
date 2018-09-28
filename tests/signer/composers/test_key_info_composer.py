# -*- coding: utf-8 -*-
from pytest import fixture
from lxml.etree import QName, fromstring
from facturark.signer.composers import NS, KeyInfoComposer


@fixture
def composer():
    return KeyInfoComposer()


@fixture
def data_dict():
    return {
        'X509_data': {
            'X509_certificate': """
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
        }
    }


def test_compose(composer, data_dict, schema):
    key_info = composer.compose(data_dict)

    assert key_info.prefix == "ds"
    assert key_info.tag == QName(NS.ds, "KeyInfo").text
    assert key_info.find('ds:X509Data/ds:X509Certificate', vars(NS)).text == (
        data_dict['X509_data']['X509_certificate'])
    schema.assertValid(key_info)
