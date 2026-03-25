from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

class BasePage:
    def __init__(self,driver):
        self.driver = driver
        self.wait = WebDriverWait(driver,5)

    def find_ele(self,locator):
        return self.wait.until(EC.visibility_of_element_located(locator))

    def enter_text(self,locator,text):
        element = self.wait.until(EC.visibility_of_element_located(locator))
        element.send_keys(text)

    def click_button(self,locator):
        self.wait.until(EC.element_to_be_clickable(locator)).click()