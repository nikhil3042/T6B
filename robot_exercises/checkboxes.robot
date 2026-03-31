*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}  https://the-internet.herokuapp.com/

*** Test Cases ***
Handling checkboxes
    Open Browser  ${url}  chrome
    Click Element    xpath=//a[text()="Checkboxes"]
#Clicks on the element
    Page Should Contain Checkbox  xpath=(//input[@type="checkbox"])[1]
#Verifies checkbox locator is found from the current page.
#works like assert
    Select Checkbox    xpath=(//input[@type="checkbox"])[1]
#Selects the checkbox identified by locator.
#Does nothing if checkbox is already selected
    Unselect Checkbox    xpath=(//input[@type="checkbox"])[2]
#Removes the selection of checkbox identified by locator.
#Does nothing if the checkbox is not selected.
    Close Browser

