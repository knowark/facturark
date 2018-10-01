from facturark.signer import Signer
from facturark.signer.composers import (
    SignatureComposer, SignatureValueComposer,
    SignedInfoComposer, ReferenceComposer, KeyInfoComposer, ObjectComposer)
from facturark.signer.composers.xades import (
    QualifyingPropertiesComposer, SignedPropertiesComposer)
from facturark.signer import (Canonicalizer, Hasher, Encoder, Identifier,
                              Encrypter)


def resolve_signature_composer():
    signed_info_composer = resolve_signed_info_composer()
    signature_value_composer = SignatureValueComposer()
    return SignatureComposer(signed_info_composer, signature_value_composer)


def resolve_signed_info_composer():
    reference_composer = ReferenceComposer()
    return SignedInfoComposer(reference_composer)


def resolve_signer(certificate, password):
    if not certificate:
        return None
    canonicalizer = Canonicalizer()
    hasher = Hasher()
    encoder = Encoder()
    identifier = Identifier()
    encrypter = Encrypter()
    signature_composer = resolve_signature_composer()
    key_info_composer = KeyInfoComposer()
    object_composer = ObjectComposer()
    qualifying_properties_composer = QualifyingPropertiesComposer()
    signed_properties_composer = SignedPropertiesComposer()
    signed_info_composer = resolve_signed_info_composer()
    signature_value_composer = SignatureValueComposer()
    signer = Signer(
        canonicalizer, hasher, encoder, identifier, encrypter,
        signature_composer, key_info_composer, object_composer,
        qualifying_properties_composer, signed_properties_composer,
        signed_info_composer, signature_value_composer,
        pkcs12_certificate=certificate, pkcs12_password=password)
    return signer
