from time import sleep
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

driver = webdriver.Chrome()

driver.get('https://the-internet.herokuapp.com/javascript_alerts')
driver.maximize_window()
sleep(2)

#simple alert
# driver.find_element(By.XPATH,'//button[@onclick="jsAlert()"]').click()
# sleep(2)
# alert  = driver.switch_to.alert
# alert.accept()
# sleep(2)

#confirmation alert
# driver.find_element(By.XPATH,'//button[@onclick="jsConfirm()"]').click()
# sleep(2)
# alert  = driver.switch_to.alert
# alert.accept()
# alert.dismiss()
# sleep(2)

#prompt alert
# driver.find_element(By.XPATH,'//button[@onclick="jsPrompt()"]').click()
# sleep(2)
# alert  = driver.switch_to.alert
# alert.send_keys('qwerty')
#
# # alert.accept()
# alert.dismiss()
# sleep(2)

#switching to alert using waits
wait = WebDriverWait(driver,10)

driver.find_element(By.XPATH,'//button[@onclick="jsAlert()"]').click()
alert = wait.until(EC.alert_is_present())
sleep(2)
alert.accept()
sleep(2)
