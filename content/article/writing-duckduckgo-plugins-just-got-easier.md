{
   "authors" : [
      "david-farrell"
   ],
   "categories" : "community",
   "image" : "/images/189/7FF3F50E-48D6-11E5-B8B3-C12EFC9DDBA7.png",
   "title" : "Writing DuckDuckGo plugins just got easier",
   "slug" : "189/2015/8/22/Writing-DuckDuckGo-plugins-just-got-easier",
   "draft" : false,
   "description" : "All you need is JSON",
   "date" : "2015-08-22T14:05:25",
   "tags" : [
      "community",
      "search",
      "json",
      "old_site"
   ]
}


The developers behind DuckDuckGo, the search engine that doesn't track you, have made it easier than ever to write plugins for the site. With the first global [Quack & Hack](https://duck.co/blog/post/196/the-first-global-quack-hack) event taking place later this month, there's never been a better time to get involved.

### Instant Answers

The DuckDuckGo engine supports several types of plugin, but instant answers that provide a static "cheatsheet" are a simple to get started. [Previously](http://perltricks.com/article/169/2015/4/20/Writing-DuckDuckGo-instant-answers-is-easy) developing a new instant answer would require a Perl module, a test file and a plain text version of the response. Now all you need to provide is a JSON file of your instant answer and you're in business.

### Setup

You'll need to fork the DuckDuckGo [repo](https://github.com/duckduckgo/zeroclickinfo-goodies) and clone your forked repo to your development machine. Optionally you can install [App::DuckPAN](https://metacpan.org/pod/App::DuckPAN), which can launch a local version of the DuckDuckGo site for testing your code. Another way to test the cheatsheet is via [Codio](https://vimeo.com/132712266).

### An Instant Answer JSON file

Instant answer JSON files should be created in the `share/goodie/cheat_sheets` directory in the repo. A good way to start is to copy one of the existing files and change it to include your content.

This is a truncated example from my `perldoc` instant answer:

``` prettyprint
{
    "id": "perldoc_cheat_sheet",
    "name": "perldoc",
    "description": "Perl Documentation",
    "metadata": {
        "sourceName": "perldoc Manual",
        "sourceUrl": "http://perldoc.perl.org/perldoc.html"
    },
    "section_order": ["Usage", "Module Options", "Search Options", "Common Options"],
    "sections": {
        "Usage": [
        {
            "key": "[perldoc <option>]",
            "val": "start perldoc"
        },
        {
            "key": "[perldoc perldoc]",
            "val": "perldoc help"
        }
        ],
       ...
    }
}
```

The `id` and `name` fields should be unique values that describe the plugin. The `metadata` fields describe the source of the information in the instant answer. It's good to use a canonical source - in this case I referenced the official Perl documentation.

The `sections` field is the content of the instant answer. Each entry is a key value for an array of key pairs. `section_order` describes the order in which the sections will be displayed in the search engine results, so make sure you put the most important sections first!

Let's take a closer look at a section entry, here is `Module Options`:

``` prettyprint
        "Module Options": [
        {
            "key": "Module::Name",
            "val": "Show module documentation"
        },
        {
            "key": "[-l Module::Name]",
            "val": "Module filepath"
        },
        {
            "key": "[-m Module::Name]",
            "val": "Module source code"
        },
        {
            "key": "[-lm Module::Name]",
            "val": "Module filepath (alt.)"
        }
        ],
```

"Module Options" is the section name, this must be present exactly in the `section_order` field, or this section will not appear at all. The section name text is the subheading used for the section, so be sure to choose something readable: "Module Options" is better than "module\_options".

Each key pair entry represents the text to be displayed for the instant answer, the `key` text should be the code and `val` the description. If the `key` text contains spaces, wrap the text in square brackets to ensure it's displayed as code on the web page (see this article's cover image for examples). You can find the complete perldoc JSON file [here](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/share/goodie/cheat_sheets/json/perldoc.json).

### Wrap up

You can test your instant answer using [App::DuckPAN](https://metacpan.org/pod/App::DuckPAN) (see my previous [article](http://perltricks.com/article/169/2015/4/20/Writing-DuckDuckGo-instant-answers-is-easy) for examples). If you want to discuss your instant answer with a developer, or resolve an issue, the DuckDuckGo team are on Slack, you can request access via [email](mailto:QuackSlack@duckduckgo.com?subject=AddMe). The official [documentation](https://duck.co/duckduckhack/goodie_overview) is also useful.

Once you've finished an instant answer, create a pull request! The DuckDuckGo developers will review your code and give feedback. Once your instant answer is approved, it will go live within a few days.

**Updated:** Changed chat details for DDG slack 2015-08-26

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
