# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2019-06-26

Thanks to [Noah Fontes](https://github.com/impl) for the pull request
that made this release possible!

### Updated

- The module is now compatible with Terraform v0.12.
- Minimum required version of the Kubernetes provider plugin is now v1.7.0.
- Default Tiller version to be installed is now v2.14.1.

### Fixed

- Label matching should now work as supposed to out-of-the-box.

## [1.0.2] - 2019-02-28

### Fixed

- Creation of cluster role binding now works as supposed to.

## [1.0.1] - 2019-02-28

### Added

- The service account token (RBAC) will now automatically be mounted.

### Fixed

- The installation namespace is now truly optional and stuff won't
  be deployed into `kube-system` even if the input parameters have
  been set to a different one.

## [1.0.0] - 2019-02-06

### Added

- Support to deploy Tiller into your Kubernetes cluster using Terraform.
  This module is basically an alternative to calling `helm init` on a random
  machine.
