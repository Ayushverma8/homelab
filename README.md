# Proxmox LXC Homelab

OpenTofu-managed LXC containers on Proxmox with automatic Tarantino-themed naming.

Every container gets a random character name from the Quentin Tarantino universe plus a unique hex suffix. Define what you need, the code gives it an identity.

```
testbox = {}  -->  beatrix-a3f1b2
docker  = {}  -->  jules-7c9e04
pihole  = {}  -->  django-d41f8b
```

## Features

- **Declarative containers**: Define containers as a simple map, override only what differs from defaults
- **Tarantino naming**: Automatic random character assignment from 30 iconic characters
- **GitHub SSH keys**: Pulls your public keys from GitHub on every apply
- **Input validation**: Catches bad values (cores, memory, disk format) at plan time
- **Makefile shortcuts**: `make plan`, `make apply`, `make destroy`

## Prerequisites

- [OpenTofu](https://opentofu.org/) installed
- Proxmox VE with API access enabled
- An API token created in Proxmox (Datacenter > Permissions > API Tokens)
- An LXC template downloaded (e.g. Ubuntu 22.04)

## Quick Start

```bash
git clone https://github.com/ayushverma8/homelab.git
cd homelab
cp terraform.tfvars.example secrets.auto.tfvars
```

Edit `secrets.auto.tfvars` with your values:

```hcl
pm_api_url          = "https://192.168.2.250:8006/api2/json"
pm_api_token_id     = "root@pam!homelab"
pm_api_token_secret = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
github_username     = "your-github-username"

lxc_containers = {
  testbox = {}
}
```

Then:

```bash
make init
make plan
make apply
```

## Container Configuration

Containers are defined as a map. The key is your label, the value overrides defaults.

| Parameter    | Default                                                        | Description              |
|-------------|----------------------------------------------------------------|--------------------------|
| target_node | proxmox                                                        | Proxmox node name        |
| ostemplate  | local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst      | LXC OS template path     |
| cores       | 1                                                              | CPU cores (1-8)          |
| memory      | 512                                                            | RAM in MB (128-8192)     |
| disk_size   | 8G                                                             | Root disk size           |
| disk_storage| local-lvm                                                      | Proxmox storage pool     |
| bridge      | vmbr0                                                          | Network bridge           |
| start       | true                                                           | Start after creation     |

### Examples

Minimal (all defaults):

```hcl
lxc_containers = {
  testbox = {}
}
```

Multiple with overrides:

```hcl
lxc_containers = {
  docker = { cores = 4, memory = 4096, disk_size = "64G" }
  pihole = { memory = 256, disk_size = "4G" }
  devbox = { cores = 2, memory = 2048 }
}
```

## File Structure

```
.
├── main.tf                    # Resources and data sources
├── variables.tf               # Variable declarations with validations
├── locals.tf                  # Tarantino character list and name assignments
├── outputs.tf                 # Container info output after apply
├── providers.tf               # Proxmox provider config
├── versions.tf                # Required providers and versions
├── Makefile                   # Shortcut commands
├── secrets.auto.tfvars        # Your actual values (gitignored)
├── terraform.tfvars.example   # Example values for reference
└── .gitignore                 # Ignores state, secrets, caches
```

## Makefile Commands

| Command          | Description                        |
|-----------------|------------------------------------|
| `make init`     | Initialize and upgrade providers   |
| `make plan`     | Preview changes                    |
| `make apply`    | Apply changes                      |
| `make destroy`  | Destroy all containers             |
| `make fmt`      | Format all .tf files               |
| `make validate` | Check formatting and validity      |
| `make output`   | Show current outputs as JSON       |

## SSH Access

If `github_username` is set, your public keys from `https://github.com/<username>.keys` are injected into every container. After apply:

```bash
ssh root@<container-ip>
```

Container IPs are shown in the output after apply.

## Tarantino Characters

The pool of 30 characters spans across Pulp Fiction, Kill Bill, Django Unchained, Inglourious Basterds, Jackie Brown, Death Proof, The Hateful Eight, and Once Upon a Time in Hollywood.

## License

MIT