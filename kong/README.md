# Kong Konnect Dataplane AddOn

## Pre-Requisite

* Subscribe 
    - [MP Listing for Konnect Saas](https://aws.amazon.com/marketplace/pp/prodview-7zds3oxx3ntjy?sr=0-2&ref_=beagle&applicationId=AWS-Marketplace-Console)
    - [MP Listing for Konnect Dataplane](https://aws.amazon.com/marketplace/pp/prodview-4lozhkbtgizp4?applicationId=AWS-Marketplace-Console&ref_=beagle&sr=0-1)

* Generate and mount secret on K8

    * Create Namespace

```
kubectl create namespace kong
```

    * Generate certificate from Kong Konnect UI and paste them in a file

```
cat >> tls.crt << EoF
PASTE_THE_CONTENTS_OF_COPIED_CODE
EoF
```

```
cat >> tls.key << EoF
PASTE_THE_CONTENTS_OF_COPIED_CODE
EoF
```
    * Create K8 secret referencing the files

```
kubectl create secret tls kong-cluster-cert -n kong --cert=./tls.crt --key=./tls.key
```



## Validate

* Run `kubectl get all -n kong` to confirm all pods are in `Running` state
* Go to Kong Konnect UI and confirm if the nodes are getting connected