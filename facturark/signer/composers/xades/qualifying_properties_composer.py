from lxml.etree import Element, SubElement, QName, tostring
from ....utils import make_child
from ....namespaces import NS
from ..composer import Composer


class QualifyingPropertiesComposer(Composer):

    def __init__(self, signed_properties_composer):
        self.signed_properties_composer = signed_properties_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.xades, root_name),
                       attrib=data_dict['@attributes'], nsmap=vars(NS))

        signed_properties_dict = data_dict.get('signed_properties')
        if signed_properties_dict:
            root.append(self.signed_properties_composer.compose(
                signed_properties_dict))

        return root
