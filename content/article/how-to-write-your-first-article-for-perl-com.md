{
   "categories" : "tutorials",
   "description" : "Our tools make it easier than you might think",
   "draft" : false,
   "date" : "2018-08-16T07:28:49",
   "authors" : [
      "david-farrell"
   ],
   "thumbnail" : "/images/how-to-write-your-first-article-for-perl-com/thumb_woman-writing.jpg",
   "image" : "/images/how-to-write-your-first-article-for-perl-com/woman-writing.jpg",
   "title" : "How to write your first article for Perl.com",
   "tags" : [
      "writing", "contributing", "perldotcom"
   ]
}

Welcome to part 2 in our contributing [series](/tags/contributing/)! The first [article]({{< relref "how-to-find-a-programming-topic-to-write-about.md" >}}) explained how to find a topic to write about. This article will show you how to submit your article to Perl.com for publication.

Our source code is hosted on a [public perldotcom GitHub repo](https://github.com/tpf/perldotcom), so the first thing you need to do is fork it so you have your own copy. Now clone your fork locally, and you should be ready to start making your changes.

### Create your author data

Perl.com stores author profile data in the `data/author` directory. As this is your first article, you'll need to create an entry for yourself. Here's mine (`data/author/david-farrell.json`):

``` json
{
  "name": "David Farrell",
  "key": "david-farrell",
  "bio": "David is the editor of PerlTricks.com. An organizer of the [New York Perl Meetup](http://www.meetup.com/The-New-York-Perl-Meetup-Group/), he works for ZipRecruiter as a software developer.",
  "image": "/images/author/david-farrell.jpg"
}
```

* `name` - your author name that will be displayed in the article
* `key` - a unique ascii-fied version of your name which should also match your author data filename (e.g. "david-farrell.json"). Use this later in the `authors` array in your article frontmatter
* `bio` - your biography in markdown, so you can include links to your social media and other relevant sites
* `image` - a square portrait/avatar jpeg image 500 pixels wide or smaller, ideally under 50kb in size. These go in the `static/images/author` directory. If you don't have an image or want to use one, use `/images/site/avatar.png`.

If you've setup everything correctly, later you should see a nicely formatted profile underneath your article body text:

![](/images/how-to-write-your-first-article-for-perl-com/profile.png)

### Generate an empty article file

You can generate an empty article with the Perl script `bin/new-article`. It requires `--title`, `--category`, `--description` and `--author` arguments. Use your `author` key from your author data that you just created. It must be run from the root project directory, like this:

    $ bin/new-article --title 'Some New Perl Article' --author 'david-farrell' --desc 'There is more than one way to do it' \
      --category 'development'

If the above command fails due to missing Perl dependencies, you can install them via `cpanm`:

    $ cpanm --installdeps .


### Refine the article frontmatter

Every article is prefaced with [front matter](http://gohugo.io/content/front-matter/), which will have been pre-populated by `bin/new-article` script. Feel free to add tags to help classify the content of the article. We use lowercase, ascii-fied tag names (for examples see the [index](/tags/)).

Two other optional frontmatter properties are `thumbnail` and `image`. If you have an image you'd like to use as the cover image for your article, create a directory under `static/images` with the same name as your article filename (without the file extension), and save the image there. The image should be landscape oriented, and smaller than 250kb. The script `bin/create-thumbnail` can be used to generate a thumbnail for your article, it will update the article frontmatter too, so save your work before running it.

You might be wondering why the `authors` property is an array; this is so you can have multiple authors per article! If you're collaborating with someone else, create their author data file and include their author key in the `authors` property.


### Write the article content

For writing guidance, our [style guide](https://github.com/tpf/perldotcom/blob/master/STYLE-GUIDE.md) describes the standards we aim for with Perl.com articles. It also has some tips to make your writing stand out. All articles are written in [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/). There are a few conventions we use:

For highlighted code syntax, use a fenced code block with the programming language name, e.g:

    ```perl
      code
      code
      code
    ```

Otherwise just use a code block (fenced or indented style) and it will be displayed in monospace on a dark background. This is used for showing data and terminal commands.

Article subheadings are size `h2`. So use the following construct:

    Subtitle goes here
    ------------------

Create links to CPAN modules with the `mcpan` shortcode:

    [Business::ISBN]({{</* mcpan "Business::ISBN" */>}})

Create links to the official Perl documentation with either `perldoc` or `perlfunc` shortcodes:

    [perldelta]({{</* perldoc "perldelta" */>}})
    [sort]({{</* perlfunc "sort" */>}})

Internal references to other articles can be created using [relref](https://gohugo.io/extras/crossreferences/). So to link to the article "save space with bit arrays":

    [save-space-with-bit-arrays]({{< relref "save-space-with-bit-arrays.md" >}})

If you're not sure how to format something, grep the `content/article` directory for examples and copy from them.

### View your article locally

It's all well and good drafting an article in Markdown, but it only comes to life when you can see how it looks in a browser. You can do that by running a local version of the site on your computer. You'll need to install [Hugo](http://gohugo.io). **Warning** package managers' versions of hugo are often very out of date, you're usually better off with a pre-compiled binary. The site has been tested with v0.59.0 and should build with the latest version of Hugo.

From the root project directory, launch a local version of the site:

    $ hugo server --buildDrafts --buildFuture
    ...
    Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
    Press Ctrl+C to stop

Pay careful attention to the program output—if you see any errors, it probably means your draft article is not correctly formatted. Once those are fixed, navigate with a browser to the localhost address shown in the output, and you should see a version of Perl.com running on your computer with your draft article at the top of the homepage!

If your page does not appear, check that Hugo sees it well:

    $ hugo list drafts

Or

    $ hugo list future

### Refining your article

Before your send us your article, check that your article:

* Code examples work (test them!)
* Has no spelling errors
* Conforms to our [style guide](https://github.com/tpf/perldotcom/blob/master/STYLE-GUIDE.md)

Tip: when I've written my first draft, I find it helpful to review it the following morning. By looking at it afresh I often find improvements I can make.

### Submit a pull request

Once the draft article looks good to you, it's ready for a pull request. Commit your changes, push them to your repo and send us a pull request from GitHub. If the article looks suitable, we'll merge the request and open a branch for editing. From their we'll review it, edit it if necessary, and ask you to review our changes. If you're happy with them, we'll publish your article. Otherwise, we can continue the editing process: usually it doesn't take more than a couple of cycles. Our goal is to preserve your voice whilst making sure the article meets our standards.

Once the article is published we'll let you know and promote it on social media. Congratulations, you're a published Perl.com author now!

\
Cover [image](https://www.flickr.com/photos/fidgetcircle/34743456922/in/photostream/) by [www.fidgetcircle.com](https://www.fidgetcircle.com)
