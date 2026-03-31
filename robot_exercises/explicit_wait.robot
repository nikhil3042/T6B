#Wait For Expected Condition = Uses Selenium Expected Conditions.
#eg:
#Wait For Expected Condition    element_to_be_clickable    xpath=//button[@id="submit"]

#Wait Until Element Is Enabled = Waits until the element becomes enabled (clickable).
#eg:
#Wait Until Element Is Enabled    id=submitBtn
#Click Button    id=submitBtn

#Wait Until Element Is Not Visible = Waits until an element disappears from the page.
#eg:
#Wait Until Element Is Not Visible    id=loadingSpinner [Waits until loading spinner disappears.]

#Wait Until Element Is Visible = Waits until the element becomes visible.
#eg:
#Wait Until Element Is Visible    id=loginBtn
#Click Button    id=loginBtn  [Prevents clicking before the element appears.]

#Wait Until Location Contains = Waits until the URL contains specific text.
#eg:
#Wait Until Location Contains    dashboard [https://site.com/dashboard/home : Useful after login redirect.]

#Wait Until Location Does Not Contain = Waits until URL no longer contains text.
#eg:
#Wait Until Location Does Not Contain    login [Used after leaving login page.]

#Wait Until Location Is = Waits until the URL exactly matches.
#eg:
#Wait Until Location Is    https://example.com/home

#Wait Until Page Contains = Waits until text appears anywhere on the page.
#eg:
#Wait Until Page Contains    Welcome
#Waits until "Welcome" appears.

#Wait Until Page Contains Element =  Waits until a specific element appears.
#eg:
#Wait Until Page Contains Element    xpath=//input[@id="username"]

#Wait Until Page Does Not Contain = Waits until text disappears from page.
#eg:
#Wait Until Page Does Not Contain    Loading...

#Wait Until Page Does Not Contain Element = Waits until element disappears.
#eg:
#Wait Until Page Does Not Contain Element    id=loadingSpinner


*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}=  https://practicetestautomation.com/practice-test-login/

*** Test Cases ***
Explicit wait example
    Open Browser  ${url}  chrome
    
    Wait Until Element Is Visible    id=username
    Input Text    id=username  student
    
    Wait Until Element Is Visible    id=password
    Input Text    id=password    Password123
    
    Wait Until Element Is Enabled    id=submit
    Click Element    id=submit
    
    Wait Until Location Contains    logged-in-successfully
    
    Close Browser