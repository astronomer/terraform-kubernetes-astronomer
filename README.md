# Astronomer Kubernetes Deployment

Deploy Astronomer on a Kubernetes cluster

# Required in path and tested versions

[Sample execution environment](pipeline/Dockerfile)

- [Terraform 0.12.3](https://www.terraform.io/upgrade-guides/0-12.html)
- [Helm 2.14.1](https://helm.sh/docs/using_helm/)
- [Kubectl 1.12.3](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

# Sample use

[Example use with other astronomer terraform modules](examples/aws/main.tf)

The above example deploys Astronomer on EKS. It creates all resources including VPC, Kubernetes cluster, and cluster configurations.

# Note

- Assumes cluster, namespace already exists
