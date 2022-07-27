
from src.hello import hello,bye
import pytest

# Adding comment to see if Jenkins is triggered by new push
def test_hello():
    output = hello()
    assert output == "Hello"

def test_bye():
    output = bye()
    assert output == "Bye"

def test_name(): # Fail on purpose to trigger Jenkins to copy and publish Results.xml
    output = hello()
    assert output == "bob"