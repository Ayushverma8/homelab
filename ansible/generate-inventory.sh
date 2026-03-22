#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

PM_API_URL=$(grep pm_api_url secrets.auto.tfvars | cut -d'"' -f2)
PM_TOKEN_ID=$(grep pm_api_token_id secrets.auto.tfvars | cut -d'"' -f2)
PM_TOKEN_SECRET=$(grep pm_api_token_secret secrets.auto.tfvars | cut -d'"' -f2)

CONTAINERS=$(tofu output -json containers)

echo "all:"
echo "  hosts:"

for key in $(echo "$CONTAINERS" | jq -r 'keys[]'); do
  vmid=$(echo "$CONTAINERS" | jq -r ".\"$key\".vmid")
  hostname=$(echo "$CONTAINERS" | jq -r ".\"$key\".hostname")
  node=$(echo "$CONTAINERS" | jq -r ".\"$key\".node")

  ip=$(curl -sk "${PM_API_URL}/nodes/${node}/lxc/${vmid}/interfaces" \
    -H "Authorization: PVEAPIToken=${PM_TOKEN_ID}=${PM_TOKEN_SECRET}" \
    | jq -r '.data[] | select(.name=="eth0") | .["ip-addresses"][] | select(.["ip-address-type"]=="inet") | .["ip-address"]' 2>/dev/null || echo "")

  if [ -n "$ip" ]; then
    echo "    ${key}:"
    echo "      ansible_host: ${ip}"
    echo "      ansible_user: root"
    echo "      hostname: ${hostname}"
    echo "      vmid: ${vmid}"
  fi
done
