*** Settings ***
Library        RequestsLibrary
Suite Setup    create github api session
Resource       helper.robot

*** Variables ***
${API_ROOT}             https://api.github.com
${API_HEADER_ACCEPT}    application/vnd.github.flash-preview+json, application/vnd.github.ant-man-preview+json
${GITHUB_TOKEN}         %{GITHUB_TOKEN}
${COMMIT_ID}            %{COMMIT_ID}
${COMMIT_URI}           /repos/Begoodpapa/ui-automation-poc/statuses/${COMMIT_ID}

*** Test Cases ***
#List Github Repository
#    ${resp}     Get Request     GITHUB     users/Begoodpapa/repos
#        Should Be Equal As Strings  ${resp.status_code}     200     [ERROR] Response not OKAY (200)
#        Log     ${resp.content}

Notify Github For Testing Result
    ${var_existing}=    Run keyword and return status    Variable Should Exist    ${GLOBAL_TEST_STATUS}
    Run keyword unless    ${var_existing}    FAIL    Variable GLOBAL_TEST_STATUS was not assigned with proper value beforehand

    ${parent_folder}    ${sub_folder}    Get S3 Folder Names From Codebuild ID
    ${s3_link}=    Catenate    SEPARATOR=    https://s3.console.aws.amazon.com/s3/buckets/uiauto-test-logs/    ${parent_folder}/    ${sub_folder}/reports/

    ${description}    Set Variable If
    ...    ${GLOBAL_TEST_STATUS}=="success"    UI automation testing ALL PASSED
    ...    ${GLOBAL_TEST_STATUS}!="success"    UI automation testing was NOT ALL PASSED

    construct github message body    ${GLOBAL_TEST_STATUS}    "${s3_link}"    "${description}"    "click the link <Details> to view robot logs"
    ${resp}    post request on endpoint    GITHUB    ${COMMIT_URI}

*** Keywords ***
create github api session
    ${header}           Create Dictionary   Authorization=token ${GITHUB_TOKEN}    Accept=${API_HEADER_ACCEPT}
    Create Session      GITHUB    ${API_ROOT}   headers=${header}

construct github message body
    [Arguments]    ${state}    ${target_url}    ${description}    ${context}
    ${GITHUB_MSG_BODY}    Set Variable     {"state":${state},"target_url":${target_url},"description":${description},"context":${context}}
    Set Global Variable    ${GITHUB_MSG_BODY}

post request on endpoint
    [Arguments]  ${alias}  ${uri}
    ${resp}     POST Request     ${alias}     ${uri}    data=${GITHUB_MSG_BODY}
        Log     ${resp.content}
        Should Be Equal As Strings  ${resp.status_code}     201     [ERROR] Response not OKAY (201)
    [Return]  ${resp}