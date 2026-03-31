*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${url}  https://www.royalchallengers.com/

*** Test Cases ***
Full page screenshot
    Set Screenshot Directory    ${CURDIR}/Screenshots
#Sets the folder where screenshots will be saved
#${CURDIR} Built-in variable in Robot Framework
#Meaning:Current directory of the test file (.robot)
# Use ../ if youre in subfolder means go one folder up from your current dir

    Open Browser  ${url}  chrome
    Maximize Browser Window
    
    Capture Page Screenshot  fullpage.png
    
    Capture Element Screenshot    xpath=//div[@class="hdr-logo"]  logo.png
    Capture Element Screenshot    xpath=(//img[@title="Virat Kohli"]/ancestor::div[@class="group-left"])[1]  virat.png
    Capture Element Screenshot    xpath=(//img[@title="Virat Kohli"]/ancestor::div[@class="group-left"])[2]  kohli.png

    Close Browser

    