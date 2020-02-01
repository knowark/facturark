from .composer import Composer


def resolve_composer(namespaces=None):
    return Composer(namespaces=namespaces)
