from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class PartyTaxSchemeComposer(Composer):

    def compose(self, data_dict, root_name='PartyTaxScheme'):
        root = Element(
            QName(NS.fe, root_name), nsmap=vars(NS))

        for tax_level_code in data_dict.get("tax_level_code"):
            make_child(root, QName(NS.cbc, 'TaxLevelCode'),
                       tax_level_code, required=False)

        # TODO: Make them required
        make_child(root, QName(NS.cac, 'RegistrationName'),
                   required=True, empty=True)
        make_child(root, QName(NS.cac, 'RegistrationAddress'),
                   required=True, empty=True)
        make_child(root, QName(NS.cac, 'CompanyID'),
                   required=True, empty=True)
        make_child(root, QName(NS.cac, 'TaxScheme'),
                   required=False, empty=True)

        return root
