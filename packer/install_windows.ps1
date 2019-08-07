# Setting Up machine for Jenkins

#Jenkins root directory
$jenkins_slave_path = "C:\Jenkins"
If(!(test-path $jenkins_slave_path))
{
    New-Item -ItemType Directory -Force -Path $jenkins_slave_path
}

# Install Chocolatey for managing installations
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Installing required packages
# "visualstudio2017-workload-webbuildtools" this will install a lot of packages including "visualstudiobuildtool"
# and "IIS"(and IIS will get you msdeploy) and "Microsoft Web Deploy 4" but make sure you configure IIS
# before installation, if you are doing deployment on same machine. Also install WebDeploy manually beforehand to match configuration with IIS
# You have been warned!

choco install git netcat jdk8 nuget.commandline visualstudio2017-workload-webbuildtools visualstudio2017buildtools -y

