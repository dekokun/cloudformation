ROLE=hoge
STACK=$(ROLE)-stack
CMD=aws cloudformation --region ap-northeast-1 --profile default
DATE=$(shell date +%Y%m%d%H%M%S)
CHANGESET="$(STACK)-changeset-${DATE}"
PARAMETERS_FILE=$(PWD)/$(ROLE)/parameters.json
TEMPLATE_FILE=$(PWD)/$(ROLE)/template.yaml
POLICY_FILE=$(PWD)/$(ROLE)/policy.json

create: $(PARAMETERS_FILE) $(TEMPLATE_FILE)
	$(CMD) create-stack --stack-name $(STACK) --parameters file://$(PARAMETERS_FILE) --template-body file://$(TEMPLATE_FILE) --capabilities CAPABILITY_NAMED_IAM
	$(CMD) set-stack-policy --stack-name $(STACK) --stack-policy-body=file://$(POLICY_FILE)

update: $(PARAMETERS_FILE) $(TEMPLATE_FILE)
	$(CMD) set-stack-policy --stack-name $(STACK) --stack-policy-body=file://$(POLICY_FILE)
	$(CMD) update-stack --stack-name $(STACK) --parameters file://$(PARAMETERS_FILE) --template-body file://$(TEMPLATE_FILE) --capabilities CAPABILITY_NAMED_IAM

diff: $(PARAMETERS_FILE) $(TEMPLATE_FILE)
	$(CMD) create-change-set --stack-name $(STACK) --parameters file://$(PARAMETERS_FILE) --template-body file://$(TEMPLATE_FILE) --change-set-name $(CHANGESET)
	@sleep 5
	@echo 'change:'
	$(CMD) describe-change-set --stack-name $(STACK) --change-set-name $(CHANGESET)

.PHONY: create update diff
