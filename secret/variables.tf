variable secret_source {
  type        = number
  default     = 0
  description = "Whether to fetch secret data from, Google Secret Manager (0), local script (1), manually provided (2)"
}

variable local_file_path {
  type        = string
  default     = ""
  description = "Path to the local file used to fetch secret data"
}

variable provided_secret_data {
  type        = string
  default     = ""
  description = "Secret data that provided manually"
}

variable secret_type {
  type        = string
  description = "Secret type to fetch: 'jwt'; 'database'"
}

variable environment_type {
  type        = string
  description = "Cloud environment where the secret is used: 'development'; 'test'; 'production'"
}