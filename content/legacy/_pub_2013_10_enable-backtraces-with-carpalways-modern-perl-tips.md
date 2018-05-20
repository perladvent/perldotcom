{
   "description" : "Ever had a program crash and wanted to get more details about where and why? The CPAN module Carp::Always is perfect for this.",
   "title" : "Enable Backtraces with Carp::Always (Modern Perl Tips)",
   "image" : null,
   "tags" : [],
   "slug" : "/pub/2013/10/enable-backtraces-with-carpalways-modern-perl-tips.html",
   "authors" : [
      "chromatic"
   ],
   "draft" : null,
   "thumbnail" : null,
   "categories" : "development",
   "date" : "2013-10-28T06:00:01-08:00"
}



Suppose you're working on a large application in Perl. Your code is in multiple files with multiple packages, and you've built your application in layers. You have a data storage layer, a framework to manage control flow, a layer for business rules, and at least one form of user interface.

Imagine someone discovers a bug. When a user attempts to log in but mistypes her email address—using a comma instead of dot, for example—the web site crashes. She sees a nearly empty "500 Server Error" page instead of the attractive error pages the designer created and the logs show only that *something* went wrong. Your custom error handler didn't even get called.

If that sounds familiar, you may have had a week like I did.

Back when Perl and Java seemed like two poles of the professional software development axis, we Perl programmers often teased Java programmers about Java's propensity to emit page long backtraces whenever anything somewhere went wrong. Over a decade later, my views have grown to include a little more nuance. The problem isn't backtraces *per se*; the problem is Java's call stacks are so deep and the stack traces so verbose that real problems may be obscured in irrelevant details.

Perl code sometimes goes too far the other direction. It makes sense to use [Carp](https://metacpan.org/pod/Carp)'s `carp()` to warn about the dubious use of code in libraries from the point of view of the caller, but modern Perl applications tend to grow beyond a single program calling to a few libraries. Our libraries depend on other libraries and something can go wrong in one layer but only produce an error in another layer. Sometimes it's nice to have the option to enable verbose backtraces for warnings and errors only temporarily, during debugging, without modifying any of your code.

That's what [Carp::Always](https://metacpan.org/pod/Carp::Always) does. If you can reproduce the error in a test case (whether a formal test script or a small, standalone program), launch the program with the command line option `-MCarp::Always` to get a verbose backtrace on warnings or errors.

(The `-M` flag tells `perl` to load a named module, just as if you'd written `use Carp::Always;` in your program.)

For bonus debugging powers, I like to use command lines of the form:

    $ perl -MCarp::Always my_test_case.pl 2> log; less log; rm log

... so that the backtrace goes to the `less` pager, where I can scroll up and down and search. When I quit the pager, the temporary file goes away so it doesn't clutter up my directory.

By tracking all control flow to the point of the error, I found the problem more quickly. You can, of course, solve this problem in multiple ways, including attaching a debugger to a running process, but when that's not an option and when you can reproduce the exception or warning in a small test file, forcing a full backtrace can be very helpful.

*chromatic is the author of [Modern Perl: the book](http://modernperlbooks.com/books/modern_perl/). His non-programming hobbies include gradually curating a list of [smoothie](https://blenderrecipereviews.com/recipes/smoothies/how-to-make-a-smoothie) recipes and [value investing](https://trendshare.org/how-to-invest/).*
