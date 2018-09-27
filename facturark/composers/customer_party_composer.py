from lxml.etree import Element, QName
from facturark.utils import make_child
from .namespaces import NS
from .composer import Composer


class CustomerPartyComposer(Composer):

    def __init__(self, party_composer):
        self.party_composer = party_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, 'AdditionalAccountID'),
                   str(int(data_dict['additional_account_id'])))

        root.append(
            self.party_composer.compose(
                data_dict['party']))

        return root
