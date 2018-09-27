from lxml.etree import Element, SubElement, QName, tostring
from facturark.utils import make_child
from .namespaces import NS
from .composer import Composer


class DebitNoteLineComposer(Composer):

    def __init__(self, amount_composer):
        self.amount_composer = amount_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cac, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, "ID"), data_dict['id'])

        root.append(self.amount_composer.compose(
            data_dict['line_extension_amount'], 'LineExtensionAmount'))

        return root
