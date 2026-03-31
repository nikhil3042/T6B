*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}  https://the-internet.herokuapp.com/

*** Test Cases ***
Drag and Drop
    Open Browser  ${url}  chrome
    Maximize Browser Window

    Click Element    xpath=//a[text()="Drag and Drop"]
    Drag And Drop    id=column-a    id=column-b
    Sleep    1s

    Close Browser

Mouse Hover
    Open Browser  ${url}  chrome
    Maximize Browser Window
    
    Click Element    xpath=//a[text()="Hovers"]
    Mouse Over    xpath=//h5[text()="name: user1"]/ancestor::div[@class="figure"]
    Sleep    1s

    Close Browser
    
Scroll to the element
    Open Browser  ${url}  chrome
    Maximize Browser Window
    Sleep    5s
    Scroll Element Into View    xpath=//a[text()="Status Codes"]
    Sleep    5s

    Close Browser