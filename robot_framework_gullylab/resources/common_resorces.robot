*** Settings ***
Library  SeleniumLibrary
Library  ../config/env_loader.py

*** Variables ***
${BROWSER}  chrome
${ENV}  qa
*** Keywords ***
Load Environment
    Load Env  ${ENV}
    ${url}  Get Env    baseurl
    ${email}  Get Env    user_email
    ${pwd}  Get Env    user_password

    Set Global Variable    ${BASE_URL}  ${url}
    Set Global Variable    ${USER_EMAIL}  ${email}
    Set Global Variable    ${USER_PWD}  ${pwd}

Open Application
    [Documentation]  opens the browser
    Open Browser  ${BASE_URL}  ${BROWSER}
    Maximize Browser Window

Close Application
    Close All Browsers