
  {
    "title"  : "Hacktoberfest is here",
    "authors": ["brian-d-foy"],
    "date"   : "2016-10-02T10:51:01",
    "tags"   : ["perl","github", "pull-request","git", "digitalocean", "hacktoberfest", "ghojo"],
    "draft"  : false,
    "image"  : "/images/hacktoberfest-is-here/hacktoberfest-2016.png",
    "description" : "Send those Perl GitHub pull requests!",
    "categories": "community"
  }

[Hacktoberfest](https://hacktoberfest.digitalocean.com/) is here, and you can be part of the effort to make Perl the most popular language in the month long festival of patches and pull requests.

[DigitalOcean](https://www.digitalocean.com/) and [GitHub](https://www.github.com/) have teamed up to encourage new users to participate in open source. Make four pull requests to any GitHub project and they'll give you a limited-edition Hacktoberfest t-shirt. It might not sound like much, but consider what you get besides the shirt: you're in the commit logs of four projects and your profile has some history. That's the first step in building your open source résumé.

The sponsors suggest that projects that want to participate label their issues with "Hacktoberfest". That's not strictly necessary, but you can [search](https://github.com/search?q=state%3Aopen+label%3Ahacktoberfest&type=Issues) for issues that projects think are suitable for new users. I think all of my projects are suitable (I may be optimistic), so I wanted a way to label all of my issues across all of my projects.

I found out about this as I was building some other GitHub tools. I looked at [Net::GitHub](https://www.metacpan.org/module/Net::GitHub), [Pithub](https://www.metacpan.org/module/Pithub), and Marchex's [github-api-tools](https://github.com/marchex/github-api-tools) but I wanted to iterate through long lists of paged results and process each item as I received them. The [GitHub Developer API](https://developer.github.com/v3/) is quite nice and even if you are re-inventing the wheel you're learning about wheels, making this a fun night of work.

The result is [hacktoberfest.pl](https://github.com/briandfoy/ghojo/blob/master/examples/hacktoberfest.pl) in my [ghojo](https://github.com/briandfoy/ghojo) repo. It will log in, list all of my repos (there are a couple hundred), create the "Hacktoberfest" label in each, and then apply the label to each open issue.

The ghojo project is still very much in its infancy (which means there's all sorts of pull request opportunities). But I allow quite a bit of flexibility by accepting a callback for things I expect to return many items:

``` prettyprint
use Ghojo;

my $ghojo = Ghojo->new( { token => ... } );

my $callback = sub {
  my $item = shift;
  ...
  };

$ghojo->repos( $repo_callback );
```

Each time I find a repo—and you don't have to know how I do that—I run that callback. It's a little bit like [File::Find](https://www.metacpan.org/module/File::Find)'s use of the `wanted` coderef. You don't see the very nice API paging going on either; `repos` keeps fetching more results as long as there are more results.

That callback deals with a repo, but each repo has a list of issues. I want to process this list of issues as I run into them. So what I need is a callback to process a repo with a nested callback for the issues:

``` prettyprint
use v5.24;

use Ghojo;

my $ghojo = Ghojo->new( { token => ... } );

my $label_name = 'Hacktoberfest';

my $callback = sub ( $item ) {
  my( $user, $repo ) = split m{/}, $item->{full_name};

  my $repo = $ghojo->get_repo_object( $owner, $repo );

  # get the labels for that repo
  my %labels = map { $_->@{ qw(name color) } } $repo->labels->@*;

  unless( exists $labels{$label_name} ) {
    my $rc = $repo->create_label( $label_name, 'ff5500' );
    say "\tCreated $label_name label" if $rc;
    }

  my $callback = sub ( $item ) {
    $repo->add_labels_to_issue( $item->{number}, $label_name );
    return $item;
    };

  my $issues = $repo->issues( $callback );

  return $repo;
  };


$ghojo->repos( $repo_callback );
```

Curiously, within a couple of hours of uploading the program, I received my first Hacktoberfest [pull request](https://github.com/briandfoy/ghojo/pull/14). [haydenty](https://github.com/haydenty) added the [CONTRIBUTING.md](https://github.com/briandfoy/ghojo/blob/master/CONTRIBUTING.md) file to my ghojo repo. It's something I've been meaning to add to all of my repos. Now I'm considering adding an issue to each repo to note that and label each one "Hacktoberfest". Or someone who wants to get started with something simple can create the issues for me, or send the pull requests right off.

If you have lots of repos, label your issues to help push Perl up in [the rankings](https://github.com/search?q=state%3Aopen+label%3Ahacktoberfest&type=Issues). By the time we reach the end of the month, I'll have a program to reverse the labeling.

Some of this I'm doing for fun, and some of this I'm doing because some organizations want better GitHub tools. Somehow how October is when all of that is coming together. If you'd like me to work on this sort of stuff for you, [let me know](mailto:brian.d.foy@gmail.com)! But submit those pull requests first so you get that t-shirt.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
