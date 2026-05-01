*** Settings ***
Resource  ../../resources/common_resorces.robot
Resource    ../../resources/pages/login_page.robot
Resource    ../../resources/pages/home_page.robot

Suite Setup  Load Environment
Test Setup  Open Application
Test Teardown  Close Application

*** Test Cases ***
#TC_01 Logging in on the GullyLabs Website
#    Clicking On Accounts
#    Login To GullyLabs    jepep82926@fengnu.com

TC_01 Successful Login
    [Documentation]  checks if user is able to click on account
    [Tags]  functional

    Clicking On Accounts
    Login To GullyLabs    ${USER_EMAIL}    ${USER_PWD}