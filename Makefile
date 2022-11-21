# Defaults
REV:=$(shell git rev-parse --short HEAD)
DATE:=$(shell date +%Y.%m.%d-%H.%M.%S)
BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)
COMMIT:=$(MODULE)_$(INFRA_VALUES)_$(DATE)_$(REV)

CURRENT_DIR_PATH:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))


# Terraform Setup
TF_MODULE_PATH:=example
TF_PLAN_FILE:=$(TF_MODULE_PATH)_$(REV)

.PHONY: clean

pre-commit: clean
	pre-commit install
	pre-commit install-hooks
	pre-commit run --all-files --show-diff-on-failure

install:
	tfenv install

init:
	terraform -chdir=$(TF_MODULE_PATH) init

upgrade: clean
	terraform -chdir=$(TF_MODULE_PATH) init -upgrade

validate:
	terraform -chdir=$(TF_MODULE_PATH) validate

plan: validate
	terraform -chdir=$(TF_MODULE_PATH) plan \
		-out=$(TF_PLAN_FILE).tfplan

plan-destroy: validate
	terraform -chdir=$(TF_MODULE_PATH) plan \
		-destroy \
		-out=$(TF_PLAN_FILE).tfplan

apply: validate
	terraform -chdir=$(TF_MODULE_PATH) apply

apply-auto-approve: validate
	terraform -chdir=$(TF_MODULE_PATH) apply -auto-approve

apply-plan:
	terraform -chdir=$(TF_MODULE_PATH) apply $(TF_PLAN_FILE).tfplan

destroy: validate
	terraform -chdir=$(TF_MODULE_PATH) destroy

destroy-auto-approve: validate
	terraform -chdir=$(TF_MODULE_PATH) destroy -auto-approve

clean:
	find . -name "*.terraform" -type d -exec rm -rf {} + || true
	find . -name "*.terraform.lock.hcl" -type f -delete || true
	find . -name "*.tfplan" -type f -delete || true
