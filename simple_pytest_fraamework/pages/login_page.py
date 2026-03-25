from selenium.webdriver.common.by import By
from pages.base_page import BasePage


class LoginPage(BasePage):
    usernameloc = (By.ID,'username')
    passwordloc = (By.ID,'password')
    logibutton = (By.ID,'submit')

    def __init__(self,driver):
        super().__init__(driver)

    def enter_username(self,username):
        self.enter_text(self.usernameloc,username)

    def enter_password(self,passkey):
        self.enter_text(self.passwordloc,passkey)

    def click_login(self):
        self.click_button(self.logibutton)
