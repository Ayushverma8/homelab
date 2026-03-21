data "http" "github_keys" {
  count = var.github_username != "" ? 1 : 0
  url   = "https://github.com/${var.github_username}.keys"
}

locals {
  ssh_keys = var.github_username != "" ? trimspace(data.http.github_keys[0].response_body) : ""
}

resource "random_shuffle" "character" {
  input        = local.tarantino_characters
  result_count = length(var.lxc_containers)
}

resource "random_id" "suffix" {
  for_each    = var.lxc_containers
  byte_length = 3
}

resource "proxmox_lxc" "container" {
  for_each = var.lxc_containers

  target_node     = each.value.target_node
  hostname        = "${local.name_assignments[each.key]}-${random_id.suffix[each.key].hex}"
  ostemplate      = each.value.ostemplate
  unprivileged    = true
  ssh_public_keys = local.ssh_keys

  rootfs {
    storage = each.value.disk_storage
    size    = each.value.disk_size
  }

  network {
    name   = "eth0"
    bridge = each.value.bridge
    ip     = "dhcp"
  }

  cores  = each.value.cores
  memory = each.value.memory
  start  = each.value.start
}