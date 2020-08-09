
HUGO=hugo

.PHONY: json
json:

.PHONY: local
local:
	$(HUGO) server --buildDrafts --buildFuture

.PHONY: deploy
deploy: json
	bin/deploy

.PHONY: show_drafts
show_drafts:
	grep -R '"draft" : true' content
