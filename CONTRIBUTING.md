Contributing
============

Interested in writing an article for Perl.com? Perhaps you want to get the word out about your new startup, provide a tutorial on your favorite module, or have community news to share. This document is for you.

Don't know what to write about? See our [article](https://www.perl.com/article/how-to-find-a-programming-topic-to-write-about/) on how to find a topic.

Our [Style Guide](STYLE-GUIDE.md) describes our writing conventions, rules and has tips to make your articles better.

Technology
----------
The website is built with [Hugo](http://gohugo.io). You can run a local version of the site by following these [instructions](#viewing-your-draft-article).

Markup
------
Articles are written in [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/). Every article is prefaced with [front matter](http://gohugo.io/content/front-matter/) in JSON. See [Generate Article Template](#generate-article-template) to get started quickly.

The front matter contains the article metadata. Here's an example for a recent article:

``` json
{
   "categories" : "development",
   "date" : "2016-02-16T09:50:00",
   "authors" : [
      "brian-d-foy"
   ],
   "description" : "Subvert and simplify code with tied scalars",
   "draft" : false,
   "title" : "Magical tied scalars",
   "tags" : [
      "tie",
      "scalar",
      "callback",
      "cycle",
      "mastering_perl"
   ]
}
```

Older articles also have the `slug` attribute, which determines the URL of the article. This isn't necessary anymore (it's used to preserve historic URLs). Instead just name the file the same as the title of the article, but in lowercase and with spaces replaced with hyphens (`-`). In this example case, the filename is `content/article/magical-tied-scalars.md`.

Two other optional attribute are `thumbnail` and `image`. Thumbnail can be used when you have an image you want to be displayed as the article's thumbnail, but not as a larger image at the beginning of the article (that's what `image is for`). If `thumbnail` is not present, Perl.com tries to use `image` as the thumbnail. If `image` is also not available, Perl.com will use the author's picture. If that's not present, it will fallback on a blank avatar image.

Once `draft` is changed to `false`, the article will be listed on the website at `perl.com/article/magical-tied-scalars`. So when providing a pull request, keep this as `true`. The site editor will switch this to `false` once the article is ready to be published.

Titles-as-filenames has another benefit: no two articles can have the same title, which avoids issues with 2 articles having duplicate URLs.

The front matter is provided inline in the markdown file, immediately followed by the article body, in GitHub flavored markdown ([cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)). The two main rules to know here are as follows:

If you want highlighted code syntax, use a fenced code block with the program language name, e.g:

    ```perl
      code
      code
      code
    ```

Otherwise just use a code block (fenced or indented style) and it will be displayed in monospace on a dark background. This is used for showing data and terminal commands.

The other thing to know is article subheadings are size `h3`. So use the following construct

    ### Subtitle goes here

The article metadata like author, title and date are contained in the front matter and not needed in the article markdown body.

Create links to CPAN modules with the `mcpan` shortcode:

	[Business::ISBN]({{<mcpan "Business::ISBN" >}})

Create links to the documentation with either `perldoc` or `perlfunc` shortcodes:

	[perldelta]({{<perldoc "perldelta" >}})
	[sort]({{<perlfunc "sort" >}})

Internal references to other articles can be created using [relref](https://gohugo.io/extras/crossreferences/). So to link to the article "save space with bit arrays":

    [save-space-with-bit-arrays]({{< relref "save-space-with-bit-arrays.md" >}})

This is a standard markdown link, except that the URL part uses `relref`. To see a real example take a look at the [source code](https://raw.githubusercontent.com/dnmfarrell/perldotcom/master/content/article/5-things-i-learned-from-learning-perl-7th-edition.md) for the article [5 things I learned from Learning Perl](http://perl.com/article/5-things-i-learned-from-learning-perl-7th-edition/).

See the `content/article` directory for further examples of our articles.

Generate Article Template
-------------------------
You can generate an article template with the Perl script `bin/new-article`. It requires `--title`, `--category`, `--description` and `--author` arguments. It must be run from the root project directory, like this:

    $ bin/new-article --title 'Some New Perl Article' --author 'david-farrell' --desc 'There is more than one way to do it' \
      --category 'development'

If the above command fails due to missing Perl dependencies, you can install
them via `cpanm`. Run the following command before re-running the command
above:

    $ cpanm --installdeps .

The `author` value is a key used to find the author data in the `data/author` directory. If this is your first article, you'll need to create an author entry too. Here's mine (`data/author/david-farrell.json`):

``` json
{
  "name": "David Farrell",
  "key": "david-farrell",
  "bio": "David is the founder and editor of PerlTricks.com. An organizer of the [New York Perl Meetup](http://www.meetup.com/The-New-York-Perl-Meetup-Group/), he works for ZipRecruiter as a software developer.",
  "image": "/images/author/david-farrell.jpg"
}
```

Both `bio` and `image` can be `null`.

Viewing Your Draft Article
--------------------------
It's all well and good drafting an article in Markdown, but it only comes to life when you can see how it looks in a browser on Perl.com. You can do that by running a local version of the site on your computer. To do that you'll need to install [Hugo](http://gohugo.io). **Warning** package managers' versions of hugo are often very out of date, you're usually better off with a pre-compiled binary. The site is tested against v0.31.1 and higher

Now fork this repo. Clone your fork:

    $ git clone https://github.com/$github_username/perldotcom
    $ cd perldotcom

Save your draft article in the `content/article` directory. Now you're ready to fire up a local version of the site:

    $ hugo server --buildDrafts
    ...
    Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
    Press Ctrl+C to stop

Pay careful attention to the program output - if you see any errors, it probably means your draft article is not correctly formatted. Once those are fixed, with a browser navigate to the address shown in the output, and you should see a local version of Perl.com running on your computer and your draft article should be at the top of the page!

Submit a Pull Request
---------------------
Once the draft article looks good in your browser, it's ready for a pull request. Commit your changes, push them to your repo:

    $ git add .
    $ git commit
    $ git push origin master

Then send us a Pull Request from GitHub!

&copy; Perl.com
