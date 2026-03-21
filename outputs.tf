output "containers" {
  value = {
    for key, c in proxmox_lxc.container : key => {
      vmid     = c.vmid
      hostname = c.hostname
      node     = c.target_node
      ip       = c.network[0].ip
      hwaddr   = c.network[0].hwaddr
    }
  }
}