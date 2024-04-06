output "private_key" {
  value       = google_service_account_key.object_admin.private_key
  sensitive   = true
  description = "Get the Object Admin Service Account private key"
}