from lxml.etree import Element, SubElement, QName, tostring
from ....utils import make_child
from ....namespaces import NS
from ..composer import Composer


class SignaturePolicyIdentifierComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.xades, root_name), nsmap=vars(NS))

        signature_policy_id_dict = data_dict['signature_policy_id']
        signature_policy_id = make_child(
            root, QName(NS.xades, "SignaturePolicyId"), empty=True)

        sig_policy_id_dict = signature_policy_id_dict['sig_policy_id']
        sig_policy_id = make_child(
            signature_policy_id, QName(NS.xades, "SigPolicyId"), empty=True)
        make_child(sig_policy_id, QName(NS.xades, "Identifier"),
                   sig_policy_id_dict['identifier'])
        print('SIG====>>>>', sig_policy_id_dict['description'])
        make_child(sig_policy_id, QName(NS.xades, "Description"),
                   sig_policy_id_dict['description'])
        
        print(tostring(root))

        sig_policy_hash_dict = signature_policy_id_dict['sig_policy_hash']
        sig_policy_hash = make_child(
            signature_policy_id, QName(NS.xades, "SigPolicyHash"), empty=True)
        make_child(
            sig_policy_hash, QName(NS.ds, "DigestMethod"),
            attributes=sig_policy_hash_dict['digest_method']['@attributes'])
        make_child(sig_policy_hash, QName(NS.ds, "DigestValue"),
                   sig_policy_hash_dict['digest_value'])

        return root
