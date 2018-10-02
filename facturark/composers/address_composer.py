from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from .namespaces import NS
from .composer import Composer


class AddressComposer(Composer):

    def compose(self, data_dict, root_name="Address"):
        root = Element(QName(NS.fe, root_name), nsmap=vars(NS))

        make_child(root, QName(NS.cbc, "Department"),
                   data_dict.get('department'), required=False)
        make_child(root, QName(NS.cbc, "CityName"),
                   data_dict.get('city_name'), required=False)

        if data_dict.get('address_line'):
            address_line = make_child(root, QName(NS.cac, "AddressLine"),
                                      required=False, empty=True)
            make_child(address_line, QName(NS.cbc, "Line"),
                       data_dict.get('address_line').get('line'),
                       required=False)

        if data_dict.get('country'):
            country = make_child(root, QName(NS.cac, "Country"),
                                 required=False, empty=True)
            make_child(country, QName(NS.cbc, "IdentificationCode"),
                       data_dict.get('country').get('identification_code'),
                       required=False)

        return root
