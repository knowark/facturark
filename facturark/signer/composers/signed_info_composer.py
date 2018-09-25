from lxml.etree import Element, SubElement, QName, tostring
from .namespaces import NS
from .composer import Composer
from .utils import make_child


class SignedInfoComposer(Composer):

    def __init__(self, reference_composer):
        self.reference_composer = reference_composer

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.ds, root_name), nsmap=vars(NS))

        canonicalization_method_dict = data_dict['canonicalization_method']
        make_child(root, QName(NS.ds, 'CanonicalizationMethod'),
                   attributes=canonicalization_method_dict.get('@attributes'))

        signature_method_dict = data_dict['signature_method']
        make_child(root, QName(NS.ds, 'SignatureMethod'),
                   attributes=signature_method_dict.get('@attributes'))

        reference_list = data_dict['references']
        for reference_dict in reference_list:
            root.append(self.reference_composer.compose(reference_dict))

        return root
