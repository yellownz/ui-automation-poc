# ui-automation-poc
UI test automation scripts for PoC work

Please go to [this link](https://www.notion.so/yellownz/UI-Test-Automation-Proof-of-Concept-730e6baf78d24b1dbff362121846e136) to see how to use this repository.

Note:
Currently we have two options of Cloud Based Selenium Grid, one is [LambdaTest](https://www.lambdatest.com/), the other is [BrowserStack](https://www.browserstack.com/). It requiers we set the environment variable REMOTE_URL properly before running tests.

For LambdaTest:
set REMOTE_URL=https://${username}:${accesskey}@hub.lambdatest.com/wd/hub
e.g. https://leo.liang:fL1GyycafGz0bi45KrIsQ9KgZhQ50QoO4VoRzINoC9QUazxIlN@hub.lambdatest.com/wd/hub

For BrowserStack:
set REMOTE_URL=http://${username}:${accesskey}@hub.browserstack.com:80/wd/hub
e.g. http://leoliang3:tF9U3xRrWHMUByqDJQz8@hub.browserstack.com:80/wd/hub
