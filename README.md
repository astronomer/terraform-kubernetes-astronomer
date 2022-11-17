# Astronomer Kubernetes Deployment

Deploy Astronomer on a Kubernetes cluster

# Required in path and tested versions

- [Terraform](https://www.terraform.io)
- [Helm 3](https://helm.sh/docs/using_helm/)
- [Kubectl 1.18](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

# Sample use

[Example use with other astronomer terraform modules](example)

The above example deploys Astronomer on GKE. It creates all resources including VPC, Kubernetes cluster, and cluster configurations.

# Note

- Assumes cluster, namespace already exists
