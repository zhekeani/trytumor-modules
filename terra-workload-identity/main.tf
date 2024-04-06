
variable environment_type {
  type        = string
  description = "Specific cloud environment to be managed by Terraform workspace, either 'development', 'test', 'production'."
}

variable organization_id {
  type        = string
  sensitive   = true
  description = "Terraform organization ID"
}


variable svc_name {
  type        = string
  description = "Service account name to be impersonated by pool provider."
}

variable workspace_id {
  type        = string
  sensitive   = true
  description = "Specific Terraform workspace to authenticate with Google Cloud Provider"
}

data "google_project" "current" {}

# Set the environment prefix
locals {
  dev_prefix      = var.environment_type == "development" ? "dev" : null
  test_prefix     = var.environment_type == "test" ? "testing" : null
  prod_prefix     = var.environment_type == "production" ? "prod" : null
  default_prefix  = "default"

  suffix          = coalesce(local.dev_prefix, local.test_prefix, local.prod_prefix, local.default_prefix)
}

locals {
  workload_identity_pool_id = "terraform-pool-${local.suffix}"
  display_name    = "terraform-pool-${local.suffix}"
  workload_identity_pool_description     = "${var.environment_type} pool"
}
  

resource "google_iam_workload_identity_pool" "tfc_identity_pool" {
  workload_identity_pool_id   = local.workload_identity_pool_id
  display_name                = local.display_name
  description                 = local.workload_identity_pool_description
  disabled                    = false
}

resource "google_iam_workload_identity_pool_provider" "pool-provider" {
  workload_identity_pool_id           =  google_iam_workload_identity_pool.tfc_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id  = "terraform-cloud-oidc-${local.suffix}"
  description   = "Terraform Cloud OIDC Provider"
  disabled      = false

  attribute_mapping                   = {
    "attribute.tfc_organization_id"   	= "assertion.terraform_organization_id"
    "attribute.tfc_project_id"        	= "assertion.terraform_project_id"
    "attribute.tfc_project_name"      	= "assertion.terraform_project_name"
    "google.subject"                 		= "assertion.terraform_workspace_id"
    "attribute.tfc_workspace_name"    	= "assertion.terraform_workspace_name"
    "attribute.tfc_workspace_env"     	= "assertion.terraform_workspace_name.split('-')[assertion.terraform_workspace_name.split('-').size() -1]"
  }

  oidc {
    issuer_uri        = "https://app.terraform.io"
  }

 attribute_condition     =  "attribute.tfc_organization_id == '${var.organization_id}' && attribute.tfc_workspace_env.startsWith ('${local.suffix}')"
}


resource "google_service_account_iam_binding" "sa_tf_trytumor_iam" {
  service_account_id  = var.svc_name
  role      = "roles/iam.workloadIdentityUser"
  members = [
    "principal://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${local.workload_identity_pool_id}/subject/${var.workspace_id}",
  ]
}

output "provider_name" {
  value   = "projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.tfc_identity_pool.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.pool-provider.workload_identity_pool_provider_id}"
}