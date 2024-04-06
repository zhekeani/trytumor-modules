# Terraform Trytumor Secret Module

---

This module facilitates the creation of Google IAM workload identity pool and a workload identity pool provider to authenticate Terraform Cloud with the Google Cloud Provider through the workload identity federation.

When using this module, the cloud environment must be specified as either "development", "test", or "production".

A service account name must be provided for this module, which will later be used for impersonation by the workload identity pool to manage Google Cloud resources.

What this module will do:

- Create Google workload identity pool
- Create Terraform cloud pool provider for that workload identity pool
- Assign `roles/iam.workloadIdentityUser` role to the provided service account
