# Three-Tier Application on Kubernetes

## Overview

This project deploys a three-tier application on Kubernetes using Jenkins Pipeline. The architecture consists of a React-based frontend, a Node.js-based logic (middle) tier, and a MongoDB database.

## Application Structure

- **frontend:** Contains the React-based frontend code.
- **middle-tier:** Houses the Node.js-based logic tier.
- **database:** Holds configurations for MongoDB.

## Prerequisites
- Create a IAM User with Administartor Access. Create Access Key as well and save it for later use.![IAM 1](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/8348460c-3741-4497-9e98-d06fb1b76563)
- Create a ECR with two public repositories named: ```three-tier-backend``` and ```three-tier-frontend```.
  ![repositories](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/a47ae951-0995-4a87-8aec-8ac846e5e544)

 Note down your public repositories default alias and update it in variables file with ```ALIAS_INFO``` variable.
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
  ![unlock jenkins](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/9ac3254a-a564-4bf7-92de-0a65368e655d)
- After putting Password click next. Click on ```Install Suggested Plugins.```
![suggested plugin](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/b007a5db-4873-4410-b649-54c609a38d4c)
- Click on ```Skip and continue as Admin```.
- Click ```Save and Finish```.
- Click ```Start Using Jenkins```.
  ![jenkins ready](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/2ac54a08-ad46-42c1-8119-a15b58e9af93)


### Install Plugin and Create Credentials:
- Click on Manage Jenkins.
- Click on Plugins.
- Click on Available Plugins on sidebar.
- Search  for ```AWS Credentails``` plugin.
  ![insatllplugin](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/5d70797a-5820-46f2-8699-0dda35f848c9)
- Click on the plugin check box and click on Install.
Now to Create Credentails for AWS and Mongo Database.
- Goto Credentials in Manage Jenkins.
- Click on Add Credentials.
- In kind Select AWS Credentials option.
- Put Access Key and Secret Access Key as require.
- Note Set ID as ```aws-cli-cred```. This id name is important.
  ![aws credentials](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/d3df5539-49c6-4d25-bbf4-5f33c0b8d8c5)
- Similary for MongoDB credentials in kind Select Username and Password options only.
- Set Id as ```mongo-pass```.This id name is important.
- Set Username and Password as per your wish.
![Credentailadisplay](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/01c87fd7-6ed2-4fd9-bf3d-5d9b2e185649)


### Create and Run Jobs:
-  Create three pipeline jobs with names ```create-cluster-pipeline```, ```deploy-app```, ```push-images-pipeline```.
  ![pipelinetype](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/86e21cd6-aad3-43e2-a4de-f7072a0eb457)

-  Copy paste the groovy script for respective pipline from jenkins-pipeline/ folder above.
![pipelines view](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/409bd096-4594-4ddb-b1ec-3c707a5fc189)
-  Run ```create-cluster-pipeline```, ```push-images-pipeline```jobs simultaneously.
-  Creating cluster will take time. Images will be pushed to ECR.
Note: These pipelines will create the cluster, push the images to the container registry and deploy the load balancer and ingress controller as well automatically. Here selecting t2.medium will come handy, as we will be able to run two jobs simultaneouly.

### Access the application:
- Check the deploy-app pipeline logs to get the Ingress Address.
  ![ingress address](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/fc02d415-c1a6-4a1f-b5da-2d52027673fd)
- Update the CNAME NS record in you DNS MAnagement with the Ingress Address.
  ![dns-management](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/2201e794-d20d-4424-958b-3d1dfea9c283)
- Voila You will be ale to access the application.
![final app](https://github.com/Aniket-d-d/TWSThreeTierAppChallenge/assets/57555096/ef4400fe-2922-4c1e-8237-e83bb58cffc7)

### Contribution
Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or create a pull request.

### Note:
- I have used sed commands and shell scripts to update the piplines according to the variables described in variables file above. 
- Please reach out for any clarifications about pipelines in this challenge.
