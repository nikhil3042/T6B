*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${AUTH_URL}       https://accounts.spotify.com  #https://developer.spotify.com/documentation/web-api/tutorials/client-credentials-flow
${API_URL}        https://api.spotify.com/v1  #in search
${CLIENT_ID}      df5db64cad6b42c8ba2daec3437820f0
${CLIENT_SECRET}  d3f9498dd7f24eacbff6921ccf06e785

*** Test Cases ***
Step 1 - Get Spotify Access Token
    # Spotify needs Content-Type as form encoded — NOT json!
    ${headers}=    Create Dictionary
    ...    Content-Type=application/x-www-form-urlencoded

    # Body sent as form data — NOT json!
    ${body}=    Create Dictionary
    ...    grant_type=client_credentials
    ...    client_id=${CLIENT_ID}
    ...    client_secret=${CLIENT_SECRET}

    Create Session    spotify_auth    ${AUTH_URL}
    ...    headers=${headers}
    ...    verify=True

    ${response}=    POST On Session    spotify_auth    /api/token
    ...    data=${body}

    Should Be Equal As Integers    ${response.status_code}    200

    ${resp_body}=    Set Variable    ${response.json()}
    Log To Console    ${resp_body}

    # Extract token
    ${token}=    Get From Dictionary    ${resp_body}    access_token
    Log To Console    Token: ${token}
    Set Suite Variable    ${SPOTIFY_TOKEN}    ${token}

Step 2 - Use Token To Search
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${SPOTIFY_TOKEN}

    Create Session    spotify    ${API_URL}
    ...    headers=${headers}
    ...    verify=True

    ${params}=    Create Dictionary
    ...    q=Believer
    ...    type=track
    ...    limit=3

    ${response}=    GET On Session    spotify    /search
    ...    params=${params}

    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${body}    tracks
    Log To Console    ${body}[tracks][items][0][name]