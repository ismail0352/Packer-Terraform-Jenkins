# Packer-Terraform-Jenkins

### Reference

This repository has the code for blogs.
* [Using Packer and Terraform to Setup Jenkins Master-Slave Architecture](https://velotio.com/blog/2019/8/5/setup-jenkins-master-slave-architecture)

* [How to Write Jenkinsfile for Angular and .Net Based Applications](https://velotio.com/blog/2019/9/3/jenkinsfile-for-angular-dotnet-applications)

The code follows along the lines of the blogs. Yet it will have its own Readme for references.

### Order of Use

* Create AWS AMI using Packer
* Create Terraform scripts for setting up Jenkins Master and Slave
  * Create prerequisistes (provider/variables tf files)
  * Create IAM roles
  * Associate user_policies for IAM user for managing instance.
  * Create Security Group
  * Create Instances on AWS
* Create Node/.Net based applications
* Create Test Cases
* Create Deployment server (Nginx/IIS)
* Create Jenkinsfile

Individual README`s are available inside all the componenets.

## Authors

* **Ismail** - *Initial work* for [Velotio](https://velotio.com/)
