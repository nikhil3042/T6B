import pytest
from selenium import webdriver

@pytest.fixture
def setup_and_teardown():
    driver = webdriver.Chrome()

    driver.get('https://practicetestautomation.com/practice-test-login/')
    driver.maximize_window()

    yield driver

    driver.quit()