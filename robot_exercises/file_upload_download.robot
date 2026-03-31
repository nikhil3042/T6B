*** Settings ***
Library  SeleniumLibrary
Library  OperatingSystem
#operating system is for download and normalize path
*** Variables ***
${path}  ${CURDIR}/../Sample.txt
${upload_url}  https://the-internet.herokuapp.com/upload
${download_url}  https://the-internet.herokuapp.com/download
${DOWNLOAD_PATH}  D:\\Downloads\\downloaded_image.jpg

*** Test Cases ***
Upload file
    Open Browser  ${upload_url}  chrome
    Maximize Browser Window

    ${var}  Normalize Path    ${path}
    Choose File    id=file-upload    ${var}
    Click Button    id=file-submit
    
    Page Should Contain    File Uploaded!
    Page Should Contain    Sample.txt

    Close Browser

Download file
    Open Browser  ${download_url}  chrome
    Maximize Browser Window

    Click Element    xpath=//a[text()="downloaded_image.jpg"]

    Wait Until Created    ${DOWNLOAD_PATH}  timeout=10s

    File Should Exist    ${DOWNLOAD_PATH}

    Close Browser