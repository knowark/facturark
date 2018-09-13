import os
from lxml import etree


def parse_xsd(path):
    directory = os.path.dirname(os.path.realpath(__file__))
    xsd_doc = etree.parse(os.path.join(directory, path))
    return etree.XMLSchema(xsd_doc)
