class Invoice:
    def __init__(self, **kwargs):
        self.type = ""
        self.__dict__.update(kwargs)
