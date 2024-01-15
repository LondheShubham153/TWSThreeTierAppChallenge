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

