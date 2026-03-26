# from itertools import product
#
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from time import sleep

opts = webdriver.ChromeOptions()
opts.add_experimental_option('detach',True)

driver = webdriver.Chrome(options=opts)
#
driver.get('https://testautomationpractice.blogspot.com/')
driver.maximize_window()

# name = driver.find_element(By.ID,'name')
# name.clear()
# name.send_keys('Nikhil')
# sleep(1)
# email = driver.find_element(By.XPATH,'//input[@placeholder="Enter EMail"]')
# email.send_keys('email@yahoo.in')
# sleep(5)
#
# print(name.get_attribute('placeholder'))
# print(name.get_attribute('value'))

# sleep(3)
# search_field = driver.find_element(By.ID,'twotabsearchtextbox')
# search_field.clear()
# search_field.send_keys('samsung s25',Keys.ENTER)

# search_button = driver.find_element(By.ID,'nav-search-submit-button')
# search_button.click()

# driver.find_element(By.ID,'chrome-search').send_keys('shirt')
# driver.find_element(By.XPATH,'//button[@type="submit"]').click()
male= driver.find_element(By.ID,'male')
male.click()
print(male.is_displayed())
print(male.is_enabled())

check= driver.find_element(By.XPATH,'//label[text()="Monday"]/preceding-sibling::input')
check.click()

print(check.is_selected())
monday_checkbox = driver.find_element(By.XPATH,'//input[@id="monday"]/following-sibling::label')
print(monday_checkbox.text)




