*** Settings ***
Library     SeleniumLibrary
Resource    helper.robot

# The following will run for each test case
Test Setup        Begin Web Test
Test Teardown     End Web Test

# The following will run once for the test suite
Suite Teardown    Update Global Test Status

*** Variables ***
${BROWSER} =          %{BROWSER}
${START_URL} =        https://yellow.co.nz/our-products/search-ads/
${SEARCH_WHAT} =      Cafe
${SEARCH_WHERE} =     Auckland
${REMOTE_URL}=        %{REMOTE_URL}
#${REMOTE_URL}=       https://leo.liang:fL1GyycafGz0bi45KrIsQ9KgZhQ50QoO4VoRzINoC9QUazxIlN@hub.lambdatest.com/wd/hub

*** Test Cases ***
User can buy online products
    Online Purchase Search Ads Pronduct

#failure case
#    Fail    just fail the test

*** Keywords ***
Begin Web Test
    Create Customized Webdriver    ${BROWSER}    ${REMOTE_URL}
    Go To    ${START_URL}

End Web Test
    Close All Browsers

Online Purchase Search Ads Pronduct
    Wait until element is enabled    Xpath=//a[contains(text(),'get started')]
    Wait Until Keyword Succeeds    5s    1s    Click Element    Xpath=//a[contains(text(),'get started')]
    Sleep    3s
    Capture Page Screenshot