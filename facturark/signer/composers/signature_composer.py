from lxml.etree import Element, SubElement, QName, tostring
from facturark.utils import make_child
from .namespaces import NS
from .composer import Composer


class SignatureComposer(Composer):

    def __init__(self, signed_info_composer, signature_value_composer):
        self.signed_info_composer = signed_info_composer
        self.signature_value_composer = signature_value_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.ds, root_name),
                       attrib=data_dict.get('@attributes'), nsmap=vars(NS))

        if data_dict.get('signed_info'):
            root.append(self.signed_info_composer.compose(
                data_dict['signed_info']))

        if data_dict.get('signature_value'):
            root.append(self.signature_value_composer.compose(
                data_dict['signature_value']))

        return root

    def inject_in_document(self, document_element, signature_element):
        path = './/ext:UBLExtensions/ext:UBLExtension[2]/ext:ExtensionContent'
        extension_content = document_element.find(path, vars(NS))
        extension_content.append(signature_element)
        return document_element
