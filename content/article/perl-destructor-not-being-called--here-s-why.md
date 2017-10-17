{
   "title" : "Perl destructor not being called? Here's why",
   "slug" : "38/2013/8/27/Perl-destructor-not-being-called--Here-s-why",
   "image" : null,
   "authors" : [
      "david-farrell"
   ],
   "description" : "If you're using a Perl destructor method ('DESTROY', 'DEMOLISH') it may not be called if the Perl process is terminated abruptly by a signal. To fix this, just add the sigtrap pragma to your program: ",
   "categories" : "development",
   "tags" : [
      "object_oriented",
      "object",
      "signal",
      "sigint",
      "destructor",
      "sigtrap",
      "old_site"
   ],
   "draft" : false,
   "date" : "2013-08-27T02:57:30"
}


If you're using a Perl destructor method ('DESTROY', 'DEMOLISH') it may not be called if the Perl process is terminated abruptly by a signal. To fix this, just add the sigtrap pragma to your program:

``` prettyprint
use sigtrap qw/die normal-signals/;
```

Now if the program receives a SIGINT or SIGTERM, the Perl process will die and call the destructor.

To read more on signal handlers see our article: [Catch and Handle Signals in Perl](http://perltricks.com/article/37/2013/8/18/Catch-and-Handle-Signals-in-Perl)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
