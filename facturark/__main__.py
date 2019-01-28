import sys
from .cli import Cli


def main(args):
    args_namespace = Cli().parse(args)
    args_namespace.func(vars(args_namespace))


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main(sys.argv[1:]))
