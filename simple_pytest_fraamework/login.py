from selenium import webdriver
from selenium.webdriver.common.by import By
from time import sleep

opts = webdriver.ChromeOptions()
opts.add_experimental_option('detach',True)
driver = webdriver.Chrome(options=opts)

driver.get('https://practicetestautomation.com/practice-test-login/')
driver.maximize_window()

username = driver.find_element(By.ID,'username')
username.send_keys('student')
password = driver.find_element(By.ID,'password')
password.send_keys('Password123')
login_button = driver.find_element(By.ID,'submit')
login_button.click()
sleep(5)
logout_button = driver.find_element(By.XPATH,'//a[text()="Log out"]')
logout_button.click()
sleep(3)
assert 'practice-test-login' in driver.current_url, 'did not log out'
print('Logged out successfully')
driver.quit()