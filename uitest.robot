*** Settings ***
Library  SeleniumLibrary

# The following will run for each test case
Test Setup  Begin Web Test
Test Teardown  End Web Test

*** Variables ***
${BROWSER} =  chrome
${START_URL} =  https://yellow.co.nz/our-products/search-ads/
${SEARCH_WHAT} =  Cafe
${SEARCH_WHERE} =  Auckland

*** Test Cases ***
User can buy online products
    Online Purchase Search Ads Pronduct

*** Keywords ***
Begin Web Test
    # open browser  about:blank  ${BROWSER}
    ${c_opts} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${c_opts}   add_argument    headless
    Call Method    ${c_opts}   add_argument    disable-gpu
    Call Method    ${c_opts}   add_argument    no-sandbox
    Call Method    ${c_opts}   add_argument    window-size\=1024,768
    Create Webdriver    Chrome    yol_alias    chrome_options=${c_opts}
    Go To    ${START_URL}

End Web Test
    Close All Browsers

Online Purchase Search Ads Pronduct
    Wait until element is enabled    Xpath=//a[contains(text(),'get started')]
    Wait Until Keyword Succeeds    5s    1s    Click Element    Xpath=//a[contains(text(),'get started')]
    Sleep    3s
    Capture Page Screenshot
