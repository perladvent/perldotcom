SITE=https://www.perl.com

HUGO=hugo

JSON_DIRNAME=json
JSON_LOCAL_DIR=static/$(JSON_DIRNAME)

BUILD_JSON_FILE=build.json
BUILD_JSON_URL=$(SITE)/$(JSON_DIRNAME)/$(BUILD_JSON_FILE)

.PHONY: new
new: ## start a new article
	perl bin/new-article

.PHONY: json
json: ## create the JSON files (static/json)
	perl bin/collate_metadata
	perl bin/tag_the_build > $(JSON_LOCAL_DIR)/$(BUILD_JSON_FILE)

.PHONY: contributors
contributors:
	perl bin/list_contributors > content/contributors.md

.PHONY: start
start: json contributors ## start the local server
	hugo server --buildDrafts --buildFuture --disableFastRender -d built

.PHONY: deploy
deploy: json contributors ## deploy the website to the static repo
	bin/deploy

.PHONY: show_drafts
show_drafts: ## show a list of drafts
	grep -R '"draft" : true' content

.PHONY: show_live_build
show_live_build: ## show the build data for the live site
	curl $(BUILD_JSON_URL) | jq .

######################################################################
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help ## Show all the Makefile targets with descriptions
help: ## show a list of targets
	@grep -E '^[a-zA-Z][/a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
