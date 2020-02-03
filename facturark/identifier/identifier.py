from hashlib import sha1
from lxml.etree import fromstring, tostring, Element, QName
from ..namespaces import NS


class Identifier:
    def identify(self, document):
        raise NotImplementedError(
            'This method should be implemented for each document.')


class BlankIdentifier(Identifier):

    def identify(self, document):
        return ''
