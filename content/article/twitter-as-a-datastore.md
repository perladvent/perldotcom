{
   "description" : "Using social media platforms for computing applications",
   "image" : "/images/210/B6ABE53E-C045-11E5-B2C3-641B7A54B0AF.png",
   "authors" : [
      "brian-d-foy"
   ],
   "categories" : "web",
   "tags" : [
      "math",
      "social_media",
      "net_twitter"
   ],
   "date" : "2016-01-21T13:52:14",
   "title" : "Twitter as a datastore",
   "draft" : false,
   "slug" : "210/2016/1/21/Twitter-as-a-datastore"
}


Why doesn't anyone talk about Twitter as a data store? It's a free account, they mostly have uptime, and you can easily control who can see the information. If you can do it in 140 characters (and [soon to be 10,000](http://www.theverge.com/2015/8/12/9134175/twitter-direct-message-character-limit)), it's an easy way to store data.

[Tweets by @excellent\_nums](https://twitter.com/excellent_nums)

I'm doing this for my [excellent numbers project](http://www.excellentnums.com) that does quite a bit of computing to find numbers with a particular property. This isn't the only way I'm storing the numbers, but I had the idea of tweeting them as soon as I found them in case every other method failed. If I accidentally deleted the output files (did that), truncated and overwrote files (did that), or somehow screwed it up in another way (did that), the numbers are still on Twitter.

I had another compelling reason, though. I wanted to get an alert on my phone when my program found another excellent number. Unfortunately, I've hitched my wagon to the iPhone. There are all sorts of complicated ways for me to get an alert but I already use Twitter and get alerts for that. So, I can have a backup store and an alert system using stuff I already have installed. I can spend more time on the math and less time on installing and managing Redis (which is easy too and deserves an article here) then coming up with a way to send new entries to my phone.

I wrote about my setup in nonspecific terms in [Mastering Perl](http://www.masteringperl.org/2015/12/ive-found-over-200-excellent-numbers/). I didn't show any code, although it's all in [the excellent\_numbers GitHub repository](https://github.com/briandfoy/excellent_numbers).

Before you start, you need some Twitter credentials to use their API through the [Net::Twitter](https://metacpan.org/pod/Net::Twitter) module. Start at [Twitter Application Management](http://apps.twitter.com) to get the four special strings you'll need (["How to Register a Twitter App in 8 Easy Steps" has a good description of the steps](http://iag.me/socialmedia/how-to-create-a-twitter-app-in-8-easy-steps/):

Consumer Key (API Key)  

Consumer Secret (API Secret)  

Access Token  

Access Token Secret  

The Net::Twitter module needs these strings to create its object. The module handles all of the OAuth details without me having to think about them:

```perl
use Net::Twitter;

my $nt = Net::Twitter->new(
   traits   => [qw/OAuth API::RESTv1_1/],
   map { $_ => $ENV{"$_"} || die "ENV $_ not set" }
           qw(     
                consumer_secret
                consumer_key
                access_token
                access_token_secret
                )
   );
```

In my excellent number program, I wanted to be as simple as possible. I didn't want to re-tweet numbers I already tweeted so I fetched everything I've tweeted so far and stored it in a hash. Twitter pages in groups of 200 tweets maximum, and this didn't seem like it would be a problem a couple of months ago but I'm now up to over 350 of them.

It's easy to fetch a bunch of statuses with the `user_timeline` method. I need to tell it where to start (`min_id` or `since_id`). Twitter returns huge JSON structures with lots of information, but Net::Twitter turns that into a Perl data structure for me. I dump what they send and pull out the parts I want:

```perl
my %tweets;
STATUSES: while( 1 ) {
  state $min_id = 1;
  state $fetch_size = 200;

  my $max_key = $min_id == 1 ? 'since_id' : 'max_id';

  my $statuses = $nt->user_timeline({
          count       => $fetch_size,
          screen_name => 'excellent_nums',
          $max_key    => $min_id,
          });     

  say { interactive } "Found " . @$statuses . " statuses";
  $min_id = $statuses->[-1]{id} - 1 if $min_id == 1;

  foreach my $status ( @$statuses ) {
          $min_id = $status->{id} - 1 if $min_id > $status->{id};
          my( $number ) = $status->{text} =~ m/(\d+)/;
          warn "[$number] has more than one tweet!\n" if exists $tweets{$number};
          $tweets{$number} = undef;
          unless( is_excellent( $number ) ) {
                  warn "Tweet for [$number] is an unexcellent error\n";
                  }       
          }       

  last if @$statuses < $fetch_size; # must be last page
  }
```

This part is complicated for another reason. At the start of the project I was generating the excellent numbers sequentially. When that's the case I only needed to look at the previous tweet to see if it was less than the number I just discovered. When I got to the big numbers, I went wide and worked on different parts of the range in parallel and sometimes on several computers simultaneously. I started to discover the numbers out of order and tweet them out of order. Hence, the paging. I could store the list of tweeted numbers locally, but that's a hassle to manage too since that can be out of sync. I still might do that when this method runs out of steam. I'm not likely to get far beyond 500 numbers though.

Notice that I also `warn` if I run into a tweet with a number that I think is a duplicate:

```perl
warn "[$number] has more than one tweet!\n" if exists $tweets{$number};
```

If this was a bigger problem (and it's not anymore), I could use the `destroy_status` method to automatically get rid of it:

```perl
$nt->destroy_status( $status->{id} ) if exists $tweets{$number};
```

I decided not to delete automatically from the program. It's not a problem to have duplicates. It's a bit messy, but it's more messy to delete stuff I want to keep and to retweet it. That risk makes it not worth it for me. I don't want another possible automated mess to clean up.

Now I know everything I've tweeted previously and I've put them in `%tweets`. The next part is to tweet what I've found and haven't stored yet. I also store that in a local file (but remember I want the alerts and the backup!) that I used to populate `%numbers`. I skip the numbers I already tweeted and use `update` to make the new tweets. Storing new numbers is easy, and when I do it I want to tweet the new numbers in ascending order:

```perl
NUMBER: foreach my $number ( sort { $a <=> $b } keys %numbers ) {
  next NUMBER if exists $tweets{$number};

  $nt->update( "$number is excellent" );
  }
```

This used to be part of the program that found the excellent numbers, but I switched to C for a huge performance bump. I still wanted to tweet from Perl, which is easy. Perl's become the glue holding together lots of different things.

Once I can read from, post to, and delete from twitter, other applications (or even real people) can follow it. It can be public or private. It's not sophisticated. It's uptime isn't going to win any awards. But it's free and easy for my small task.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
