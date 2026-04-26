#SHAWDOW DOM:
#Shadow DOM is a browser feature that lets developers create a hidden, isolated DOM tree inside an element.
#You have to use JavaScript to access elements inside the shadow DOM because Selenium cannot directly interact with them.

*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${Base URL}  https://testautomationpractice.blogspot.com/

*** Test Cases ***
Verify Shadow DOM Element
    Open Browser  ${Base URL}  chrome
    Maximize Browser Window
    Sleep    2s
    ${text_field}=    Get Shadow Element    div#shadow_host    input[type="text"]
    Input Text    ${text_field}    Nikhil
    ${check_box}=    Get Shadow Element    div#shadow_host    input[type="checkbox"]
    Click Element    ${check_box}
    Sleep    2s
    Close All Browsers


*** Keywords ***
Get Shadow Element
    [Arguments]    ${parent_locator}    ${child_locator}
    ${element}=    Execute Javascript
    ...    return document.querySelector('${parent_locator}')
    ...    .shadowRoot.querySelector('${child_locator}')
    RETURN    ${element}

#Always inspect and look for #shadow-root (open)
#If it says closed shadow root = you cannot access it (even with Selenium)
#Prefer CSS selectors over XPath

#If there are nested shadow DOMS then you can use this code to access the element:
#<parent-element>
#  #shadow-root
#    <child-element>
#      #shadow-root
#        <button>Click Me</button>
#
#*** Keywords ***
#Get Nested Shadow Element
#    ${element}=    Execute Javascript
#    ...    return document.querySelector("parent-element")
#    ...    .shadowRoot.querySelector("child-element")
#    ...    .shadowRoot.querySelector("button")
#    RETURN    ${element}


#Shadow DOM uses a different DOM tree
#Browser internally creates a separate document fragment
#XPath engine is designed to work only on the main DOM tree
#It has no concept of shadow roots
#XPath:
#Works like: “search entire document tree”
#But Shadow DOM = not part of that tree
#So XPath literally can’t see it
#
#CSS selectors:
#Work with querySelector()
#Browser allows querySelector() to run inside shadowRoot