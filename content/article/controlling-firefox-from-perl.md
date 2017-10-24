{
   "date" : "2014-12-08T14:13:27",
   "slug" : "138/2014/12/8/Controlling-Firefox-from-Perl",
   "tags" : [
      "javascript",
      "firefox",
      "mechanize"
   ],
   "image" : "/images/138/589C58AA-7EE4-11E4-9429-0240B3613736.png",
   "authors" : [
      "brian-d-foy"
   ],
   "title" : "Controlling Firefox from Perl",
   "description" : "Form submission, scraping, JavaScript execution are all possible",
   "categories" : "web",
   "draft" : false
}


I've been playing with [WWW::Mechanize::Firefox](http://www.metacpan.org/module/WWW::Mechanize::Firefox). It's like the LWP-backended [WWW::Mechanize](http://www.metacpan.org/module/WWW::Mechanize), but with a browser doing all the work. Instead of doing it all in Perl, I can use it as the glue language that it is.

Sometimes [WWW::Mechanize](http://www.metacpan.org/module/WWW::Mechanize), [LWP::UserAgent](http://www.metacpan.org/module/LWP::UserAgent), or [Mojo::UserAgent](http://www.metacpan.org/module/Mojo::UserAgent) aren't enough. For basic web scraping and automation they work well, but fail miserably for anything that requires JavaScript. Some people have luck with SpiderMonkey ([with several Perl interfaces](https://metacpan.org/search?q=spidermonkey&)), but that still isn't the whole browser environment.

Before you start, you need the [Firefox](https://www.mozilla.org) browser (or one of its forks) with the [MozRepl](https://addons.mozilla.org/en-us/firefox/addon/mozrepl/) add-on, which provides an interactive JavaScript console that you can telnet into. Once activated, you can connect to the console and can control the browser.

[![activate\_mozrepl](https://farm8.staticflickr.com/7503/15324164413_0a43aeb932.jpg)](https://farm8.staticflickr.com/7503/15324164413_0a43aeb932.jpg "activate_mozrepl by brian d foy, on Flickr")

I have to know JavaScript to control Firefox directly. I can telnet into the MozRepl server and issue commands. It's a bit more work than I'd like to do.

[![mozrepl\_telnet](https://farm9.staticflickr.com/8680/15941835341_f064e9e2a3.jpg)](https://farm9.staticflickr.com/8680/15941835341_f064e9e2a3.jpg "mozrepl_telnet by brian d foy, on Flickr")

I'm not going to control Firefox directly, though, because I'm going to let some Perl modules do that for me. The basic interface of [WWW::Mechanize::Firefox](http://www.metacpan.org/module/WWW::Mechanize::Firefox) is the same as [WWW::Mechanize](http://www.metacpan.org/module/WWW::Mechanize):

``` prettyprint
#!/usr/local/perls/perl-5.20.0/bin/perl
use v5.10;
use WWW::Mechanize::Firefox;

my $mech = WWW::Mechanize::Firefox->new;
$mech->autoclose_tab( 0 );

$mech->get( 'http://www.perltricks.com' );

foreach my $link ( $mech->links ) {
    state $count = 0;
    say $count++, ": ", $link->url;
    }
```

I get a list of the links on the PerlTricks main page:

    0: http://perltricks.com/favicon.ico
    1: http://perltricks.com/feed/atom
    2: http://perltricks.com/feed/rss
    3: http://perltricks.com/css/bootstrap.min.css
    4: http://perltricks.com/css/carousel.css
    5: http://perltricks.com/css/perltricks.css
    6: https://twitter.com/intent/follow?screen_name=perltricks
    7: http://perltricks.com/feed/rss
    ...

That's not even the good part yet.

### Executing JavaScript

Since I'm connected to a JavaScript terminal, I can evaluate JavaScript code. The `eval` returns the result and its type:

``` prettyprint
use v5.10;
use WWW::Mechanize::Firefox;

my $mech = WWW::Mechanize::Firefox->new;
$mech->autoclose_tab( 0 );

my( $result, $type ) = $mech->eval( '2+2' );

say "2+2 is $result (type $type)";
```

    2+2 is 4 (type number)

That evaluates the JavaScript in its own context, which isn't that interesting for me. I want to interact and control parts of a web page. To do that, I use the `eval_in_page`. That runs the JavaScript with everything else going on in the current tab, including all the JavaScript code it has loaded. Here's an example that uses the StackExchange JavaScript to change the view from the desktop mode to the mobile mode:

``` prettyprint
use v5.10;
use WWW::Mechanize::Firefox;

my $mech = WWW::Mechanize::Firefox->new;
$mech->autoclose_tab( 0 );

$mech->get( 'http://www.stackoverflow.com/' );
sleep 5;
$mech->eval_in_page( 'StackExchange.switchMobile("on")' );
```

When I run this, the screen changes from the full site to the mobile site.

[![screenshots](https://farm9.staticflickr.com/8640/15943126852_07692bfc09.jpg)](https://farm9.staticflickr.com/8640/15943126852_07692bfc09.jpg "screenshots by brian d foy, on Flickr")

### Some problems

This approach has some problem though, almost none of which come from Perl. If I want to automate something that makes many requests or runs for a long time, Firefox is likely to have problems. Over time, [it's memory footprint grows](https://support.mozilla.org/en-US/kb/firefox-uses-too-much-memory-ram), leading to poor performance and crashes. Sometimes the connection to the console breaks, taking down my program with it.

Because of this, I limit my use of [WWW::Mechanize::Firefox](http://www.metacpan.org/module/WWW::Mechanize::Firefox) to the parts of my problem that require JavaScript. I can extract the information I need then use [Mojo::UserAgent](http://www.metacpan.org/module/Mojo::UserAgent) to handle the other parts.

### Similar solutions

The [WWW::Mechanize::Firefox](http://www.metacpan.org/module/WWW::Mechanize::Firefox) isn't the only way to do this sort of thing. [Rob Hammond posted on blogs.perl.org about PhantomJS](http://blogs.perl.org/users/robhammond/2013/02/web-scraping-with-perl-phantomjs.html), which received some comments about [WWW::WebKit](http://www.metacpan.org/module/WWW::WebKit). There used to be a Win32::IE::Mechanize, but apparently it [doesn't work in IE 8](http://www.perlmonks.org/?node_id=1061372). [Selenium](http://www.seleniumhq.org) and [Test::WWW::Selenium](http://www.metacpan.org/module/Test::WWW::Selenium) is another tool that I could use, but that's more geared to browser acceptance testing and replays.

*Join the discussion on the Perl [subreddit](http://www.reddit.com/r/perl/comments/2onaz4/controlling_firefox_from_perl_by_brian_d_foy/) about this article!*

**Update:** *last paragraph updated to include Selenium reference. 2014-12-09*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
