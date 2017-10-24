{
   "tags" : [
      "cache",
      "reddit",
      "storable",
      "humor"
   ],
   "authors" : [
      "david-farrell"
   ],
   "slug" : "171/2015/5/4/Cache--Reddit-or--how-to-use-social-media-as-a-temporary-data-store",
   "title" : "Cache::Reddit or: how to use social media as a temporary data store",
   "categories" : "web",
   "image" : "/images/171/2E921FA4-B008-11E4-BF49-19CBDA487E9F.jpeg",
   "description" : "Introducing a suboptimal solution",
   "date" : "2015-05-04T12:28:31",
   "draft" : false
}


Sometimes crazy ideas are brilliant, but most of the time they are just crazy. I recently uploaded a new module to CPAN: [Cache::Reddit](https://metacpan.org/pod/Cache::Reddit). It's a caching module with a twist: it saves cached data as text posts on Reddit. Is that a good idea? Probably not, it's definitely crazy.

### Setup

You probably don't want to do this, but if you were considering using the module, here's how. First you'll need a Reddit account with enough karma to use the API (usually handful of upvoted links and comments is enough). Second you should create your own [subreddit](http://www.reddit.com/subreddits/create/) to post to. Install [Cache::Reddit](https://metacpan.org/pod/Cache::Reddit) using the command line clients cpan or cpanm

``` prettyprint
$ cpan Cache::Reddit
```

Or:

``` prettyprint
$ cpanm Cache::Reddit
```

Finally set the environment variables: `reddit_username`, `reddit_password`, and `reddit_subreddit` (the name of the subreddit that data will be posted to). On Linux / OSX you can do this at the terminal:

``` prettyprint
$ export reddit_username=somename
$ export reddit_password=itsasecret
$ export reddit_subreddit=mycache
```

To set environment variables on Windows 8, these [steps](http://winaero.com/blog/how-to-edit-environment-variables-quickly-in-windows-8-1-and-windows-8/) might work.

### Using Cache::Reddit

The module exports the typical caching functions you'd expect: `set` for saving data, `get` for retrieval and `remove` for removal. For example:

``` prettyprint
use Cache::Reddit; #exports get, set, remove

my $monthly_revenues = { jan => 25000, feb => 23500, mar => 31000, apr => 15000 };
my $key = set($monthly_revenues); # serialize and save on reddit
...
my $revenue_data = get($key);
remove($key);
```

### Limitations

Although the data is stored in a failsafe, redundant, backed-up environment in the cloud, frequent users of Reddit will appreciate that the service is likely to unavailable for a few seconds multiple times a day.

Retrieval from the cache using `get` doesn't use a hash lookup; instead Cache::Reddit iterates through all available posts on the subreddit until it finds a match. This yields 0(n) performance, which means that the `get` function will get slower the more items are cached. This is not likely to be a performance bottleneck though, as typically a subreddit only holds 1,000 links before they are lost to the ether.

The data is serialized and deserialized using [Storable](https://metacpan.org/pod/Storable), which may open pose a security risk if the cached data is edited by a mod. Up to 40,000 characters of data can be stored at one time. Unless the subreddit permits both links and text posts, in which case the limit is 10,000 characters. But Cache::Reddit does boast 100% test coverage.

### Looking forwards

In the future I'd like to take advantage of Reddit's voting system to implement a crude [LRU](https://en.wikipedia.org/wiki/Least_Recently_Used#LRU) cache. Comments could prove to be a powerful version control system. Patches welcome, the source code is on Instagram.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
