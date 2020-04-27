# eks-config

This repo contains base manifests to be deployed into EKS with GitOps.

## Create your Route 53 subdomain and cert for use with external-dns and ALB ingress

A pre-requisite to this is that you already have a domain registered with AWS

```
cd terraform
# Create a params.tfvars file if needing to set variables

terraform init
terraform plan -var-file=params.tfvars
terraform apply -var-file=params.tfvars

# Get the ARN of your certificate to use in any ingresses that are deployed
# IMPORTANT: Also, update your registered DNS name servers with the NS record from your main domain
```

## Update manifests to reflect your environment

* `manifests/kube-system/external-dns.yaml` - domain-filter
* Certificate for any ingresses.  (grep -R certificate-arn *)
* `manifests/kube-system/alb-ingress-controller-deployment.yaml` - cluster-name (if changing from eks1)
* `manifests/kube-system/cluster-autoscaler-deployment.yaml` - image version should match cluster version (1.15.6 for K8s 1.15. 1.16.5 for K8S 1.16, etc)
* `manifests/kube-system/cluster-autoscaler-deployment.yaml` - k8s.io/cluster-autoscaler/eks1 (if changing from eks1)
* `manifests/amazon-cloudwatch/fluentd-configmap-cluster-info.yaml` - cluster name and region (if changing from eks1 / us-west-2)
* `manifests/amazon-cloudwatch/cloudwatch-agent-configmap.yaml` - cluster_name (if changing from eks1)

Yes, I could have created a quickstart profile to avoid this...

## Setup Helm if it isn't already

```
brew install helm
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

## Create your EKS Cluster with GitOps Enabled

```
# Install eksctl
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl

# Deploy your cluster
eksctl create cluster -f cluster.yaml
kubectl get nodes

# Add Weave Flux for GitOps
EKSCTL_EXPERIMENTAL=true \
    eksctl enable repo \
        --git-url git@github.com:example/my-eks-config \
        --git-email your@email.com \
        --git-paths=manifests \
        --cluster eks1 \
        --region us-west-2

```

Copy the lines with ssh-rsa and add to GitHub allowing write access: Settings > Deploy Keys > Add deploy key.  Make certain to check the box to allow write access.  
