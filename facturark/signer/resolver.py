from facturark.signer.composers import (
    SignatureComposer, SignatureValueComposer,
    SignedInfoComposer, ReferenceComposer)


def resolve_signature_composer():
    signed_info_composer = resolve_signed_info_composer()
    signature_value_composer = SignatureValueComposer()
    return SignatureComposer(signed_info_composer, signature_value_composer)


def resolve_signed_info_composer():
    reference_composer = ReferenceComposer()
    return SignedInfoComposer(reference_composer)
