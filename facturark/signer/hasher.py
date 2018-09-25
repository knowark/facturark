from hashlib import sha1


class Hasher:
    def __init__(self):
        pass

    def hash(self, data):
        return sha1(data).digest()
