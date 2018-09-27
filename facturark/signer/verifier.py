from lxml.etree import tostring, QName, fromstring
from .composers.namespaces import NS


class Verifier:
    def __init__(self, canonicalizer, encoder, hasher):
        self.canonicalizer = canonicalizer
        self.encoder = encoder
        self.hasher = hasher
        self.signature_path = './/ds:Signature'

    def verify(self, element):
        return True

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
        resource = element

        if sanitized_uri:
            path = ".//*[@Id='{}']".format(sanitized_uri)
            resource = element.find(path, namespaces=vars(NS))
        else:
            self._remove_signature(resource)

        canonical_resource = self.canonicalizer.canonicalize(resource)
        resource_hash = self.hasher.hash(canonical_resource, method)
        base64_digest = self.encoder.base64_encode(resource_hash)

        return base64_digest

    def _digest_signed_info(self, element, method):
        resource = element.find(
            self.signature_path + "/ds:SignedInfo", namespaces=vars(NS))

        canonical_resource = self.canonicalizer.canonicalize(resource)
        resource_hash = self.hasher.hash(canonical_resource, method)
        base64_digest = self.encoder.base64_encode(resource_hash)

        return base64_digest
