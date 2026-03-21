.PHONY: init plan apply destroy fmt validate output

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

ssh:
	@echo "Available containers:"
	@tofu output -json | jq -r '.containers.value | to_entries[] | "\(.key): \(.value.hostname)"'