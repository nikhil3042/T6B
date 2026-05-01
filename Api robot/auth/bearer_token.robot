*** Settings ***
Library  RequestsLibrary
Library  Collections

*** Variables ***
${BASE_URL}=  https://www.shoppersstack.com/shopping

*** Test Cases ***
Step1 Login
    Create Session    shopperstackapi    ${BASE_URL}  verify=False

    ${creds}=  Create Dictionary
    ...  email=couragethecowardlydog@yahoo.com
    ...  password=qwerty123
    ...  role=SHOPPER

    ${response}  POST On Session  shopperstackapi  /users/login  json=${creds}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Set Variable    ${response.json()}
    Log To Console    ${body}
    #extract the token

    ${token}=  Get From Dictionary    ${body}[data]    jwtToken
    ${userid}=  Get From Dictionary    ${body}[data]    userId

    Set Suite Variable  ${JWT_TOKEN}  ${token}
    Set Suite Variable  ${shopper_id}  ${userid}

Step2 Use token
    ${header}=  Create Dictionary  Authorization=Bearer ${JWT_TOKEN}

    Create Session    shopperstackapi    ${BASE_URL}  headers=${header}  verify=False

    ${response}=  GET On Session    shopperstackapi  /shoppers/${shopper_id}/carts

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}  Set Variable  ${response.json()}
    Log To Console    ${body}

