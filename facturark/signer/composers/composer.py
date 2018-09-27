from lxml.etree import Element, SubElement, QName, tostring
from facturark.utils import make_child
from .namespaces import NS


class Composer:

    def compose(self, data_dict, root_name=None):
        raise NotImplementedError("The 'compose' method should be "
                                  "implemented by subclasses.")

    @property
    def root_name(self):
        return self.__class__.__name__.replace('Composer', '')
