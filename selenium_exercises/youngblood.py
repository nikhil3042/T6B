from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

opts = webdriver.ChromeOptions()
opts.add_experimental_option('detach',True)

driver = webdriver.Chrome(options=opts)

driver.get('https://abc.com/')
driver.maximize_window()

wait = WebDriverWait(driver,10)

images = wait.until(EC.presence_of_all_elements_located((By.XPATH,'//section[@class="tilegroup tilegroup--homehero tilegroup--landscape"]/descendant::picture//img')))

for image_link in images:
    print(image_link.get_attribute('src'))

loading_symbol = wait.until(EC.invisibility_of_element_located((By.CSS_SELECTOR,'svg[id="preloader-animated_svg__svg3"]')))

show_subtitle = wait.until(EC.visibility_of_element_located((By.XPATH,'//span[text()="ABC SHOWS, SPECIALS & MORE"]')))

assert "ABC SHOWS, SPECIALS & MORE" in show_subtitle.text, 'Our script is not working'

print('YAYYYYYYYYYYYY')
driver.quit()


# case1: Does not combine
# driver.implicitly_wait(10)
#
# loader = driver.find_element(By.ID, "loading")
#
# WebDriverWait(driver, 10).until(EC.visibility_of_element(loader))


# case2: Does combine Internally
# driver.implicitly_wait(10)
#
# WebDriverWait(driver, 10).until(
#     EC.visibility_of_element_located((By.ID, "loading")))



