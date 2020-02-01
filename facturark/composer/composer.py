from lxml.etree import Element, SubElement, QName, tostring
from ..utils import make_child
from ..namespaces import NS


class Composer:

    def compose(self, obj):
        """Compose XML element from obj dict."""
        tag, content = next(iter(obj.items()))
        root = self._build(Element(tag), content)
        return root

    def _build(self, parent, item):
        """Recursively build XML element from item object."""
        if isinstance(item, (int, float)):
            item = str(item)

        if isinstance(item, str):
            parent.text = item
            return parent

        elif isinstance(item, dict):
            text = item.pop("#", None)
            if text is not None:
                parent.text = text

            attributes = item.pop("&", {})
            for attribute, value in attributes.items():
                parent.set(attribute, value)

            for tag, content in item.items():
                if not isinstance(content, (list, tuple)):
                    content = [content]
                for line in content:
                    element = Element(tag)
                    parent.append(self._build(element, line))

        return parent
