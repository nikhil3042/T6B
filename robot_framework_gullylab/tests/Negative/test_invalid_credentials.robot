*** Settings ***
Resource  ../../resources/pages/login_page.robot
Resource  ../../resources/common_resorces.robot
Resource    ../../resources/pages/home_page.robot

Suite Setup  Load Environment
Test Setup  Open Application
Test Teardown  Close Application

*** Test Cases ***
TC_07 Login with invalid credentials
    Clicking On Accounts
    Sleep    2s
    Login To GullyLabs    kjebfkeb@gmail.com    1234567890
    Page Should Contain    Incorrect email or password