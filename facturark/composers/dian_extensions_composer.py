from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS
from .composer import Composer


class DianExtensionsComposer(Composer):

    def compose(self, data_dict, root_name=None):
        root_name = root_name or self.root_name
        root = Element(QName(NS.sts, root_name), nsmap=vars(NS))

        invoice_control = make_child(
            root, QName(NS.sts, "InvoiceControl"), empty=True)
        make_child(invoice_control, QName(NS.sts, "InvoiceAuthorization"),
                   data_dict['invoice_control']['invoice_authorization'])

        authorization_period_dict = (
            data_dict['invoice_control']['authorization_period'])
        authorization_period = make_child(
            invoice_control, QName(NS.sts, "AuthorizationPeriod"), empty=True)
        make_child(authorization_period, QName(NS.cbc, "StartDate"),
                   authorization_period_dict['start_date'])
        make_child(authorization_period, QName(NS.cbc, "EndDate"),
                   authorization_period_dict['end_date'])

        authorized_invoices_dict = (
            data_dict['invoice_control']['authorized_invoices'])
        authorized_invoices = make_child(
            invoice_control, QName(NS.sts, "AuthorizedInvoices"), empty=True)
        make_child(authorized_invoices, QName(NS.sts, "Prefix"),
                   authorized_invoices_dict.get('prefix'), required=False)
        make_child(authorized_invoices, QName(NS.sts, "From"),
                   authorized_invoices_dict['from'])
        make_child(authorized_invoices, QName(NS.sts, "To"),
                   authorized_invoices_dict['to'])

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
