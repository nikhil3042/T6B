# 🧪 GullyLabs – Robot Framework Test Automation Framework

> A structured, maintainable, and CI/CD-ready end-to-end test automation framework built with **Robot Framework** and **SeleniumLibrary** for the [GullyLabs](https://gullylabs.com) e-commerce website.

---

## 📑 Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Folder & File Explanations](#folder--file-explanations)
  - [config/](#config)
  - [locators/](#locators)
  - [resources/pages/](#resourcespages)
  - [resources/common_resorces.robot](#resourcescommon_resorcesrobot)
  - [tests/](#tests)
  - [Root Level Files](#root-level-files)
- [Test Cases Covered](#test-cases-covered)
- [How to Set Up & Run](#how-to-set-up--run)
- [CI/CD with Jenkins](#cicd-with-jenkins)
- [Environment Configuration](#environment-configuration)
- [Design Principles](#design-principles)
- [.gitignore Breakdown](#gitignore-breakdown)

---

## Overview

This framework automates functional testing of the **GullyLabs e-commerce platform**. It covers user flows like login, logout, product search, add to cart, cart verification, and full end-to-end journeys.

The framework follows the **Page Object Model (POM)** pattern — separating locators, page-level keywords, and test cases into dedicated layers. This makes it easy to maintain, scale, and plug into a CI/CD pipeline via Jenkins.

---

## Tech Stack

| Tool / Library | Version | Purpose |
|---|---|---|
| Robot Framework | 7.4.2 | Core test automation framework |
| SeleniumLibrary | 6.8.0 | Browser automation via Selenium |
| Selenium | 4.24.0 | WebDriver bindings for Python |
| WebDriver Manager | 4.0.2 | Auto-manages browser drivers |
| Pabot | 5.2.2 | Parallel test execution |
| DataDriver (XLS) | 1.11.2 | Data-driven testing from Excel |
| PyYAML | 6.0.3 | Parsing `env.yaml` config file |
| python-dotenv | 1.2.2 | Optional `.env` file support |
| Python | 3.x | Runtime for all above libraries |
| Jenkins | — | CI/CD pipeline execution |

---

## Project Structure

```
GullyLabs-Automation/
│
├── config/
│   ├── env.yaml                        # Environment-specific credentials & URLs
│   └── env_loader.py                   # Python utility to load env config into RF
│
├── locators/
│   ├── cart_page_locators.robot        # XPath/CSS locators for cart page
│   ├── home_page_locators.robot        # XPath/CSS locators for home page
│   ├── login_page_locators.robot       # XPath/CSS locators for login page
│   └── logout_page_locators.robot      # XPath/CSS locators for logout page
│
├── resources/
│   ├── common_resorces.robot           # Shared setup keywords (open/close browser, load env)
│   └── pages/
│       ├── cart_page.robot             # Keywords for cart page actions
│       ├── close_cart_page.robot       # Keyword to close the cart drawer
│       ├── home_page.robot             # Keywords for home page actions
│       ├── login_page.robot            # Keywords for login actions
│       ├── logout_page.robot           # Keywords for logout actions
│       └── search_page.robot           # Keywords for product search actions
│
├── tests/
│   ├── test_login.robot                # TC_01: Successful login
│   ├── test_logout.robot               # TC_02: Successful logout
│   ├── test_search.robot               # TC_03: Search a valid product
│   ├── test_add_to_cart.robot          # TC_04: Add product to cart
│   ├── test_and_verify_product_in_cart.robot  # TC_05: Verify cart contents
│   ├── test_end_to_end.robot           # TC_06: Full E2E user journey
│   ├── test_invalid_credentials.robot  # TC_07: Login with wrong credentials
│   └── test_serach_non_existing_product.robot # TC_08: Search non-existing product
│
├── reports/                            # Auto-generated test reports (gitignored)
│
├── GullyLabs_TestCases.xlsx            # Master test case document (manual/reference)
├── Jenkinsfile                         # Jenkins pipeline definition
├── requirements.txt                    # Python dependencies
└── .gitignore                          # Files/folders excluded from Git
```

---

## Folder & File Explanations

---

### `config/`

**Why this folder exists:** All test environments (QA, Dev, Prod) need different URLs and credentials. Instead of hardcoding these values across test files, they are centralized here. This means switching environments is a one-variable change.

---

#### `env.yaml`

```yaml
qa:
  baseurl: 'https://gullylabs.com'
  user_email: 'jepep82926@fengnu.com'
  user_password: 'WhitePasta123'
dev:
  ...
prod:
  ...
```

**What is stored here:** Base URL, login email, and password for each environment (qa, dev, prod).

**Why YAML:** YAML is human-readable and natively supported by PyYAML. It allows a clean, nested key-value structure perfect for environment configs.

**How it is used:** The `env_loader.py` script reads this file at runtime and loads the correct environment block into Robot Framework global variables.

> ⚠️ **Security Note:** This file currently contains credentials in plain text. In production, sensitive values should be injected via environment variables or a secrets manager (e.g., Jenkins credentials store, HashiCorp Vault).

---

#### `env_loader.py`

```python
import yaml, os

_data = {}

def load_env(env):
    file_path = os.path.join(os.path.dirname(__file__), "env.yaml")
    with open(file_path, "r") as file:
        config = yaml.safe_load(file)
    global _data
    _data = config[env]

def get_env(key):
    return _data.get(key.lower())
```

**What it does:** A Python library imported directly into Robot Framework. It has two functions:

- `load_env(env)` — Reads `env.yaml` and loads the block matching the given environment name (e.g., `qa`).
- `get_env(key)` — Returns a specific value (like `baseurl` or `user_email`) from the loaded environment block.

**Why Python:** Robot Framework allows importing Python files as libraries. This gives you the full power of Python for logic that is too complex for Robot's built-in syntax — like reading YAML files and managing global state.

**Where it is called:** Inside `common_resorces.robot` via the `Load Environment` keyword, which then sets global Robot Framework variables like `${BASE_URL}`, `${USER_EMAIL}`, and `${USER_PWD}`.

---

### `locators/`

**Why this folder exists:** Locators (XPath, CSS selectors, IDs) are the most frequently changing part of any UI test suite. When the UI changes, you only need to update the locator in one place rather than hunting through every test file. This is the foundation of the **Page Object Model** pattern.

**What is stored here:** Robot Framework `*** Variables ***` sections containing element locators for each page.

---

#### `cart_page_locators.robot`

| Variable | Locator | What it targets |
|---|---|---|
| `${first_product}` | `xpath=//div[@id="ProductGridContainer"]/descendant::a` | First product link in the product grid |
| `${gender}` | `xpath=//div[@class="gender-button"]/a[text()="Men"]` | "Men" gender selector on product page |
| `${size}` | `xpath=//select[@class='select']` | Size dropdown selector |
| `${add_ot_cart_btn}` | `xpath=//button[@name='add']` | Add to Cart button |
| `${close_cart_btn}` | `xpath=//button[@data-entity-name="Close"]` | Cart drawer close button |
| `${name_in_cart}` | `xpath=//div[@class="product__title grid gap-3"]/h1` | Product title on product detail page |

---

#### `home_page_locators.robot`

| Variable | Locator | What it targets |
|---|---|---|
| `${account}` | `xpath=(//shopify-account)[2]` | Account icon on the navigation bar |
| `${search_button}` | `xpath=(//a[@href='/search'])[2]` | Search icon on the navigation bar |
| `${search_field}` | `xpath=//input[@class='input search__input']` | Search text input field |
| `${product_name}` | `xpath=//p[@class='grow']/descendant::a[...]` | Specific product link in search results |

> **Note:** `(//shopify-account)[2]` uses index `[2]` because Shopify renders account elements twice (mobile + desktop). Index 2 targets the desktop/visible one.

---

#### `login_page_locators.robot`

| Variable | Locator | What it targets |
|---|---|---|
| `${email_field}` | `id=CustomerEmail` | Email input on the login form |
| `${password_field}` | `id=CustomerPassword` | Password input on the login form |
| `${sign_in_button}` | `xpath=(//button[@class="button button--primary button--fixed"])[2]` | Sign In submit button |

---

#### `logout_page_locators.robot`

| Variable | Locator | What it targets |
|---|---|---|
| `${account_btn}` | `xpath=(//shopify-account)[2]` | Account icon to open account menu |
| `${logout_link}` | `xpath=//a[@href='/account/logout']` | Log out link inside account dropdown |

---

### `resources/pages/`

**Why this folder exists:** This layer contains **reusable keywords** built on top of raw locators. Instead of repeating `Click Element ${email_field}` in every test, you call `Login To GullyLabs`. This is the **keyword abstraction layer** — it makes tests readable, reusable, and easy to maintain.

---

#### `cart_page.robot`

**Purpose:** Contains the `Add To Cart` keyword — the most complex action keyword in the framework.

**What `Add To Cart` does step by step:**
1. Clicks the first product in the product grid.
2. Selects the "Men" gender option.
3. Captures the product name from the page (`${name_in_cart}`) and normalizes whitespace using Python's `str.split()` + `join` via `Evaluate`.
4. Selects size "UK 7" from the size dropdown.
5. Clicks the "Add to Cart" button.
6. Verifies the page contains "Cart".
7. Returns the normalized product name — used later in `TC_05` to verify the correct product appears in the cart.

> **Why `Evaluate`?** Product names on the page can have inconsistent whitespace (tabs, double spaces). `' '.join($name.split())` normalizes it to single spaces so string comparisons work reliably.

---

#### `close_cart_page.robot`

**Purpose:** A single-keyword file that closes the cart slide-out drawer.

**What `Close Cart` does:**
1. Waits until the close button is enabled (not just visible — this prevents clicking before the animation completes).
2. Clicks the close button.

**Why separate?** The cart close action is used in the E2E test after adding to cart. Keeping it separate makes it composable and avoids duplicating the wait logic.

---

#### `home_page.robot`

**Purpose:** Keywords for actions on the home/navigation bar.

**Keywords:**

- `Clicking On Accounts` — Clicks the account icon to navigate to the login page or account menu.
- `Clicking On Search` — Clicks the search icon to open the search bar.

**Why these are separate keywords:** Every test that requires login starts with `Clicking On Accounts`. Abstracting it means if the account icon locator changes, you fix it in one locator file and one keyword — not in 7 test files.

---

#### `login_page.robot`

**Purpose:** The login action keyword.

**What `Login To GullyLabs` does:**
1. Takes `${email}` and `${password}` as arguments.
2. Types email into the email field.
3. Types password into the password field.
4. Waits for the sign-in button to be enabled.
5. Clicks the sign-in button.

**Why arguments instead of hardcoded values:** The same keyword is reused for both valid credentials (from `${USER_EMAIL}`, `${USER_PWD}`) and invalid credentials (hardcoded wrong values in `TC_07`). Arguments make it flexible.

> **Commented-out assertions:** `Page Should Contain Account` and the logout link check are commented out. These can be uncommented to add post-login verification if the page reliably shows those elements after login.

---

#### `logout_page.robot`

**Purpose:** The logout action keyword.

**What `Logout From GullyLabs` does:**
1. Clicks the account button (opens account dropdown menu).
2. Logs a confirmation message.
3. Clicks the logout link (`/account/logout`).

---

#### `search_page.robot`

**Purpose:** The product search keyword.

**What `Search a product` does:**
1. Takes `${product}` as the search term argument.
2. Clicks the search button to open the search panel.
3. Waits 2 seconds for the panel animation.
4. Types the search term into the search input.
5. Presses `ENTER` to trigger the search.

---

### `resources/common_resorces.robot`

**Why this file exists:** Every single test in the framework needs to open a browser, load environment credentials, and close the browser. Centralizing these in one file prevents duplication and ensures every test uses the same setup/teardown behavior.

**What is stored here:** Shared libraries, global variables, and foundational keywords used across all tests.

```robot
*** Settings ***
Library  SeleniumLibrary
Library  ../config/env_loader.py    ← imports Python file as a library

*** Variables ***
${BROWSER}  chrome                  ← default browser
${ENV}      qa                      ← default environment
```

**Keywords:**

| Keyword | What it does |
|---|---|
| `Load Environment` | Calls `env_loader.py` to load the `${ENV}` block from `env.yaml`, then sets `${BASE_URL}`, `${USER_EMAIL}`, `${USER_PWD}` as global Robot Framework variables |
| `Open Application` | Opens Chrome browser at `${BASE_URL}` and maximizes the window |
| `Close Application` | Closes all open browser instances |

**How they are used in tests:**
```robot
Suite Setup     Load Environment    ← runs once before the entire suite
Test Setup      Open Application    ← runs before each test case
Test Teardown   Close Application   ← runs after each test case (even if test fails)
```

This pattern guarantees a **fresh browser session** for every test, preventing state leakage between tests.

---

### `tests/`

**Why this folder exists:** This is the only layer that should change when business requirements change. Tests import page keywords and simply describe *what* to do in plain English — not *how* to do it. This is the top of the POM hierarchy.

---

#### `test_login.robot` — TC_01: Successful Login

**Flow:** Open browser → Click Account icon → Enter valid credentials → Sign in.

**Tags:** `functional`

**Verifies:** That the login flow completes without error (implicit verification via no exception thrown).

---

#### `test_logout.robot` — TC_02: Logout Successful

**Flow:** Login → Wait 5 seconds (for page to settle) → Click Account → Click Logout.

**Tags:** `Functional`

**Why the 5s sleep?** The page needs time to complete the login redirect before attempting to find the account dropdown. A more robust solution would use `Wait Until Page Contains Element`.

---

#### `test_search.robot` — TC_03: Search a Product

**Flow:** Login → Search for "Shoes".

**Tags:** `functional`

**Verifies:** That the search feature is accessible after login and does not crash.

---

#### `test_add_to_cart.robot` — TC_04: Add Product to Cart

**Flow:** Login → Search "Shoes" → Add first result to cart.

**Verifies:** That the page contains "Cart" after clicking Add to Cart (confirming the cart interaction succeeded).

---

#### `test_and_verify_product_in_cart.robot` — TC_05: Verify Product in Cart

**Flow:** Login → Search "Shoes" → Add to Cart → Capture returned product name → Verify the same product name appears on the cart page.

**Key behavior:** `Add To Cart` keyword returns `${name1}` (the product name). The test then uses `Page Should Contain ${name1}` to assert the correct product was added. This is a **data-driven assertion** — it works regardless of which product gets added.

---

#### `test_end_to_end.robot` — TC_06: Complete End-to-End Test

**Flow:** Login → Search "Shoes" → Add to Cart → Close Cart → Click Account → Logout.

**Why this test matters:** This is the most important test. It simulates a real user journey from start to finish. If this passes, the core purchase flow is working end-to-end.

---

#### `test_invalid_credentials.robot` — TC_07: Login with Invalid Credentials

**Flow:** Navigate to login → Enter wrong email and password → Verify error message.

**Asserts:** `Page Should Contain    Incorrect email or password`

**Why this test matters:** Negative testing. Verifies the application correctly rejects bad credentials and displays the right error — critical for security and UX.

---

#### `test_serach_non_existing_product.robot` — TC_08: Search Non-Existing Product

**Flow:** Login → Search "suit case" → Verify no-results message.

**Asserts:** `Page Should Contain    No results found for "suit case"`

**Why this test matters:** Another negative test. Ensures the search gracefully handles zero results and displays a helpful message rather than crashing or showing a blank page.

> **Note:** There is a typo in the filename (`serach` instead of `search`). Consider renaming to `test_search_non_existing_product.robot` for consistency.

---

### Root Level Files

---

#### `requirements.txt`

**Purpose:** Defines all Python packages needed to run the framework. Anyone cloning the repo can run `pip install -r requirements.txt` to get a fully working environment instantly.

**Why each package is included:**

| Package | Reason |
|---|---|
| `robotframework` | The core framework itself |
| `robotframework-seleniumlibrary` | Browser automation keywords for Robot |
| `selenium` | The underlying WebDriver engine |
| `webdriver-manager` | Automatically downloads/manages ChromeDriver — no manual driver setup |
| `robotframework-pabot` | Enables running tests in parallel to reduce execution time |
| `robotframework-datadriver[XLS]` | Enables data-driven tests from Excel files |
| `PyYAML` | Needed by `env_loader.py` to parse `env.yaml` |
| `python-dotenv` | Allows loading `.env` files if needed in future |

---

#### `GullyLabs_TestCases.xlsx`

**Purpose:** The master test case document. Contains the manual/reference test cases that were used as the basis for building automated tests.

**Why it is here:** Serves as documentation and traceability — stakeholders and QA leads can review what is being tested without reading Robot Framework syntax. Also used with `robotframework-datadriver` for data-driven test execution if needed.

---

#### `Jenkinsfile`

**Purpose:** Defines the full CI/CD pipeline that Jenkins executes automatically (e.g., on every Git push or on a schedule).

**Pipeline Stages:**

| Stage | What it does |
|---|---|
| `Cleanup Old Reports` | Deletes report folders older than 7 days using PowerShell to prevent disk bloat |
| `Setup Virtual Environment` | Creates a `.venv` Python virtual environment if one doesn't already exist |
| `Install / Update Requirements` | Upgrades pip and installs all packages from `requirements.txt` into the venv |
| `Run Robot Framework Tests` | Runs all tests in the `tests/` folder, outputs results to a date-stamped folder under `reports/` |
| `Generate RobotMetrics Report` | Generates an enhanced HTML report using RobotMetrics for better test analytics |

**Post-Build Actions:**

| Condition | Action |
|---|---|
| `always` | Publishes the Robot report in Jenkins UI (pass threshold: 90%, unstable threshold: 80%) |
| `success` | Logs ✅ success message |
| `unstable` | Logs ⚠️ warning (some tests failed but above unstable threshold) |
| `failure` | Logs ❌ failure (critical error or below unstable threshold) |
| `cleanup` | Keeps the workspace so reports remain accessible |

**Why date-stamped reports?** `reports\yyyyMMdd\` means each day's run gets its own folder. Jenkins keeps the last 10 builds, and the cleanup stage removes anything older than 7 days — balancing history retention with disk usage.

> **Platform note:** This Jenkinsfile uses `powershell` steps, meaning it is designed for a **Windows-based Jenkins agent**. For Linux agents, replace `powershell` steps with `sh` and adjust path separators.

---

#### `.gitignore`

**Purpose:** Tells Git which files and folders should never be committed to the repository.

**Key sections and why:**

| Section | What is ignored | Why |
|---|---|---|
| Python & Virtual Env | `.venv/`, `__pycache__/`, `*.pyc` | Virtual environments are machine-specific and regenerated from `requirements.txt` |
| Robot Reports | `reports/` | Test reports are generated artifacts — large, binary, and environment-specific |
| RobotMetrics | `RobotMetrics/`, `robotmetrics-report/` | Same reason — generated output |
| PyCharm IDE | `.idea/`, `*.iml` | IDE config is personal and should not pollute the repo for other developers |
| Windows Files | `Thumbs.db`, `Desktop.ini` | OS-generated junk files |
| Credentials & Secrets | `.env`, `secrets.py`, `*.key`, `*.pem` | **Critical** — private keys and `.env` files must never be committed |
| Local Config Overrides | `config/config.local.yaml` | Developer-specific local overrides that differ from team defaults |
| Pytest / Coverage | `.pytest_cache/`, `.coverage` | Generated test artifacts |
| Logs & Temp | `*.log`, `*.tmp`, `~$*` | Temporary and lock files |

---

## Test Cases Covered

| TC ID | Test File | Type | Description |
|---|---|---|---|
| TC_01 | `test_login.robot` | Positive | Successful login with valid credentials |
| TC_02 | `test_logout.robot` | Positive | Successful logout after login |
| TC_03 | `test_search.robot` | Positive | Search for an existing product ("Shoes") |
| TC_04 | `test_add_to_cart.robot` | Positive | Add a product to the cart |
| TC_05 | `test_and_verify_product_in_cart.robot` | Positive | Verify correct product appears in cart |
| TC_06 | `test_end_to_end.robot` | E2E | Full flow: Login → Search → Add to Cart → Close Cart → Logout |
| TC_07 | `test_invalid_credentials.robot` | Negative | Login with wrong credentials shows error |
| TC_08 | `test_serach_non_existing_product.robot` | Negative | Search for non-existent product shows no-results message |

---

## How to Set Up & Run

### Prerequisites

- Python 3.8 or above
- Google Chrome browser installed
- Git

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd GullyLabs-Automation
```

### 2. Create a Virtual Environment

```bash
python -m venv .venv
```

### 3. Activate the Virtual Environment

**Windows:**
```bash
.venv\Scripts\activate
```

**macOS/Linux:**
```bash
source .venv/bin/activate
```

### 4. Install Dependencies

```bash
pip install -r requirements.txt
```

### 5. Run All Tests

```bash
robot -d reports/local tests/
```

### 6. Run a Specific Test File

```bash
robot -d reports/local tests/test_login.robot
```

### 7. Run Tests by Tag

```bash
robot -d reports/local --include functional tests/
```

### 8. Run Tests in Parallel (using Pabot)

```bash
pabot --processes 4 -d reports/local tests/
```

### 9. View the Report

Open `reports/local/report.html` in your browser.

---

## CI/CD with Jenkins

The `Jenkinsfile` at the root of the project defines a full automated pipeline.

**To use it:**
1. Create a new **Pipeline** job in Jenkins.
2. Set the pipeline definition to **"Pipeline script from SCM"**.
3. Point it to this repository.
4. Jenkins will automatically detect and execute the `Jenkinsfile`.

The pipeline will:
- Set up the Python environment.
- Install dependencies.
- Run all tests.
- Publish the Robot Framework HTML report inside Jenkins.
- Mark the build as **Passed**, **Unstable**, or **Failed** based on the pass threshold.

---

## Environment Configuration

To switch between environments, change the `${ENV}` variable in `resources/common_resorces.robot`:

```robot
${ENV}  qa       ← change to 'dev' or 'prod'
```

Or pass it at runtime:

```bash
robot -v ENV:prod -d reports/local tests/
```

This will load the corresponding block from `config/env.yaml`.

---

## Design Principles

This framework follows these software engineering and QA best practices:

1. **Page Object Model (POM):** Locators, page keywords, and test cases are in separate layers. Changing the UI only requires updating the locator file — not the tests.

2. **Single Responsibility:** Each file has one job. `login_page_locators.robot` only holds locators. `login_page.robot` only holds keywords. `test_login.robot` only holds test cases.

3. **DRY (Don't Repeat Yourself):** Browser setup/teardown, environment loading, and common actions are defined once in `common_resorces.robot` and reused everywhere.

4. **Environment Abstraction:** No credentials or URLs are hardcoded in test files. All environment-specific data comes from `env.yaml` via `env_loader.py`.

5. **Positive + Negative Testing:** The suite covers both happy paths (valid login, successful search) and unhappy paths (invalid credentials, no search results).

6. **CI/CD Ready:** The `Jenkinsfile` makes this framework production-ready — tests run automatically, reports are published, and build health is tracked.

---

## .gitignore Breakdown

The `.gitignore` is organized into clearly labeled sections:

- **Python & Virtual Environment** — keeps generated bytecode and environment folders out of the repo.
- **Robot Framework Reports** — test output is regenerated on every run, no need to version it.
- **PyCharm IDE files** — keeps developer-specific IDE settings private.
- **Windows System Files** — prevents OS junk files from polluting the repo.
- **Credentials & Secrets** — the most important section; ensures `.env` files and private keys are never accidentally committed.
- **Local Config Overrides** — lets developers have local settings without affecting the team.
- **Logs & Temp Files** — keeps the repository clean of runtime noise.

---

*This README was generated based on full source analysis of the GullyLabs Robot Framework automation project.*
