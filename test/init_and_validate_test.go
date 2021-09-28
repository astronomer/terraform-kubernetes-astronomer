package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/thanhpk/randstr"
)

func TestInitAndValidate(t *testing.T) {
	directory := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/from_scratch")
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformBinary: "terraform-0.13.7",
		TerraformDir:    directory,
		Vars: map[string]interface{}{
			"deployment_id": randstr.String(16),
			"email":         "qa@astronomer.io",
		},
		EnvVars: map[string]string{},
	})

	//defer terraform.Destroy(t, terraformOptions)
	terraform.Init(t, terraformOptions)
	terraform.Validate(t, terraformOptions)
}
