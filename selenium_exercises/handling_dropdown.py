from time import sleep
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.select import Select

driver = webdriver.Chrome()

driver.get('https://testautomationpractice.blogspot.com/')
driver.maximize_window()

country_dropdown = driver.find_element(By.ID,'country')
dropdown = Select(country_dropdown)

dropdown.select_by_value('australia')
sleep(2)
dropdown.select_by_index(5)
sleep(2)
dropdown.select_by_visible_text('Japan')
sleep(10)
