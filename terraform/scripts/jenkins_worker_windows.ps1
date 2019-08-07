<powershell>

function Wait-For-Jenkins {

  Write-Host "Waiting jenkins to launch on 8080..."

  Do {
  Write-Host "Waiting for Jenkins"

   Nc -zv ${server_ip} 8080
   If( $? -eq $true ) {
     Break
   }
   Sleep 10

  } While (1)

  Do {
   Write-Host "Waiting for JNLP"
      
   Nc -zv ${server_ip} 33453
   If( $? -eq $true ) {
    Break
   }
   Sleep 10

  } While (1)      

  Write-Host "Jenkins launched"
}

function Slave-Setup()
{
  # Register_slave
  $JENKINS_URL="http://${server_ip}:8080"

  $USERNAME="${jenkins_username}"
  
  $PASSWORD="${jenkins_password}"

  $AUTH = -join ("$USERNAME", ":", "$PASSWORD")
  echo $AUTH

  # Below IP collection logic works for Windows Server 2016 edition and needs testing for windows server 2008 edition
  $SLAVE_IP=(ipconfig | findstr /r "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" | findstr "IPv4 Address").substring(39) | findstr /B "172.31"
  
  $NODE_NAME="jenkins-slave-windows-$SLAVE_IP"
  
  $NODE_SLAVE_HOME="C:\Jenkins\"
  $EXECUTORS=2
  $JNLP_PORT=33453

  $CRED_ID="$NODE_NAME"
  $LABELS="build windows"
  
  # Creating CMD utility for jenkins-cli commands
  # This is not working in windows therefore specify full path
  $jenkins_cmd = "java -jar C:\Jenkins\jenkins-cli.jar -s $JENKINS_URL -auth admin:$PASSWORD"

  Sleep 20

  Write-Host "Downloading jenkins-cli.jar file"
  (New-Object System.Net.WebClient).DownloadFile("$JENKINS_URL/jnlpJars/jenkins-cli.jar", "C:\Jenkins\jenkins-cli.jar")

  Write-Host "Downloading slave.jar file"
  (New-Object System.Net.WebClient).DownloadFile("$JENKINS_URL/jnlpJars/slave.jar", "C:\Jenkins\slave.jar")

  Sleep 10

  # Waiting for Jenkins to load all plugins
  Do {
  
    $count=(java -jar C:\Jenkins\jenkins-cli.jar -s $JENKINS_URL -auth $AUTH list-plugins | Measure-Object -line).Lines
    $ret=$?

    Write-Host "count [$count] ret [$ret]"

    If ( $count -gt 0 ) {
        Break
    }

    sleep 30
  } While ( 1 )

  # For Deleting Node, used when testing
  Write-Host "Deleting Node $NODE_NAME if present"
  java -jar C:\Jenkins\jenkins-cli.jar -s $JENKINS_URL -auth $AUTH delete-node $NODE_NAME
  
  # Generating node.xml for creating node on Jenkins server
  $NodeXml = @"
<slave>
<name>$NODE_NAME</name>
<description>Windows Slave</description>
<remoteFS>$NODE_SLAVE_HOME</remoteFS>
<numExecutors>$EXECUTORS</numExecutors>
<mode>NORMAL</mode>
<retentionStrategy class="hudson.slaves.RetentionStrategy`$Always`"/>
<launcher class="hudson.slaves.JNLPLauncher">
  <workDirSettings>
    <disabled>false</disabled>
    <internalDir>remoting</internalDir>
    <failIfWorkDirIsMissing>false</failIfWorkDirIsMissing>
  </workDirSettings>
</launcher>
<label>$LABELS</label>
<nodeProperties/>
</slave>
"@
  $NodeXml | Out-File -FilePath C:\Jenkins\node.xml 

  type C:\Jenkins\node.xml

  # Creating node using node.xml
  Write-Host "Creating $NODE_NAME"
  Get-Content -Path C:\Jenkins\node.xml | java -jar C:\Jenkins\jenkins-cli.jar -s $JENKINS_URL -auth $AUTH create-node $NODE_NAME

  Write-Host "Registering Node $NODE_NAME via JNLP"
  Start-Process java -ArgumentList "-jar C:\Jenkins\slave.jar -jnlpCredentials $AUTH -jnlpUrl $JENKINS_URL/computer/$NODE_NAME/slave-agent.jnlp"
}

### script begins here ###

Wait-For-Jenkins

Slave-Setup

echo "Done"
</powershell>
<persist>true</persist>

