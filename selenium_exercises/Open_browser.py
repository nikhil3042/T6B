from selenium import webdriver
from selenium.webdriver.common.by import By
from time import sleep

driver = webdriver.Chrome()

driver.get("https://testautomationpractice.blogspot.com/")
sleep(2)
# driver.get("https://www.cricbuzz.com/")
# sleep(2)
# driver.get("https://www.myntra.com/")
# sleep(2)

# //span[text()="All"]/ancestor::div[@id="nav-main"]
# //div[@id="nav-main"]/descendant::span[text()="All"]

# //a[text()="Fresh"]/ancestor::li/following-sibling::li[1]
driver.find_element(By.LINK_TEXT,"Udemy Courses")
print('i found the element using link text')

driver.find_element(By.PARTIAL_LINK_TEXT,"Udemy")
print('i found the element using partial-link text')
