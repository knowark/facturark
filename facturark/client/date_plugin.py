from lxml.etree import tostring, fromstring
from zeep import Plugin


class DatePlugin(Plugin):
    def egress(self, envelope, http_headers, operation, binding_options):
        return envelope, http_headers
