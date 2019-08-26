node (label: 'build && linux') {
  stage('Clean Workspace'){
    cleanWs()
  }

  stage("Main build") {
    docker.image('node:10').pull()
    docker.image('ismail0352/chrome-node').pull()

    stage('Checkout SCM') {
      checkout([$class: 'GitSCM', branches: [[name: 'master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/ismail0352/Packer-Terraform-Jenkins.git']]])
    }
    
    // Permorming Install and Lint
    docker.image('node:10').inside {
      stage('Install') {
        sh label:
          'Running npm install',
        script: '''
          node --version
          cd hello-world-node
          npm install
        '''
      }

      stage('Lint') {
        sh label:
          'Running npm run lint',
        script: '''
          cd hello-world-node
          npm run lint
        '''
      }
    }

    stage('Get test dependency') {
      sh label:
        'Downloading chrome.json',
      script: '''
        wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json -O $WORKSPACE/chrome.json
      '''
    }

    docker.image('ismail0352/chrome-node').inside('--name chrome-node --security-opt seccomp=$WORKSPACE/chrome.json') {
      stage('Test') {
        sh label:
          'Running npm run test',
        script: '''
          node --version
          cd hello-world-node
          npm run test
        '''
      }

      stage('e2e') {
        sh label:
          'Running npm run e2e',
        script: '''
          cd hello-world-node
          npm run e2e
        '''
      }
    }
    stage ('Build') {
      docker.image('node:10').inside {
        sh label:
          'Running npm run build',
        script: '''
          node --version
          cd hello-world-node
          npm run build
        '''
      }
    }
  }

  stage("Deploy") {
    def containerName = "hello-nginx"
    // Any change in Volume will automatically result in Hot Reload of Nginx
    def rc = sh (script: "docker inspect -f '{{.State.Running}}' ${containerName}", returnStatus: true)
    if(rc == 0) {
      echo "Container ${containerName} exists..."
      try {
        echo "Nginx will reload changes from the mounted file system..."
        timeout(time: 120, unit: 'SECONDS') { // change to a convenient timeout for you
          input(
            message: 'Click "Create" to Discard old container and create a new one?\nClick "Abort" to keep the old one\nIf nothing is clicked "Abort" will be triggered', ok: 'Create')
          }
          echo "Removing old container and creating a new one..."
          sh "docker rm -f hello-nginx"
          sh "docker run -d -p 80:80 -v $WORKSPACE/hello-world-node/dist/hello-world-node:/usr/share/nginx/html/ --name ${containerName} nginx"

      }
      catch(err) { // timeout reached or input false
        echo "Doing Nothing!"
      }
    }
    else
    {
      echo "Container ${containerName} does not exist... Creating..."
      sh "docker run -d -p 80:80 -v $WORKSPACE/hello-world-node/dist/hello-world-node:/usr/share/nginx/html/ --name ${containerName} nginx"
    }
  }
}
