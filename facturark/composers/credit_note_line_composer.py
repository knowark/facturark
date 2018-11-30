from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class CreditNoteLineComposer(Composer):

    def __init__(self, amount_composer):
        self.amount_composer = amount_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.cac, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, "ID"), data_dict['id'])
        make_child(root, QName(NS.cbc, "UUID"), data_dict['uuid'])

        root.append(
            self.amount_composer.compose(data_dict['line_extension_amount'],
                                         'LineExtensionAmount'))

        discrepancy_response_dict = data_dict['discrepancy_response']
        discrepancy_response = make_child(
            root, QName(NS.cac, "DiscrepancyResponse"), empty=True)
        make_child(discrepancy_response, QName(NS.cbc, "ReferenceID"),
                   empty=True)
        make_child(discrepancy_response, QName(NS.cbc, "ResponseCode"),
                   discrepancy_response_dict['response_code'])

        return root
