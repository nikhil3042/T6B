*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}  https://the-internet.herokuapp.com/javascript_alerts
${text}  Kitkat shake

*** Test Cases ***
Handling JS Alert
    Open Browser  ${url}  chrome
    Maximize Browser Window
    Click Button    Click for JS Alert

    Handle Alert
#by default handle alert will wait for alert and accept by default
    ${result}=  Get Text    id=result
# Get Text will give us the inner text
    Log To Console    ${result}

    Page Should Contain    ${result}
#page should contain works as assert
    Close Browser

Handling JS Confirm
    Open Browser  ${url}  chrome
    Maximize Browser Window
    Click Button    Click for JS Confirm
#to accept
    Handle Alert
#to cancel
#    Handle Alert  action=DISMISS

    ${result}=  Get Text    id=result
    Log To Console    ${result}

    Page Should Contain    You clicked: Ok
#    Page Should Contain    You clicked: Cancel
    Close Browser

Handling JS Prompt
    Open Browser  ${url}  chrome
    Maximize Browser Window

    Click Button    xpath=//button[text()="Click for JS Prompt"]
#to accept
#    Input Text Into Alert    ${text}
#to cancel
    Input Text Into Alert    ${text}  action=DISMISS
#Input Text Into Alert will handle the alert and enter text
    ${result}=  Get Text    id=result
    Log To Console    ${result}

#    Page Should Contain    You entered: ${text}
    Page Should Contain    You entered: null
    Close Browser