# ShopperStack API Test Suite — Robot Framework

A complete API automation suite for the ShopperStack e-commerce platform built using Robot Framework and the RequestsLibrary.

---

## Project Structure

```
ShopperStack_Api/
├── auth/
│   └── bearer_token.robot          # Shared resource: login + address keywords
├── api/
│   ├── shopper_profile.robot       # Login, fetch & update shopper profile
│   ├── shopper_address.robot       # CRUD operations on shopper addresses
│   ├── shopper_cart.robot          # CRUD operations on shopping cart
│   ├── shopper_wishlist.robot      # Wishlist management
│   ├── shopper_order.robot         # Place, update, invoice for orders
│   └── product_view_action.robot   # Browse/fetch products
└── reports/                        # Auto-generated test reports (log, output, report)
```

---

## How to Run

### Run all tests (excluding delete)
```bash
robot -d reports -e delete api
```

### Run all tests including delete
```bash
robot -d reports api
```

### Run a single file
```bash
robot -d reports api/shopper_cart.robot
```

### Run files in a specific order (recommended for order tests)
```bash
robot -d reports -e delete api/shopper_profile.robot api/shopper_address.robot api/shopper_cart.robot api/shopper_wishlist.robot api/shopper_order.robot api/product_view_action.robot
```

---

## Prerequisites

Install required Python libraries before running:

```bash
pip install robotframework
pip install robotframework-requests
```

---

## File-by-File Explanation

---

### `auth/bearer_token.robot`

This is a **Resource file** (no `Test Cases` section). It contains shared keywords and variables used by all other test files.

```robot
*** Settings ***
Library  RequestsLibrary   # Enables HTTP methods: GET, POST, PUT, PATCH, DELETE
Library  Collections       # Enables dictionary/list utilities like Get From Dictionary
```

```robot
*** Variables ***
${BASE_URL}       https://www.shoppersstack.com/shopping   # Root URL for all API calls
${USER_EMAIL}     couragethecowardlydog@yahoo.com          # Login email used across all tests
${USER_PASSWORD}  qwerty123                               # Login password
${USER_ROLE}      SHOPPER                                 # Role sent during login
```

#### Keyword: `Get Bearer Token`

```robot
Create Session  auth_session  ${BASE_URL}  verify=False
```
Creates an HTTP session named `auth_session` pointing to the base URL.
`verify=False` disables SSL certificate verification (needed for self-signed certs).

```robot
${payload}=  Create Dictionary
...  email=${USER_EMAIL}
...  password=${USER_PASSWORD}
...  role=${USER_ROLE}
```
Builds a JSON-compatible dictionary as the login request body using the variables defined above.

```robot
${response}=  POST On Session   auth_session  /users/login  json=${payload}
```
Sends a POST request to `/users/login` with the payload. The full URL becomes `https://www.shoppersstack.com/shopping/users/login`.

```robot
Should Be Equal As Integers  ${response.status_code}  200
```
Asserts the response status is 200. If not, the test fails immediately here.

```robot
${body}=  Set Variable  ${response.json()}
${token}=  Get From Dictionary  ${body}[data]  jwtToken
${user_id}=  Get From Dictionary  ${body}[data]  userId
```
Parses the JSON response body and extracts `jwtToken` and `userId` from the `data` key.

```robot
Set Suite Variable  ${token}
Set Suite Variable  ${SHOPPER_ID}  ${user_id}
```
Makes `${token}` and `${SHOPPER_ID}` available to every test case in the same suite (file).

---

#### Keyword: `Get Address ID`

```robot
Create Session    address_session   ${BASE_URL}   verify=False
${header}=  Create Dictionary    Authorization=Bearer ${token}
```
Creates a new session and builds the Authorization header using the token fetched by `Get Bearer Token`. This keyword must always run **after** `Get Bearer Token`.

```robot
${response}=  GET On Session    address_session  /shoppers/${SHOPPER_ID}/address  headers=${header}
```
Fetches all addresses for the logged-in shopper.

```robot
${default_address}=  Get From Dictionary    ${body}[data][0]    addressId
Set Suite Variable    ${DEFAULT_ADDRESS_ID}   ${default_address}
```
Picks the **first address** in the list (`[0]`) and stores its `addressId` as a suite variable for use in order tests.

---

### `api/shopper_profile.robot`

Tests login and shopper profile operations.

```robot
Resource  ../auth/bearer_token.robot
```
Imports the shared resource file. This gives access to `${BASE_URL}`, `${token}`, `${SHOPPER_ID}`, and the keywords `Get Bearer Token` and `Get Address ID`.

```robot
Test Setup  Get Bearer Token
```
Runs `Get Bearer Token` **before every single test case** in this file. This ensures a fresh token and `${SHOPPER_ID}` is available for each test.

---

#### Test: `Shopper_login`
Verifies that the login API works and the correct email is returned.

```robot
${fetched_email}=  Get From Dictionary  ${body}[data]  email
Should Be Equal  ${fetched_email}  ${USER_EMAIL}
```
Extracts the email from the response and asserts it matches what was used to log in.

---

#### Test: `Find Shopper data by shopperId`
Fetches the shopper's profile using their ID.

```robot
${response}=  GET On Session  shopper_session  /shoppers/${SHOPPER_ID}  headers=${header}
```
`${SHOPPER_ID}` is set by `Get Bearer Token` in Test Setup, so it's always available here.

---

#### Test: `Update the shopper Details`
Updates the shopper's profile using a PATCH request.

```robot
${response}=  PATCH On Session  shopper_session  /shoppers/${SHOPPER_ID}  headers=${header}  json=${payload}
```
Sends only the fields that need updating. PATCH is a partial update (unlike PUT which replaces the full record).

---

### `api/shopper_address.robot`

Tests all address CRUD operations. Test cases run in **top-to-bottom order** and share `${ADDRESS_ID}` via `Set Suite Variable`.

```robot
Test Setup    Get Bearer Token
```
Fetches a fresh token before each test.

---

#### Test: `Get all Address`
```robot
[Tags]  order
```
Tagged `order` so it runs when filtering by that tag. Fetches all addresses and logs the full response body.

---

#### Test: `Add new Address`
```robot
${address_id}=  Get From Dictionary    ${body}[data]    addressId
Set Suite Variable    ${ADDRESS_ID}   ${address_id}
```
After successfully adding a new address (201 Created), the new `addressId` is extracted and stored as `${ADDRESS_ID}`. This variable is used by the next two test cases.

> ⚠️ **Precondition:** The shopper account must exist and be authenticated. If `Add new Address` fails, `Get address by addressId`, `Update an added Address`, and `Delete an added Address` will all fail because `${ADDRESS_ID}` won't be set.

---

#### Test: `Get address by addressId`
```robot
${response}=  GET On Session    address_session  /shoppers/${SHOPPER_ID}/address/${ADDRESS_ID}  headers=${header}
```
Uses `${ADDRESS_ID}` set by the previous test. Fetches a specific address by its ID.

---

#### Test: `Update an added Address`
Sends a PUT request (full replacement) to update the address. Notice `type` changed from `Apartment` to `Flat` compared to the Add test.

---

#### Test: `Delete an added Address`
```robot
[Tags]  delete
```
Tagged `delete` so it is **excluded** when running with `-e delete`. This prevents accidental data deletion during regular test runs.

```robot
Should Be Equal As Integers    ${response.status_code}  204
```
204 No Content is the expected response for a successful DELETE with no body returned.

---

### `api/shopper_cart.robot`

Tests all cart operations. `${ITEM_ID}` and `${PRODUCT_ID}` are shared between tests using `Set Suite Variable`.

---

#### Test: `Get all Products from Cart`
Fetches all items currently in the cart. No preconditions needed.

---

#### Test: `Add a product to Cart`
```robot
${payload}=  Create Dictionary
...  productId=152
...  quantity=1
```
Adds product with ID `152` to the cart with quantity 1.

```robot
${item_id}=  Get From Dictionary    ${body}[data]    itemId
${product_id}=  Get From Dictionary    ${body}[data]    productId
Set Suite Variable    ${PRODUCT_ID}   ${product_id}
Set Suite Variable    ${ITEM_ID}   ${item_id}
```
Extracts both `itemId` (cart line item ID) and `productId` from the response and saves them as suite variables. Note: `itemId` ≠ `productId` — `itemId` is the unique ID for this specific cart entry.

---

#### Test: `Update an added product in Cart`
```robot
${response}=  PUT On Session    cart_session  /shoppers/${SHOPPER_ID}/carts/${ITEM_ID}  headers=${header}   json=${payload}
```
Updates the quantity of the cart item identified by `${ITEM_ID}` to 3.

> ⚠️ **Precondition:** `Add a product to Cart` must run first to set `${ITEM_ID}` and `${PRODUCT_ID}`.

---

#### Test: `Delete a product from Cart`
```robot
[Tags]  delete
${response}=  DELETE On Session    cart_session  /shoppers/${SHOPPER_ID}/carts/${PRODUCT_ID}  headers=${header}
```
Deletes the product from the cart using `${PRODUCT_ID}`. Tagged `delete` to allow exclusion.

> ⚠️ **Important:** If you run delete, the cart will be empty. This affects `Place order from cart` in `shopper_order.robot` which requires cart items.

---

### `api/shopper_wishlist.robot`

Tests wishlist operations. Simple three-test flow.

---

#### Test: `Get all Products from wishlist`
Fetches all wishlist items. No preconditions.

---

#### Test: `Add a product to wishlist`
```robot
${payload}=  Create Dictionary
...  productId=157
...  quantity=2
```
Adds product `157` with quantity `2` to the wishlist.

```robot
${product_id}=  Get From Dictionary    ${body}[data]    productId
Set Suite Variable    ${PRODUCT_ID}   ${product_id}
```
Saves the product ID for the delete test that follows.

---

#### Test: `Delete a product from wishlist`
```robot
[Tags]  delete
${response}=  DELETE On Session    wishlist_session  /shoppers/${SHOPPER_ID}/wishlist/${PRODUCT_ID}  headers=${header}
Should Be Equal As Integers    ${response.status_code}  204
```
Deletes the product from wishlist using `${PRODUCT_ID}` set in the previous test.

---

### `api/shopper_order.robot`

The most complex file. Tests the full order lifecycle. Uses **two keywords in Test Setup** and shares `${ORDER_ID}` across tests.

```robot
Test Setup    Run Keywords
...  Get Bearer Token
...  Get Address ID
```
`Run Keywords` allows calling multiple keywords in one `Test Setup`. Here it: logs in to get a fresh token, then fetches the first address to set `${DEFAULT_ADDRESS_ID}`. Both must succeed for any test to proceed.

---

#### Test: `Get order history`
Fetches all past orders for the shopper. No special preconditions beyond authentication.

---

#### Test: `Place order from cart`

> ⚠️ **Precondition:** The cart **must have at least one item** before this test runs. Either:
> - Run `shopper_cart.robot` first (without `-e delete`), OR
> - Manually add a product to the cart before running

```robot
${address_info}=  Create Dictionary
...  addressId=${DEFAULT_ADDRESS_ID}   # fetched by Get Address ID in Test Setup
```
Uses the first address from the shopper's address book, fetched automatically in Test Setup.

```robot
${payload}=  Create Dictionary
...  address=${address_info}
...  paymentMode=COD
```
Builds the order payload. `paymentMode` must be `COD` (as per Swagger — not `paymentMethod`).

```robot
${order_id}=  Get From Dictionary    ${body}[data]    orderId
Set Suite Variable    ${ORDER_ID}   ${order_id}
```
Extracts the newly created `orderId` and saves it so the next two tests can use it.

---

#### Test: `Update Order Status`
```robot
${qp}=  Create Dictionary  status=DELIVERED
${response}=    PATCH On Session    order_session
...    /shoppers/${SHOPPER_ID}/orders/${ORDER_ID}
...    headers=${header}
...    params=${qp}
```
`status` is sent as a **query parameter** (not in the request body). Valid values: `PLACED`, `IN_TRANSIT`, `DISPATCHED`, `OUT_FOR_DELIVERY`, `DELIVERED`, `CANCELLED`, `REJECTED`.

> ⚠️ **Precondition:** `Place order from cart` must run first to set `${ORDER_ID}`.

---

#### Test: `Generate Invoice Copy`
```robot
${response}=    GET On Session    order_session
...    /shoppers/${SHOPPER_ID}/orders/${ORDER_ID}/invoice
...    headers=${header}
```
Fetches the invoice for a specific order. Response is XML (not JSON), so use `${response.content}` to log it.

> ⚠️ **Precondition:** `Place order from cart` must run first to set `${ORDER_ID}`.

---

### `api/product_view_action.robot`

A minimal file that tests product browsing.

#### Test: `Return all Default Product`
```robot
${qp}=  Create Dictionary    zoneId=ALPHA
${response}=  GET On Session    product_session  /products/alpha  headers=${header}   params=${qp}
```
Passes `zoneId=ALPHA` as a query parameter. The full URL becomes `/products/alpha?zoneId=ALPHA`.

---

## Variable Reference

| Variable | Set In | Used In |
|---|---|---|
| `${BASE_URL}` | `bearer_token.robot` (static) | All files |
| `${USER_EMAIL}` | `bearer_token.robot` (static) | `shopper_profile.robot`, login |
| `${USER_PASSWORD}` | `bearer_token.robot` (static) | Login |
| `${USER_ROLE}` | `bearer_token.robot` (static) | Login |
| `${token}` | `Get Bearer Token` keyword | All authenticated requests |
| `${SHOPPER_ID}` | `Get Bearer Token` keyword | All files |
| `${DEFAULT_ADDRESS_ID}` | `Get Address ID` keyword | `shopper_order.robot` |
| `${ADDRESS_ID}` | `Add new Address` test | `Get address by addressId`, `Update`, `Delete` address |
| `${ITEM_ID}` | `Add a product to Cart` test | `Update an added product in Cart` |
| `${PRODUCT_ID}` | `Add a product to Cart` / `Add to wishlist` | `Delete from Cart`, `Delete from wishlist` |
| `${ORDER_ID}` | `Place order from cart` test | `Update Order Status`, `Generate Invoice Copy` |

---

## Execution Order & Dependencies

```
bearer_token.robot          (Resource - never run directly)
        ↓
shopper_profile.robot       (independent - no dependencies)
        ↓
shopper_address.robot       (Add Address → sets ${ADDRESS_ID})
        ↓
shopper_cart.robot          (Add to Cart → sets ${ITEM_ID}, ${PRODUCT_ID})
        ↓                   ⚠️ Don't run with delete tag before order tests
shopper_wishlist.robot      (Add to Wishlist → sets ${PRODUCT_ID})
        ↓
shopper_order.robot         (needs cart items + address → sets ${ORDER_ID})
        ↓
product_view_action.robot   (independent - no dependencies)
```

---

## Common Mistakes ❌

### 1. Importing a test file as a Resource
```robot
# ❌ WRONG — shopper_address.robot has a Test Cases section
Resource    ../api/shopper_address.robot

# ✅ CORRECT — only files with a Keywords section (no Test Cases) can be Resources
Resource    ../auth/bearer_token.robot
```
**Rule:** A Resource file must NEVER contain a `Test Cases` section or `Test Setup` in Settings. It should only have `Keywords`, `Variables`, and `Settings` (Libraries). If you need to share logic, move it to a `*** Keywords ***` section in a dedicated resource file.

---

### 2. Running files separately and expecting variables to carry over
```bash
# ❌ WRONG — ${ORDER_ID} set in first run is lost
robot api/shopper_cart.robot
robot api/shopper_order.robot

# ✅ CORRECT — same session, variables shared
robot api/shopper_cart.robot api/shopper_order.robot
```

---

### 3. Using `Set Global Variable` vs `Set Suite Variable`
```robot
# ⚠️ Set Suite Variable — only within the same file (suite)
Set Suite Variable    ${ORDER_ID}    ${order_id}

# ✅ Use Set Global Variable if sharing across multiple files in one run
Set Global Variable    ${ORDER_ID}    ${order_id}
```
In this project, `Set Suite Variable` works because dependent tests are in the **same file**. Use `Set Global Variable` only when sharing across different `.robot` files.

---

### 4. Wrong payload key name
```robot
# ❌ WRONG
...  paymentMethod=COD

# ✅ CORRECT (as per Swagger)
...  paymentMode=COD
```

---

### 5. Placing an order with an empty cart
The `Place order from cart` test will return a **404 error** if the cart is empty. Always ensure cart has items by either:
- Running `shopper_cart.robot` (without `-e delete`) before `shopper_order.robot`
- Manually adding a product to the cart via Swagger

---

### 6. Dependent tests failing due to chain reaction
If `Add new Address` fails → `${ADDRESS_ID}` is never set → `Get address by addressId`, `Update an added Address`, and `Delete an added Address` all fail with `Variable '${ADDRESS_ID}' not found`.

Same applies to:
- `Add a product to Cart` failing → `Update` and `Delete` cart tests fail
- `Place order from cart` failing → `Update Order Status` and `Generate Invoice Copy` fail

---

### 7. Running delete tests before order tests
```bash
# ❌ WRONG — deletes cart items, then order test finds empty cart
robot -d reports api/shopper_cart.robot api/shopper_order.robot

# ✅ CORRECT — exclude delete so cart items remain for order tests
robot -d reports -e delete api/shopper_cart.robot api/shopper_order.robot
```

---

### 8. `Test Setup` and `Test Cases` in a Resource file
```robot
# ❌ WRONG — bearer_token.robot is imported as Resource
# Adding Test Setup or Test Cases to it will cause:
# "Setting 'Test Setup' is not allowed in resource file"
# "Resource file with 'Test Cases' section is invalid"
```
Keep resource files clean — only `*** Settings ***` (Libraries), `*** Variables ***`, and `*** Keywords ***`.

---

### 9. Using `AND` incorrectly in `Run Keywords`
```robot
# ❌ WRONG — missing AND between keywords with arguments
Test Setup    Run Keywords
...    Create Session    my_session    ${BASE_URL}
...    Get Bearer Token

# ✅ CORRECT — use AND to separate keywords that have arguments
Test Setup    Run Keywords
...    Create Session    my_session    ${BASE_URL}    AND
...    Get Bearer Token
```
When keywords have NO arguments (like `Get Bearer Token`), you can omit `AND`. But when any keyword has arguments, always use `AND` between keywords.

---

## Quick Reference: HTTP Methods Used

| Method | Used For |
|---|---|
| `GET On Session` | Fetch data (orders, cart, address, profile, products) |
| `POST On Session` | Create new records (login, add address, add to cart, place order) |
| `PUT On Session` | Full update (update address, update cart item) |
| `PATCH On Session` | Partial update (update shopper profile, update order status) |
| `DELETE On Session` | Remove records (delete address, cart item, wishlist item) |
