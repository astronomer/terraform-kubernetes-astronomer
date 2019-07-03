# Terraform module: Tiller installation

This Terraform module can be used to install [Tiller](https://docs.helm.sh/)
(a.k.a. the Helm Server) into a Kubernetes cluster.

This module is basically an alternative to calling `helm init` on any random
machine to deploy Tiller into your cluster.
