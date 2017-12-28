{
   "image" : "/images/154/91EE4478-B617-11E4-A56B-890CDB487E9F.png",
   "date" : "2015-02-23T14:12:06",
   "title" : "Build a Twitter bot with Perl",
   "categories" : "web",
   "slug" : "154/2015/2/23/Build-a-Twitter-bot-with-Perl",
   "description" : "Automating tweets can win you more followers!",
   "draft" : false,
   "tags" : [
      "perl",
      "reddit",
      "bot",
      "twitter",
      "automation",
      "tweet"
   ],
   "authors" : [
      "david-farrell"
   ]
}


Following on from last week's Reddit bot [article](http://perltricks.com/article/151/2015/2/9/Build-a-Reddit-bot-with-Perl), let's look at how to build a Twitter bot using Perl. As you'd expect, Perl makes it easy to do, but before we get to the code, let's talk about advantages.

Adding tweet automation to an existing app can bring several benefits. Firstly it's a time saver, allowing you to focus on other higher-value activities. Automation provides protection from manual transcription errors like misspelled words and broken urls. Automation also means it's cheaper to increase your tweet volume and all else being equal, a higher tweet volume will lead to more Twitter followers. Sound good? Excellent, let's get to the code then!

### Writing tweets

The core code for writing tweets is very simple. I'm using the [Net::Twitter::Lite](https://metacpan.org/pod/Net::Twitter::Lite) distribution, which supports the latest version of the Twitter [API](https://dev.twitter.com/rest/public).

```perl
use strict;
use warnings;
use Net::Twitter::Lite::WithAPIv1_1;

sub tweet
{
  my ($text) = @_;

  my $twitter = Net::Twitter::Lite::WithAPIv1_1->new(
    access_token_secret => $ENV{TWITTER_ACCESS_SECRET},
    consumer_secret     => $ENV{TWITTER_CONSUMER_SECRET},
    access_token        => $ENV{TWITTER_ACCESS_TOKEN},
    consumer_key        => $ENV{TWITTER_CONSUMER_KEY},
    user_agent          => 'TwitterBotExample',
    ssl => 1,
  );
  $twitter->update($text);
}
```

The code imports `Net::Twitter::Lite::WithAPIv1_1` to use the new Twitter API. The subroutine `tweet` takes some text as an argument. It then creates a new `Net::Twitter::Lite::WithAPIv1_1` object, using environment vars as credentials. If you don't have these credentials already, it's free to register an application for your own Twitter account and [generate the tokens](https://dev.twitter.com/oauth/overview/application-owner-access-tokens). Finally the subroutine calls the `update` method to tweet the text.

Now I can send one tweet by adding this line to my code:

```perl
tweet("This is a computer speaking!");
```

### Safety first

So far so good huh? However this code isn't very safe. What if `$text` is not provided as an argument, or our environment variables are not declared, or the call to Twitter fails? I'll add some checks to handle these scenarios:

```perl
use strict;
use warnings;
use Net::Twitter::Lite::WithAPIv1_1;
use Try::Tiny;

sub tweet
{
  my ($text) = @_;

  die 'tweet requires text as an argument' unless $text;

  unless ($ENV{TWITTER_CONSUMER_KEY}
          && $ENV{TWITTER_CONSUMER_SECRET}
          && $ENV{TWITTER_ACCESS_TOKEN}
          && $ENV{TWITTER_ACCESS_SECRET})
  {
    die 'Required Twitter Env vars are not all defined';
  }

  try
  {
    my $twitter = Net::Twitter::Lite::WithAPIv1_1->new(
      access_token_secret => $ENV{TWITTER_ACCESS_SECRET},
      consumer_secret     => $ENV{TWITTER_CONSUMER_SECRET},
      access_token        => $ENV{TWITTER_ACCESS_TOKEN},
      consumer_key        => $ENV{TWITTER_CONSUMER_KEY},
      user_agent          => 'TwitterBotExample',
      ssl => 1,
    );
    $twitter->update($text);
  }
  catch
  {
    die join(' ', "Error tweeting $text",
                   $_->code, $_->message, $_->error);
  };
}
```

This code is largely the same as before, except now it checks for the required variables before processing. The code also imports [Try::Tiny](https://metacpan.org/pod/Try::Tiny) as I added a try/catch block around the twitter code. The catch block will activate if the Twitter interaction throws an exception. Because Net::Twitter::Lite throws structured exceptions, the catch block builds an exception string by extracting information from the structured exception, then calls `die` itself.

You might be wondering if it's necessary to call `die` at all. Can't we just return `undef` instead and keep our code running? The advantage of calling `die` is that the caller of the `tweet` subroutine is better placed to decide how to handle the issue, and so we defer that decision to them. If the calling code doesn't handle `die` correctly, we know the program will exit. But if we returned `undef`, we would have no such assurances. This doesn't mean however that the code *has* to exit. Let's assume I had hundreds of tweets to send out, maybe I just want to log the error somewhere and keep going:

```perl
foreach my $text (@tweet_texts)
{
  try
  {
    tweet($text);
  }
  catch
  {
    log_error($_);
  };
}
```

If I was printing a sequence of tweets, where ordering is important, I could still log the error but then call `die` to exit the program:

```perl
foreach my $text (@sequence_of_texts)
{
  try
  {
    tweet($text);
  }
  catch
  {
    log_error($_);
    die $_; # exit the program
  };
}
```

### Better text handling

So now the code is safer, how else can it be improved? One famous restriction is that a tweet cannot be longer than 140 characters. Right now if the `tweet()` subroutine received a text string longer than 140 characters, the Twitter API would reject it, raise and exception and the code would die. I think we can do better than that.

When I think about the contents of tweets that I send, I'm usually tweeting links to articles about Perl. Invariably they will include some text, a url and a hashtag. It's useful to break these out into separate arguments to `tweet()` because to make everything fit, you could truncate the text, but you wouldn't want to truncate a url or hashtag as it might change the meaning and/or break the url.

```perl
use strict;
use warnings;
use Net::Twitter::Lite::WithAPIv1_1;
use Try::Tiny;

sub tweet
{
  my ($text, $url, $hashtag) = @_;

  unless ($text && $url && $hashtag)
  {
    die 'tweet requires text, url and hashtag arguments';
  }

  unless ($ENV{TWITTER_CONSUMER_KEY}
          && $ENV{TWITTER_CONSUMER_SECRET}
          && $ENV{TWITTER_ACCESS_TOKEN}
          && $ENV{TWITTER_ACCESS_SECRET})
  {
    die 'Required Twitter Env vars are not all defined';
  }

  # build tweet, max 140 chars
  my $tweet;
  
  if (length("$text $hashtag") < 118)
  {
    $tweet = "$text $url $hashtag";
  }
  elsif (length($text) < 118)
  {
    $tweet = "$text $url";
  }
  else # shorten text, drop the hashtag
  {
    $tweet = substr($text, 0, 113) . "... " . $url;
  }

  try
  {
    my $twitter = Net::Twitter::Lite::WithAPIv1_1->new(
      access_token_secret => $ENV{TWITTER_ACCESS_SECRET},
      consumer_secret     => $ENV{TWITTER_CONSUMER_SECRET},
      access_token        => $ENV{TWITTER_ACCESS_TOKEN},
      consumer_key        => $ENV{TWITTER_CONSUMER_KEY},
      user_agent          => 'TwitterBotExample',
      ssl => 1,
    );
    $twitter->update($tweet);
  }
  catch
  {
    die join(' ', "Error tweeting $text $url $hashtag",
                   $_->code, $_->message, $_->error);
  };
}
```

Twitter treats urls as having a length of 12 characters. Now the code checks the length of our arguments, truncating `$text` if necessary. The hashtag will be included only if there is enough space.

This code works for me, but you may want to do things a little differently. The Twitter credentials could be stored in a [configuration](http://perltricks.com/article/29/2013/9/17/How-to-Load-YAML-Config-Files) file, instead of environment variables. The `$hashtag` argument could be an arrayref of hashtags, that are incrementally added to the tweet text, instead of a single text string which restricts it to an all-or-nothing basis.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
