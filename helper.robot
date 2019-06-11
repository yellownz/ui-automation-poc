*** Settings ***
Library    String
Library    Collections
Library    SeleniumLibrary

*** Variables ***
${AWS_CODE_BUID_ID}    %{CODEBUILD_BUILD_ID}    #AWS codebuild job has a environmental variable $CODEBUILD_BUILD_ID

*** Keywords ***
Set Driver Variables
    [Arguments]    ${browser}    ${remote_url}
    [Documentation]    Selects proper driver (chrome, safari, firefox, ie etc.)
    ${drivers}=    Create Dictionary    ff=Firefox    firefox=Firefox    ie=Ie
    ...    internetexplorer=Ie    googlechrome=Chrome    gc=Chrome
    ...    chrome=Chrome    opera=Opera    phantomjs=PhantomJS    safari=Safari
    ...    headlesschrome=Chrome    headlessfirefox=Firefox
    ${name}=    Evaluate    "Remote" if "${remote_url}"!="None" else $drivers["${browser}"]
    Set Global Variable    ${DRIVER_NAME}    ${name}
    ${dc names}=    Create Dictionary    ff=FIREFOX    firefox=FIREFOX    ie=INTERNETEXPLORER
    ...    internetexplorer=INTERNETEXPLORER    googlechrome=CHROME    gc=CHROME
    ...    chrome=CHROME    opera=OPERA    phantomjs=PHANTOMJS    htmlunit=HTMLUNIT
    ...    htmlunitwithjs=HTMLUNITWITHJS    android=ANDROID    iphone=IPHONE
    ...    safari=SAFARI    headlessfirefox=FIREFOX    headlesschrome=CHROME
    ${dc name}=    Get From Dictionary    ${dc names}    ${browser.lower().replace(' ', '')}
    ${driver name}=    Get From Dictionary    ${drivers}    ${browser.lower().replace(' ', '')}
    #${caps}=    Evaluate    sys.modules['selenium.webdriver'].DesiredCapabilities.${dc name}    selenium.webdriver,sys
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].${driver name}Options()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --no-sandbox
    #Call Method    ${options}    add_argument    headless
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    ${caps}=     Call Method     ${options}    to_capabilities

    Run keyword if    '${dc name}'=='SAFARI'    Run keywords
    ...    Set To Dictionary    ${caps}    platform    macOS Sierra
    ...    AND    Set To Dictionary    ${caps}    version    10.0
    ...    AND    Set To Dictionary    ${caps}    visual    true
    Run keyword if    '${dc name}'=='FIREFOX'    Run keywords
    ...    Set To Dictionary    ${caps}    platform    Windows10
    ...    AND    Set To Dictionary    ${caps}    version    66.0
    ...    AND    Set To Dictionary    ${caps}    visual    true
    #Log to console    ${caps}

    ${url as str}=    Evaluate    str('${remote_url}')    # REMOTE_URL = remote means remote Selenium Hub, otherwise it is local browser instance
    ${kwargs}=    Create Dictionary
    Run Keyword If    "${name}"=="Remote"    Set To Dictionary    ${kwargs}    command_executor
    ...    ${url as str}    desired_capabilities    ${caps}
    Run Keyword If    "${name}"!="Remote"    Set To Dictionary    ${kwargs}    desired_capabilities    ${caps}    
    Set Global Variable    ${KWARGS}    ${kwargs}

Create Customized Webdriver
    [Arguments]    ${browser}    ${remote_url}
    Set Driver Variables    ${browser}    ${remote_url}
    Create Webdriver    ${DRIVER_NAME}    kwargs=${KWARGS}

Create Global Variable For Overall Test Result
    Set Global Variable    ${GLOBAL_TEST_STATUS}    "success"    # the global variable indicates the overall test result(success/failure) of all test suites

Update Global Test Status
    ${var_existing}=    Run keyword and return status    Variable Should Exist    ${GLOBAL_TEST_STATUS}
    Run keyword unless    ${var_existing}    Create Global Variable For Overall Test Result    # this keyword should be only called for 1st test suite while the varaible is not created
    ${curr_global_test_status}=    Set Variable    ${GLOBAL_TEST_STATUS}

    ${GLOBAL_TEST_STATUS}=    Set Variable If
    ...    '${SUITE STATUS}'=='FAIL'    "failure"    #  ${SUITE STATUS} is an automatic variable indicates the status of the current test suit
    ...    '${SUITE STATUS}'=='PASS'    ${curr_global_test_status} 
    Set Global Variable    ${GLOBAL_TEST_STATUS}
    #Log    ${GLOBAL_TEST_STATUS}

Get S3 Folder Names From Codebuild ID
    [Documentation]    AWS codebuild job has a environmental variable $CODEBUILD_BUILD_ID, which has the build name as the prefix
    ...   echo $CODEBUILD_BUILD_ID 
    ...   UI_automation_PoC:922922e2-1f10-45ea-919e-a72bf3672d9f 
    ...   return value of this keyword is 922922e2-1f10-45ea-919e-a72bf3672d9f in upper exmaple
    ${length}=    Get Length    ${AWS_CODE_BUID_ID}
    : FOR   ${i}    IN RANGE    0   ${length}
    \   Log     ${AWS_CODE_BUID_ID[${i}]}
    \   Exit for loop if    '${AWS_CODE_BUID_ID[${i}]}'==':'
    ${code_build_id}=    Get Substring    ${AWS_CODE_BUID_ID}    ${i+1}
    ${code_build_task_name}=    Get Substring    ${AWS_CODE_BUID_ID}    0    ${i}
    Log Many    ${code_build_id}    ${code_build_task_name}
    [return]    ${code_build_id.strip()}    ${code_build_task_name.strip()}
