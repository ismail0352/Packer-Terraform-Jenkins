# Creating AMI's

### For Jenkins Master and Linux Slave
`Amazon Linux 2` has been taken as the base AMI for creating Jenkins master and Linux slave.
`Windows Server 2016 with Containers` has been taken as the base AMI for creating Windows slave.

### Install
Packer is used for creating AMI's. 
Packer version is `v1.4.2`.

### How to use

##### The flow is as follows:
1. Edit amazon.json file for Jenkins master and Linux Slave manually and update `ami_users` value with actual value for your account.
2. Edit windows.json file for Windows Slave and update `ami_users` value with actual value for your account.
3. Everything that will be required for the instance are already included in json files
   
##### Commands to create AMI's
* **Jenkins Master and Linux Slave**: `packer build amazon.json`
&nbsp;

* **Windows Slave**: `packer build windows.json`
