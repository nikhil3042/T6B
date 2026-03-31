*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}=  https://demo.automationtesting.in/Frames.html

*** Test Cases ***
Handling Single Iframe
    Open Browser  ${url}  chrome
    Select Frame    xpath=//iframe[@src="SingleFrame.html"]
#Select frame switches the control to iframe
    Input Text    xpath=(//input[@type="text"])[1]    Nik

    Unselect Frame
    Close Browser

Handling Nested Iframe
    Open Browser  ${url}  chrome
    Click Element    xpath=//a[text()="Iframe with in an Iframe"]

    Select Frame    xpath=//iframe[@src="MultipleFrames.html"]
    Select Frame    xpath=//iframe[@src="SingleFrame.html"]

    Input Text    xpath=//input[@type="text"]    Nik

    Unselect Frame
    Unselect Frame
#Unselect Frame switches the control back to the parent frame
    Close Browser