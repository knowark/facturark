from ..signer import Signer
from ..signer.composers import (
    SignatureComposer, SignatureValueComposer,
    SignedInfoComposer, ReferenceComposer, KeyInfoComposer, ObjectComposer)
from ..signer.composers.xades import (
    QualifyingPropertiesComposer, SignedPropertiesComposer,
    SigningCertificateComposer, SignaturePolicyIdentifierComposer,
    SignerRoleComposer, SignedSignaturePropertiesComposer)
from ..signer import (Canonicalizer, Hasher, Encoder, Identifier,
                      Encrypter, Verifier)


def resolve_signed_properties_composer():
    signing_certificate_composer = SigningCertificateComposer()
    signature_policy_identifier_composer = (
        SignaturePolicyIdentifierComposer())
    signer_role_composer = SignerRoleComposer()
    signed_signature_properties_composer = SignedSignaturePropertiesComposer(
        signing_certificate_composer,
        signature_policy_identifier_composer,
        signer_role_composer)
    return SignedPropertiesComposer(signed_signature_properties_composer)


def resolve_qualifying_properties_composer():
    signed_properties_composer = resolve_signed_properties_composer()
    return QualifyingPropertiesComposer(signed_properties_composer)


def resolve_signature_composer():
    signed_info_composer = resolve_signed_info_composer()
    signature_value_composer = SignatureValueComposer()
    return SignatureComposer(signed_info_composer, signature_value_composer)


def resolve_signed_info_composer():
    reference_composer = ReferenceComposer()
    return SignedInfoComposer(reference_composer)


def resolve_signer(keystore, password):
    if not keystore:
        return None
    canonicalizer = Canonicalizer()
    hasher = Hasher()
    encoder = Encoder()
    identifier = Identifier()
    encrypter = Encrypter()
    signature_composer = resolve_signature_composer()
    key_info_composer = KeyInfoComposer()
    object_composer = ObjectComposer()
    qualifying_properties_composer = resolve_qualifying_properties_composer()
    signed_properties_composer = resolve_signed_properties_composer()
    signed_info_composer = resolve_signed_info_composer()
    signature_value_composer = SignatureValueComposer()
    signer = Signer(
        canonicalizer, hasher, encoder, identifier, encrypter,
        signature_composer, key_info_composer, object_composer,
        qualifying_properties_composer, signed_properties_composer,
        signed_info_composer, signature_value_composer,
        pkcs12_keystore=keystore, pkcs12_password=password)
    return signer


def resolve_verifier():
    canonicalizer = Canonicalizer()
    encoder = Encoder()
    hasher = Hasher()
    encrypter = Encrypter()
    verifier = Verifier(canonicalizer, encoder, hasher, encrypter)
    return verifier
