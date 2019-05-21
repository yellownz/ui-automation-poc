*** Settings ***
Library        RequestsLibrary
Suite Setup    create github api session

*** Variables ***
${API_ROOT}             https://api.github.com
${API_HEADER_ACCEPT}    application/vnd.github.flash-preview+json, application/vnd.github.ant-man-preview+json
{GITHUB_TOKEN}          %{GITHUB_TOKEN}
${COMMIT_ID}            64aa1982864d18016ca9590cb7c5fa99369e1236
${COMMIT_URI}           /Begoodpapa/ui-automation-poc/statuses/${COMMIT_ID}

*** Test Cases ***
List Github Repos
    [tags]    debug
    ${resp}     Get Request     GITHUB     users/Begoodpapa/repos
        Should Be Equal As Strings  ${resp.status_code}     200     [ERROR] Response not OKAY (200)
        Log     ${resp.content}

Notify Github For Testing Result
    ${resp}    post request on endpoint    GITHUB    ${COMMIT_URI}

*** Keywords ***
create github api session
    ${header}           Create Dictionary   Authorization=token ${GITHUB_TOKEN}    Accept=${API_HEADER_ACCEPT}
    Create Session      GITHUB    ${API_ROOT}   headers=${header}

post request on endpoint
    [Arguments]  ${alias}  ${uri}
    ${resp}     POST Request     ${alias}     ${uri}
        Should Be Equal As Strings  ${resp.status_code}     200     [ERROR] Response not OKAY (200)
        Log     ${resp.content}
    [Return]  ${resp}