from abc import ABC, abstractmethod


class Serializer(ABC):

    @abstractmethod
    def serialize(invoice):
        """Serialize method to be implemented"""
