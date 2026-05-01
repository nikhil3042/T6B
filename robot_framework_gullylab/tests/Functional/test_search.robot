*** Settings ***
Resource    ../../resources/common_resorces.robot
Resource  ../../resources/pages/home_page.robot
Resource  ../../resources/pages/login_page.robot
Resource  ../../resources/pages/search_page.robot

Suite Setup  Load Environment
Test Setup  Open Application
Test Teardown  Close Application

*** Test Cases ***
TC_03 Search a Product
    [Documentation]  Searches a product on GullyLabs
    [Tags]  functional
    Clicking On Accounts
    Sleep    2s
    Login To GullyLabs    ${USER_EMAIL}    ${USER_PWD}
    Sleep    2s
    Search a product  Shoes
