{
   "slug" : "/pub/2006/02/09/debug_mod_perl.html",
   "description" : " Because of the added complexity of being inside of the Apache web server, debugging mod_perl applications is often not as straightforward as it is with regular Perl programs or CGIs. Is the problem with your code, Apache, a CPAN...",
   "authors" : [
      "frank-wiles"
   ],
   "draft" : null,
   "tags" : [
      "apache-db",
      "apache-dprof",
      "apache-smallprof",
      "mod-perl"
   ],
   "thumbnail" : "/images/_pub_2006_02_09_debug_mod_perl/111-mod_perl_debug.gif",
   "date" : "2006-02-09T00:00:00-08:00",
   "categories" : "web",
   "image" : null,
   "title" : "Debugging and Profiling mod_perl Applications"
}



Because of the added complexity of being *inside* of the Apache web server, debugging [`mod_perl`](http://perl.apache.org/) applications is often not as straightforward as it is with regular Perl programs or CGIs. Is the problem with your code, Apache, a CPAN module you are using, or within `mod_perl` itself? How do you tell? Sometimes traditional debugging techniques will not give you enough information to find your problem.

Perhaps, instead, you're baffled as to why some code you just wrote is running so slow. You're probably asking yourself, "Isn't this `mod_perl` stuff supposed to improve my code's performance?" Don't worry, slow code happens even to the best of us. How do you profile your code to find the problem?

This article shows how to use the available CPAN modules to debug and profile your `mod_perl` applications.

### Traditional Debugging Methods

The tried-and-true `print` statement is the debugger's best friend. Used wisely this, can be the easiest and fastest way of figuring out what is amiss in your program. Can't figure out why your sales tax subroutine is always off by 14 cents? Add several `print` statements just before, just after, and all around inside of that particular subroutine. Use them to show the value of key variables at each step in the process. You can direct the output straight onto the page in your browser, or if you prefer, into hidden HTML comments. Typically this is all that you need to spot your problems. It's flexible and easy to implement and understand.

Another common approach is to place `die()` and/or `warn()` statements as you trace through your code, isolating the problem. `die()` is especially useful if you do not want your program to continue executing, possibly because the errors will corrupt your otherwise valid testing data. The main benefit of using `warn` over a simple `print` statement is that the output goes instead to the appropriate Apache *error\_log*. This keeps your debugging information out of the user interface and gives you the ability to log and spot errors long after they occurred for the user. Simply `tail` your *error\_log* in another window and you can watch it all day long. If you're into that sort of thing.

For example, if you had some code like:

    sub handler {
        my $r   =   shift;

        # Set content type
        $r->content_type( 'text/html' );

        my $req = Apache2::Request->new($r);

        # Compute sales tax if we are told to do so
        my $tax = 0;
        if( $req->param('compute_sales_tax') ) {
            my $tax = compute_sales_tax($r, $req->param('total_amount');
        }

        # Code to display results to the browser....
    }

... you might find a problem during testing. Your initial search leads you to believe that either the code never calls the `compute_sales_tax()` function or the function always returns zero. You can add some simple debugging statements:

    sub handler {
        my $r   =   shift;

        # Set content type
        $r->content_type( 'text/html' );

        my $req = Apache2::Request->new($r);

        # Compute sales tax if we are told to do so
        my $tax = 0;

        # Debugging statements
        warn("Tax at start '$tax'");
        warn('compute_sales_tax ' . $req->param('compute_sales_tax') );

        if( $req->param('compute_sales_tax') ) {

            # Debugging
            warn("Tax before sub '$tax'");
            my $tax = compute_sales_tax($r, $req->param('total_amount');
            warn("Tax after sub '$tax'");
        }

        warn("Tax after if '$tax'");

        # Code to display results to the browser....
    }

Assuming that the page that directs the user to this code has set `compute_sales_tax` to a `true` value, you will see something similar to:

    Tax at start '0' at line 5
    compute_sales_tax 1 at line 6
    Tax before sub '0' at line 12
    Tax after sub '1.36' at line 14
    Tax after if '0' at line 17

If you read through this, you see that `compute_sales_tax()` is indeed being called, otherwise you would not see the "Tax before/after" `warn` outputs. Directly after the subroutine call you can see that `$tax` holds a suitable value. However, after the `if` block, `$tax` reverts back to zero. Upon closer examination, you might find that the bug is the `my` before the call to `compute_sales_tax()`. This creates a locally scoped variable named `$tax` and does not assign it to the `$tax` variable in the outer block, which causes it to stay zero and makes it seem that `compute_sales_tax()` was never called.

### When to Use `Apache::DB`

Using `print`, `die`, and `warn` statements in your code will help you find and fix 99 percent of the bugs you may run across when building `mod_perl` applications. Too bad there is still that pesky remaining 1 percent that will make you tear your hair out in clumps and wish you had gone into selling insurance instead of programming. Luckily there is [Apache::DB]({{<mcpan "Apache::DB" >}}) to help keep the glare off our collective heads at next year's Perl conference to a minimum.

Sometime, despite all of your attempts to see what is going wrong, you will find yourself in a situation where:

-   Your code causes Apache to segfault and you can't for the life of you figure out why.
-   It appears that your code segfaults inside of a subroutine or method you are calling in a CPAN module you are using.
-   You have more debugging statements than actual code.

You could spend time hacking up your other installed modules, such as those from CPAN, with debugging statements--but this only means you will have to return later and remove all of it. You could take an easier route and debug your `mod_perl` application with a real source debugger.

Using the Perl debugger allows you to see directly into what is happening to your code and data. You can step through your code line by line, as Perl executes it. Because you are following the same *flow*, there is no chance that you are making any bad assumptions. You might even consider it WYSIWYG, albeit without a GUI.

### Using `Apache::DB`

While `Apache::DB` works with both `mod_perl` 1.x and `mod_perl` 2.x, all of the examples in this article use `mod_perl` 2.0. Once you have installed `Apache::DB` from CPAN, using it is fairly simple. It does, however, require that you make a few Apache configuration changes. Assuming you have a `mod_perl` handler installed at `/modperl/` on your system, your configuration needs to resemble this:

    <Location /modperl>
      SetHandler perl-script
      PerlResponseHandler My::Modperl::Handler
      PerlFixupHandler +Apache::DB
    </Location>

You also need to modify either the appropriate `<Perl></Perl>` section or your *startup.pl* file to include:

    use APR::Pool ();
    use Apache::DB ();
    Apache::DB->init();

If you are working in a `mod_perl` 1.0 environment, the only change is that you should not include the `use APR::Pool ();` directive.

Note that you must call `Apache::DB->init();` prior to whatever code you are attempting to debug. To be safe, I always just put it as the very first thing in my *startup.pl*.

Once you have modified your configuration, the last step is to launch your Apache server with the `-X` command-line option. This option tells Apache to launch only one back-end process and to not fork into the background. If you don't use this option, you can't guarantee that your debugger has connected to same Apache child as your browser.

With this Apache daemon tying up your command prompt, simply browse to your application. As you will see, the shell running `httpd` has been replaced with a Perl debugging session. This debugging session is tied directly to your application and browser. If you look at your browser it will appear to hang waiting for a response; this is due to the fact your Apache server is waiting on you to work with the debugger.

Perl's debugger is very similar to other debuggers you may have used. You can step through your code line by line, skip entire subroutines, set break points, and display and/or change the value of variables with it.

It might be useful to read through [`man perldebtut`]({{< perldoc "perldebtut" >}}), a introductory tutorial on using the debugger. For a more complete reference to all of the available commands, see [`man perldebug`]({{< perldoc "perldebug" >}}). This list should be just enough to get you started:

| Command        | Description                                                                                                                                                                                                                                                                                           |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `p expression` | This prints out the value of an expression or variable, just like the `print` directive in Perl.                                                                                                                                                                                                      |
| `x expression` | This evaluates an expression and prettily prints it for you. Use it to make complex data structures readable.                                                                                                                                                                                         |
| `s`            | This tells the debugger to take a single *step*. A step is a single statement. If the next statement is a subroutine, the debugger will treat it as only one statement; you will not be able to step through each statement of that subroutine and the flow will continue without descending into it. |
| `n`            | This tells the debugger to go to the next statement. If the next statement is a subroutine, you will descend into it and be able to step through each line of that subroutine.                                                                                                                        |
| `l line`       | Display a particular line of source code.                                                                                                                                                                                                                                                             |
| `M`            | Display all loaded modules.                                                                                                                                                                                                                                                                           |

### Code Profiling with `Apache::DProf`

[`Apache::DProf`]({{<mcpan "Apache::DProf" >}}) provides the necessary hooks for you to get some coarse profiling information about your code. By coarse, I mean only information on a subroutine level. It will show you the number of times a subroutine is called along with duration information.

Essentially, `Apache::DProf` wraps [`Devel::DProf`]({{<mcpan "Devel::DProf" >}}) for you, making your life much easier. It is *possible* to use `Devel::DProf` by itself, but it assumes that you are running a normal Perl program from the command line and not in a persistent `mod_perl` environment. This isn't optimal, because while you can shoehorn `Devel::DProf` into working, you'll end up profiling all of the code used at server startup when you really only care about the runtime code.

Using `Apache::DProf` is relatively straightforward. All you need to do is include `PerlModule Apache::DProf` in your *httpd.conf* and restart your server.

As an example, here's a small application to profile. This code, while not all that useful, will help illustrate the major differences between these two profiling modules:

    package PerlTest;

    sub handler {
        my $r = shift;

        $r->content_type( 'text/plain' );

        handle_request($r);

        return( Apache2::Const::OK );
    }

    sub handle_request {
        my $r = shift;

        $r->print( "Handling request....\n" );

        cleanup_request($r);

    }

    sub cleanup_request {
        my $r = shift;

        $r->print( "Cleaning up request....\n" );

        sleep(5);     # Take some time in this section
    }

    1;

When you profile a module with `Apache::Dprof`, it will create a directory named *dprof/* in your server's *logs/* directory. Under this directory will be subdirectories named after the PID of each Apache child your server has. This allows you to profile code over a long period of time on a production system to see where your real bottlenecks are. Often, *faking* a typical user session does not truly represent how your users interact with your application and having the real data is beneficial.

After your server has run for a while, you need to stop it and revert your configuration, removing the `PerlModule Apache::DProf` you just inserted. This is due to the fact that `Apache::DProf` does not write its data to disk until the server child ends.

Viewing the profiling data is exactly the same as with `Devel::DProf`. Choose a particular Apache child directory in *$SERVER\_ROOT/logs/dprof/* and run `dprofpp` on the corresponding *tmon.out* file.

After beating on the code sample above for awhile with `ab`, here are the results `Apache::DProf` gave me:

    Total Elapsed Time = 1082.402 Seconds
      User+System Time =        0 Seconds
    Exclusive Times
    %Time ExclSec CumulS #Calls sec/call Csec/c  Name
     0.00   0.004  0.001    687   0.0000 0.0000  RevSys::PerlTest::cleanup_request
     0.00       - -0.000      1        -      -  warnings::import
     0.00       - -0.000      1        -      -  APR::Pool::DESTROY
     0.00       - -0.000      1        -      -  strict::import
     0.00       - -0.000      1        -      -  Apache2::XSLoader::load
     0.00       - -0.000      3        -      -  Apache2::RequestIO::BEGIN
     0.00       - -0.000      2        -      -  RevSys::PerlTest::BEGIN
     0.00       - -0.003    687        -      -  Apache2::RequestRec::content_type
     0.00       - -0.006   1374        -      -  Apache2::RequestRec::print
     0.00       - -0.012    687        -      -  RevSys::PerlTest::handle_request
     0.00       - -0.024    687        -      -  RevSys::PerlTest::handler

As expected, `cleanup_request()` shows the most time used per call. The report also shows stats for the other function calls you would expect as well as the ones that happen *behind the scenes*.

### Code Profiling with `Apache::SmallProf`

While `Apache::DProf` will show you which subroutines use the most system resources, sometimes that is not enough information. [`Apache::SmallProf`]({{<mcpan "Apache::SmallProf" >}}) gives you fine-grained details in a line-by-line profile of your code.

Setup is similar to both of two previous modules. Add into a `<Perl>` section or your *startup.pl* file the code:

    use APR::Pool ();
    use Apache::DB ();
    Apache::DB->init();

You also need to add `PerlFixupHandler Apache::SmallProf` into the `<Directory>` or `<Location>` block that refers to your `mod_perl` code.

Like `Apache::DProf`, `Apache::SmallProf` writes all of the profiling data into *$SERVER\_ROOT/logs/smallprof/*. One interesting difference between `Apache::DProf` and `Apache::SmallProf` is that the latter writes a profile for each module in use. This is helpful because you already know which subroutines are slow and which packages they are in, from your first round of profiling with `Apache::DProf`. By focusing on those modules you can find your troubled code much faster.

Viewing `Apache::SmallProf` data is, however, a little different from `Apache::DProf`. A module profile looks like this:

|            |               |              |                 |                 |
|------------|---------------|--------------|-----------------|-----------------|
| `<number>` | `<wall time>` | `<cpu time>` | `<line number>` | `<source line>` |

`<number>` is the number of times this particular line was executed, `<wall time>` is the actual time passed, and `<cpu time>` is the amount of time the CPU spent working on that line. The remaining two pieces of data are the line number in the file and the actual source on that line.

You can just open up the profiles generated by `Apache::SmallProf` and look at the results. However, this doesn't get to the heart of the matter very quickly. Sorting the profile by the amount of time spent on each line gets you where you want to go:

    $ sort -nrk 2 logs/smallprof/MyHandler.pm | more

This command sorts the profile for `MyHandler.pm` by the wall time of each line. If you use this same sort on the output from `Apache::SmallProf` on the example code, you will see something similar to this:

    # sort -nrk 2 PerlTest.pm.prof | more
        1 5.000785 0.000000         29:    sleep( 5 );
        1 0.008177 0.000000         13:    return( Apache2::Const::OK );
        1 0.007431 0.010000         21:    cleanup_request( $r );
        3 0.001343 0.000000          4:use Apache2::RequestIO;
        1 0.000176 0.000000         33:1;
        3 0.000164 0.000000          3:use Apache2::RequestRec;
        1 0.000093 0.000000         19:    $r->print( "Handling request......\n" );
        1 0.000067 0.000000         11:    handle_request( $r );
        1 0.000058 0.000000          9:    $r->content_type( 'text/plain' );
        1 0.000058 0.000000         28:    $r->print( "Cleaning up request......\n" );

As you can see, `Apache::SmallProf` has zeroed right in on our `sleep()` call as the source of our performance problems.

### Conclusion

Hopefully, this article has given you enough of an introduction to these modules that you can begin using them in your development efforts. The next time you face a seemingly unsolvable bug or performance issue, you have a few more weapons in your arsenal.

If you have trouble getting any of these three modules to work, please don't hesitate to contact me directly. If you need `mod_perl` help in general, I strongly suggest you join the `mod_perl` mailing list. You can often get an answer to your `mod_perl` question in a few hours, if not minutes.
