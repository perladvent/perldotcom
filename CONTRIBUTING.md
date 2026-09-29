# Contributing

All of our contributions flow through GitHub.

## Write an article

Interested in writing an article for Perl.com? Perhaps you want to get the word
out about your new startup, provide a tutorial on your favorite module, or have
community news to share. This document is for you.

You can propose an article as a [GitHub
issue](https://github.com/perladvent/perldotcom/issues), or simply send up a pull
request. Inside the repo, you can run the `make new` target and you'll be led
through the questions to set up your initial article template:

```
% cpm install -g --cpanfile cpanfile
% make init    # once per clone: enables local git hooks
% make new
```

`make init` turns on a pre-commit check that catches a common mistake —
using an SVG as an article's thumbnail/feature image, which breaks the
social-media preview card. It's optional but recommended; the same check
runs in CI on every pull request.

You can then check your article by starting a local server using [Hugo
](https://gohugo.io/). Deployment uses a pinned Hugo version (run in Docker), so
matching it is best if you're doing layout work on the site; for _articles_
rather than layout, the latest available version is probably fine. Run `make
hugo-version` to print the pinned version, and see [DEPLOYMENT.md](DEPLOYMENT.md)
for how the site is built and published.

To start the server run:

```
% make start
```

Once you submit your article, an editor will help guide it to its final form.

Don't know what to write about? See our
[article](https://perl.com/article/how-to-find-a-programming-topic-to-write-about/)
on how to find a topic.

Check out our first time author
[tutorial](https://perl.com/article/how-to-write-your-first-article-for-perl-com/)
to understand our contributor process.  Our [Style Guide](STYLE-GUIDE.md)
describes our standards and has tips to make your articles better. For the most
part, your article should look and read like other Perl.com articles.

## Fix a problem

Since we've moved to GitHub, it's easy for you to fix problems you find,
whether that's a simple typo to adjusting code for new interfaces.

You can edit files directly in GitHub, which will automatically fork our repo
and send a pull request.

For big edits, you might want to raise a [GitHub
issue](https://github.com/perladvent/perldotcom/issues) before you spend too
much time on it.

&copy; Perl.com
