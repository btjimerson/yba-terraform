variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "region" {
  description = "The region to create the cluster in"
  type        = string
}

variable "resource_prefix" {
  description = "A prefix added to all created resources"
  type        = string
}

variable "department_tag_value" {
  description = "The value for the department tag for resources"
  type        = string
}

variable "task_tag_value" {
  description = "The value for the task tag for resources"
  type        = string
}

variable "owner_tag_value" {
  description = "The value for the owner tag for resources"
  type        = string
}

variable "customer_tag_value" {
  description = "The value for the customer tag for resources"
  type        = string
}

variable "sales_region_tag_value" {
  description = "The value for the sales region tag for resources"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR range for the new subnet"
  type        = string
  default     = "10.1.0.0/24"
}

variable "node_pool_size" {
  description = "The number of nodes in the default node pool (per zone)"
  type        = number
  default     = 1
}

variable "node_pool_machine_type" {
  description = "The machine type to use for the default node pool"
  type        = string
}

variable "node_pool_disk_type" {
  description = "The disk type to use for the node pool's machine disk (one of pd-standard | pd-balanced | pd-ssd)"
  type        = string
  default     = "pd-standard"
  validation {
    condition     = contains(["pd-standard", "pd-balanced", "pd-ssd"], var.node_pool_disk_type)
    error_message = "Must be one of [pd-standard pd-balanced pd-ssd]"
  }
}

variable "node_pool_disk_size" {
  description = "The size in GB for the node pool's machine disk"
  type        = number
}

variable "acm_namespace" {
  description = "The name of the ACM default namespace"
  type        = string
  default     = "config-management-system"
}

variable "acm_git_repo" {
  description = "The git repo URL for Anthos config management"
  type        = string
}

variable "acm_repo_branch" {
  description = "The repo branch to sync for ACM"
  type        = string
  default     = "main"
}

variable "acm_repo_authentication" {
  description = "The secret type for the ACM repo"
  type        = string
  default     = "none"
  validation {
    condition     = contains(["ssh", "cookiefile", "gcenode", "gcpserviceaccount", "token", "none"], var.acm_repo_authentication)
    error_message = "Must be one of [ssh cookiefile gcenode gcpserviceaccount token none]"
  }

}

variable "acm_repo_username" {
  description = "The username to use for authentication to Git (only required if authentication is token)"
  type        = string
  default     = ""
}

variable "acm_repo_pat" {
  description = "The personal access token for authentication to Git (only required if authentication is token)"
  type        = string
  default     = ""
}

variable "acm_config_sync_source_format" {
  description = "The config sync source format (one of hierarchical | unstructured)"
  type        = string
  default     = "unstructured"
  validation {
    condition     = contains(["unstructured", "hierarchical"], var.acm_config_sync_source_format)
    error_message = "Must be on of [hierarchical unstructured]"
  }
}
