data "google_project" "current" {}


# Create the service account
resource "google_service_account" "object_admin" {
  account_id    = "gcp-storage-object-admin"
  display_name  = "Service Account - storage object admin"
}

resource "google_project_iam_member" "object_admin" {

  project = data.google_project.current.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.object_admin.email}"
}

# module "service_account-iam-bindings" {
#   source            = "terraform-google-modules/iam/google//modules/service_accounts_iam"

#   service_accounts = [google_service_account.object_admin.email]
#   mode             = "additive"
#   project          = data.google_project.current.project_id

#   bindings         = {
#     "roles/storage.objectAdmin"   = [
#       "serviceAccount:${google_service_account.object_admin.email}"
#     ]
#   }
# }


# Creating key for service account
resource "google_service_account_key" "object_admin" {
  service_account_id  =   google_service_account.object_admin.name
}

