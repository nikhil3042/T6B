*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://restful-booker.herokuapp.com

*** Test Cases ***
Basic Auth - Get All Bookings
    # Create list of [username, password]
    ${auth}=    Create List    admin    password123
# Create List not Create Dictionary for basic auth! Because it expects [username, password] as a pair — not key value!
    # Pass auth= directly to Create Session so it works commonly for entire session than using it in every request
    Create Session    booker    ${BASE_URL}  auth=${auth}  verify=True

    ${response}=    GET On Session    booker    /booking

    # Validations
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be True    ${response.elapsed.total_seconds()} < 3
    ${body}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${body}

    Log To Console    ${body}

