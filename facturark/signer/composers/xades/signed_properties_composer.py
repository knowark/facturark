from lxml.etree import Element, SubElement, QName, tostring
from facturark.utils import make_child
from ..namespaces import NS
from ..composer import Composer


class SignedPropertiesComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.xades, root_name), nsmap=vars(NS))

        signed_properties_id = data_dict.get('@attributes', {}).get('Id')
        if signed_properties_id:
            root.set('Id', signed_properties_id)

        return root