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

up: apply provision
	@echo "Infrastructure up and provisioned"

down: destroy
	@rm -f ansible/inventory.yml
	@echo "Infrastructure destroyed"