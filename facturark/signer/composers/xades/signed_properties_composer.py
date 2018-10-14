from lxml.etree import Element, SubElement, QName, tostring
from ....utils import make_child
from ....namespaces import NS
from ..composer import Composer


class SignedPropertiesComposer(Composer):

    def __init__(self, signed_signature_properties_composer):
        self.signed_signature_properties_composer = (
            signed_signature_properties_composer)

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.xades, root_name), nsmap=vars(NS))

        signed_properties_id = data_dict.get('@attributes', {}).get('Id')
        if signed_properties_id:
            root.set('Id', signed_properties_id)

        signed_signature_properties_dict = data_dict[
            'signed_signature_properties']
        root.append(self.signed_signature_properties_composer.compose(
            signed_signature_properties_dict))

        return root
