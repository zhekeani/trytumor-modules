output "secret_data" {
  value       = local.secret_data
  sensitive   = true
  description = "Fetched secret data"
}
