from lxml.etree import tostring, fromstring
from zeep import Plugin


class DatePlugin(Plugin):
    def egress(self, envelope, http_headers, operation, binding_options):
        serialized_envelope = tostring(
            envelope).replace(b'2018-11-20T23:21:04', b'2018-11-20T23:21:04')
        envelope = fromstring(serialized_envelope)
        return envelope, http_headers
