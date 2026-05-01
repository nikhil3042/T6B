# 🤖 Robot Framework — API Testing Framework

A hands-on API automation framework built with **Robot Framework**, covering real-world scenarios including CRUD operations, file uploads, form data, query parameters, Basic Auth, Bearer Token authentication, and full OAuth 2.0 integration with Spotify.

---

## 📦 Installation & Dependencies

### 1. `robotframework-requests`
```bash
pip install robotframework-requests
```
This library wraps Python's `requests` library into Robot Framework keywords like `GET On Session`, `POST On Session`, etc. **Without this, you cannot make any HTTP calls in Robot Framework.**

---

### 2. `robotframework-jsonlibrary`
```bash
pip install robotframework-jsonlibrary
```
Helps you read and manipulate JSON easily. For example — loading a JSON file as a request payload, or extracting values using JSONPath like `$.data.id`. Extremely useful when your request bodies are complex and deeply nested.

---

### 3. `jsonschema`
```bash
pip install jsonschema
```
A Python library that validates whether a JSON response matches an expected structure. For example — you can define that a response **must** have an `id` field that is an integer, and it will fail the test if it doesn't match.

---

## 🔌 Core Concept — What is `Create Session`?

Think of `Create Session` the same way you think of creating a WebDriver in Selenium:

```python
# Selenium equivalent
driver = webdriver.Chrome()
driver.get("https://google.com")
```

In Robot Framework:
```robot
Create Session    mySession    https://reqres.in
${response}=    GET On Session    mySession    /api/users
```

You **create a session first**, then use it to make requests. The session holds:

| Parameter  | Description |
|------------|-------------|
| `alias`    | The name you give to the session (used to reference it in later requests) |
| `url`      | The base URL — no endpoint, just the root |
| `verify`   | SSL certificate verification — `True` or `False` |
| `headers`  | Default headers sent with every request in this session (e.g. `Content-Type`, `Authorization`) |
| `timeout`  | How many seconds to wait before the request gives up (e.g. `10`, `30`) |

---

## 🔒 SSL Verification — `verify=True` vs `verify=False`

### What is SSL?
**SSL (Secure Sockets Layer)** — when you visit a website with `https://`, the `S` means the connection is encrypted and secure. SSL verification is your code checking whether that website's security certificate is valid and trusted.

### Real-Life Analogy
It's like checking someone's ID card before letting them in. When you connect to `https://reqres.in`, SSL verification checks:
- ✅ Is this certificate issued by a trusted authority?
- ✅ Is it still valid (not expired)?
- ✅ Does it actually belong to `reqres.in`?

If all checks pass → connection proceeds normally.  
If any check fails → your code throws an error.

### When to Use What?

| Situation | Use |
|-----------|-----|
| Public API (Spotify, reqres.in) | `verify=True` |
| Your company's production API | `verify=True` |
| Local development server | `verify=False` |
| Internal test server with self-signed cert | `verify=False` |

> 💡 **Simple rule** — Always use `verify=True` unless you're hitting a local or internal server and getting SSL errors. For all public APIs, `verify=True` is correct.

> ⚠️ If you see `InsecureRequestWarning: Unverified HTTPS request is being made...` — fix it by explicitly adding `verify=True` to your `Create Session` call.

---

## 🔄 `GET` vs `GET On Session`

### `GET` — Standalone, one-off request
```robot
GET    https://reqres.in/api/users
```
- Makes a single request
- You pass the **full URL** every time
- No session involved
- No shared headers or auth

### `GET On Session` — Session-based request
```robot
Create Session    api    https://reqres.in
GET On Session    api    /api/users
```
- Uses an existing session
- You pass only the **endpoint** — base URL comes from the session
- Automatically shares headers, auth, and timeout from the session

### Why It Matters — The Real Difference

```robot
# ❌ Using GET — repeating yourself every single time
GET    https://reqres.in/api/users    headers=${headers}
GET    https://reqres.in/api/users/1    headers=${headers}
GET    https://reqres.in/api/users/2    headers=${headers}

# ✅ Using GET On Session — clean and reusable
Create Session    api    https://reqres.in    headers=${headers}
GET On Session    api    /api/users
GET On Session    api    /api/users/1
GET On Session    api    /api/users/2
```

| Feature | `GET` | `GET On Session` |
|---------|-------|------------------|
| Reusable base URL | ❌ | ✅ |
| Shared headers | ❌ | ✅ |
| Auth token once | ❌ | ✅ |
| Good for frameworks | ❌ | ✅ |
| Quick one-off test | ✅ | Overkill |

> 💡 **Simple rule** — In any real project or framework, **always use `GET On Session`**. Use plain `GET` only if you're making a single throwaway request with no auth or shared headers.

---

## 📦 Request Body Formats — `json=` vs `data=` vs `files=`

| Parameter | Sends As | Used For |
|-----------|----------|----------|
| `json=${body}` | `application/json` | Sending JSON payloads |
| `data=${body}` | `application/x-www-form-urlencoded` | Sending form data |
| `files=${file}` | `multipart/form-data` | Uploading files |

---

## 📐 Variable Scopes

| Keyword | Scope | Lifespan |
|---------|-------|----------|
| `Set Test Variable` | Only inside the current test case | Dies when the test ends |
| `Set Suite Variable` | Across all tests in the current `.robot` file | Dies when the file/suite run ends |
| `Set Global Variable` | Across all files in the entire robot run | Dies when the full robot run ends |

```robot
# Lives ONLY inside this one test — dies when test ends
Set Test Variable    ${order_id}    666

# Lives across ALL tests in this FILE — dies when file ends
Set Suite Variable    ${ORDER_ID}    666

# Lives across ALL files — dies when robot run ends
Set Global Variable    ${ORDER_ID}    666
```

> ⚠️ `Set Suite Variable` only lives during that robot run. When you start a new run, it's a fresh start — the variable is gone.

---

## 🐾 `pet.robot` — Petstore API Tests

**Base URL:** `https://petstore.swagger.io/v2`  
**Libraries:** `RequestsLibrary`, `Collections`, `JSONLibrary`

This file covers full CRUD operations on the Petstore API, plus file uploads and form data submission.

---

### Test Case: `Add Pet`
Loads the `add_pet.json` file as the request payload and sends a `POST` to `/pet`.

```robot
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
```

**What it does:**
- Creates a session for the Petstore API
- Loads the `add_pet.json` payload from the `data/` folder using `JSONLibrary`
- Sends a `POST` request with `json=${payload}` (sends as `application/json`)
- Validates the response status is `200`
- Checks that `id` is `99` and `status` is `available`
- Saves the `PET_ID` as a Suite Variable so subsequent tests can use it

---

### `add_pet.json` — Payload File
```json
{
  "id": 99,
  "category": {
    "id": 99,
    "name": "doggo"
  },
  "name": "doggo",
  "photoUrls": ["string"],
  "tags": [{ "id": 99, "name": "doggo" }],
  "status": "available"
}
```

> This is an example of a **nested JSON object**. You can build this either using Robot's `Create Dictionary` / `Create List` keywords, or simply load it from a `.json` file using `JSONLibrary` (which is the approach used here).

#### Option 1 — Build with Robot keywords (no file)
```robot
${category}=    Create Dictionary    id=0    name=Dogs
${tag}=         Create Dictionary    id=0    name=cute
${tags}=        Create List          ${tag}
${photo_urls}=  Create List          string

${body}=    Create Dictionary
...    id=0
...    category=${category}
...    name=Bruno
...    photoUrls=${photo_urls}
...    tags=${tags}
...    status=available
```

#### Option 2 — Load from file using JSONLibrary
```robot
${body}=    Load JSON From File    ${CURDIR}/../data/add_pet.json
```

---

### Test Case: `Update Pet (PUT)`
Loads `update_pet.json` and sends a full `PUT` request to replace the pet.

```robot
Update Pet (PUT)
    Create Session    petapi    ${BASE_URL}    verify=True
    ${payload}=    Load Json From File    ${CURDIR}/../data/update_pet.json
    ${response}=    PUT On Session    petapi    /pet    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${body}[name]      Bruno Updated
    Should Be Equal As Strings    ${body}[status]    sold
    Log To Console    ${body}
```

**What it does:**
- Loads the full updated payload from `update_pet.json`
- Sends a `PUT` (full replacement) to `/pet`
- Validates that `name` is now `Bruno Updated` and `status` is `sold`

---

### `update_pet.json` — Payload File
```json
{
  "id": 99,
  "category": { "id": 99, "name": "Dogs" },
  "name": "Bruno Updated",
  "photoUrls": ["https://example.com/bruno.jpg"],
  "tags": [{ "id": 99, "name": "cute" }],
  "status": "sold"
}
```

---

### Test Case: `Update Pet Status (PATCH)` *(commented out)*
A `PATCH` request to update only the status field — no JSON file needed, just a small dictionary.

```robot
# ${payload}=    Create Dictionary
# ...    id=${PET_ID}
# ...    status=available
# ${response}=    PATCH On Session    petapi    /pet    json=${payload}
```

> `PATCH` is used for **partial updates** (only the fields you include get changed). `PUT` is used for **full replacement** (you send the entire object).

---

### Test Case: `Get Pet by Id`
Fetches a single pet using the `PET_ID` saved from the `Add Pet` test.

```robot
Get Pet by Id
    Create Session    petapi    ${BASE_URL}  verify=True
    ${response}=  GET On Session  petapi  /pet/${PET_ID}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=  Set Variable  ${response.json()}
    Dictionary Should Contain Item    ${body}    id    ${PET_ID}
    Log To Console    ${body}
```

**What it does:**
- Uses `${PET_ID}` (Suite Variable set in `Add Pet`) to build the endpoint dynamically
- Validates the response contains the correct `id`
- `Dictionary Should Contain Item` checks both the **key** and the **value** together

---

### Test Case: `Find Pets By Status` — Query Parameters
Demonstrates how to send query parameters (`?status=available`) using a dictionary.

```robot
Find Pets By Status
    Create Session    petapi    ${BASE_URL}    verify=True
    ${q_params}=    Create Dictionary    status=available
    ${response}=    GET On Session    petapi    /pet/findByStatus  params=${q_params}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Set Variable    ${response.json()}
    Log To Console    ${body}
    Log To Console    Total pets found: ${body.__len__()}
    Log To Console    First pet: ${body}[0]
```

**What it does:**
- Creates a dictionary with `status=available` and passes it as `params=`
- Robot Framework automatically appends it to the URL as `?status=available`
- The response is a **list** of pets, so `${body}[0]` accesses the first item
- `${body.__len__()}` returns the total number of pets found

---

### Test Case: `Upload an img` — Multipart File Upload
Uploads a `.jpg` image using `multipart/form-data`.

```robot
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
```

**What it does:**
- `${form_data}` holds the optional metadata string to send alongside the image
- `${file_path}` builds the absolute path to the image using `${CURDIR}`
- `Evaluate` opens the file in binary read mode (`'rb'`) and wraps it in a dictionary with the key `file` — this is exactly the format `requests` expects for multipart uploads
- Sends both `data=${form_data}` and `files=${file}` together — this triggers `multipart/form-data` automatically

---

### Test Case: `Update Pet With Form Data`
Updates a pet's name and status using URL-encoded form data (`data=`).

```robot
Update Pet With Form Data
    Create Session    petapi    ${BASE_URL}    verify=True
    ${form_data}=    Create Dictionary
    ...    name=Bruno New Name
    ...    status=sold
    ${response}=    POST On Session    petapi  /pet/${PET_ID}
    ...    data=${form_data}
    Should Be Equal As Integers    ${response.status_code}    200
    Log To Console    ${response.json()}
```

**What it does:**
- Uses `data=${form_data}` (not `json=`) which sends the body as `application/x-www-form-urlencoded`
- This is how HTML forms work — key=value pairs in the body

---

### Test Case: `Delete Pet`

```robot
Delete Pet
    Create Session    storeapi    ${BASE_URL}  verify=True
    ${response}=  DELETE On Session  storeapi  /pet/${PET_ID}
    Log To Console    ${response.status_code}
```

Sends a `DELETE` request to remove the pet by its ID.

---

### Test Case: `Adding Pet` — Full Response Validation
A more thorough version of the Add Pet test that validates **5 things** about the response.

```robot
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
```

**What it validates:**
1. **Status code** — must be `200`
2. **Response time** — must be under 3 seconds using `${response.elapsed.total_seconds()}`
3. **Response headers** — `Content-Type` must contain `application/json`
4. **Body fields** — `id`, `name`, `status`, and presence of `category` and `tags` keys
5. **Nested object** — drills into `category` dictionary to confirm the `name` key exists

---

## 🏪 `store.robot` — Store/Order API Tests

**Base URL:** `https://petstore.swagger.io/v2`  
**Libraries:** `RequestsLibrary`, `Collections`

---

### Test Case: `Returns Inventory`
```robot
Returns Inventory
    Create Session    storeapi    ${BASE_URL}
    ${response}=  GET On Session  storeapi  /store/inventory
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=  Set Variable  ${response.json()}
    Dictionary Should Contain Key  ${body}  string
    Log To Console    ${body}
```

Gets the store inventory. The response is a flat dictionary of status labels to counts. Uses `Dictionary Should Contain Key` to verify a key named `string` exists in the response.

> 💡 In API testing, `${scalar}` variables are used ~90% of the time because real API responses are always nested objects — so preserving the structure in a single variable is the standard approach.

---

### Test Case: `Place Order`
Builds the order payload entirely with `Create Dictionary` (no external JSON file needed since it's a flat structure).

```robot
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
```

- Sends a `POST` to `/store/order` with a complete order payload
- Validates `id` is `666` and `status` is `placed`
- Saves `ORDER_ID` as a Suite Variable for use in the next tests

---

### Test Case: `Get Order`
```robot
Get Order
    Create Session    storeapi    ${BASE_URL}  verify=True
    ${response}=  GET On Session  storeapi  /store/order/${ORDER_ID}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=  Set Variable  ${response.json()}
    Dictionary Should Contain Item    ${body}    id    ${ORDER_ID}
    Log To Console    ${body}
```

Fetches the previously placed order using `${ORDER_ID}`. Validates with `Dictionary Should Contain Item` which checks both the key **and** value simultaneously.

---

### Test Case: `Delete Order`
```robot
Delete Order
    Create Session    storeapi    ${BASE_URL}  verify=True
    ${response}=  DELETE On Session  storeapi  /store/order/${ORDER_ID}
    Log To Console    ${response.status_code}
```

---

### Test Case: `E2E Order Flow` — Chained Request Flow
Demonstrates how to chain multiple API calls within a **single test case** without relying on Suite Variables.

```robot
E2E Order Flow
    Create Session    storeapi    ${BASE_URL}    verify=True

    # Step 1: Place Order
    ${payload}=  Create Dictionary
    ...  id=666  petId=666  quantity=10
    ...  shipDate=2026-04-20T10:50:11.706Z
    ...  status=placed  complete=True
    ${res1}=  POST On Session  storeapi  /store/order  json=${payload}
    Should Be Equal As Integers    ${res1.status_code}    200
    ${order_id}=    Set Variable    ${res1.json()}[id]

    # Step 2: Get Order (chaining)
    ${res2}=  GET On Session  storeapi  /store/order/${order_id}
    Should Be Equal As Integers    ${res2.status_code}    200

    # Step 3: Delete Order
    ${res3}=  DELETE On Session  storeapi  /store/order/${order_id}
    Should Be Equal As Integers    ${res3.status_code}    200
```

**What it demonstrates:**
- All three steps (Place → Get → Delete) happen inside **one test**
- `${order_id}` is a local variable — scoped only to this test (no `Set Suite Variable` needed)
- Response chaining: the `id` extracted from the POST response is immediately used in the GET and DELETE

---

## 🔐 Authentication — 3 Types

### Overview

| Feature | Basic Auth | Bearer Token | OAuth 2.0 |
|---------|-----------|--------------|-----------|
| Credentials sent | Every request | Only at login | Only at login |
| Who gives the token | Nobody — direct credentials | Same API server | Separate auth server |
| Token expiry | No token | Sometimes | Always — expires |
| Refresh token | No | No | Yes |
| Security level | Low | Medium | High |
| Used by | Old/simple APIs | Simple modern APIs | Spotify, Google, GitHub |

---

### How They Work — Visual Flow

**Basic Auth:**
```
[Request + username:password] ──→ API
[Request + username:password] ──→ API
[Request + username:password] ──→ API
```
Every single request carries the credentials. No login step — credentials go directly in **every** request. Like showing your ID card at every door you enter.

**Bearer Token:**
```
[Login] ──→ API ──→ token
[Request + token] ──→ API
[Request + token] ──→ API
```
You log in once, get a token, and reuse it for all subsequent requests. Like getting a wristband at a concert — show it at every door.

**OAuth 2.0:**
```
[Login] ──→ AUTH SERVER ──→ token
[Request + token] ──→ API SERVER
[Request + token] ──→ API SERVER
         ↑
    Different server!
```
Same as Bearer Token flow, BUT the token comes from a **separate, dedicated auth server** — not the API itself. Has strict standards, expiry, scopes, and refresh tokens. Like getting a visa — issued by an embassy (auth server), used at borders (API server).

---

## 🔑 `basic_auth.robot` — Basic Authentication

**Base URL:** `https://restful-booker.herokuapp.com`

```robot
Basic Auth - Get All Bookings
    ${auth}=    Create List    admin    password123
    Create Session    booker    ${BASE_URL}  auth=${auth}  verify=True
    ${response}=    GET On Session    booker    /booking
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be True    ${response.elapsed.total_seconds()} < 3
    ${body}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${body}
    Log To Console    ${body}
```

**Key points:**
- Use `Create List` — **not** `Create Dictionary` — for Basic Auth credentials. The library expects `[username, password]` as a positional pair, not key-value.
- Pass `auth=${auth}` directly to `Create Session` so the credentials are automatically attached to **every request** in the session — no need to repeat them per request.
- Validates status code is `200`, response time is under 3 seconds, and body is not empty.

---

## 🎫 `bearer_token.robot` — Bearer Token Authentication

**Base URL:** `https://www.shoppersstack.com/shopping`

---

### Step 1 — Login to Get the Token

```robot
Step1 Login
    Create Session    shopperstackapi    ${BASE_URL}  verify=False
    ${creds}=  Create Dictionary
    ...  email=couragethecowardlydog@yahoo.com
    ...  password=qwerty123
    ...  role=SHOPPER
    ${response}  POST On Session  shopperstackapi  /users/login  json=${creds}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Set Variable    ${response.json()}
    ${token}=  Get From Dictionary    ${body}[data]    jwtToken
    ${userid}=  Get From Dictionary    ${body}[data]    userId
    Set Suite Variable  ${JWT_TOKEN}  ${token}
    Set Suite Variable  ${shopper_id}  ${userid}
```

**What it does:**
- Sends login credentials as a JSON body to `/users/login`
- The token is **nested** inside `${body}[data]` — uses `Get From Dictionary` to drill in and extract `jwtToken` and `userId`
- Saves both as Suite Variables for use in Step 2
- Uses `verify=False` because this is an internal/dev server

---

### Step 2 — Use the Token

```robot
Step2 Use token
    ${header}=  Create Dictionary  Authorization=Bearer ${JWT_TOKEN}
    Create Session    shopperstackapi    ${BASE_URL}  headers=${header}  verify=False
    ${response}=  GET On Session    shopperstackapi  /shoppers/${shopper_id}/carts
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}  Set Variable  ${response.json()}
    Log To Console    ${body}
```

**What it does:**
- Builds the `Authorization` header as `Bearer <token>` using the `JWT_TOKEN` from Step 1
- Creates a new session with the header baked in — so **all** subsequent requests automatically carry the Bearer token
- Hits the `/shoppers/{id}/carts` endpoint using the `shopper_id` from Step 1

---

## 🎵 `spotify_oauth.robot` — OAuth 2.0 (Spotify)

**Auth URL:** `https://accounts.spotify.com`  
**API URL:** `https://api.spotify.com/v1`

OAuth 2.0 is the most advanced authentication type. The token comes from a **completely separate auth server** (not the API server).

---

### Setting Up Spotify Developer Credentials

1. Go to [https://developer.spotify.com](https://developer.spotify.com)
2. Log in with your Spotify account
3. Click **Dashboard → Create App**
4. Fill in:
   - App name: `Robot Framework Tests`
   - App description: `API Testing Practice`
   - Redirect URI: `http://localhost:8888/callback`
5. Click **Save**
6. Copy your **Client ID** and **Client Secret** — paste them into `${CLIENT_ID}` and `${CLIENT_SECRET}` in the Variables section

---

### The Full OAuth 2.0 Flow

```
Your Robot Test
      ↓
POST https://accounts.spotify.com/api/token
      ↓  (sends Client ID + Client Secret)
Spotify Auth Server
      ↓  (returns access_token)
Your Robot Test
      ↓  (uses access_token in Authorization header)
https://api.spotify.com/v1/...
```

---

### Step 1 — Get the Access Token

```robot
Step 1 - Get Spotify Access Token
    ${headers}=    Create Dictionary
    ...    Content-Type=application/x-www-form-urlencoded

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
    ${token}=    Get From Dictionary    ${resp_body}    access_token
    Log To Console    Token: ${token}
    Set Suite Variable    ${SPOTIFY_TOKEN}    ${token}
```

**Critical points:**
- Spotify's token endpoint requires `Content-Type: application/x-www-form-urlencoded` — **not** JSON
- The body must be sent as `data=${body}` — **not** `json=${body}`. Using `json=` here will cause a `400 Bad Request`
- `grant_type=client_credentials` tells Spotify this is the Client Credentials OAuth flow (app-to-app, no user login)
- The `access_token` is extracted from the response and saved as a Suite Variable

---

### Step 2 — Use the Token to Search

```robot
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
```

**What it does:**
- Builds the `Authorization: Bearer <token>` header using the `SPOTIFY_TOKEN` from Step 1
- Creates a **new session** pointing to `api.spotify.com` (the API server — different from the auth server)
- Sends query parameters: search for `q=Believer`, type `track`, limit to `3` results
- Validates the response contains a `tracks` key
- Logs the name of the first track found: `${body}[tracks][items][0][name]`

> The two-session approach (`spotify_auth` and `spotify`) perfectly mirrors how OAuth 2.0 works in real life — the auth server and the API server are separate, so you use two different sessions for them.

---

## 🧪 Response Validation Techniques Used

| Keyword | Purpose |
|---------|---------|
| `Should Be Equal As Integers` | Validates numeric values (status codes, IDs) |
| `Should Be Equal As Strings` | Validates string values (names, statuses) |
| `Should Be True` | Validates boolean expressions (e.g. response time < 3) |
| `Should Contain` | Checks if a string contains a substring (e.g. Content-Type header) |
| `Should Not Be Empty` | Ensures a list or body is not empty |
| `Dictionary Should Contain Key` | Checks a key exists in a dict (value doesn't matter) |
| `Dictionary Should Contain Item` | Checks both key AND value exist in a dict |
| `Get From Dictionary` | Extracts a value from a dictionary by key |
| `${response.elapsed.total_seconds()}` | Gets the response time in seconds |
| `${body}[key]` | Directly accesses a key in the JSON response dictionary |
| `${body}[0]` | Accesses the first item in a JSON response list |
| `${body}[tracks][items][0][name]` | Deep nested access — chain as many levels as needed |

---

## 💡 Key Takeaways & Best Practices

1. **Always use `GET On Session` (not plain `GET`)** in any framework — it's reusable, clean, and supports shared auth/headers.
2. **Use `verify=True` for public APIs** — only use `verify=False` for internal/dev servers with self-signed certs.
3. **Use `Set Suite Variable` to chain tests** — save values like IDs or tokens from one test and reuse them in the next.
4. **Match the body format to the API's expectation** — `json=` for JSON, `data=` for form-encoded, `files=` for multipart.
5. **For Spotify (and OAuth 2.0 APIs)** — the token endpoint requires `data=` with form encoding, not JSON.
6. **For Basic Auth** — always use `Create List` not `Create Dictionary` and pass it via `auth=` in `Create Session`.
7. **For Bearer Token** — build the `Authorization=Bearer ${TOKEN}` header dictionary and pass it via `headers=` in `Create Session`.
8. **Load complex JSON payloads from files** — use `Load Json From File` from `JSONLibrary` instead of building deeply nested dictionaries in Robot code.
9. **Validate thoroughly** — go beyond just status code. Always check response time, headers, body fields, nested keys, and data types.
