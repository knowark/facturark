from pytest import raises
from facturark.validator import Reviewer


def test_reviewer_review(reviewer, invoice):
    result = reviewer.review(invoice)
    assert result is True


def test_reviewer_review_credit_note(reviewer, credit_note):
    result = reviewer.review(credit_note)
    assert result is True


def test_reviewer_check(reviewer, invoice):
    valid_values = {'A': 1, 'B': 2, 'C': 3}
    given_value = 'A'
    result = reviewer.check(valid_values, given_value)
    assert result is None


def test_reviewer_check_raise_error(reviewer, invoice):
    valid_values = {'A': 1, 'B': 2, 'C': 3}
    given_value = 'X'
    message = 'Invalid value: {}'.format(given_value)
    with raises(ValueError):
        reviewer.check(valid_values, given_value, message)


def test_reviewer_check_lower_raise_error(reviewer, invoice):
    upper_limit = 14
    given_value = 15
    message = 'Invalid value: {}'.format(given_value)
    with raises(ValueError):
        reviewer.check_lower(upper_limit, given_value, message)
