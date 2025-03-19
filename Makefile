.PHONY: help

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  tf-init        Initialize Terraform"
	@echo "  tf-plan        Plan Terraform"
	@echo "  tf-apply       Apply Terraform"
	@echo "  tf-destroy     Destroy Terraform"
	@echo "  tf-nuke        Destroy and Apply Terraform"
	@echo "  tf-test-run    Apply and Destroy Terraform"

ckan-solr-docker:
	@docker build -t docker.io/nathstevo97/ckan-solr .\ckan-solr

ckan-datapusher-docker:
	@docker build -t docker.io/nathstevo97/ckan-datapusher ./ckan-datapusher

ckan-docker:
	@docker build -t docker.io/nathstevo97/ckan ./ckan

ckan-build:
	@docker-compose -f docker-compose.yaml build

ckan-up: ckan-build
	@docker-compose -f docker-compose.yaml up -d

ckan-down:
	@docker-compose -f docker-compose.yaml down

tf-init:
	@terraform init

tf-plan:
	@terraform plan

tf-apply:
	@terraform apply --var-file=terraform.tfvars --auto-approve

tf-destroy:
	@terraform destroy --var-file=terraform.tfvars --auto-approve

tf-nuke:
	$(MAKE) tf-destroy
	$(MAKE) tf-apply

tf-test-run:
	$(MAKE) tf-apply
	$(MAKE) tf-destroy