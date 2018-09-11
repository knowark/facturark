import abc

ABC = abc.ABCMeta('ABC', (object,), {'__slots__': ()})  # py2 and py3 compat

class Serializer(ABC):

    @abc.abstractmethod
    def serialize(invoice):
        """Serialize method to be implemented"""
