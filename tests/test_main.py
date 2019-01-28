import facturark.__main__
from pytest import raises
from facturark.__main__ import main


def test_main(monkeypatch):
    test_dict = {
        'call_dict': None
    }

    def mock_parse(self, args):
        class MockNamespace:
            def __init__(self):
                self.field = 'value'

            def func(self, options_dict):
                test_dict['call_dict'] = options_dict
        return MockNamespace()

    monkeypatch.setattr(facturark.__main__.Cli, 'parse', mock_parse)

    args = ['build', 'invoice.json', '-o', 'invoice.xml']
    main(args)

    assert isinstance(test_dict['call_dict'], dict)
    assert test_dict['call_dict'] == {'field': 'value'}
