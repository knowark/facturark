from lxml.etree import Element, SubElement, QName, tostring
from ....utils import make_child
from ..namespaces import NS
from ..composer import Composer


class SignedSignaturePropertiesComposer(Composer):

    def __init__(self, signing_certificate_composer,
                 signature_policy_identifier_composer,
                 signer_role_composer):
        self.signing_certificate_composer = signing_certificate_composer
        self.signature_policy_identifier_composer = (
            signature_policy_identifier_composer)
        self.signer_role_composer = signer_role_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.xades, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.xades, "SigningTime"),
                   data_dict['signing_time'])

        signing_certificate_dict = data_dict['signing_certificate']
        root.append(self.signing_certificate_composer.compose(
            signing_certificate_dict))

        signature_policy_identifier_dict = data_dict[
            'signature_policy_identifier']
        root.append(self.signature_policy_identifier_composer.compose(
            signature_policy_identifier_dict))

        signer_role_dict = data_dict['signer_role']
        root.append(self.signer_role_composer.compose(
            signer_role_dict))

        return root
