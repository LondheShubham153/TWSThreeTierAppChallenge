<h1 align="center">
        HELM CHART
</h1>

<p align="center"> A Helm chart is a package of pre-configured Kubernetes resources that can be easily deployed and managed using Helm, which is a package manager for Kubernetes applications. Helm charts provide a way to define, install, and upgrade even the most complex Kubernetes applications. </p>

## Overview ##

In this project, we have created a helm chart for three-tier-application.<br>
i.e Frontend, Backend and Database (mongo)<br>
Helm chart follows some file structure and the structure for this application is attached below.

  <br>

![Helm-chart](https://github.com/LondheShubham153/TWSThreeTierAppChallenge/assets/108048384/adb2adb9-4ec7-4a6b-833d-1269860b149f)


## Prerequisites ##

kubectl – A command line tool for working with Kubernetes clusters. For more information, see Installing or updating kubectl.
    https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

eksctl – A command line tool for working with EKS clusters that automates many individual tasks. For more information, see Installing or updating. https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html

AWS CLI – A command line tool for working with AWS services, including Amazon EKS. For more information, see Installing, updating, and uninstalling the AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html in the AWS Command Line Interface User Guide.

After installing the AWS CLI, I recommend that you also configure it. For more information, see Quick configuration with aws configure in the AWS Command Line Interface User Guide. https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config

 # Install EKS
 ## Create cluster.yaml file and paste this code.

    apiVersion: eksctl.io/v1alpha5
    kind: ClusterConfig

    metadata:
    name: Three-Tier-demo-cluster
    region: us-east-1

    nodeGroups:
    - name: ng-1
        instanceType: t2.medium
        desiredCapacity: 1
    - name: ng-2
        instanceType: t2.medium
        desiredCapacity: 1

  ## Apply the manifest

    eksctl create cluster -f cluster.yaml

<h1 align="center">
    IAM OIDC PROVIDER
</h1>

IAM (Identity and Access Management) OIDC (OpenID Connect) Provider is a service that allows you to use OpenID Connect to federate identities from an OIDC-compatible identity provider (IdP) with AWS IAM (Identity and Access Management). OpenID Connect is an authentication protocol built on top of OAuth 2.0, and it allows third-party identity providers to provide identity services for applications.

In the context of AWS IAM, an OIDC provider enables you to use identities from an external OIDC-compatible IdP to grant temporary security credentials to users in your AWS account. This allows you to manage access to AWS resources using the identities from your OIDC provider, making it easier to integrate AWS services with your existing identity infrastructure.


 # Commands to configure IAM OIDC provider 

    export cluster_name=<CLUSTER-NAME>
    oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5) 

  ## Check if there is an IAM OIDC provider configured already

    aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4

  If not, run the below command

    eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve

 ## Configure ALB (Application LoadBalancer)

    
 An Application Load Balancer (ALB) is an Amazon Web Services (AWS) service that operates at the application layer to distribute incoming application traffic across multiple targets, supporting features like content-based routing, WebSocket communication, and SSL/TLS termination. It enhances the availability and fault tolerance of applications by evenly distributing traffic to backend instances in one or more Availability Zones.

 # How to setup alb add on

 Download IAM policy

    curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

 Create IAM Policy

    aws iam create-policy \
        --policy-name AWSLoadBalancerControllerIAMPolicy \
        --policy-document file://iam_policy.json

 Create IAM Role

    eksctl create iamserviceaccount \
    --cluster=<your-cluster-name> \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --role-name AmazonEKSLoadBalancerControllerRole \
    --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
    --approve

 ## Deploy ALB controller

 Add helm repo

    helm repo add eks https://aws.github.io/eks-charts

 Update the repo

    helm repo update eks

 Install

    helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    -n kube-system \
    --set clusterName=<your-cluster-name> \
    --set serviceAccount.create=false \
    --set serviceAccount.name=aws-load-balancer-controller \
    --set region=<region> \
    --set vpcId=<your-vpc-id>

 Verify that the deployments are running.

    kubectl get deployment -n kube-system aws-load-balancer-controller


## Installation 

  Follow the link for configuring helm in your system.

        https://helm.sh/docs/intro/install/

  ### Perform following configuration
  templates/frontend-deployment.yaml

    env:
        - name: REACT_APP_BACKEND_URL
        value: "http://<your-domain-name>/api/tasks"

  templates/ingress.yaml

    ingressClassName: alb
    rules:
        - host: <your-domain-name>


  ### Create the namespace 

    kubectl create ns workshop


  ### Deploy your helm chart 
  <p>Move to helm-chart directory with cd helm-chart and execute the below command</p>

    helm install three-tier-architecture-demo  --namespace workshop .

<p>Now, it deployed all the manfiest yaml file present in the templates directory. As, you already deployed the ingress controller and this controller automatically creates the application load balancer based on your ingress.yaml</p>

  ### Check if container is running or not 
      kubectl get all -n workshop 

 ### Attach your load balancer dns with your domain name in your domain provider portal
 ![Screenshot 2024-01-17 161152](https://github.com/LondheShubham153/TWSThreeTierAppChallenge/assets/108048384/4b573f9b-d97c-4e36-bb73-1ea2aa5c8cd3)

  * Set the type of the record as CNAME.<br>
  * Choose any subdomain name<br>
  * Put the loadbalancer dns in value section

  ### Access your application 

    http://<your-domain-name>
