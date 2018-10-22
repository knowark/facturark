from lxml.etree import tostring, fromstring
from zeep import Plugin


class DatePlugin(Plugin):

    def egress(self, envelope, http_headers, operation, binding_options):
        serialized_envelope = tostring(envelope).replace(b'000-', b'-')
        envelope = fromstring(serialized_envelope)
        print(tostring(envelope, pretty_print=True))
        return envelope, http_headers
