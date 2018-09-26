from base64 import b64encode


class Encoder:
    def __init__(self):
        pass

    def base64_encode(self, data):
        return b64encode(data)
