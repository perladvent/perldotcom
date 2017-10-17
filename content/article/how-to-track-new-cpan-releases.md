{
   "date" : "2013-07-29T01:11:31",
   "tags" : [
      "community",
      "configuration",
      "cpan",
      "module",
      "subroutine",
      "sysadmin",
      "old_site"
   ],
   "draft" : false,
   "title" : "How to track new CPAN releases",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "cpan",
   "image" : null,
   "slug" : "33/2013/7/29/How-to-track-new-CPAN-releases",
   "description" : "CPAN is a fantastic Perl resource with thousands of modules and new ones being added all the time. But how do you keep track of what's being released? This article describes three techniques for keeping tabs on the latest CPAN releases. "
}


CPAN is a fantastic Perl resource with thousands of modules and new ones being added all the time. But how do you keep track of what's being released? This article describes three techniques for keeping tabs on the latest CPAN releases.

### CPAN.org

The CPAN website's [recent uploads](http://search.cpan.org/recent) page maintains a list of the latest CPAN releases, with links to the module documentation. Additionally it's possible to search the release history using the navigating arrow links at the top of the page.

### CPAN::Recent::Uploads

Chris Williams' [CPAN::Recent::Uploads](https://metacpan.org/module/CPAN::Recent::Uploads) module offers a programmatic interface to track recent CPAN uploads. It provides a "recent" function that accepts two optional arguments: the time from which to view uploads since and the URL of the CPAN mirror to use. By default it will return a list of modules released in the past week on the CPAN mirror "ftp://ftp.funet.fi/pub/CPAN/". The module's [documentation](https://metacpan.org/module/CPAN::Recent::Uploads) also has an example Perl one liner. To see CPAN::Recent::Uploads in action, enter this at the command-line:

``` prettyprint
# print a list of this week's CPAN releases
perl -MCPAN::Recent::Uploads -le "print for CPAN::Recent::Uploads->recent;"
```

### Twitter

The Twitter account [CPAN New Modules](https://twitter.com/cpan_new) tweets every new CPAN release. The author Punytan has also released the source code on [github](https://t.co/K7KnELaYzk).

You can subscribe to the stream by clicking this button: [Follow @cpan\_new](https://twitter.com/cpan_new)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
