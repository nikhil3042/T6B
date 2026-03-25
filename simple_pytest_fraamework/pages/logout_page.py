from selenium.webdriver.common.by import By
from pages.base_page import BasePage


class LogoutPage(BasePage):
    logoutbutton = (By.XPATH,'//a[text()="Log out"]')
    successtext = (By.XPATH,'//h1[text()="Logged In Successfully"]')

    def __init__(self,driver):
        super().__init__(driver)

    def success_msg(self):
        txt = self.find_ele(self.successtext)
        return txt.text

    def click_logout(self):
        self.click_button(self.logoutbutton)

