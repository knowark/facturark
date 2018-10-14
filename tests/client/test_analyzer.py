

def test_analyzer_get_supplier_vat(analyzer, document):

    result = analyzer.get_supplier_vat(document)

    assert result == '900373115'


def test_analyzer_get_document_number(analyzer, document):

    result = analyzer.get_document_number(document)

    assert result == '980007161'


def test_analyzer_get_issue_date(analyzer, document):

    result = analyzer.get_issue_date(document)

    assert result == '2016-07-12T00:31:40'
