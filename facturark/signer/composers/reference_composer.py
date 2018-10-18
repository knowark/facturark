from lxml.etree import Element, SubElement, QName, tostring
from ...utils import make_child
from ...namespaces import NS
from .composer import Composer


class ReferenceComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.ds, root_name),
                       data_dict.get('@attributes'),
                       nsmap=vars(NS))

        transforms_list = data_dict.get('transforms')
        if transforms_list:
            transforms = make_child(
                root, QName(NS.ds, 'Transforms'), empty=True)
            for transform_dict in transforms_list:
                make_child(transforms, QName(NS.ds, 'Transform'),
                           attributes=transform_dict.get('@attributes'))

        digest_method_dict = data_dict['digest_method']
        make_child(root, QName(NS.ds, 'DigestMethod'),
                   attributes=digest_method_dict.get('@attributes'))

        make_child(root, QName(NS.ds, 'DigestValue'),
                   data_dict['digest_value'])

        return root
