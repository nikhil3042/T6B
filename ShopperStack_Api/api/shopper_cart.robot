*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../auth/bearer_token.robot

Test Setup    Get Bearer Token

*** Test Cases ***
Get all Products from Cart
    [Documentation]    Test case to verify fetching of all products from cart
    Create Session    cart_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${response}=  GET On Session    cart_session  /shoppers/${SHOPPER_ID}/carts  headers=${header}
    Should Be Equal As Integers    ${response.status_code}  200
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}

Add a product to Cart
    [Documentation]    Test case to verify adding a product to cart
    Create Session    cart_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${payload}=  Create Dictionary
    ...  productId=152
    ...  quantity=1
    ${response}=  POST On Session    cart_session  /shoppers/${SHOPPER_ID}/carts  headers=${header}   json=${payload}
    Should Be Equal As Integers    ${response.status_code}  201
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}
    ${item_id}=  Get From Dictionary    ${body}[data]    itemId
    ${product_id}=  Get From Dictionary    ${body}[data]    productId

    Set Suite Variable    ${PRODUCT_ID}   ${product_id}
    Set Suite Variable    ${ITEM_ID}   ${item_id}

Update an added product in Cart
    [Documentation]    Test case to verify updating an added product in cart
    Create Session    cart_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${payload}=  Create Dictionary
    ...  productId=${PRODUCT_ID}
    ...  quantity=3
    ${response}=  PUT On Session    cart_session  /shoppers/${SHOPPER_ID}/carts/${ITEM_ID}  headers=${header}   json=${payload}
    Should Be Equal As Integers    ${response.status_code}  200
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}
    
Delete a product from Cart
    [Documentation]    Test case to verify deleting a product from cart
    [Tags]  delete
    Create Session    cart_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${response}=  DELETE On Session    cart_session  /shoppers/${SHOPPER_ID}/carts/${PRODUCT_ID}  headers=${header}
    Should Be Equal As Integers    ${response.status_code}  200