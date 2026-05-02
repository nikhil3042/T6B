*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../auth/bearer_token.robot

Test Setup    Get Bearer Token

*** Test Cases ***
Get all Products from wishlist
    [Documentation]    Test case to verify fetching of all products from wishlist
    Create Session    wishlist_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${response}=  GET On Session    wishlist_session  /shoppers/${SHOPPER_ID}/wishlist  headers=${header}
    Should Be Equal As Integers    ${response.status_code}  200
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}

Add a product to wishlist
    [Documentation]    Test case to verify adding a product to wishlist
    Create Session    wishlist_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${payload}=  Create Dictionary
    ...  productId=157
    ...  quantity=2
    ${response}=  POST On Session    wishlist_session  /shoppers/${SHOPPER_ID}/wishlist  headers=${header}   json=${payload}
    Should Be Equal As Integers    ${response.status_code}  201
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}
    ${product_id}=  Get From Dictionary    ${body}[data]    productId
    Set Suite Variable    ${PRODUCT_ID}   ${product_id}

Delete a product from wishlist
    [Documentation]    Test case to verify deleting a product from wishlist
    [Tags]  delete
    Create Session    wishlist_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${response}=  DELETE On Session    wishlist_session  /shoppers/${SHOPPER_ID}/wishlist/${PRODUCT_ID}  headers=${header}
    Should Be Equal As Integers    ${response.status_code}  204

