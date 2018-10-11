from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from .namespaces import NS
from .composer import Composer


class ExtensionComposer(Composer):

    def __init__(self, dian_extensions_composer):
        self.content_composer_dict = {
            'dian_extensions': dian_extensions_composer
        }

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.ext, root_name), nsmap=vars(NS))

        extension_content_dict = data_dict['extension_content']
        extension_content = make_child(
            root, QName(NS.ext, 'ExtensionContent'), empty=True)

        for key, content_dict in extension_content_dict.items():
            content_composer = self.content_composer_dict[key]
            extension_content.append(content_composer.compose(content_dict))

        return root
