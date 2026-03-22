.PHONY: init plan apply destroy fmt validate output inventory provision provision-check up down

init:
	tofu init -upgrade

plan:
	tofu plan

apply:
	tofu apply

destroy:
	tofu destroy

fmt:
	tofu fmt -recursive

validate:
	tofu fmt -check -recursive
	tofu validate

output:
	tofu output -json

inventory:
	@bash ansible/generate-inventory.sh > ansible/inventory.yml
	@echo "Inventory written to ansible/inventory.yml"
	@cat ansible/inventory.yml

provision: inventory
	cd ansible && ansible-playbook playbook.yml

provision-check: inventory
	cd ansible && ansible-playbook playbook.yml --check --diff

up: apply
	@echo "Waiting for containers to get IPs..."
	@bash ansible/generate-inventory.sh > ansible/inventory.yml
	@cat ansible/inventory.yml
	cd ansible && ansible-playbook playbook.yml
	@echo ""
	@echo "============================================"
	@echo "Infrastructure up and provisioned"
	@echo "============================================"
	@echo ""
	@echo "SSH into your containers:"
	@grep ansible_host ansible/inventory.yml | while read -r line; do \
		ip=$$(echo $$line | cut -d: -f2 | tr -d ' '); \
		echo "  ssh root@$$ip"; \
	done
	@echo ""

down: destroy
	@rm -f ansible/inventory.yml
	@echo "Infrastructure destroyed"