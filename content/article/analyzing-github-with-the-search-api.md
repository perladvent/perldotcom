{
   "date" : "2014-09-05T12:11:51",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "github",
      "git",
      "docker",
      "search",
      "api",
      "net_github"
   ],
   "title" : "Analyzing GitHub with the search API",
   "thumbnail" : "/images/112/thumb_87727BBA-34A1-11E4-B2A5-54317BB45C3F.png",
   "description" : "Net::GitHub makes it easy to search GitHub",
   "draft" : false,
   "slug" : "112/2014/9/5/Analyzing-GitHub-with-the-search-API",
   "categories" : "data",
   "image" : "/images/112/87727BBA-34A1-11E4-B2A5-54317BB45C3F.png"
}


The Net::GitHub module provides a perly interface to GitHub's feature-rich API. You can do everything with it, from creating new repos to managing issues and initiating pull requests. Today I'm going to focus on search.

### Setup

Grab yourself a copy of [Net::GitHub]({{<mcpan "Net::GitHub" >}}) (make sure it's version 0.68 or higher). The CPAN Testers [results](http://matrix.cpantesters.org/?dist=Net-GitHub+0.68) show that it builds on all major platforms, including Windows. You can install it via from CPAN at the command line:

```perl
$ cpan Net::GitHub
```

### First steps

First we need to create a search object. You can search GitHub anonymously up to 5 times per minute or if you authenticate, 20 times per minute. The module [documentation]({{<mcpan "Net::GitHub" >}}) shows examples of how to authenticate, so we'll proceed here unauthenticated.

```perl
use Net::GitHub::V3;

# unauthenticated
my $gh = Net::GitHub::V3->new;
my $search = $gh->search;
my %data = $search->repositories({ q => 'docker'});
```

The code above creates a `$search` object, and initiates a repo search for docker. The `%data` hash contains the search results. Let's have a look at them:

```perl
{'incomplete_results' => bless( do{\(my $o = 0)}, 'JSON::XS::Boolean' ),
 'total_count' => 12830,
 'items' => [ {
                   'open_issues_count' => 771,
                   'url' => 'https://api.github.com/repos/docker/docker',
                   'has_downloads' => bless( do{\(my $o = 1)}, 'JSON::XS::Boolean' ),
                   'tags_url' => 'https://api.github.com/repos/docker/docker/tags',
                   'forks_count' => 2794,
                   'has_issues' => $VAR1->{'items'}[0]{'has_downloads'},
                   'clone_url' => 'https://github.com/docker/docker.git',
                   'name' => 'docker',
                   'private' => $VAR1->{'incomplete_results'},
                   'watchers_count' => 14846,
                   'pushed_at' => '2014-09-05T00:32:46Z',
                   'description' => 'Docker - the open-source application container engine',
                   'updated_at' => '2014-09-04T21:59:25Z',
                   'html_url' => 'https://github.com/docker/docker',
                   'stargazers_count' => 14846,
                   'size' => 135198,
                   'watchers' => 14846,
                   'created_at' => '2013-01-18T18:10:
                   'open_issues' => 771,
                   'language' => 'Go',
                   'git_url' => 'git://github.com/docker/docker.
                   'full_name' => 'docker/docker',
                   'homepage' => 'http://www.docker.com',
                   'forks' => 2794,
                   'score' => '89.950935',
                    ...
                   },
            ]
};
```

I've truncated the results for the sake of brevity, to show the top level key values and one simplified repo:

-   `incomplete_results` is a key value pair that returns a boolean true if the are more search results than those returned by the search
-   `total_count` shows the total number of repos returned by the search
-   `items` is the interesting one - it's an arrayref of repo hashes

### Getting more results

Let's update the code to pull more results. GitHub permits up to 100 results per API call and a 1,000 results per search.

```perl
use Net::GitHub::V3;

my $gh = Net::GitHub::V3->new;
my $search = $gh->search;

my @data = @{ $search->repositories({ q => 'docker',
                                      per_page => 100 })->{items} };

while ($search->has_next_page) {
    sleep 12; # 5 queries max per minute
    push @data, @{ $search->next_page->{items} };
}
```

The code above executes the same search as before, except now I'm passing the `per_page` parameter to get 100 results per call. I also extract the `items` arrayref directly into the `@data` array. The while loop will continue to call the search API until no further results are returned or we hit the 1,000 result limit.

### Analyzing the data

So now we have a full set of results in , what can we do with it? One analysis that could be interesting is a count by programming language. Every repo hash contains a `language` key value pair, so we can extract and count it. Lets see which language most docker-related repos are written in.

```perl
use Net::GitHub::V3;

my $gh = Net::GitHub::V3->new;
my $search = $gh->search;

my @data = @{ $search->repositories({ q => 'docker+created:>2014-09-01',
                                      per_page => 100 })->{items} };

while ($search->has_next_page) {
    sleep 12; # 5 queries max per minute
    push @data, @{ $search->next_page->{items} };
}

my %languages;

for my $repo (@data) {
    my $language = $repo->{language} ? $repo->{language} : 'Other';
    $languages{ $language }++;
}

for (sort { $languages{$b} <=> $languages{$a} } keys %languages) {
    printf "%10s: %5i\n", $_, $languages{$_};
}
```

Let's walk through this code. First of all, I changed the search argument to limit results to repos created since September 2014 using the `created` qualifier. This was to ensure we didn't hit the 1,000 result search limit. The GitHub search API supports a whole range of useful [search qualifiers](https://developer.github.com/v3/search/#parameters) (although it's not documented, `created` will take a full timestamp like `2014-09-01T00:00:00Z`).

Next I declared the `%languages` hash and iterated through the results, extracting each repo's language. Where language was `undef`, I labelled the repo "Other". Finally I sorted the results and printed them using [printf]({{< perlfunc "printf" >}})to get a nicely formatted output. Here are the results:

```perl
     Shell:   238
     Other:    58
    Python:    13
      Ruby:    10
JavaScript:     8
        Go:     6
      Perl:     2
       PHP:     2
   Clojure:     1
      Java:     1
```

Perhaps as is to be expected, the results show shell programs dominating the Docker space in September.

### Further Info

GitHub's search API supports more than just repo search. You can search issues, code and users as well. Check out the official GitHub search API [documentation](https://developer.github.com/v3/search/) for more examples.

[Net::GitHub]({{<mcpan "Net::GitHub" >}}) provides an interface for far more than just search though. It's a full-featured API - you can literally manage your GitHub account via Perl code with Net::GitHub. The developer Fayland Lam has provided loads of documentation, and I found him helpful responsive to enquiries. Thanks Fayland!

If you're looking for more than just search, you may also want to look at Ingy döt Net's awesome [git-hub](https://github.com/ingydotnet/git-hub), which provides the full power of GitHub at the command line.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
