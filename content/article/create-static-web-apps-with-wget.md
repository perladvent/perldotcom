{
   "image" : "/images/103/998C1D22-1144-11E4-80EC-0DC15E2B53EB.png",
   "slug" : "103/2014/7/22/Create-static-web-apps-with-Wget",
   "date" : "2014-07-22T12:44:13",
   "title" : "Create static web apps with Wget",
   "tags" : [
      "app",
      "mvc",
      "static",
      "perl",
      "framework",
      "wget",
      "recursive",
      "recursion",
      "webapp"
   ],
   "authors" : [
      "david-farrell"
   ],
   "description" : "An alternative to Wallflower",
   "draft" : false,
   "categories" : "apps"
}


*Last week we covered [Wallflower](https://metacpan.org/pod/distribution/App-Wallflower/bin/wallflower) an awesome utility for generating static websites from Perl web applications. This week we're covering an alternative method, that uses [Wget](https://en.wikipedia.org/wiki/Wget). One benefit of this method is it can be used on any dynamic web application, not just Perl ones.*

### Requirements

You'll need Wget installed - if you're using Linux it should already be installed. OSX users can install it with [Homebrew](http://brew.sh/) and there is a Windows [version](http://gnuwin32.sourceforge.net/packages/wget.htm) available. To follow this example you'll also need Dancer2 installed, which you can get via cpan:

``` prettyprint
$ cpan Dancer2
```

### Create the application

We'll use Dancer2 to create a basic skeleton app:

``` prettyprint
$ dancer2 -a MyApp
+ MyApp
+ MyApp/config.yml
+ MyApp/MANIFEST.SKIP
+ MyApp/Makefile.PL
+ MyApp/views
+ MyApp/views/index.tt
+ MyApp/views/layouts
+ MyApp/views/layouts/main.tt
+ MyApp/t
+ MyApp/t/002_index_route.t
+ MyApp/t/001_base.t
+ MyApp/bin
+ MyApp/bin/app.pl
+ MyApp/lib
+ MyApp/lib/MyApp.pm
+ MyApp/environments
+ MyApp/environments/production.yml
+ MyApp/environments/development.yml
+ MyApp/public
+ MyApp/public/500.html
+ MyApp/public/404.html
+ MyApp/public/favicon.ico
+ MyApp/public/dispatch.cgi
+ MyApp/public/dispatch.fcgi
+ MyApp/public/css
+ MyApp/public/css/error.css
+ MyApp/public/css/style.css
+ MyApp/public/javascripts
+ MyApp/public/javascripts/jquery.js
+ MyApp/public/images
+ MyApp/public/images/perldancer.jpg
+ MyApp/public/images/perldancer-bg.jpg
```

Lets start the app:

``` prettyprint
$ ./MyApp/bin/app.pl
>> Dancer2 v0.143000 server 435 listening on http://0.0.0.0:3000
```

### Create the static site

We'll point Wget at the site in recursive mode, so that it pulls all the files we need (up to a depth of 5 by default).

``` prettyprint
$ wget -r 0:3000 -d 0:3000 --page-requisites
```

Here we pass Wget the following options:

-   "-r 0:3000" to recursively follow links from 0:3000
-   -"d 0:3000" to only save static files from the local domain
-   "--page-requisites" to pull all required files for a page, even if beyond our depth limit

By default Wget will create a directory named after the domain ("0:3000") and place all static files there. And that's it, all the files for our static site have been generated.

### Wget vs Wallflower

So if both apps can generate static sites, which one is better? If you're working with a non-Perl site, then Wget is obviously the way to go. In terms of speed, Wget is faster if you combine the command with xargs and request the urls in parallel:

``` prettyprint
$ cat urls.txt | xargs -P16 wget -i
```

To take advantage of the parallel GET requests, you'll need to serve the application on a web server though.

Wallflower has nice option ("-F") to take a list of URLs to download, which can be useful if the entire site cannot be downloaded by following links from the root application page. [App::Wallflower](https://metacpan.org/pod/Wallflower) is the source library for Wallflower, and extendible through Perl code, so you can further tailor the process to meet your needs. This can be used for post-processing actions like generating a sitemap.xml or advanced setups like a hybrid application, where the public pages of the site are static, but the secure parts remain dynamic. With Wallflower all of this can be scripted in Perl, with Wget you'd need to a combination of shell scripts and Perl, which is less convenient.

As was recommended in last week's [article](http://perltricks.com/article/102/2014/7/15/Generate-static-websites-from-dynamic-Perl-web-apps#h3Wallflower%20Tips) make sure you're using absolute urls in your template code to avoid deployment issues with your static files.

### Thanks

*Thanks to Steve Schnepp for contacting us with this tip. Thanks to Philippe Bruhat for creating Wallflower and providing additional technical guidance.*

***Correction:** technical comparison of Wallflower and Wget updated following clarification from module author. 2014-08-02*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
