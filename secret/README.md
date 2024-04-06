# Terraform Trytumor Secret Module

---

This module manages the creation of secrets in Google Secret Manager with the flexibility to not always provide a secret data source or include data that is used as secret data in Terraform configuration after creating the secret for the first time.

This module offers three options as the secret data source:

- From local `.txt` file
- From manually provided value
- From the secret itself (after the first creation use case)
