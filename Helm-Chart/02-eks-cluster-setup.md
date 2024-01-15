# Install EKS

Please follow the prerequisites doc before this.

## Create cluster.yaml

```
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
```

## Apply the manifest

```
eksctl create cluster -f cluster.yaml

```

## Delete the cluster

```
eksctl delete cluster --name Three-Tier-demo-cluster --region us-east-1
```