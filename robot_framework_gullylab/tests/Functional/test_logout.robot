*** Settings ***
Resource    ../../resources/pages/logout_page.robot
Resource    ../../resources/common_resorces.robot
Resource    ../../resources/pages/login_page.robot
Resource    ../../resources/pages/home_page.robot

Suite Setup    Load Environment
Test Setup    Open Application
Test Teardown    Close Application

*** Test Cases ***
TC_02 Logout Successful
    [Documentation]  This feature logout user from the gully labs
    [Tags]    Functional
    Clicking On Accounts
    Login To GullyLabs    ${USER_EMAIL}  ${USER_PWD}
    Sleep    5s
    Logout From GullyLabs
