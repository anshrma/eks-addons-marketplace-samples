# KubeCost AddOn

## Pre-Requisite

* Subscribe - [MP Listing](https://aws.amazon.com/marketplace/pp/prodview-asiz4x22pm2n2?sr=0-1&ref_=beagle&applicationId=AWS-Marketplace-Console)

* Ensure EBS CSI Driver is installed on the server

## Validate

* Run kubectl to enable port forwarding

```
kubectl get all -n kubecost
```

**NOTE** All pods should be in running status. If they are not in **Running** status then do `kubectl describe pvc -n kubecost` as the likely reason of EBS driver faiing to be bound.

```
kubectl port-forward --namespace kubecost deployment/cost-analyzer 9090
```