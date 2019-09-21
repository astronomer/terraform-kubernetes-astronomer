output "tiller_namespace" {
  description = "Namespace into which Tiller has been deployed."
  value       = var.tiller_namespace
}

output "tiller_version" {
  description = "Version of Tiller that has been deployed."
  value       = var.tiller_version
}
