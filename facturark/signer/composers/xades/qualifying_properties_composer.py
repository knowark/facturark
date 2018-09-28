from lxml.etree import Element, SubElement, QName, tostring
from facturark.utils import make_child
from ..namespaces import NS
from ..composer import Composer


class QualifyingPropertiesComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.xades, root_name),
                       attrib=data_dict['@attributes'], nsmap=vars(NS))

        return root
