from lxml import etree
from zeep import Transport
from zeep.wsdl.utils import etree_to_string


class SoapTransport(Transport):

    def post_xml(self, address, envelope, headers):
        message = etree_to_string(envelope)
        response = self.post(address, message, headers)
        content_type = response.headers['Content-Type']
        response.headers['Content-Type'] = content_type.replace(
            "Multipart/Related", "multipart/related")

        return response
