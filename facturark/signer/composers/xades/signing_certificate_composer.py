from lxml.etree import Element, SubElement, QName, tostring
from ....utils import make_child
from ..namespaces import NS
from ..composer import Composer


class SigningCertificateComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.xades, root_name), nsmap=vars(NS))

        for cert_dict in data_dict['certs']:
            cert = make_child(root, QName(NS.xades, "Cert"), empty=True)

            cert_digest_dict = cert_dict['cert_digest']
            cert_digest = make_child(
                cert, QName(NS.xades, "CertDigest"), empty=True)
            make_child(
                cert_digest, QName(NS.ds, "DigestMethod"),
                attributes=cert_digest_dict['digest_method']['@attributes'])
            make_child(cert_digest, QName(NS.ds, "DigestValue"),
                       cert_digest_dict['digest_value'])

            issuer_serial_dict = cert_dict['issuer_serial']
            issuer_serial = make_child(
                cert, QName(NS.xades, "IssuerSerial"), empty=True)
            make_child(issuer_serial, QName(NS.ds, "X509IssuerName"),
                       issuer_serial_dict['X509_issuer_name'])
            make_child(issuer_serial, QName(NS.ds, "X509SerialNumber"),
                       issuer_serial_dict['X509_serial_number'])

        return root
