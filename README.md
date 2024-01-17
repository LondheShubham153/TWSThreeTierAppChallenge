# TWSThreeTierAppChallenge

## Overview
This repository hosts the `#TWSThreeTierAppChallenge` for the TWS community. 
The challenge involves deploying a Three-Tier Web Application using ReactJS, NodeJS, and MongoDB, with deployment on AWS EKS. Participants are encouraged to deploy the application, add creative enhancements, and submit a Pull Request (PR). Merged PRs will earn exciting prizes!

**Get The Challenge here**

[![YouTube Video](https://img.youtube.com/vi/tvWQRTbMS1g/maxresdefault.jpg)](https://youtu.be/tvWQRTbMS1g?si=eki-boMemxr4PU7-)

## Prerequisites
- Basic knowledge of Docker, and AWS services.
- An AWS account with necessary permissions.

## Challenge Steps

### Step 1: IAM Configuration
- Create a user `eks-admin` with `AdministratorAccess`.
- Generate Security Credentials: Access Key and Secret Access Key.

### Step 2: EC2 Setup
- Launch an Ubuntu instance in your favourite region (eg. region `us-west-2`).
- SSH into the instance from your local machine.

### Step 3: Install AWS CLI v2
``` shell
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update
aws configure
```

### Step 4: Install Docker
``` shell
sudo apt-get update
sudo apt install docker.io
docker ps
sudo chown $USER /var/run/docker.sock
```

### Step 5: Install kubectl
``` shell
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

### Step 6: Install eksctl
``` shell
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

### Step 7: Install Helm Chart
``` shell
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version
```

### Step 8: Setup EKS Cluster
``` shell
eksctl create cluster --name three-tier-cluster --region us-west-2 --node-type t2.medium --nodes-min 2 --nodes-max 2
aws eks update-kubeconfig --region us-west-2 --name three-tier-cluster
kubectl get nodes
```

### Step 9: Add the Helm Stable Charts
``` shell
helm repo add stable https://charts.helm.sh/stable
```

### Step 10: Add Prometheus Helm repo and Install Prometheus
``` shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install stable prometheus-community/kube-prometheus-stack -n workshop
```

### Step 11: Edit service for Prometheus
``` shell
kubectl edit svc stable-kube-prometheus-sta-prometheus -n workshop
```
<img width="509" alt="Screenshot 2024-01-17 154212" src="https://github.com/iamamash/TWSThreeTierAppChallenge/assets/42666741/c0ed6acc-a95f-4823-b978-df31d8a1bf26">

**Change it from ClusterIP to LoadBalancer after changing make sure to save the file**

### Step 12: Edit service for Grafana
``` shell
kubectl edit svc stable-grafana -n workshop
```
<img width="838" alt="Screenshot 2024-01-17 154656" src="https://github.com/iamamash/TWSThreeTierAppChallenge/assets/42666741/55f3302e-2a4e-49bb-9444-0e40829e4a0b">

**Change it from ClusterIP to LoadBalancer after changing make sure to save the file**

### Step 13: Making Dashboard using Grafana
``` shell
kubectl get svc -n workshop
```
> - Use the LoadBalancer link and access the Grafana in the browser.
> 
> - Give username as "admin" and for password run the below command.
>   ``` shell
>   kubectl get secret --namespace workshop stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
>   ```
>
> - Click on create your first dashboard in Grafana.
>
> - click on import dashboard.
>
> - Give no "15760" or select prometheus from the Load field and click on Load button.
>
> - Then click on Import.

### Step 14: Run Manifests
``` shell
kubectl create namespace workshop
kubectl apply -f .
kubectl delete -f .
```

### Step 15: Install AWS Load Balancer
``` shell
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
eksctl utils associate-iam-oidc-provider --region=us-west-2 --cluster=three-tier-cluster --approve
eksctl create iamserviceaccount --cluster=three-tier-cluster --namespace=kube-system --name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn=arn:aws:iam::626072240565:policy/AWSLoadBalancerControllerIAMPolicy --approve --region=us-west-2
```

### Step 16: Deploy AWS Load Balancer Controller
``` shell
sudo snap install helm --classic
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=my-cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
kubectl get deployment -n kube-system aws-load-balancer-controller
kubectl apply -f full_stack_lb.yaml
```

### Important for CI/CD
> - If you want to add Continuous Deployment (CD) you need to make a bit changes in the github workflow's `.github/workflows/cicd.yaml` file.
>
> - Create all the secret variables that are listed under the `env` section in `cicd.yaml`. For creating them follow the below steps:
>   - Go to settings -> Security (Secrets and variables) -> Actions -> New repository secret -> Give Secret name and value -> Add secret.
>
> - Pass your own env varibales that you've created and replace them with mine including AWS CLI, AWS ECR, AWS EKS, and more.
>
> - Your AWS EKS Cluster should be up and running for smooth and Continuous Delivery (CD) implementation.

### Cleanup
- To delete the EKS cluster:
``` shell
eksctl delete cluster --name three-tier-cluster --region us-west-2
```

## Contribution Guidelines
- Fork the repository and create your feature branch.
- Deploy the application, adding your creative enhancements.
- Ensure your code adheres to the project's style and contribution guidelines.
- Submit a Pull Request with a detailed description of your changes.

## Rewards
- Successful PR merges will be eligible for exciting prizes!

## Support
For any queries or issues, please open an issue in the repository.

---
Happy Learning! 🚀👨‍💻👩‍💻
