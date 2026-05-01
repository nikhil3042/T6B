*** Settings ***
Library    SeleniumLibrary
Resource    ../../locators/logout_page_locators.robot

*** Keywords ***
Logout From GullyLabs
    [Documentation]  This feature log out from gully labs

    Click Element    ${account_btn}
    Log    clicked on account button
    Log    logout button visible
    Click Element    ${logout_link}
    Log    clicked logout
