*** Settings ***
Library    SeleniumLibrary
Resource    ../../locators/cart_page_locators.robot

*** Keywords ***
Close Cart
    Wait Until Element Is Enabled    ${close_cart_btn}
    Click Element    ${close_cart_btn}