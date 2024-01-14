Enhancements:
1. Configured EBS CI driver for leveraging peristent volume for mongodb database
Create an IAM role and attach a policy. AWS maintains an AWS managed policy or you can create your own custom policy.

eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster <YOUR-CLUSTER-NAME> \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve

2. Run the following command

eksctl create addon --name aws-ebs-csi-driver --cluster <YOUR-CLUSTER-NAME> --service-account-role-arn arn:aws:iam::<AWS-ACCOUNT-ID>:role/AmazonEKS_EBS_CSI_DriverRole --force

3. Added mongo-pvc.yaml file
   
4. Changed mongo/deploy.yaml from deploymnent resource to StatefulSet resource.
5. Implemented Automated Synchronization with Argo CD
6. Install argoCD
   
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

7. Expose Argo CD Server Service in NodePort Mode

kubectl edit svc argocd-server -n argocd
(and change the type to NodePort from ClusterIP)

8. Configure inbound rule as per port 
9. Create application which points to this repo url

9. To add observability of your cluster and send logs to cloud watch :
  
  1. https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-prerequisites.html
  attach this policy to your worker-node
  
  2. install the Amazon CloudWatch Observability EKS add-on(follow: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-EKS-addon.html)
  aws iam attach-role-policy \
--role-name <my-worker-node-role> \
--policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy \
--policy-arn arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess

  
  3. aws eks create-addon --cluster-name my-cluster-name --addon-name amazon-cloudwatch-observability
  
  4. https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-metrics.html
  5. https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs-FluentBit.html
  6. kubectl get pods -n amazon-cloudwatch

![argocd1](https://github.com/Chitrakshi18/three-tier/assets/49672979/28cb66ab-1117-4b03-baf0-e2545ac38b11)



   
![EBS-three-tier](https://github.com/Chitrakshi18/three-tier/assets/49672979/12e5cdac-abc4-433a-ac84-ce323e36ae49)


![frontend-three-tier](https://github.com/Chitrakshi18/three-tier/assets/49672979/7640f051-ee9b-49ea-8b49-f9dbf4488d8f)

![cw](https://github.com/Chitrakshi18/EKS-three-tier-application/assets/49672979/3c3855b4-e909-4f07-a34c-0338c6fd6030)

![fluentD](https://github.com/Chitrakshi18/EKS-three-tier-application/assets/49672979/ed43d1db-1e32-4a25-8112-02e22c6e5487)


![logs](https://github.com/Chitrakshi18/EKS-three-tier-application/assets/49672979/affe18de-36b0-4b70-adda-7e149b373f31)
