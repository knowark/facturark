from lxml.etree import Element, SubElement, QName, tostring
from ....utils import make_child
from ..namespaces import NS
from ..composer import Composer


class SignerRoleComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.xades, root_name), nsmap=vars(NS))

        claimed_roles_list = data_dict['claimed_roles']
        claimed_roles = make_child(
            root, QName(NS.xades, "ClaimedRoles"), empty=True)
        for claimed_role_dict in claimed_roles_list:
            make_child(claimed_roles, QName(NS.xades, "ClaimedRole"),
                       claimed_role_dict['claimed_role'])

        return root
