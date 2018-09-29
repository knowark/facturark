from uuid import uuid4


class Identifier:

    def generate_id(self, uuid="", suffix="", prefix="xmldsig"):
        tokens_list = []
        if prefix:
            tokens_list.append(prefix)

        if not uuid:
            uuid = str(uuid4())
        tokens_list.append(uuid)

        if suffix:
            tokens_list.append(suffix)
        return "-".join(tokens_list)
