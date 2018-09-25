from lxml.etree import tostring


class Canonicalizer:

    def canonicalize(self, element):
        document = tostring(element, method='c14n')
        return document
