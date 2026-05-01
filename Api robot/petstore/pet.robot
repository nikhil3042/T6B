*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary

*** Variables ***
${BASE_URL}=  https://petstore.swagger.io/v2

*** Test Cases ***
Add Pet
    Create Session    petapi    ${BASE_URL}  verify=True
    ${payload}=  Load Json From File    ${CURDIR}/../data/add_pet.json

    ${response}=  POST On Session  petapi  /pet  json=${payload}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=  Set Variable  ${response.json()}

    Should Be Equal As Integers    ${body}[id]    99
    Should Be Equal As Strings    ${body}[status]    available

    Set Suite Variable    ${PET_ID}  ${body}[id]

    Log To Console    ${body}

Update Pet (PUT)
    Create Session    petapi    ${BASE_URL}    verify=True
    # Load full JSON file for PUT
    ${payload}=    Load Json From File    ${CURDIR}/../data/update_pet.json

    ${response}=    PUT On Session    petapi    /pet    json=${payload}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${body}[name]      Bruno Updated
    Should Be Equal As Strings    ${body}[status]    sold

    Log To Console    ${body}

#Update Pet Status (PATCH)
#    Create Session    petapi    ${BASE_URL}    verify=True
#    # Just a small dictionary for PATCH — no file needed!
#    ${payload}=    Create Dictionary
#    ...    id=${PET_ID}
#    ...    status=available
#
#    ${response}=    PATCH On Session    petapi    /pet    json=${payload}
#
#    Should Be Equal As Integers    ${response.status_code}    200
#
#    ${body}=    Set Variable    ${response.json()}
#    Should Be Equal As Strings    ${body}[status]    available
#
#    Log To Console    ${body}

Get Pet by Id
    Create Session    petapi    ${BASE_URL}  verify=True

    ${response}=  GET On Session  petapi  /pet/${PET_ID}

    Should Be Equal As Integers    ${response.status_code}    200

    ${body}=  Set Variable  ${response.json()}
    Dictionary Should Contain Item    ${body}    id    ${PET_ID}

    Log To Console    ${body}

#QUERY PARAMETER
Find Pets By Status
    Create Session    petapi    ${BASE_URL}    verify=True
    ${q_params}=    Create Dictionary    status=available

    ${response}=    GET On Session    petapi    /pet/findByStatus  params=${q_params}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Set Variable    ${response.json()}

    Log To Console    ${body}
        # Response is a LIST of pets
    Log To Console    Total pets found: ${body.__len__()}
    Log To Console    First pet: ${body}[0]

Upload an img
    Create Session    petapi    ${BASE_URL}  verify=True

    ${form_data}=  Create Dictionary  additionalMetadata=Bruno's profile photo
    ${file_path}=  Set Variable  ${CURDIR}/../data/download.jpg
    ${file}=  Evaluate    {'file': open($file_path, 'rb')}

    ${response}=  POST On Session  petapi  /pet/${PET_ID}/uploadImage
    ...  data=${form_data}
    ...  files=${file}

    Should Be Equal As Integers    ${response.status_code}    200
    Log To Console    ${response.json()}

Update Pet With Form Data
    Create Session    petapi    ${BASE_URL}    verify=True

    ${form_data}=    Create Dictionary
    ...    name=Bruno New Name
    ...    status=sold

    ${response}=    POST On Session    petapi  /pet/${PET_ID}
    ...    data=${form_data}

    Should Be Equal As Integers    ${response.status_code}    200

    Log To Console    ${response.json()}

Delete Pet
    Create Session    storeapi    ${BASE_URL}  verify=True
    ${response}=  DELETE On Session  storeapi  /pet/${PET_ID}

    Log To Console    ${response.status_code}


Adding Pet
    Create Session    petapi    ${BASE_URL}    verify=True
    ${payload}=    Load Json From File    ${CURDIR}/../data/add_pet.json

    ${response}=    POST On Session    petapi    /pet    json=${payload}

    # 1. Status code
    Should Be Equal As Integers    ${response.status_code}    200

    # 2. Response time
    Should Be True    ${response.elapsed.total_seconds()} < 3

    # 3. Headers
    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Contain    ${content_type}    application/json

    # 4. Body validation
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${body}[id]      99
    Should Be Equal As Strings    ${body}[name]     Bruno
    Should Be Equal As Strings    ${body}[status]   available
    Dictionary Should Contain Key    ${body}    category
    Dictionary Should Contain Key    ${body}    tags

    # 5. Nested validation
    ${category}=    Get From Dictionary    ${body}    category
    Dictionary Should Contain Key    ${category}    name

    Set Suite Variable    ${PET_ID}    ${body}[id]
    Log To Console    ${body}