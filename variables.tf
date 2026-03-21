variable "pm_api_url" {
  type = string

  validation {
    condition     = can(regex("^https://", var.pm_api_url))
    error_message = "pm_api_url must start with https://"
  }
}

variable "pm_api_token_id" {
  type = string

  validation {
    condition     = can(regex("^.+@.+!.+$", var.pm_api_token_id))
    error_message = "pm_api_token_id must be in format user@realm!token-name"
  }
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

variable "container_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "github_username" {
  type    = string
  default = ""
}

variable "lxc_containers" {
  type = map(object({
    target_node  = optional(string, "proxmox")
    ostemplate   = optional(string, "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst")
    cores        = optional(number, 1)
    memory       = optional(number, 512)
    disk_size    = optional(string, "8G")
    disk_storage = optional(string, "local-lvm")
    bridge       = optional(string, "vmbr0")
    start        = optional(bool, true)
  }))

  validation {
    condition     = length(var.lxc_containers) > 0
    error_message = "At least one container must be defined"
  }

  validation {
    condition     = alltrue([for k, v in var.lxc_containers : v.cores >= 1 && v.cores <= 8])
    error_message = "cores must be between 1 and 8"
  }

  validation {
    condition     = alltrue([for k, v in var.lxc_containers : v.memory >= 128 && v.memory <= 8192])
    error_message = "memory must be between 128 and 8192 MB"
  }

  validation {
    condition     = alltrue([for k, v in var.lxc_containers : can(regex("^[0-9]+G$", v.disk_size))])
    error_message = "disk_size must be in format like 8G, 16G, 32G"
  }
}