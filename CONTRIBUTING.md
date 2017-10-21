Contributing
============

Interested in writing an article for Perl.com? Perhaps you want to get the word out about your new startup, provide a tutorial on your favorite module, or have community news to share. This document is for you.

Technology
----------
The website is built with [Hugo](http://gohugo.io) and hosted on GitHub Pages. You can run a local version of the site by following these [instructions](#viewing-your-draft-article).

Style Guide
===========
This section is intended to guide Perl.com authors in producing articles that are consistent with the aims of the website. None of this is set in stone - great writing should always prevail.

Goal
----
We aspire to reasoned, insightful, professional writing with a lighthearted bent.

Topics of interest
------------------
- Anything Perl related: news, events, tutorials, community
- Non-Perl programming subjects: version control, hosting, sysadmin, search
- Open Source tools and techniques

Looking for an idea for an article? Our bread and butter is: "here is something cool you can do with Perl". Start there.

Politics / Tone
---------------
- We are pro: Perl, Open Source and free software
- No rants or "hit pieces"
- Reasoned criticism is fine

Language
--------
- American English
- 300-1,000 words per article
- Simple English (use [hemingway](http://www.hemingwayapp.com/) to help)
- Articles can begin with an italicized introductory paragraph
- Prefer the first-person
- We are "Perl.com"
- You can use "we" to refer to Perl.com, the staff, our point of view etc.
- When referring to Perl modules for the first time provide a link to the module on [metacpan](https://metacpan.org/)

Markup
------
Articles are written in [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/). Every article is prefaced with [front matter](http://gohugo.io/content/front-matter/) in JSON. See [Generate Article Template](#generate-article-template) to get started quickly.

The front matter contains the article metadata. Here's an example for a recent article:

``` json
  {
     "tags" : [
       "tie",
       "scalar",
       "callback",
       "cycle"
     ],
     "title" : "Magical tied scalars",
     "description" : "Subvert and simplify code with tied scalars",
     "authors" : [
        "brian d foy"
     ],
     "date" : "2016-02-16T09:50:00",
     "draft" : true
  }
```

Older articles also have the `slug` attribute, which determines the URL of the article. This isn't necessary anymore (it's used to preserve historic URLs for articles from our old site). Instead just name the file the same as the title of the article, but in lowercase and with spaces replaced with hyphens (`-`). In this example case, the filename is `content/article/magical-tied-scalars.md`.

Once `draft` is changed to `false`, the article will be listed on the website at `perl.com/article/magical-tied-scalars`. So when providing a pull request, keep this as `true`. The site editor will switch this to `false` once the article is ready to be published.

Titles-as-filenames has another benefit: no two articles can have the same title, which avoids issues with 2 articles having duplicate URLs.

The front matter is provided inline in the markdown file, immediately followed by the article body, in GitHub flavored markdown ([cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)). The two main rules to know here are as follows:

If you want highlighted code syntax, use a fenced code block with the `prettyprint`  keyword:

    ``` prettyprint
      code
      code
      code
    ```

Code is highlighted using `prettify.js` and it will automatically detect the code type and provide the appropriate syntax highlighting (it's not perfect, but good enough).

Otherwise just use a code block (fenced or indented style) and it will be displayed in monospace on a dark background. This is used for showing data and terminal commands.

The other thing to know is article subheadings are size `h3`. So use the following construct

    ### Subtitle goes here

The article metadata like author, title and date are contained in the front matter and not needed in the article markdown body.

Internal references to other articles can be created using [relref](https://gohugo.io/extras/crossreferences/). So to link to the article "save space with bit arrays":

    [save-space-with-bit-arrays]({{< relref "save-space-with-bit-arrays.md" >}})

This is a standard markdown link, except that the URL part uses `relref`. To see a real example take a look at the [source code](https://raw.githubusercontent.com/dnmfarrell/perldotcom/master/content/article/5-things-i-learned-from-learning-perl-7th-edition.md) for the article [5 things I learned from Learning Perl](http://perl.com/article/5-things-i-learned-from-learning-perl-7th-edition/).

See the `content/article` directory for further examples of our articles.

Generate Article Template
-------------------------
You can generate an article template with the Perl script `bin/new-article`. It requires `--title`, `--category`, `--description` and `--author` arguments. It must be run from the root project directory, like this:

    $ ./bin/new-article --title 'Some New Perl Article' --author 'David Farrell' --desc 'There is more than one way to do it' \
      --category 'development'

Viewing Your Draft Article
--------------------------
It's all well and good drafting an article in Markdown, but it only comes to life when you can see how it looks in a browser on Perl.com. You can do that by running a local version of the site on your computer. To do that you'll need to install [Hugo](http://gohugo.io) and clone the repo:

    $ git clone https://github.com/dnmfarrell/perldotcom
    $ cd perldotcom

Save your draft article in the `content/article` directory. Now you're ready to fire up a local version of the site:

    $ hugo server --buildDrafts
    1 of 1 draft rendered
    0 future content
    232 pages created
    729 paginator pages created
    11 categories created
    6 authors created
    680 tags created
    in 988 ms
    Watching for changes in /home/dfarrell/perldotcom/{data,content,layouts,static}
    Serving pages from memory
    Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
    Press Ctrl+C to stop

Pay careful attention to the program output - if you see any errors, it probably means your draft article is not correctly formatted. Once those are fixed, with a browser navigate to the address shown in the output, and you should see a local version of Perl.com running on your computer and your draft article should be at the top of the page!

&copy; Perl.com
