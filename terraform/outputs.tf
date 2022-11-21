# https://github.com/hashicorp/terraform/issues/1178
resource "null_resource" "dependency_setter" {}
output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}
