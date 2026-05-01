*** Settings ***
Resource  ../../resources/pages/cart_page.robot
Resource  ../../resources/pages/search_page.robot
Resource  ../../resources/pages/home_page.robot
Resource  ../../resources/pages/login_page.robot
Resource  ../../resources/common_resorces.robot

Suite Setup  Load Environment
Test Setup  Open Application
Test Teardown  Close Application

*** Test Cases ***
TC_04 Add product to cart
    Clicking On Accounts
    Login To GullyLabs    ${USER_EMAIL}    ${USER_PWD}
    Search a product    Shoes
    Add To Cart