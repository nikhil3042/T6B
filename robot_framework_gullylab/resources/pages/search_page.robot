*** Settings ***
Library    SeleniumLibrary
Resource  ../../locators/home_page_locators.robot

*** Keywords ***
Search a product
    [Arguments]  ${product}
    Click Element    ${search_button}
    Sleep    2s
    Input Text    ${search_field}    ${product}
    Sleep    2s
    Press Keys  ${search_field}  ENTER