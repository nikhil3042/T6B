*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}=  https://the-internet.herokuapp.com/windows

*** Test Cases ***
Handling Windows
    Open Browser  ${url}  chrome
    Maximize Browser Window
    Click Element    xpath=//a[text()="Click Here"]

    ${windows}=  Get Window Handles
#gets all window handles

    Switch Window  NEW
#Switches to newly opened window
#Shortcut keyword: NEW → latest window
    Title Should Be    New Window
#Verifies the title of new window

    Switch Window  ${windows}[0]
#Switches to parent window by indexing

#alternative ways are by tittle and url
#    Switch Window  title=<title>
#    Switch Window  url=<url>

    Go To    https://www.cricbuzz.com/
#Go To : Opens new URL in same window

    Close Browser