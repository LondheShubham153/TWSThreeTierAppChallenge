# Three-Tier Application on Kubernetes

## Overview

This project deploys a three-tier application on Kubernetes using Jenkins Pipeline. The architecture consists of a React-based frontend, a Node.js-based logic (middle) tier, and a MongoDB database.

## Application Structure

- **frontend:** Contains the React-based frontend code.
- **middle-tier:** Houses the Node.js-based logic tier.
- **database:** Holds configurations for MongoDB.

## Prerequisites
- Create a IAM User with Administartor Access. Create Access Key as well and save it for later use.
- Create a ECR with two public repositories named: ```three-tier-backend``` and ```three-tier-frontend```. Note down your public repositories default alias and update it in variables file with ```ALIAS_INFO``` variable.
- Update your domain name in variables file.
- Update your update ```ACCOUNT ID``` in variable file.
Note: variables file above is created to set account ID, Domain name and ECR's default alias. This is done so that there variables will be updated automatically in commands to be executed in Pielines. 

## Automated Installation

### Create and Initial EC2 Instance:
- Name the EC2 Instance as ```ak-three-tier-hq```
- Select Ubuntu AMI and t2.medium as Instance.type.
- In security group open access to port 8080 for accessing Jenkins.
- Configure storage to 20 Gb
- In Advanced details section copy-paste all the data from ```installUD.sh``` file into user-data box.
- Hit launch Instance.
- All the required things will be installed in the hq instance now. Like docker, jenkins, aws cliv2, helm, kubectl, eksctl.

### Access the Jenkins:
- SSH into hq instance. To get Jenkins password use command: ```sudo cat /var/lib/jenkins/secrets/initialAdminPassword``` 
- Access the Jenkins on VM_IP:8080.
- After putting Password click next. Click on ```Install Suggested Plugins.```
- Click on ```Skip and continue as Admin```.
- Click ```Save and Finish```.
- Click ```Start Using Jenkins```.

### Install Plugin and Create Credentials:
- Click on Manage Jenkins.
- Click on Plugins.
- Click on Available Plugins on sidebar.
- Search  for ```AWS Credentails``` plugin.
- Click on the plugin check box and click on Install.
Now to Create Credentails for AWS and Mongo Database.
- Goto Credentials in Manage Jenkins.
- Click on Add Credentials.
- In kind Select AWS Credentials option.
- Put Access Key and Secret Access Key as require.
- Note Set ID as ```aws-cli-cred```. This id name is important.
- Similary for MongoDB credentials in kind Select Username and Password options only.
- Set Id as ```mongo-pass```.This id name is important.
- Set Username and Password as per your wish.

### Create and Run Jobs:
-  Create three pipeline jobs with names ```create-cluster-pipeline```, ```deploy-app```, ```push-images-pipeline```.
-  Copy paste the groovy script for respective pipline from jenkins-pipeline/ folder above.
-  Run ```create-cluster-pipeline```, ```push-images-pipeline```jobs simultaneously.
-  Creating cluster will take time. Images will be pushed to ECR.
Note: These pipelines will create the cluster, push the images to the container registry and deploy the load balancer and ingress controller as well automatically. Here selecting t2.medium will come handy, as we will be able to run two jobs simultaneouly.

### Access the application:
- Check the deploy-app pipeline logs to get the Ingress Address.
- Update the CNAME NS record in you DNS MAnagement with the Ingress Address.
- Voila You will be ale to access the application.

###Contribution
Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or create a pull request.
