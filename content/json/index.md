{
  "title": "Perl.com JSON files",
  "type": "about",
  "categories": "meta",
  "exclude_paginate": 1
}

## JSON files

Perl.com provides various JSON files for its articles for your programming pleasure. Get all the articles, or just the last 10 (for a smaller file):

* [All articles](/json/all_articles.json)
* [Previous 10 articles](/json/previous_ten_articles.json)

Another set of JSON files have the keys that you can use to find smaller sets of files:

* [List of authors](/json/authors.json)
* [List of categories](/json/categories.json)
* [List of tags](/json/tags.json)

Each author, category, and tag has its own list of articles:

	/json/by_{author,category,tag}/KEY.json

If there's another dataset that you'd like, let us know by [opening a GitHub issue](https://github.com/tpf/perldotcom/issues).
