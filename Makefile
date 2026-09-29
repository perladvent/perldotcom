SITE=https://www.perl.com

# The one place the pinned Hugo version lives. bin/deploy reads it from the
# environment (exported below), so update it here and nowhere else.
HUGO_VERSION=0.161.1
export HUGO_VERSION

# Running `make` with no target shows the help menu.
.DEFAULT_GOAL := help

JSON_DIRNAME=json
JSON_LOCAL_DIR=static/$(JSON_DIRNAME)

DEPLOYED_TAG_NAME=deployed

BUILD_JSON_FILE=build.json
BUILD_JSON_URL=$(SITE)/$(JSON_DIRNAME)/$(BUILD_JSON_FILE)

.PHONY: init
init: ## set up local git hooks (.githooks); run once per clone
	git config core.hooksPath .githooks
	@echo "git hooks enabled: core.hooksPath -> .githooks"

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

HUGO_SERVER_FLAGS=--buildDrafts --buildFuture --disableFastRender -d built --config hugo.toml

.PHONY: start
start: json contributors ## start the local server (see start-tailscale to expose it)
	hugo server $(HUGO_SERVER_FLAGS)

.PHONY: start-tailscale
start-tailscale: json contributors ## start the server bound to your Tailscale IP (reachable on your tailnet)
	hugo server --bind $(shell tailscale ip -4 | head -1) --baseURL http://$(shell tailscale ip -4 | head -1):1313/ $(HUGO_SERVER_FLAGS)

.PHONY: deploy
deploy: on_master json contributors ## deploy the website to the static repo
	PERLDOTCOM_DEPLOY_VIA_MAKE=1 bin/deploy
	git tag -d $(DEPLOYED_TAG_NAME)
	- git push origin --delete $(DEPLOYED_TAG_NAME)
	git tag $(DEPLOYED_TAG_NAME)
	git push origin --tags

.PHONY: show_drafts
show_drafts: ## show a list of drafts
	grep -R '"draft" : true' content

.PHONY: show_live_build
show_live_build: ## show the build data for the live site
	- perl bin/site-is-fresh

.PHONY: refresh_tags
refresh_tags: ## sync the tags with the repo
	git fetch --tags --force

.PHONY: hugo-version
hugo-version: ## print the pinned Hugo version used for deployment
	@echo $(HUGO_VERSION)

.PHONY: on_master
on_master:
	@ perl -le 'die "Must be on master to run this target" if `git rev-parse --abbrev-ref HEAD` !~ /\Amaster\Z/'

######################################################################
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help ## Show all the Makefile targets with descriptions
help: ## show a list of targets
	@grep -E '^[a-zA-Z][/a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
