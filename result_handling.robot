*** Settings ***
Library        RequestsLibrary
Suite Setup    create github api session

*** Variables ***
${API_ROOT}             https://api.github.com
${API_HEADER_ACCEPT}    application/vnd.github.flash-preview+json, application/vnd.github.ant-man-preview+json
${GITHUB_TOKEN}         %{GITHUB_TOKEN}
${COMMIT_ID}            22640cf482150597c9a72f2c747360bf8f8908e1
${COMMIT_URI}           /repos/Begoodpapa/ui-automation-poc/statuses/${COMMIT_ID}

*** Test Cases ***
List Github Repos
    ${resp}     Get Request     GITHUB     users/Begoodpapa/repos
        Should Be Equal As Strings  ${resp.status_code}     200     [ERROR] Response not OKAY (200)
        Log     ${resp.content}

Notify Github For Testing Result
    [tags]    debug
    ${resp}    post request on endpoint    GITHUB    ${COMMIT_URI}

*** Keywords ***
create github api session
    ${header}           Create Dictionary   Authorization=token ${GITHUB_TOKEN}    Accept=${API_HEADER_ACCEPT}
    Create Session      GITHUB    ${API_ROOT}   headers=${header}

post request on endpoint
    [Arguments]  ${alias}  ${uri}
    ${resp}     POST Request     ${alias}     ${uri}
        Log     ${resp.content}
        Should Be Equal As Strings  ${resp.status_code}     200     [ERROR] Response not OKAY (200)
    [Return]  ${resp}