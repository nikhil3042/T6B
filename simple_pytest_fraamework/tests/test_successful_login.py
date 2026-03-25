from pages.login_page import LoginPage
from pages.logout_page import LogoutPage


def test_successful_login(setup_and_teardown):
    login_obj = LoginPage(setup_and_teardown)
    logout_obj = LogoutPage(setup_and_teardown)

    login_obj.enter_username('student')
    login_obj.enter_password('Password123')
    login_obj.click_login()

    assert "Successfully" in logout_obj.success_msg(), "Not successful...try again"
    logout_obj.click_logout()