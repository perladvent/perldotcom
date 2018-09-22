BIN=bin

######################################################################
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help: ## show a list of targets
	@ grep -E '^[a-zA-Z][/a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'


deploy: # convert the markdown to the HTML site
	$(BIN)/deploy

.PHONY: new
new:  # create a new article


.PHONY: check_links
check_links: # check the links from markdown
	$(BIN)/check_links

.PHONY: check_links
check_links_html: # check the links from the HTML




