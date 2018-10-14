from lxml.etree import tostring
from ..namespaces import NS


class Canonicalizer:

    def canonicalize(self, element):
        document = tostring(element, method='c14n', with_comments=False)
        return document
