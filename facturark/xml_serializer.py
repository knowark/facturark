from facturark.serializer import Serializer


class XmlSerializer(Serializer):

    def __init__(self):
        pass

    def serialize(self, invoice):
        return "<invoice></invoice>"
