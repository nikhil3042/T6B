*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../auth/bearer_token.robot

Test Setup    Get Bearer Token

*** Test Cases ***
Return all Default Product
    [Documentation]    Test case to verify fetching of all default products
    Create Session    product_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${qp}=  Create Dictionary    zoneId=ALPHA
    ${response}=  GET On Session    product_session  /products/alpha  headers=${header}   params=${qp}
    Should Be Equal As Integers    ${response.status_code}  200
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}