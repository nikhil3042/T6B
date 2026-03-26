"""
1. Open website (MakeMyTrip)
2. Verify the current url
3. Select trip type → One Way if not selected
4. Enter:
From city,
To city,
Departure date (calendar handling, if next arrow is showing stale element
use action chains by moving to arrow then action.click(ele).perform)
5. Click Search Flights
6. Wait for results page (handle the loading)
7. Fetch me the first flight
"""

from time import sleep
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains

opts = webdriver.ChromeOptions()
opts.add_experimental_option('detach',True)
driver = webdriver.Chrome(options=opts)
wait = WebDriverWait(driver,10)
action = ActionChains(driver)

driver.get('https://www.cleartrip.com/')
driver.maximize_window()

wait.until(EC.visibility_of_element_located((By.XPATH,'(//div[@data-testid="loginPopup"]/div/div[2])[1]'))).click()

assert 'https://www.cleartrip.com/' == driver.current_url, 'URL is wrong'

from_loc = wait.until(EC.visibility_of_element_located((By.XPATH,'//input[@placeholder="Where from?"]')))
from_loc.send_keys('Bengaluru')
sleep(1)
wait.until(EC.element_to_be_clickable((By.XPATH,'(//li[@class="m-1"])[1]'))).click()

to_loc = wait.until(EC.visibility_of_element_located((By.XPATH,'//input[@placeholder="Where to?"]')))
to_loc.send_keys('Jaipur')
sleep(1)
wait.until(EC.element_to_be_clickable((By.XPATH,'(//li[@class="m-1"])[1]'))).click()

departure = wait.until(EC.element_to_be_clickable((By.XPATH,'//div[@data-testid="dateSelectOnward"]')))
departure.click()

month_year = 'August 2026'
date = '30'

while True:

    month_picker = wait.until(EC.visibility_of_element_located((By.XPATH,'(//div[@class="DayPicker-Month"]/div[1]/div)[1]')))
    if month_picker.text == month_year:
        break
    else:
        sleep(1)
        right_arrow = wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR,'div[class="flex-1 ta-right"] svg')))
        action.move_to_element(right_arrow).perform()
        action.click(right_arrow).perform()


date_picker = wait.until(EC.visibility_of_element_located((By.XPATH,f'(//div[text()={date}])[1]')))
date_picker.click()
sleep(2)

search_flight = wait.until(EC.element_to_be_clickable((By.XPATH,'//h4[text()="Search flights"]/ancestor::button')))
search_flight.click()

flight = driver.find_element(By.XPATH,'//div[@class="sc-aXZVg dczbns mb-2 bg-white"]')
print(flight.text)

sleep(2)
driver.quit()

