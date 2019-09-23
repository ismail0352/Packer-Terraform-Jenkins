# Chrome-Node

This Dockerfile can help you get started when running test for node based applications on chrome.

It gets you Node 10 and Chrome 76.

Prefably if you are using this long after it was created just recreate the image using the Dockerfile :)

## Purpose
It was created for the purpose of Performing `Karma` and `Protactor` test. But can be extended if needed with `Jenkins` as well when creating pipeline.

## Getting Started

Download chrome.json
`wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json`

Just run `docker run -d ismail0352/chrome-node --security-opt seccomp=./chrome.json`.

**Note**: Please rememeber to provide `--security-opt seccomp=./chrome.json`, without this your test will fail.
 
## Using it in Jenkinsfile
```
docker.image('ismail0352/chrome-node').inside('--name chrome-node --security-opt seccomp=$WORKSPACE/chrome.json') { 
  stage('Test') {
    sh label: 
      'Running npm run test', 
    script: '''
      …
      npm run test
      …
      '''
  }
    
  stage('e2e') {
    sh label: 
      'Running npm run e2e', 
    script: '''
      …
      npm run e2e
      …
      '''
  }
}
```
