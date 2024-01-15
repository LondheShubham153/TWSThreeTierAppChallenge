### Before deploying your chart configure your domain name in frontend-deployment.yaml and ingress.yaml

```
 env:
    - name: REACT_APP_BACKEND_URL
      value: "http://<your-domain-name>/api/tasks"
```
```
  ingressClassName: alb
  rules:
    - host: <your-domain-name>
```

### Create the namespace 
```
kubectl create ns workshop

```

### Deploy your helm chart 
```
helm install three-tier-architecture-demo  --namespace workshop .

```

### Check if container is running or not 

```
kubectl get all -n workshop 

```
### Attach your load balancer dns with your domain name in your domain provider protol

### Access your application 

```
http://<your-domain-name>
```