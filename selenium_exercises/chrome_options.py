from selenium import webdriver
from time import sleep

opts = webdriver.ChromeOptions()

opts.add_experimental_option('detach',True)
opts.add_argument('--headless')
opts.add_argument('--incognito')
opts.add_argument('--disable_notifications')

driver = webdriver.Chrome(options = opts)

driver.get('https://cornerhouseicecreams.com/')
driver.maximize_window()
print(f'current url is > {driver.current_url}')
print(f'title of the page is > {driver.title}')
sleep(5)

driver.quit()

