import hashlib


class Hasher:
    def __init__(self):
        self.algorithms = {
            "http://www.w3.org/2001/04/xmlenc#sha512": 'sha512',
            "http://www.w3.org/2001/04/xmlenc#sha256": 'sha256',
            "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256": 'sha256',
            "http://www.w3.org/2000/09/xmldsig#sha1": 'sha1'
        }

    def hash(self, data, algorithm="http://www.w3.org/2001/04/xmlenc#sha256"):
        hash_name = self.algorithms.get(algorithm)
        hash_function = getattr(hashlib, hash_name)
        return hash_function(data).digest()
