from lxml.etree import SubElement


# def make_child(parent, tag, text=None, attributes=None, required=True):
#     if required and not (text or attributes):
#         raise ValueError("The <{}> tag is required".format(tag))

#     child = SubElement(parent, tag, attributes)

#     if text:
#         child.text = text

#     return child


def make_child(parent, tag, text=None, attributes=None,
               required=True, empty=False):
    if empty and (text or attributes):
        raise ValueError("The <{}> tag should be empty but text "
                         "or attributes were given.".format(tag))

    if (required and not empty) and not (text or attributes):
        raise ValueError("The <{}> tag is required".format(tag))

    child = SubElement(parent, tag, attributes)

    if text:
        child.text = text

    return child
