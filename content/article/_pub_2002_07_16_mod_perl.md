{
   "authors" : [
      "stas-bekman"
   ],
   "image" : null,
   "title" : "Improving mod_perl Sites' Performance: Part 3",
   "description" : " In this article we will continue the topic started in the previous article. This time we talk about tools that help us with code profiling and memory usage measuring. Code Profiling Techniques The profiling process helps you to determine...",
   "thumbnail" : null,
   "categories" : "web",
   "tags" : [
      "mod-perl-benchmarking-test"
   ],
   "date" : "2002-07-16T00:00:00-08:00",
   "slug" : "/pub/2002/07/16/mod_perl",
   "draft" : null
}





In this article we will continue the topic started in the previous
article. This time we talk about tools that help us with code profiling
and memory usage measuring.

### [Code Profiling Techniques]{#code_profiling_techniques}

The profiling process helps you to determine which subroutines or just
snippets of code take the longest time to execute and which subroutines
are called most often. You will probably just want to optimize those.

When do you need to profile your code? You do that when you suspect that
some part of your code is being called very often and so there may be a
need to optimize it to significantly improve the overall performance.

For example, you might have used the `diagnostics` pragma, which extends
the terse diagnostics normally emitted by both the Perl compiler and the
Perl interpreter, augmenting them with the more verbose and endearing
descriptions found in the `perldiag` manpage. If you've ever done so,
then you know that it might slow your code down tremendously, so let's
first see whether or not it actually does.

We will run a benchmark, once with diagnostics enabled and once
disabled, on a subroutine called *test\_code*.

The code inside the subroutine does an arithmetic and a numeric
comparison of two strings. It assigns one string to another if the
condition tests true but the condition always tests false. To
demonstrate the `diagnostics` overhead the comparison operator is
intentionally *wrong*. It should be a string comparison, not a numeric
one.

      use Benchmark;
      use diagnostics;
      use strict;
      
      my $count = 50000;
      
      disable diagnostics;
      my $t1 = timeit($count,\&test_code);
      
      enable  diagnostics;
      my $t2 = timeit($count,\&test_code);
      
      print "Off: ",timestr($t1),"\n";
      print "On : ",timestr($t2),"\n";
      
      sub test_code{
        my ($a,$b) = qw(foo bar);
        my $c;
        if ($a == $b) {
          $c = $a;
        }
      }

For only a few lines of code we get:

      Off:  1 wallclock secs ( 0.81 usr +  0.00 sys =  0.81 CPU)
      On : 13 wallclock secs (12.54 usr +  0.01 sys = 12.55 CPU)

With `diagnostics` enabled, the subroutine `test_code()` is 16 times
slower than with `diagnostics` disabled!

Now let's fix the comparison the way it should be, by replacing `==`
with `eq`, so we get:

        my ($a,$b) = qw(foo bar);
        my $c;
        if ($a eq $b) {
          $c = $a;
        }

and run the same benchmark again:

      Off:  1 wallclock secs ( 0.57 usr +  0.00 sys =  0.57 CPU)
      On :  1 wallclock secs ( 0.56 usr +  0.00 sys =  0.56 CPU)

Now there is no overhead at all. The `diagnostics` pragma slows things
down only when warnings are generated.

After we have verified that using the `diagnostics` pragma might adds a
big overhead to execution runtime, let's use the code profiling to
understand why this happens. We are going to use `Devel::DProf` to
profile the code. Let's use this code:

      diagnostics.pl
      --------------
      use diagnostics;
      print "Content-type: text/html\n\n";
      test_code();
      sub test_code{
        my ($a,$b) = qw(foo bar);
        my $c;
        if ($a == $b) {
          $c = $a;
        }
      }

Run it with the profiler enabled, and then create the profiling stastics
with the help of dprofpp:

      % perl -d:DProf diagnostics.pl
      % dprofpp
      
      Total Elapsed Time = 0.342236 Seconds
        User+System Time = 0.335420 Seconds
      Exclusive Times
      %Time ExclSec CumulS #Calls sec/call Csec/c  Name
       92.1   0.309  0.358      1   0.3089 0.3578  main::BEGIN
       14.9   0.050  0.039   3161   0.0000 0.0000  diagnostics::unescape
       2.98   0.010  0.010      2   0.0050 0.0050  diagnostics::BEGIN
       0.00   0.000 -0.000      2   0.0000      -  Exporter::import
       0.00   0.000 -0.000      2   0.0000      -  Exporter::export
       0.00   0.000 -0.000      1   0.0000      -  Config::BEGIN
       0.00   0.000 -0.000      1   0.0000      -  Config::TIEHASH
       0.00   0.000 -0.000      2   0.0000      -  Config::FETCH
       0.00   0.000 -0.000      1   0.0000      -  diagnostics::import
       0.00   0.000 -0.000      1   0.0000      -  main::test_code
       0.00   0.000 -0.000      2   0.0000      -  diagnostics::warn_trap
       0.00   0.000 -0.000      2   0.0000      -  diagnostics::splainthis
       0.00   0.000 -0.000      2   0.0000      -  diagnostics::transmo
       0.00   0.000 -0.000      2   0.0000      -  diagnostics::shorten
       0.00   0.000 -0.000      2   0.0000      -  diagnostics::autodescribe

It's not easy to see what is responsible for this enormous overhead,
even if `main::BEGIN` seems to be running most of the time. To get the
full picture we must see the OPs tree, which shows us who calls whom, so
we run:

      % dprofpp -T

and the output is:

     main::BEGIN
       diagnostics::BEGIN
          Exporter::import
             Exporter::export
       diagnostics::BEGIN
          Config::BEGIN
          Config::TIEHASH
          Exporter::import
             Exporter::export
       Config::FETCH
       Config::FETCH
       diagnostics::unescape
       .....................
       3159 times [diagnostics::unescape] snipped
       .....................
       diagnostics::unescape
       diagnostics::import
     diagnostics::warn_trap
       diagnostics::splainthis
          diagnostics::transmo
          diagnostics::shorten
          diagnostics::autodescribe
     main::test_code
       diagnostics::warn_trap
          diagnostics::splainthis
             diagnostics::transmo
             diagnostics::shorten
             diagnostics::autodescribe
       diagnostics::warn_trap
          diagnostics::splainthis
             diagnostics::transmo
             diagnostics::shorten
            diagnostics::autodescribe

So we see that two executions of `diagnostics::BEGIN` and 3161 of
`diagnostics::unescape` are responsible for most of the running
overhead.

If we comment out the `diagnostics` module, we get:

      Total Elapsed Time = 0.079974 Seconds
        User+System Time = 0.059974 Seconds
      Exclusive Times
      %Time ExclSec CumulS #Calls sec/call Csec/c  Name
       0.00   0.000 -0.000      1   0.0000      -  main::test_code

It is possible to profile code running under mod\_perl with the
`Devel::DProf` module, available on CPAN. However, you must have apache
version 1.3b3 or higher and the `PerlChildExitHandler` enabled during
the httpd build process. When the server is started, `Devel::DProf`
installs an `END` block to write the *tmon.out* file. This block will be
called at server shutdown. Here is how to start and stop a server with
the profiler enabled:

      % setenv PERL5OPT -d:DProf
      % httpd -X -d `pwd` &
      ... make some requests to the server here ...
      % kill `cat logs/httpd.pid`
      % unsetenv PERL5OPT
      % dprofpp

The `Devel::DProf` package is a Perl code profiler. It will collect
information on the execution time of a Perl script and of the subs in
that script (remember that `print()` and `map()` are just like any other
subroutines you write, but they come bundled with Perl!)

Another approach is to use `Apache::DProf`, which hooks `Devel::DProf`
into mod\_perl. The `Apache::DProf` module will run a `Devel::DProf`
profiler inside each child server and write the *tmon.out* file in the
directory `$ServerRoot/logs/dprof/$$` when the child is shutdown (where
`$$` is the number of the child process). All it takes is to add to
*httpd.conf*:

      PerlModule Apache::DProf

Remember that any PerlHandler that was pulled in before `Apache::DProf`
in the *httpd.conf* or *startup.pl*, will not have its code debugging
information inserted. To run `dprofpp`, chdir to
`$ServerRoot/logs/dprof/$$` and run:

      % dprofpp

(Lookup the `ServerRoot` directive's value in *httpd.conf* to figure out
what your `$ServerRoot` is.)

### [Measuring the Memory of the Process]{#measuring_the_memory_of_the_process}

One very important aspect of performance tuning is to make sure that
your applications don't use much memory, since if they do you cannot run
many servers and therefore in most cases under a heavy load the overall
performance degrades.

In addition the code may not be clean and leak memory, which is even
worse. In this case, the same process serves many requests and after
each request more memory is used. After a while all your RAM will be
used and machine will start swapping (use the swap partition) which is a
very undesirable event, since it may lead to a machine crash.

The simplest way to figure out how big the processes are and see whether
they grow is to watch the output of `top(1)` or `ps(1)` utilities.

For example the output of top(1):

        8:51am  up 66 days,  1:44,  1 user,  load average: 1.09, 2.27, 2.61
      95 processes: 92 sleeping, 3 running, 0 zombie, 0 stopped
      CPU states: 54.0% user,  9.4% system,  1.7% nice, 34.7% idle
      Mem:  387664K av, 309692K used,  77972K free, 111092K shrd,  70944K buff
      Swap: 128484K av,  11176K used, 117308K free                170824K cached

         PID USER PRI NI SIZE  RSS SHARE STAT LIB %CPU %MEM   TIME COMMAND
      29225 nobody 0  0  9760 9760  7132 S      0 12.5  2.5   0:00 httpd_perl
      29220 nobody 0  0  9540 9540  7136 S      0  9.0  2.4   0:00 httpd_perl
      29215 nobody 1  0  9672 9672  6884 S      0  4.6  2.4   0:01 httpd_perl
      29255 root   7  0  1036 1036   824 R      0  3.2  0.2   0:01 top
        376 squid  0  0 15920  14M   556 S      0  1.1  3.8 209:12 squid
      29227 mysql  5  5  1892 1892   956 S N    0  1.1  0.4   0:00 mysqld
      29223 mysql  5  5  1892 1892   956 S N    0  0.9  0.4   0:00 mysqld
      29234 mysql  5  5  1892 1892   956 S N    0  0.9  0.4   0:00 mysqld

Which starts with overall information of the system and then displays
the most active processes at the given moment. So for example if we look
at the `httpd_perl` processes we can see the size of the resident
(`RSS`) and shared (`SHARE`) memory segments. This sample was taken on
the production server running linux.

But of course we want to see all the apache/mod\_perl processes, and
that's where `ps(1)` comes to help. The options of this utility vary
from one Unix flavor to another, and some flavors provide their own
tools. Let's check the information about mod\_perl processes:

      % ps -o pid,user,rss,vsize,%cpu,%mem,ucomm -C httpd_perl
        PID USER      RSS   VSZ %CPU %MEM COMMAND
      29213 root     8584 10264  0.0  2.2 httpd_perl
      29215 nobody   9740 11316  1.0  2.5 httpd_perl
      29216 nobody   9668 11252  0.7  2.4 httpd_perl
      29217 nobody   9824 11408  0.6  2.5 httpd_perl
      29218 nobody   9712 11292  0.6  2.5 httpd_perl
      29219 nobody   8860 10528  0.0  2.2 httpd_perl
      29220 nobody   9616 11200  0.5  2.4 httpd_perl
      29221 nobody   8860 10528  0.0  2.2 httpd_perl
      29222 nobody   8860 10528  0.0  2.2 httpd_perl
      29224 nobody   8860 10528  0.0  2.2 httpd_perl
      29225 nobody   9760 11340  0.7  2.5 httpd_perl
      29235 nobody   9524 11104  0.4  2.4 httpd_perl

Now you can see the resident (`RSS`) and virtual (`VSZ`) memory segments
(and shared memory segment if you ask for it) of all mod\_perl
processes. Please refer to the `top(1)` and `ps(1)` man pages for more
information.

You probably agree that using `top(1)` and `ps(1)` are cumbersome if we
want to use memory size sampling during the benchmark test. We want to
have a way to print memory sizes during the program execution at desired
places. If you have `GTop` modules installed, which is a perl glue to
the `libgtop` library, it's exactly what we need.

Note: `GTop` requires the `libgtop` library but is not available for all
platforms. Visit <http://www.home-of-linux.org/gnome/libgtop/> to check
whether your platform/flavor is supported.

`GTop` provides an API for retrieval of information about processes and
the whole system. We are only interested in memory sampling API methods.
To print all the process related memory information we can execute the
following code:

      use GTop;
      my $gtop = GTop->new;
      my $proc_mem = $gtop->proc_mem($$);
      for (qw(size vsize share rss)) {
          printf "   %s => %d\n", $_, $proc_mem->$_();
      }

When executed we see the following output (in bytes):

          size => 1900544
         vsize => 3108864
         share => 1392640
           rss => 1900544

So if we are interested in to print the process resident memory segment
before and after some event we just do it: For example if we want to see
how much extra memory was allocated after a variable creation we can
write the following code:

      use GTop;
      my $gtop = GTop->new;
      my $before = $gtop->proc_mem($$)->rss;
      my $x = 'a' x 10000;
      my $after  = $gtop->proc_mem($$)->rss;
      print "diff: ",$after-$before, " bytes\n";

and the output

      diff: 20480 bytes

So we can see that Perl has allocated extra 20480 bytes to create `$x`
(of course the creation of `after` needed a few bytes as well, but it's
insignificant compared to a size of `$x`)

The `Apache::VMonitor` module with help of the `GTop` module allows you
to watch all your system information using your favorite browser from
anywhere in the world without a need to telnet to your machine. If you
are looking into what information you can retrieve with `GTop`, you
should examine `Apache::VMonitor`, as it deploys a big part of the API
that `GTop` provides.

If you are running a true BSD system, you may use
`BSD::Resource::getrusage` instead of `GTop`. For example:

      print "used memory = ".(BSD::Resource::getrusage)[2]."\n"

For more information refer to the `BSD::Resource` manpage.

### [Measuring the Memory Usage of Subroutines]{#measuring_the_memory_usage_of_subroutines}

With help of `Apache::Status` you can find out the size of each and
every subroutine.

1.  Build and install mod\_perl as you always do, make sure it's version
    1.22 or higher.
2.  Configure /perl-status if you haven't already:

          <Location /perl-status>
            SetHandler perl-script
            PerlHandler Apache::Status
            order deny,allow
            #deny from all
            #allow from ...
          </Location>

3.  Add to httpd.conf

          PerlSetVar StatusOptionsAll On
          PerlSetVar StatusTerse On
          PerlSetVar StatusTerseSize On
          PerlSetVar StatusTerseSizeMainSummary On

          PerlModule B::TerseSize

4.  Start the server (best in httpd -X mode)
5.  From your favorite browser fetch <http://localhost/perl-status>
6.  Click on 'Loaded Modules' or 'Compiled Registry Scripts'
7.  Click on the module or script of your choice (you might need to run
    some script/handler before you will see it here unless it was
    preloaded)
8.  Click on 'Memory Usage' at the bottom
9.  You should see all the subroutines and their respective sizes.

Now you can start to optimize your code, or test which of several
implementations is of the least size.

For example let's compare `CGI.pm`'s OO vs. procedural interfaces:

As you will see below the first OO script uses about 2k bytes while the
second script (procedural interface) uses about 5k.

Here are the code examples and the numbers:

1.    cgi_oo.pl
          ---------
          use CGI ();
          my $q = CGI->new;
          print $q->header;
          print $q->b("Hello");

2.    cgi_mtd.pl
          ---------
          use CGI qw(header b);
          print header();
          print b("Hello");

After executing each script in single server mode (-X) the results are:

1.    Totals: 1966 bytes | 27 OPs
          
          handler 1514 bytes | 27 OPs
          exit     116 bytes |  0 OPs

2.    Totals: 4710 bytes | 19 OPs
          
          handler  1117 bytes | 19 OPs
          basefont  120 bytes |  0 OPs
          frameset  120 bytes |  0 OPs
          caption   119 bytes |  0 OPs
          applet    118 bytes |  0 OPs
          script    118 bytes |  0 OPs
          ilayer    118 bytes |  0 OPs
          header    118 bytes |  0 OPs
          strike    118 bytes |  0 OPs
          layer     117 bytes |  0 OPs
          table     117 bytes |  0 OPs
          frame     117 bytes |  0 OPs
          style     117 bytes |  0 OPs
          Param     117 bytes |  0 OPs
          small     117 bytes |  0 OPs
          embed     117 bytes |  0 OPs
          font      116 bytes |  0 OPs
          span      116 bytes |  0 OPs
          exit      116 bytes |  0 OPs
          big       115 bytes |  0 OPs
          div       115 bytes |  0 OPs
          sup       115 bytes |  0 OPs
          Sub       115 bytes |  0 OPs
          TR        114 bytes |  0 OPs
          td        114 bytes |  0 OPs
          Tr        114 bytes |  0 OPs
          th        114 bytes |  0 OPs
          b         113 bytes |  0 OPs

Note, that the above is correct if you didn't precompile all `CGI.pm`'s
methods at server startup. Since if you did, the procedural interface in
the second test will take up to 18k and not 5k as we saw. That's because
the whole of `CGI.pm`'s namespace is inherited and it already has all
its methods compiled, so it doesn't really matter whether you attempt to
import only the symbols that you need. So if you have:

      use CGI  qw(-compile :all);

in the server startup script. Having:

      use CGI qw(header);

or

      use CGI qw(:all);

is essentially the same. You will have all the symbols precompiled at
startup imported even if you ask for only one symbol. It seems to me
like a bug, but probably that's how `CGI.pm` works.

BTW, you can check the number of opcodes in the code by a simple command
line run. For example comparing 'myÂ %hash' vs. 'myÂ %hashÂ = ()'.

      % perl -MO=Terse -e 'my %hash' | wc -l
      -e syntax OK
          4

      % perl -MO=Terse -e 'my %hash = ()' | wc -l
      -e syntax OK
         10

The first one has fewer opcodes.

Note that you shouldn't use `Apache::Status` module on production server
as it adds quite a bit of overhead to each request.

------------------------------------------------------------------------

[References]{#references}
=========================

-   The mod\_perl site's URL: <http://perl.apache.org>
-   `Devel::DProf`

    <http://search.cpan.org/search?dist=DProf>

-   `Apache::DProf`

    <http://search.cpan.org/search?dist=Apache-DB>

-   `Apache::VMonitor`

    <http://search.cpan.org/search?dist=Apache-VMonitor>

-   `GTop`

    <http://search.cpan.org/search?dist=GTop>

    The home of the C library:
    <http://www.home-of-linux.org/gnome/libgtop/>

-   `BSD::Resource`

    <http://search.cpan.org/search?dist=BSD-Resource>


