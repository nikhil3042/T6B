*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}  https://www.thesouledstore.com/

*** Test Cases ***
Scrolling using JS Executor
    Open Browser  ${url}  chrome
    Maximize Browser Window
#bottom of page
    Execute Javascript  window.scrollTo(0, document.body.scrollHeight)
    Sleep    1s
#top of page
    Execute Javascript  window.scrollTo(0,0)
    Sleep    1s
#to scroll exactly at position
    Execute Javascript  window.scrollTo(0,200)
    Sleep    1s
#to scroll by pixels from where we are at present
    Execute Javascript  window.scrollBy(0,500)
    Sleep    1s
#to scroll to particular element
    Scroll Element Into View  xpath=//span[contains(text(),"Bangalore")]
    Sleep    1s

    Close All Browsers