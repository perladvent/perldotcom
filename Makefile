
HUGO=hugo

.PHONY: new
new: ## start a new article
	perl bin/new-article

.PHONY: json
json:
	perl bin/collate_metadata

.PHONY: start
start: ## start the local server
	hugo server --buildDrafts --buildFuture --disableFastRender -d built

.PHONY: deploy
deploy: json ## deploy the website to the static repo
	bin/deploy

.PHONY: show_drafts
show_drafts: # show a list of drafts
	grep -R '"draft" : true' content

######################################################################
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help ## Show all the Makefile targets with descriptions
help: ## show a list of targets
	@grep -E '^[a-zA-Z][/a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
