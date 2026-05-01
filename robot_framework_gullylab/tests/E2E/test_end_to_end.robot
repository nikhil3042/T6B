*** Settings ***
Resource  ../../resources/pages/cart_page.robot
Resource  ../../resources/pages/search_page.robot
Resource  ../../resources/pages/home_page.robot
Resource  ../../resources/pages/login_page.robot
Resource  ../../resources/common_resorces.robot
Resource    ../../resources/pages/logout_page.robot
Resource    ../../resources/pages/close_cart_page.robot

Suite Setup  Load Environment
Test Setup  Open Application
Test Teardown  Close Application

*** Test Cases ***
TC_06 Complete End To End Testing
    Clicking On Accounts
    Sleep    2s
    Login To GullyLabs    ${USER_EMAIL}    ${USER_PWD}
    Sleep    2s
    Search a product    Shoes
    Sleep    2s
    Add To Cart
    Close Cart
    Clicking On Accounts
    Sleep    2s
    Logout From GullyLabs
