*** Settings ***
Documentation  opening different browsers
Library  SeleniumLibrary

#Library = it is used to import external libraries that provide keywords.
#Documentation = Description for the entire file or test suite

*** Variables ***
${base_url}  https://www.cricbuzz.com/

*** Test Cases ***
Opening the chrome
    [Documentation]  Opens chrome browser and navigates to cricbuzz
    [Tags]  functional
#[Documentation] = description of test case
#[Tags] = to group test cases so we can run that group of exclude that group of test cases
    Open Browser  ${base_url}  chrome
    Sleep    1s
# can give Sleep  2 minutes 30s, 300ms it takes many time formats
    Maximize Browser Window
    Log To Console    chrome opened
# prints message in console
    Log    chrome opened
# Writes message to log file
    Sleep    1s

    Close Window
    Close Browser
    Close All Browsers

# Close Window: Closes only the current tab/window you are on.
#Example scenario: Chrome opened 3 tabs opened inside it
#If you run: Close Window
#Only the active tab closes.
#Browser stays open with remaining tabs.

#Close Browser: Closes one browser instance completely.
#Example: One Chrome browser opened by test
#Contains multiple tabs
#If you run Close Browser
#Result:
#Entire Chrome instance closes
#All tabs inside it close
#But if:
#You opened Firefox + Chrome in same test:
#only the currently active browser closes.

#Close All Browsers: Closes every browser opened during the test execution.
#Example: Test opened: Chrome, Firefox, Edge
#If you use Close All Browsers
#Result:
#Chrome closed
#Firefox closed
#Edge closed
#Everything shut down.

Open Firefox
    Open Browser  ${base_url}  firefox
    Maximize Browser Window
    Log    opened firefox
    Close Browser

Open Edge
    Open Browser  ${base_url}  edge
    Maximize Browser Window
    Log    opened edge
    Close All Browsers

#I can even open chrome & firefox in headless mode by giving headlesschrome & headlessfirefox




