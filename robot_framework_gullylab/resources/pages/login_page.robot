*** Settings ***
Resource  ../../locators/login_page_locators.robot
Resource  ../common_resorces.robot

*** Keywords ***
Login To GullyLabs
    [Arguments]  ${email}  ${password}
    Input Text    ${email_field}    ${email}
    Input Text    ${password_field}  ${password}
    Wait Until Element Is Enabled    ${sign_in_button}
    Click Element    ${sign_in_button}
    
#    Page Should Contain    Account
#    Page Should Contain Element    xpath=//a[text()="Log out"]