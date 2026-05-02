*** Settings ***
Library  RequestsLibrary
Library  Collections

*** Variables ***
${BASE_URL}  https://www.shoppersstack.com/shopping
${USER_EMAIL}  couragethecowardlydog@yahoo.com
${USER_PASSWORD}  qwerty123
${USER_ROLE}  SHOPPER

*** Keywords ***
Get Bearer Token
    Create Session  auth_session  ${BASE_URL}  verify=False

    ${payload}=  Create Dictionary
    ...  email=${USER_EMAIL}
    ...  password=${USER_PASSWORD}
    ...  role=${USER_ROLE}

    ${response}=  POST On Session   auth_session  /users/login  json=${payload}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    ${token}=  Get From Dictionary  ${body}[data]  jwtToken
    ${user_id}=  Get From Dictionary  ${body}[data]  userId

    Set Suite Variable  ${token}
    Set Suite Variable    ${SHOPPER_ID}  ${user_id}


Get Address ID
    Create Session    address_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${response}=  GET On Session    address_session  /shoppers/${SHOPPER_ID}/address  headers=${header}

    Should Be Equal As Integers    ${response.status_code}  200

    ${body}=  Set Variable    ${response.json()}
    ${default_address}=  Get From Dictionary    ${body}[data][0]    addressId
    Set Suite Variable    ${DEFAULT_ADDRESS_ID}   ${default_address}
