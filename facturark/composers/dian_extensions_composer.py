from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from .namespaces import NS
from .composer import Composer


class DianExtensionsComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.sts, root_name), nsmap=vars(NS))

        invoice_source = make_child(
            root, QName(NS.sts, "InvoiceSource"), empty=True)
        make_child(invoice_source, QName(NS.cbc, "IdentificationCode"),
                   data_dict['invoice_source']['identification_code'])

        software_provider = make_child(
            root, QName(NS.sts, "SoftwareProvider"), empty=True)
        make_child(software_provider, QName(NS.sts, "ProviderID"),
                   data_dict['software_provider']['provider_id'])
        make_child(software_provider, QName(NS.sts, "SoftwareID"),
                   data_dict['software_provider']['software_id'])

        make_child(root, QName(NS.sts, "SoftwareSecurityCode"),
                   data_dict['software_security_code'])

        return root
