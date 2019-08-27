pipeline {
  agent { label "build && windows" }
  stages {
    stage('Clean Workspace'){
      steps {
        cleanWs()
      }
    }
    
    stage('Checkout'){
      steps {
        checkout([$class: 'GitSCM', 
        branches: [[name: '*/master']], 
        doGenerateSubmoduleConfigurations: false, 
        extensions: [], 
        submoduleCfg: [], 
        userRemoteConfigs: [[url: 'https://github.com/ismail0352/Packer-Terraform-Jenkins.git']]])

      }
    }
    
    stage('Nuget Restore') {
      steps {
        bat label: 'Nuget Restore', 
        script: '''
          nuget restore "PrimeDotnet\\prime-dotnet.sln"
          echo "Nuget Done Starting Msbuild *************"
        ''' 
      }
    }

    stage('Build') {
      steps {
        script {
          //def msbuild = tool name: 'msbuild_2017', type: 'hudson.plugins.msbuild.MsBuildInstallation'
          tool name: 'msbuild_2017', type: 'msbuild'
          bat "\"${tool 'msbuild_2017'}\"\\msbuild.exe PrimeDotnet\\prime-dotnet.sln /P:DeployOnBuild=True /p:AllowUntrustedCertificate=True /p:MSDeployServiceUrl=<IP or Hostname of IIS server> /P:DeployIISAppPath=\"Default Web Site/PrimeDotnet\""
        }
      }
    }

    stage('UnitTest') {
      steps {
        script {
          bat label: 'Unit Test using Dotnet CLI',
        script: '''
          dotnet.exe test .\\PrimeDotnet\\
        '''
        }
      }
    }

    stage('Deploy') {
      steps {
        bat label: 'MsDeploy',
        script: '''
          // For Localhost
          "C:\\Program Files (x86)\\IIS\\Microsoft Web Deploy V3\\msdeploy.exe" -verb:sync -source:package="PrimeDotnet\\bin\\Debug\\Package\\PrimeDotnet.zip" -dest:auto,computerName=localhost

          // For Remote Server
           "C:\\Program Files (x86)\\IIS\\Microsoft Web Deploy V3\\msdeploy.exe" -verb:sync -source:package="PrimeDotnet\\obj\\Debug\\Package\\PrimeDotnet.zip" -dest:auto,computerName="<IP or Hostname>",userName=administrator,password="supersecret",authType=NTLM -allowUntrusted=true
        '''
      }
    }
  }
}
