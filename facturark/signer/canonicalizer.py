from lxml.etree import tostring, fromstring, cleanup_namespaces
from ..namespaces import NS


class Canonicalizer:

    def canonicalize(self, element):
        document = tostring(element, method='c14n', with_comments=False)
        return document
    
    def clean(self, element):
        cleanup_namespaces(element)
        return element

    def parse(self, document):
        element = fromstring(document)
        return element
    
    

