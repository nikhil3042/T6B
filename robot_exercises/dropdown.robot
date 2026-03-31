*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}  https://the-internet.herokuapp.com/
${dropdown_locator}  id=dropdown

*** Test Cases ***
Handling Dropdown
    Open Browser  ${url}  chrome
    Click Element    xpath=//a[text()="Dropdown"]

    Page Should Contain List    ${dropdown_locator}

    ${items}=  Get List Items    ${dropdown_locator}
    Log To Console    ${items}

    Select From List By Label    ${dropdown_locator}  Option 1

    ${selected}=  Get Selected List Label    ${dropdown_locator}
    Log To Console    ${selected}

    List Selection Should Be    ${dropdown_locator}  Option 1

    Close Browser


#Get List Items = Returns all options available in the dropdown. List [str]
#Get Selected List Label = Returns currently selected option (visible text).
#Get Selected List Labels = Returns all selected labels (used for multi-select dropdowns). list
#Get Selected List Value = Returns value attribute of selected option.
#Get Selected List Values = Returns all selected values (multi-select dropdown).

#List Selection Should Be = Checks if the selected value is correct.
#List Should Have No Selection = Checks dropdown has no option selected.
#Page Should Contain List = Checks if dropdown exists on page.
#Page Should Not Contain List = Checks dropdown does not exist.

#Select From List By Label = Select using visible text.
#Select From List By Value = Select using value attribute.
#Select From List By Index = Select using index
#Select All From List = Selects all options (only works for multi-select dropdown).

#Unselect From List By Label = unselect using visible text.(only works for multi-select dropdown).
#Unselect From List By Value = unselect using value attribute.(only works for multi-select dropdown).
#Unselect From List By Index = unselect using index (only works for multi-select dropdown).
#Unselect All From List = unselects all options (only works for multi-select dropdown).


