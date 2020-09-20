
HUGO=hugo

.PHONY: new
new:
	perl bin/new-article

.PHONY: json
json:

.PHONY: start
start:
	hugo server --buildDrafts --buildFuture --disableFastRender -d built

.PHONY: deploy
deploy: json
	bin/deploy

.PHONY: show_drafts
show_drafts:
	grep -R '"draft" : true' content


