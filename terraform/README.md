## Terraform files for Jenkins Master and Slaves

Before looking at this please make sure you have created the IAM policies as per your requirement, Created Security Groups and also taken care of all prerequisites.

### Install
Terraform is used for creating AMI's. 
Terraform version is `v0.11.13`.

### How to use

##### The flow is as follows:
1. Edit tf files for server and slaves as needed
2. Edit the user-data files are per requirements
3. Save the files and from the same directory run terraform commands.
   
##### Commands to create Security Groups
* Initialize terraform - `terraform init` 
* Check - `terraform plan`
* Apply - `terraform apply`
