from copy import deepcopy
from lxml.etree import tostring, QName, fromstring
from ..namespaces import NS
from ..utils import read_asset


class Verifier:
    def __init__(self, canonicalizer, encoder, hasher, encrypter):
        self.canonicalizer = canonicalizer
        self.encoder = encoder
        self.hasher = hasher
        self.encrypter = encrypter
        self.signature_path = './/ds:Signature'

    def verify(self, element):
        # Compare Resources Digests
        reference_dict_list = self._parse_references(element)
        for reference_dict in reference_dict_list:
            computed_digest = self._digest_resource(
                element, reference_dict['uri'],
                reference_dict['digest_method'])
            self._compare_digests(
                computed_digest, reference_dict['digest_value'])

        # Get X509 PEM Certificate
        certificate = self._extract_certificate(element)

        # Get Signature Value
        signature_value = self._extract_signature_value(element)

        # Get Hash Method
        method = self._extract_signature_method(element)

        # Get Signed Info Digest
        signed_info_digest = self._digest_signed_info(element, method)

        # Verify Xades
        self._verify_xades(element)

        # Verify Encrypted Signature
        self.encrypter.verify_signature(
            certificate, signature_value, signed_info_digest, method)

        return True

    def verify_bytes(self, document):
        element = fromstring(document)
        return self.verify(element)

    def _get_signature(self, element):
        path = self.signature_path
        signature = element.find(path, namespaces=vars(NS))
        return signature

    def _get_canonical_signed_info(self, element):
        path = self.signature_path + '/ds:SignedInfo'
        signed_info = element.find(path, namespaces=vars(NS))
        canonical_signed_info = self.canonicalizer.canonicalize(signed_info)
        return fromstring(canonical_signed_info)

    def _get_signature_method(self, element):
        path = self.signature_path + '/ds:SignedInfo/ds:SignatureMethod'
        signature_method = element.find(path, namespaces=vars(NS))
        algorithm = signature_method.attrib.get('Algorithm')
        return algorithm

    def _get_canonicalization_method(self, element):
        path = self.signature_path + '/ds:SignedInfo/ds:CanonicalizationMethod'
        canonicalization_method = element.find(path, namespaces=vars(NS))
        algorithm = canonicalization_method.attrib.get('Algorithm')
        return algorithm

    def _parse_references(self, element):
        path = self.signature_path + '/ds:SignedInfo/ds:Reference'
        references = element.findall(path, namespaces=vars(NS))

        reference_dict_list = []
        for reference in references:
            transforms = reference.find(QName(NS.ds, 'Transforms'))
            if transforms is None:
                transforms = []
            digest_method = reference.find(QName(NS.ds, 'DigestMethod'))
            digest_value = reference.find(QName(NS.ds, 'DigestValue'))
            reference_dict = {
                "id": reference.attrib.get('Id'),
                "uri": reference.attrib.get('URI'),
                "transforms": [transform.attrib.get('Algorithm')
                               for transform in transforms],
                "digest_method": digest_method.attrib.get('Algorithm'),
                "digest_value": digest_value.text
            }
            reference_dict_list.append(reference_dict)

        return reference_dict_list

    def _remove_signature(self, element):
        signature = element.find(self.signature_path, namespaces=vars(NS))
        if signature is not None:
            signature.getparent().remove(signature)

    def _digest_resource(self, element, uri, method):
        sanitized_uri = uri.replace("#", "")
        resource = deepcopy(element)

        if sanitized_uri:
            path = './/*[@Id="{}"]'.format(sanitized_uri)
            resource = element.find(path, namespaces=vars(NS))
        else:
            self._remove_signature(resource)

        canonical_resource = self.canonicalizer.canonicalize(resource)

        print()
        print()
        print('VERIFIER')
        print('URI', sanitized_uri)
        print(tostring(resource, pretty_print=True))

        resource_hash = self.hasher.hash(canonical_resource, method)
        base64_digest = self.encoder.base64_encode(resource_hash)
        print('RESOURCE HASH: -->>', base64_digest)

        return base64_digest

    def _extract_certificate(self, element):
        path = './/ds:X509Certificate'
        certificate = element.find(path, namespaces=vars(NS))
        certificate_bytes = b"-----BEGIN CERTIFICATE-----\n"
        certificate_bytes += certificate.text.encode('utf-8').strip()
        certificate_bytes += b"\n-----END CERTIFICATE-----"
        return certificate_bytes

    def _extract_signature_value(self, element):
        path = './/ds:SignatureValue'
        signature_value = element.find(path, namespaces=vars(NS))
        return signature_value.text.encode('utf-8')

    def _extract_signature_method(self, element):
        path = './/ds:SignatureMethod'
        signature_method = element.find(path, namespaces=vars(NS))
        return signature_method.attrib.get('Algorithm', "").encode('utf-8')

    def _digest_signed_info(self, element, method):
        resource = element.find(
            self.signature_path + "/ds:SignedInfo", namespaces=vars(NS))

        canonical_resource = self.canonicalizer.canonicalize(resource)
        resource_hash = self.hasher.hash(canonical_resource, method)
        base64_digest = self.encoder.base64_encode(resource_hash)

        return base64_digest

    def _compare_digests(self, computed_digest, given_digest):
        decoded_computed_digest = self.encoder.base64_decode(
            computed_digest)
        decoded_given_digest = self.encoder.base64_decode(
            given_digest)

        if decoded_computed_digest != decoded_given_digest:
            raise ValueError("Mismatched digest values")

    def _verify_xades(self, element):
        self._verify_xades_cert(element)
        self._verify_xades_policy(element)

    def _verify_xades_cert(self, element):
        digest_path = ".//xades:Cert/xades:CertDigest/ds:DigestValue"
        given_digest = element.find(
            digest_path, namespaces=vars(NS)).text.encode('utf-8')

        method_path = ".//xades:Cert/xades:CertDigest/ds:DigestMethod"
        method = element.find(
            method_path, namespaces=vars(NS)).attrib['Algorithm']

        certificate = element.find(
            './/ds:X509Certificate', namespaces=vars(NS)).text
        decoded_certificate = self.encoder.base64_decode(certificate)
        certificate_hash = self.hasher.hash(decoded_certificate, method)
        computed_digest = self.encoder.base64_encode(certificate_hash)

        if computed_digest != given_digest:
            raise ValueError('XADES: Bad certificate digest')

    def _verify_xades_policy(self, element):
        policy_uri = element.find(
            './/xades:SigPolicyId/xades:Identifier',
            namespaces=vars(NS)).text
        policy_filename = policy_uri.split('/')[-1]
        policy_binary = read_asset(policy_filename)

        method = element.find(
            './/xades:SigPolicyHash/ds:DigestMethod',
            namespaces=vars(NS)).attrib['Algorithm']

        given_digest = element.find(
            './/xades:SigPolicyHash/ds:DigestValue',
            namespaces=vars(NS)).text.encode('utf-8')

        computed_digest = self.encoder.base64_encode(
            self.hasher.hash(policy_binary, method))

        if computed_digest != given_digest:
            raise ValueError('XADES: Bad policy digest')
