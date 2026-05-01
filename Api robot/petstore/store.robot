*** Settings ***
Library  RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}  https://petstore.swagger.io/v2

*** Test Cases ***
Returns Inventory
    Create Session    storeapi    ${BASE_URL}
    ${response}=  GET On Session  storeapi  /store/inventory

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=  Set Variable  ${response.json()}
    #in API testing you'll use ${scalar} 90% of the time because real responses are always nested so the structure is maintained
    Dictionary Should Contain Key  ${body}  string

    Log To Console    ${body}
    Log To Console    ${response.status_code}


Place Order
    Create Session    storeapi    ${BASE_URL}  verify=True
    ${payload}=  Create Dictionary
    ...  id=666
    ...  petId=666
    ...  quantity=10
    ...  shipDate=2026-04-20T10:50:11.706Z
    ...  status=placed
    ...  complete=True

    ${response}=  POST On Session  storeapi  /store/order  json=${payload}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=  Set Variable  ${response.json()}
    
    Should Be Equal As Integers    ${body}[id]    666
    Should Be Equal As Strings    ${body}[status]    placed

    Set Suite Variable    ${ORDER_ID}  ${body}[id]

    Log To Console    ${body}
    Log To Console    ${ORDER_ID}

Get Order
    Create Session    storeapi    ${BASE_URL}  verify=True

    ${response}=  GET On Session  storeapi  /store/order/${ORDER_ID}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=  Set Variable  ${response.json()}
    Dictionary Should Contain Item    ${body}    id    ${ORDER_ID}

    Log To Console    ${body}

Delete Order
    Create Session    storeapi    ${BASE_URL}  verify=True
    ${response}=  DELETE On Session  storeapi  /store/order/${ORDER_ID}

    Log To Console    ${response.status_code}


E2E Order Flow
    Create Session    storeapi    ${BASE_URL}    verify=True

    # Step 1: Place Order
    ${payload}=  Create Dictionary
    ...  id=666
    ...  petId=666
    ...  quantity=10
    ...  shipDate=2026-04-20T10:50:11.706Z
    ...  status=placed
    ...  complete=True

    ${res1}=  POST On Session  storeapi  /store/order  json=${payload}
    Should Be Equal As Integers    ${res1.status_code}    200

    ${order_id}=    Set Variable    ${res1.json()}[id]

    # Step 2: Get Order (chaining)
    ${res2}=  GET On Session  storeapi  /store/order/${order_id}
    Should Be Equal As Integers    ${res2.status_code}    200

    # Step 3: Delete Order
    ${res3}=  DELETE On Session  storeapi  /store/order/${order_id}
    Should Be Equal As Integers    ${res3.status_code}    200

