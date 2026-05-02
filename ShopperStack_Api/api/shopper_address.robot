*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../auth/bearer_token.robot

Test Setup    Get Bearer Token

*** Test Cases ***
Get all Address
    [Documentation]    Test case to fetch all addresses
    [Tags]  order
    Create Session    address_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${response}=  GET On Session    address_session  /shoppers/${SHOPPER_ID}/address  headers=${header}

    Should Be Equal As Integers    ${response.status_code}  200

    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}

Add new Address
    [Documentation]    Test case to add new address
    Create Session    address_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${payload}=  Create Dictionary
    ...  addressId=1203
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
    ${response}=  POST On Session    address_session  /shoppers/${SHOPPER_ID}/address  headers=${header}   json=${payload}
    Should Be Equal As Integers    ${response.status_code}  201
    ${body}=  Set Variable    ${response.json()}
    ${address_id}=  Get From Dictionary    ${body}[data]    addressId
    Log To Console    ${body}
    Set Suite Variable    ${ADDRESS_ID}   ${address_id}

Get address by addressId
    [Documentation]    Test case to fetch address by addressId
    Create Session    address_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${response}=  GET On Session    address_session  /shoppers/${SHOPPER_ID}/address/${ADDRESS_ID}  headers=${header}
    Should Be Equal As Integers    ${response.status_code}  200
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}

Update an added Address
    [Documentation]    Test case to update an added address
    Create Session    address_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${payload}=  Create Dictionary
    ...  addressId=${ADDRESS_ID}
    ...  buildingInfo=Triveni Complex
    ...  city=Banglore
    ...  country=India
    ...  landmark=Post-Office
    ...  name=Courage Pinky
    ...  phone=8975642310
    ...  pincode=560010
    ...  state=KA
    ...  streetInfo=Shiv Shakti Nagar
    ...  type=Flat
    ${response}=  PUT On Session   address_session   /shoppers/${SHOPPER_ID}/address/${ADDRESS_ID}  headers=${header}   json=${payload}
    Should Be Equal As Integers    ${response.status_code}  200
    ${body}=  Set Variable    ${response.json()}
    Log To Console    ${body}
    
Delete an added Address
    [Documentation]    Test case to delete an added address
    [Tags]  delete
    Create Session    address_session   ${BASE_URL}   verify=False
    ${header}=  Create Dictionary    Authorization=Bearer ${token}
    ${response}=  DELETE On Session   address_session   /shoppers/${SHOPPER_ID}/address/${ADDRESS_ID}  headers=${header}
    Should Be Equal As Integers    ${response.status_code}  204