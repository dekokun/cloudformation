ROLE=hoge
STACK=$(ROLE)-stack
CMD=aws cloudformation --region ap-northeast-1 --profile default
DATE=$(shell date +%Y%m%d%H%M%S)
CHANGESET="$(STACK)-changeset-${DATE}"

stack-create:
	$(CMD) create-stack --stack-name $(STACK) --parameters file://$(PWD)/$(ROLE)/parameters.json --template-body file://$(PWD)/$(ROLE)/template.yaml --capabilities CAPABILITY_NAMED_IAM

stack-update:
	$(CMD) update-stack --stack-name $(STACK) --parameters file://$(PWD)/$(ROLE)/parameters.json --template-body file://$(PWD)/$(ROLE)/template.yaml --capabilities CAPABILITY_NAMED_IAM

stack-diff:
	$(CMD) create-change-set --stack-name $(STACK) --parameters file://$(PWD)/$(ROLE)/parameters.json --template-body file://$(PWD)/$(ROLE)/template.yaml --change-set-name $(CHANGESET)
	@sleep 5
	@echo 'change:'
	$(CMD) describe-change-set --stack-name $(STACK) --change-set-name $(CHANGESET)

.PHONY: stack-create stack-update stack-diff
