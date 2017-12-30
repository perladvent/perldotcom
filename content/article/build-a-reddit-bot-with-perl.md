{
   "date" : "2015-02-09T13:41:04",
   "tags" : [
      "xml",
      "perl",
      "reddit",
      "rss",
      "feed",
      "atom",
      "bot"
   ],
   "title" : "Build a Reddit bot with Perl",
   "authors" : [
      "david-farrell"
   ],
   "description" : "It's easy and fast to do",
   "thumbnail" : "/images/151/thumb_2E921FA4-B008-11E4-BF49-19CBDA487E9F.jpeg",
   "image" : "/images/151/2E921FA4-B008-11E4-BF49-19CBDA487E9F.jpeg",
   "categories" : "web",
   "draft" : false,
   "slug" : "151/2015/2/9/Build-a-Reddit-bot-with-Perl"
}


One of my goals for this year was to post more links to the Perl [subreddit](http://www.reddit.com/r/perl). I'm usually good at linking to PerlTricks articles, but not so good at linking to other content. And that's a shame because there are a lot of active Perl blogs out there (I know of at least 25-30).

A busier Perl subreddit is good for the community; more links on /r/perl should lead to more visitors, and more activity on the subreddit and so on - a virtuous circle. So I built a bot to automate the posting of links. In this article I'm going to show you how I did it.

### Reddit API

You'll need a Reddit account to use the API. I like to use [Reddit::Client](https://metacpan.org/pod/Reddit::Client) as it works well, has good documentation and maintains a session cache. This is a subroutine for posting links to Reddit:

```perl
use warnings;
use strict;
use Reddit::Client;

sub post_reddit_link
{
    my ($title, $url, $subreddit) = @_; 

    my $reddit       = Reddit::Client->new(
        session_file => 'logs/session_data.json',
        user_agent   => 'perly_bot/v0.01',
    );  

    unless ( $reddit->is_logged_in ) { 
        $reddit->login( $ENV{REDDIT_USERNAME}, 
                        $ENV{REDDIT_PASSWORD} );
        $reddit->save_session();
    }   
    
    $reddit->submit_link(
            subreddit => $subreddit,
            title     => $title,
            url       => $url
    );
}
```

The code should be fairly self-explanatory. The `post_reddit_link` subroutine accepts three parameters: the subreddit to post to, the title of the post, and the URL of the link. It initializes a new Reddit::Client object, passing the path of the session file and the user agent string to use when calling the Reddit API. The session file is just a cache for storing a session cookie.

Next, the subroutine checks if the `$reddit` object has an active session or not, triggering a login request if necessary. I like to store credentials in environment variables: that way the code and any config files can still be hosted on a public repository, without risk of sharing your login details with anyone. The last bit of code calls `submit_link` method to post the link to the Reddit API.

This code will work in ideal scenarios, but what if something goes wrong? For example, Reddit imposes restrictions on the posting of links: the same link cannot be posted twice to the same subreddit, proxy domains are banned and links cannot be posted too frequently. In order to capture the error messages, I'm going to wrap the `submit_link` method in a try/catch block.

```perl
use warnings;
use strict;
use Reddit::Client;
use Try::Tiny;
use Time::Piece;

open my $ERROR_LOG, '>>', 'logs/error.log' or die $!;

sub post_reddit_link
{
    my ($title, $url, $subreddit) = @_; 

    my $reddit       = Reddit::Client->new(
        session_file => 'logs/session_data.json',
        user_agent   => 'perly_bot/v0.01',
    );  

    unless ( $reddit->is_logged_in ) { 
        $reddit->login( $ENV{REDDIT_USERNAME}, 
                        $ENV{REDDIT_PASSWORD} );
        $reddit->save_session();
    }   
    
    try {
        $reddit->submit_link(
            subreddit => $subreddit,
            title     => $title,
            url       => $url
        );
    } catch {
        log_error("Error posting $title $url $_");
    };
}

sub log_error
{
    my $datetime = localtime;
    say $ERROR_LOG $datetime_now->datetime . "\t$_[0]";
}
```

In addition to the try/catch, I've added a `log_error` subroutine which will write error messages to the error log.

### Reading blog feeds

Now I have a subroutine for posting links to Reddit, I need a way to monitor blog feeds and post links to new articles. Most blogs provide feed data via RSS or atom data, for example [blogs.perl.org](http://blogs.perl.org) uses atom. I can monitor this feed using [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny) and [XML::Atom::Client](https://metacpan.org/pod/XML::Atom::Client).

```perl
use XML::Atom::Client;
use HTTP::Tiny;

sub check_feed
{
    my ($url) = @_;

    my $ua = HTTP::Tiny->new;
    my $response = $ua->get($url);
    if ( $response->{success} )
    {
        my $posts = 
          XML::Atom::Feed->new( Stream => \$response->{content} );

        foreach my $post ( $posts->entries )
        {
            post_reddit_link(
                $post->title,
                $post->link->href,
                'perl'
            );
        }
    }
    else
    {
        log_error(
"Error requesting $url. $response->{status} $response->{reason}"
        );
    }
}
```

This code declares a subroutine called `check_feed` which accepts a URL as parameter. It fetches the URL content using HTTP::Tiny, and if successful, loops through every blog post in an atom feed, calling `post_reddit_link` on each post. As it stands, this code is going to cause problems. We only want to post relevant and new content to the Perl subreddit, but this code will post a link for every blog post returned by the feed URL.

To check for relevant content, I can use a regex to match against keywords. If the text contains words like "Perl" or "CPAN", I assume it's Perl related. This is the regex:

```perl
#  must contain a Perl keyword to be considered relevant
my $looks_perly = qr/\b(?:perl|cpan|cpanminus|moose|metacpan|modules?)\b/i;
```

To filter out stale content, I need to set a threshold for how long posts should be considered fresh. I can then subtract the publication date of the blog post from the current datetime to see if the publication date exceeds my threshold or not. I'm going to use 24 hours as my threshold:

```perl
use Time::Piece;
use Time::Seconds;

my $datetime_post = 
  Time::Piece->strptime($post->published, '%Y-%m-%dT%H:%M:%SZ');
my $datetime_now = localtime;

if ( $datetime_post > $datetime_now - ONE_DAY )
{
   ...
}
```

This code uses the `strptime` function in Time::Piece to extract the publication datetime of the post. It then compares the datetime of the post with the current datetime minus 24 hours ("ONE\_DAY" is a constant for 24 hours that is exported by Time::Seconds).

### Wrap up

Putting it all together, the code looks like this:

```perl
use warnings;
use strict;
use Reddit::Client;
use Try::Tiny;
use Time::Piece;
use Time::Seconds;
use XML::Atom::Client;
use HTTP::Tiny;

open my $ERROR_LOG, '>>', 'logs/error.log' or die $!;

#  must contain a Perl keyword to be considered relevant
my $looks_perly = qr/\b(?:perl|cpan|cpanminus|moose|metacpan|modules?)\b/i;

# post links for new posts on blogs.perl.org
check_feed('http://blogs.perl.org/atom.xml');

sub post_reddit_link
{
    my ($title, $url, $subreddit) = @_;

    my $reddit       = Reddit::Client->new(
        session_file => 'logs/session_data.json',
        user_agent   => 'perly_bot/v0.01',
    );

    unless ( $reddit->is_logged_in ) {
        $reddit->login( $ENV{REDDIT_USERNAME},
                        $ENV{REDDIT_PASSWORD} );
        $reddit->save_session();
    }

    try {
        $reddit->submit_link(
            subreddit => $subreddit,
            title     => $title,
            url       => $url
        );
    } catch {
        log_error("Error posting $title $url $_");
    };
}

sub log_error
{
    my $datetime = localtime;
    say $ERROR_LOG $datetime->datetime . "\t$_[0]";
}

sub check_feed
{
    my ($url) = @_;

    my $ua = HTTP::Tiny->new;
    my $response = $ua->get($url);

    if ( $response->{success} )
    {
        my $posts =
          XML::Atom::Feed->new( Stream => \$response->{content} );

        foreach my $post ( $posts->entries )
        {
            my $datetime_post =
              Time::Piece->strptime($post->published, '%Y-%m-%dT%H:%M:%SZ');
            my $datetime_now = localtime;

            # if fresh post and contains Perl keyword
            if (   $datetime_post > $datetime_now - ONE_DAY
                && $post->summary =~ $looks_perly)
            {
                post_reddit_link(
                    $post->title,
                    $post->link->href,
                    'perl'
                );
            }
        }
    }
    else
    {
        log_error(
"Error requesting $url. $response->{status} $response->{reason}"
        );
    }
}
```

When run, this script will check blogs.perl.org for new posts, and submit them to /r/perl.

There's a lot more that could be done with this script: for instance it only supports atom feeds, but many blog feeds use RSS. The URLs to check must be hard coded into the script - it would be better to take them from a configurable list. Finally, there is no URL caching, so running this script twice in 24 hours will lead to it attempting to post the same links to Reddit twice. For an extended example that addresses these issues and more, check out my Perly-Bot GitHub [repo](https://github.com/dnmfarrell/Perly-Bot).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
