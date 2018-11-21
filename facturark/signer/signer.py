# -*- coding: utf-8 -*-
from OpenSSL import crypto
from datetime import datetime, timedelta, tzinfo
from ..utils import read_asset
from lxml.etree import tostring


class Signer:
    def __init__(self, canonicalizer, hasher, encoder, identifier, encrypter,
                 signature_composer, key_info_composer, object_composer,
                 qualifying_properties_composer, signed_properties_composer,
                 signed_info_composer, signature_value_composer,
                 pkcs12_certificate, pkcs12_password):
        self.canonicalizer = canonicalizer
        self.hasher = hasher
        self.encoder = encoder
        self.identifier = identifier
        self.encrypter = encrypter
        self.signature_composer = signature_composer
        self.key_info_composer = key_info_composer
        self.object_composer = object_composer
        self.qualifying_properties_composer = qualifying_properties_composer
        self.signed_properties_composer = signed_properties_composer
        self.signed_info_composer = signed_info_composer
        self.signature_value_composer = signature_value_composer
        self.signature_algorithm = (
            "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256")
        self.digest_algorithm = (
            "http://www.w3.org/2001/04/xmlenc#sha256")
        self.pkcs12_certificate = pkcs12_certificate
        self.pkcs12_password = pkcs12_password

    def sign(self, element):

        # Create Signature ID
        signature_id = self.identifier.generate_id()

        # Parse PKCS12 Certificate
        certificate = self._parse_certificate(
            self.pkcs12_certificate, self.pkcs12_password)

        # Prepare KeyInfo Element
        x509_certificate = certificate.get_certificate()
        key_info_id = self.identifier.generate_id(suffix='keyinfo')
        key_info_element, key_info_digest = (
            self._prepare_key_info(x509_certificate, key_info_id,
                                   self.digest_algorithm))

        # Prepare Signed Properties Element
        signed_properties_id = signature_id + '-signedprops'
        signed_properties_element, signed_properties_digest = (
            self._prepare_signed_properties(
                x509_certificate, signed_properties_id))

        # Prepare Document Element
        document_element, document_digest = (
            self._prepare_document(element, self.digest_algorithm))

        # Prepare Signed Info
        signed_info_element, signed_info_digest = self._prepare_signed_info(
            (signature_id + '-ref0', '', document_digest),
            (None, key_info_id, key_info_digest),
            (None, signed_properties_id, signed_properties_digest)
        )

        # Create Encrypted Signature Digest
        private_key = certificate.get_privatekey().to_cryptography_key()
        signature_value_digest = self._create_signature_value_digest(
            private_key, signed_info_digest)

        # Prepare Signature Value Element
        uid = signature_id + '-sigvalue'
        signature_value_element = self._prepare_signature_value(
            signature_value_digest, uid)

        # Create Signature
        signature_element = self._create_signature(
            signature_id, signed_info_element, signature_value_element,
            key_info_element, signed_properties_element)

        # Inject Signature Element In Document Element
        signed_document_element = self._inject_signature(
            document_element, signature_element)

        # return signed_document_element
        return document_element

    def _parse_certificate(self, pkcs12_certificate, pkcs12_password):
        certificate = crypto.load_pkcs12(pkcs12_certificate, pkcs12_password)
        return certificate

    def _serialize_certificate(self, certificate_object):
        pem_certificate = crypto.dump_certificate(
            crypto.FILETYPE_PEM, certificate_object)

        return self._normalize_certificate(pem_certificate)

    def _create_reference_dict(self, digest_value, attributes,
                               transforms=None):
        reference_dict = {
            "@attributes": attributes,
            "digest_method": {
                "@attributes": {
                    "Algorithm": self.digest_algorithm
                }
            },
            "digest_value": digest_value
        }
        if transforms:
            reference_dict['transforms'] = transforms
        return reference_dict

    def _prepare_document(self, document_element, algorithm):
        canonicalized_document = self.canonicalizer.canonicalize(
            document_element)
        document_digest = self.encoder.base64_encode(self.hasher.hash(
            canonicalized_document, algorithm))
        document_element = self.canonicalizer.parse(canonicalized_document)

        return document_element, document_digest

    def _prepare_key_info(self, certificate_object, uid, algorithm):
        serialized_certificate = self._serialize_certificate(
            certificate_object)
        key_info_dict = {
            '@attributes': {'Id': uid},
            'X509_data': {
                'X509_certificate': serialized_certificate
            }
        }
        key_info = self.key_info_composer.compose(key_info_dict)
        canonicalized_key_info = self.canonicalizer.canonicalize(key_info)
        key_info_digest = self.encoder.base64_encode(
            self.hasher.hash(canonicalized_key_info, algorithm))
        key_info = self.canonicalizer.parse(canonicalized_key_info)

        return key_info, key_info_digest

    def _normalize_certificate(self, certificate_pem):
        normalized_certificate = certificate_pem.replace(
            b'-----BEGIN CERTIFICATE-----', b'')
        normalized_certificate = normalized_certificate.replace(
            b'-----END CERTIFICATE-----', b'')
        return normalized_certificate.replace(b'\n', b'')

    def _get_certificate_digest_value(self, certificate_pem, algorithm):
        normalized_certificate = self._normalize_certificate(certificate_pem)

        certificate_binary = self.encoder.base64_decode(normalized_certificate)
        certificate_hash = self.hasher.hash(certificate_binary, algorithm)
        certificate_digest = self.encoder.base64_encode(certificate_hash)

        return certificate_digest

    def _get_policy(self):
        return (
            ('https://facturaelectronica.dian.gov.co/'
                'politicadefirma/v2/politicadefirmav2.pdf'),
            (u"Política de firma para facturas electrónicas de la "
             u"República de Colombia"))

    def _get_policy_hash(self, algorithm, policy_path=None):
        algorithm = algorithm
        path = policy_path or "politicadefirmav2.pdf"

        policy_binary = read_asset(path)
        policy_hash = self.hasher.hash(policy_binary, algorithm)
        policy_digest = self.encoder.base64_encode(policy_hash)

        return policy_digest

    def _get_local_time(self):
        class UTC_M5(tzinfo):
            def utcoffset(self, dt):
                return timedelta(hours=-5)

            def dst(self, dt):
                return timedelta(0)

        now = datetime.now(tz=UTC_M5())
        serialized_now = now.isoformat()
        timezone_suffix = serialized_now[-6:]
        local_time = serialized_now[:-9] + timezone_suffix
        return local_time

    def _prepare_signed_properties(self, certificate_object, uid):
        digest_algorithm = self.digest_algorithm
        signing_time = self._get_local_time()
        issuer_name = self._prepare_issuer_name(certificate_object)
        serial_number = str(certificate_object.get_serial_number())
        certificate_pem = crypto.dump_certificate(
            crypto.FILETYPE_PEM, certificate_object)
        digest_value = self._get_certificate_digest_value(certificate_pem,
                                                          digest_algorithm)
        policy_identifier, policy_description = self._get_policy()
        policy_hash = self._get_policy_hash(digest_algorithm)

        certs = [{
            'cert_digest': {
                'digest_method': {
                    '@attributes': {'Algorithm': digest_algorithm}
                },
                'digest_value': digest_value
            },
            'issuer_serial': {
                'X509_issuer_name': issuer_name,
                'X509_serial_number': serial_number
            }
        }]

        signature_policy_id_dict = {
            'sig_policy_id': {
                'identifier': policy_identifier,
                'description': policy_description
            },
            'sig_policy_hash': {
                'digest_method': {
                    '@attributes': {
                        'Algorithm': digest_algorithm
                    }
                },
                'digest_value': policy_hash
            }
        }
        claimed_role = 'supplier'

        signed_properties_dict = {
            '@attributes': {'Id': uid},
            'signed_signature_properties': {
                'signing_time': signing_time,
                'signing_certificate': {
                    'certs': certs
                },
                'signature_policy_identifier': {
                    'signature_policy_id': signature_policy_id_dict
                },
                'signer_role': {
                    'claimed_roles': [{
                        'claimed_role': claimed_role
                    }]
                }
            }
        }

        signed_properties = self.signed_properties_composer.compose(
            signed_properties_dict)

        canonicalized_signed_properties = self.canonicalizer.canonicalize(
            signed_properties)
        signed_properties_digest = self.encoder.base64_encode(
            self.hasher.hash(
                canonicalized_signed_properties, digest_algorithm))

        return signed_properties, signed_properties_digest

    def _prepare_issuer_name(self, certificate_object):
        """Reverse Distinguished Names.

        Join Distinguished Names in reverse according to
        https://www.ietf.org/rfc/rfc2253.txt
        This format is used by the 'getName()' method of
        javax.security.auth.x500.X500Principal
        """

        issuer_name = b','.join(
            [key + b'=' + value for key, value in
             reversed(certificate_object.get_issuer().get_components())])
        return issuer_name

    def _prepare_signature_value(self, value, uid):
        signature_value = self.signature_value_composer.compose({
            "@attributes": {"Id": uid},
            "#text": value})

        return signature_value

    def _prepare_signed_info(self, document_tuple, key_info_tuple,
                             signed_properties_tuple):
        document_reference_id, document_reference_uri, document_digest = (
            document_tuple)
        _, key_info_reference_uri, key_info_digest = (
            key_info_tuple)
        _, signed_properties_reference_uri, signed_properties_digest = (
            signed_properties_tuple)
        signed_properties_reference_type = (
            "http://uri.etsi.org/01903#SignedProperties")

        signed_info_dict = {
            "canonicalization_method": {
                "@attributes": {
                    "Algorithm": ("http://www.w3.org/TR/"
                                  "2001/REC-xml-c14n-20010315")
                }
            },
            "signature_method": {
                "@attributes": {
                    "Algorithm": self.signature_algorithm
                }
            },
            "references": [
                self._create_reference_dict(
                    document_digest,
                    {'Id': document_reference_id,
                     'URI': document_reference_uri},
                    [{"@attributes": {"Algorithm": (
                        "http://www.w3.org/2000/09/"
                        "xmldsig#enveloped-signature")}}]),

                self._create_reference_dict(
                    key_info_digest,
                    {'URI': "#" + key_info_reference_uri}),
                self._create_reference_dict(
                    signed_properties_digest,
                    {'Type': signed_properties_reference_type,
                     'URI': "#" + signed_properties_reference_uri})
            ]
        }

        signed_info = self.signed_info_composer.compose(signed_info_dict)
        canonicalized_signed_info = self.canonicalizer.canonicalize(
            signed_info)
        signed_info_digest = self.encoder.base64_encode(self.hasher.hash(
            canonicalized_signed_info))

        return signed_info, signed_info_digest

    def _create_signature_value_digest(self, private_key, signed_info_digest):
        encrypted_signature_value = self.encrypter.create_signature(
            private_key, signed_info_digest, self.signature_algorithm)

        signature_value_digest = self.encoder.base64_encode(
            encrypted_signature_value)

        return signature_value_digest

    def _create_signature(self, signature_id, signed_info_element,
                          signature_value_element, key_info_element,
                          signed_properties_element):

        signature = self.signature_composer.compose({
            '@attributes': {'Id': signature_id}})
        signature_id = signature.attrib.get('Id')
        signature.append(signed_info_element)
        signature.append(signature_value_element)
        signature.append(key_info_element)

        qualifying_properties_element = (
            self.qualifying_properties_composer.compose({
                '@attributes': {'Target': '#' + signature_id}}))
        qualifying_properties_element.append(signed_properties_element)
        object_element = self.object_composer.compose({})
        object_element.append(qualifying_properties_element)

        signature.append(object_element)

        return signature

    def _inject_signature(self, document_element, signature_element):
        signed_document = self.signature_composer.inject_in_document(
            document_element, signature_element)
        return signed_document
