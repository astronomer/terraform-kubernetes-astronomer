# Astronomer Kubernetes Deployment

Deploy Astronomer on a Kubernetes cluster

# Required in path and tested versions

[Sample execution environment](pipeline/Dockerfile)

- [Terraform 0.13](https://www.terraform.io/upgrade-guides/0-13.html)
- [Helm 3](https://helm.sh/docs/using_helm/)
- [Kubectl 1.18](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

# Sample use

[Example use with other astronomer terraform modules](examples/aws/main.tf)

The above example deploys Astronomer on EKS. It creates all resources including VPC, Kubernetes cluster, and cluster configurations.

# Note

- Assumes cluster, namespace already exists
