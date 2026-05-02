*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../auth/bearer_token.robot

Test Setup    Run Keywords
    ...  Get Bearer Token
    ...  Get Address ID

*** Test Cases ***
Get order history
    [Documentation]    Test case to verify fetching of order history
    Create Session    order_session   ${BASE_URL}   verify=False

    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${response}=  GET On Session    order_session  /shoppers/${SHOPPER_ID}/orders  headers=${header}
    Should Be Equal As Integers    ${response.status_code}  200
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}

Place order from cart
    [Documentation]    Test case to verify placing an order from cart
    Create Session    order_session   ${BASE_URL}   verify=False

    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${address_info}=  Create Dictionary
    ...  addressId=${DEFAULT_ADDRESS_ID}
    ...  buildingInfo=Triveni Complex
    ...  city=Banglore
    ...  country=India
    ...  landmark=Post-Office
    ...  name=Courage Pinky
    ...  phone=8975642310
    ...  pincode=560010
    ...  state=KA
    ...  streetInfo=Shiv Shakti Nagar
    ...  type=Apartment

    ${payload}=  Create Dictionary
    ...  address=${address_info}
    ...  paymentMode=COD

    ${response}=  POST On Session    order_session  /shoppers/${SHOPPER_ID}/orders  headers=${header}   json=${payload}
    Should Be Equal As Integers    ${response.status_code}  201
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}

    ${order_id}=  Get From Dictionary    ${body}[data]    orderId
    Set Suite Variable    ${ORDER_ID}   ${order_id}

Update Order Status
    [Documentation]    Test case to verify updating order status
    Create Session    order_session    ${BASE_URL}    verify=False
    ${header}=    Create Dictionary    Authorization=Bearer ${token}
    ${qp}=  Create Dictionary  status=DELIVERED

    ${response}=    PATCH On Session    order_session
    ...    /shoppers/${SHOPPER_ID}/orders/${ORDER_ID}
    ...    headers=${header}
    ...    params=${qp}

    Should Be Equal As Integers    ${response.status_code}    200

Generate Invoice Copy
    [Documentation]    Test case to verify generating invoice copy for an order
    Create Session    order_session    ${BASE_URL}    verify=False
    ${header}=    Create Dictionary    Authorization=Bearer ${token}

    ${response}=    GET On Session    order_session
    ...    /shoppers/${SHOPPER_ID}/orders/${ORDER_ID}/invoice
    ...    headers=${header}

    Should Be Equal As Integers    ${response.status_code}    200

