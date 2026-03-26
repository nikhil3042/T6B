# framework-pytest

## 📌 What is a Framework?

A **framework** is a structured way of organizing code to make development and testing easier, reusable, and maintainable.

### ❓ Why do we use a framework?

* To **reduce code duplication**
* To improve **readability and maintainability**
* To follow **best practices**
* To make automation **scalable**
* To organize test cases, reports, and configurations in a clean way

---

## 🔢 Types of Frameworks

* **Linear Framework**
  Simple record-and-playback approach where test steps are written sequentially. No reuse, mostly for beginners.

* **Modular Framework**
  Application is divided into modules, and tests are written separately for each module. Improves reusability.

* **Data-Driven Framework**
  Test data is separated from test scripts (e.g., Excel, JSON). Same test runs with multiple data sets.

* **Keyword-Driven Framework**
  Uses predefined keywords (like click, input, login) to represent actions. Non-technical users can write tests.

* **Hybrid Framework**
  Combination of multiple frameworks (most commonly used in real projects).

---

## ⚙️ What is `conftest.py`?

`conftest.py` is a special file in pytest used to store **common fixtures and setup code** that can be shared across multiple test files.

---

## 🔁 What is a Fixture?

A **fixture** is a callable function that, when decorated with `@pytest.fixture`, becomes reusable across test cases.

👉 It is mainly used to provide **setup and teardown** for tests.

### Example:

```python
import pytest
from selenium import webdriver

@pytest.fixture
def setup_and_teardown():
    driver = webdriver.Chrome()

    driver.get('https://practicetestautomation.com/practice-test-login/')
    driver.maximize_window()

    yield driver

    driver.quit()
```

### 🧠 What each line does:

* `import pytest` → Imports pytest framework
* `from selenium import webdriver` → Imports Selenium WebDriver
* `@pytest.fixture` → Converts function into a fixture
* `def setup_and_teardown():` → Fixture function
* `driver = webdriver.Chrome()` → Launches Chrome browser
* `driver.get(...)` → Opens the given URL
* `driver.maximize_window()` → Maximizes browser window
* `yield driver` → Sends driver to test & pauses execution
* `driver.quit()` → Closes browser after test finishes

---

## 📦 What is `requirements.txt`?

A file that contains all the **dependencies (libraries)** required for the project.

### Example:

```
pytest
selenium
```

👉 Install all dependencies using one command.

---

## 📂 Tests and Pages

### 🧪 Tests Folder

Contains actual test cases.

### 📄 Pages Folder

Contains page classes (elements + actions).

---

## 🧱 What is POM (Page Object Model)?

A design pattern where:

* Each webpage is represented as a **class**
* Elements and actions are separated from test logic

### ✅ Advantages:

* Reusable code
* Easy maintenance
* Better readability
* Less duplication

---

## 🚀 What is Pytest?

Pytest is a **testing framework in Python** used to write simple and scalable test cases.

### ⭐ Advantages of Pytest:

* Simple syntax
* Supports fixtures
* Powerful assertions
* Easy to use
* Supports plugins
* Parallel execution support

---

## 🐍 What is `venv`?

A **virtual environment** is an isolated Python environment.

### Why use it?

* Avoid dependency conflicts
* Keep project dependencies separate

---

## 🚫 What is `.gitignore`?

A file used to tell Git **which files/folders to ignore**.

### Example:

```
venv/
__pycache__/
*.log
```

---

## 📊 HTML Report Generation

To generate HTML reports in pytest, we use a plugin.

### 1️⃣ Install plugin:

```bash
pip install pytest-html
```

### 2️⃣ Run tests with report:

```bash
pytest --html=report.html
```

👉 This will generate an HTML report file after execution.

---

## ▶️ How to Run the Project

### 1️⃣ Create Virtual Environment

```bash
python -m venv venv
```

### 2️⃣ Activate Virtual Environment

* Windows:

```bash
venv\Scripts\activate
```

* Mac/Linux:

```bash
source venv/bin/activate
```

### 3️⃣ Deactivate Virtual Environment

```bash
deactivate
```

### 4️⃣ Install Requirements

```bash
pip install -r requirements.txt
```

### 5️⃣ Run Tests

```bash
pytest
```

or run a specific file:

```bash
pytest file_name.py
```

---

## 📂 Project Structure

```
framework-pytest/
│
├── tests/
│   └── test_login.py
│
├── pages/
│   ├── base_page.py
│   └── login_page.py
│
├── conftest.py
├── requirements.txt
└── README.md
```

---

## 📄 Pages (POM Structure)

### 🔹 Base Page (`base_page.py`)

This is the **parent class** for all pages.

👉 Common reusable methods go here:

* click element
* enter text
* wait for element
* get text

### Example:

```python
from selenium.webdriver.common.by import By

class BasePage:

    def __init__(self, driver):
        self.driver = driver

    def click(self, locator):
        self.driver.find_element(*locator).click()

    def send_keys(self, locator, value):
        self.driver.find_element(*locator).send_keys(value)
```

---

### 🔹 Login Page (`login_page.py`)

This contains:

* Locators
* Page actions

### Example:

```python
from selenium.webdriver.common.by import By
from pages.base_page import BasePage

class LoginPage(BasePage):

    username = (By.ID, "username")
    password = (By.ID, "password")
    login_btn = (By.ID, "submit")

    def login(self, user, pwd):
        self.send_keys(self.username, user)
        self.send_keys(self.password, pwd)
        self.click(self.login_btn)
```

---

## 🧪 Test File (`test_login.py`)

```python
from pages.login_page import LoginPage

def test_valid_login(setup_and_teardown):
    driver = setup_and_teardown
    login = LoginPage(driver)

    login.login("student", "Password123")
