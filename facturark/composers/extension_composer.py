from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class ExtensionComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.ext, root_name), nsmap=vars(NS))

        extension_content = data_dict['extension_content']
        make_child(root, QName(NS.ext, 'ExtensionContent'), empty=True)

        return root
