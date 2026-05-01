*** Settings ***
Library  SeleniumLibrary
Resource  ../../locators/home_page_locators.robot

*** Keywords ***
Clicking On Accounts
    Click Element    ${account}
Clicking On Search
    Click Element    ${search_button}