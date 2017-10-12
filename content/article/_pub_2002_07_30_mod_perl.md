{
   "slug" : "/pub/2002/07/30/mod_perl",
   "date" : "2002-07-30T00:00:00-08:00",
   "categories" : "web",
   "title" : "Improving mod_perl Sites' Performance: Part 4",
   "tags" : [
      "mod-perl-shared-memory"
   ],
   "thumbnail" : null,
   "draft" : null,
   "authors" : [
      "stas-bekman"
   ],
   "description" : " Introduction If your OS supports sharing of memory (and most sane systems do), you might save a lot of RAM by sharing it between child processes. This will allow you to run more processes and hopefully better satisfy the...",
   "image" : null
}





### [Introduction]{#introduction}

If your OS supports sharing of memory (and most sane systems do), you
might save a lot of RAM by sharing it between child processes. This will
allow you to run more processes and hopefully better satisfy the client,
without investing extra money into buying more memory.

This is only possible when you preload code at server startup. However,
during a child process' life, its memory pages tend to become unshared.
There is no way we can make Perl allocate memory so that (dynamic)
variables land on different memory pages from constants, so the
**copy-on-write** effect will hit you almost at random.

If you are pre-loading many modules, you might be able to trade off the
memory that stays shared against the time for an occasional fork by
tuning `MaxRequestsPerChild`. Each time a child reaches this upper limit
and dies, it should release its unshared pages. The new child which
replaces it will share its fresh pages until it scribbles on them.

The ideal is a point where your processes usually restart before too
much memory becomes unshared. You should take some measurements to see
if it makes a real difference, and to find the range of reasonable
values. If you have success with this, tuning the value of
`MaxRequestsPerChild` will probably be peculiar to your situation and
may change with changing circumstances.

It is very important to understand that your goal is not to have
`MaxRequestsPerChild` to be 10000. Having a child serving 300 requests
on precompiled code is already a huge overall speedup, so if it is 100
or 10000 it probably does not really matter if you can save RAM by using
a lower value.

Do not forget that if you preload most of your code at server startup,
the newly forked child gets ready very very fast, because it inherits
most of the preloaded code and the perl interpreter from the parent
process.

During the life of the child, its memory pages (which aren't really its
own to start with, it uses the parent's pages) gradually get \`dirty' -
variables which were originally inherited and shared are updated or
modified -- and the *copy-on-write* happens. This reduces the number of
shared memory pages, thus increasing the memory requirement. Killing the
child and spawning a new one allows the new child to get back to the
pristine shared memory of the parent process.

The recommendation is that `MaxRequestsPerChild` should not be too
large, otherwise you lose some of the benefit of sharing memory.

### [How Shared Is My Memory?]{#how_shared_is_my_memory}

You've probably noticed that the word shared is repeated many times in
relation to `mod_perl`. Indeed, shared memory might save you a lot of
money, since with sharing in place you can run many more servers than
without it.

How much shared memory do you have? You can see it by either using the
memory utility that comes with your system or you can deploy the `GTop`
module:

      use GTop ();
      print "Shared memory of the current process: ",
        GTop->new->proc_mem($$)->share,"\n";
      
      print "Total shared memory: ",
        GTop->new->mem->share,"\n";

When you watch the output of the `top` utility, don't confuse the `RES`
(or `RSS`) columns with the `SHARE` column. `RES` is RESident memory,
which is the size of pages currently swapped in.

### [Calculating Real Memory Usage]{#calculating_real_memory_usage}

I have shown how to measure the size of the process' shared memory, but
we still want to know what the real memory usage is. Obviously this
cannot be calculated simply by adding up the memory size of each process
because that wouldn't account for the shared memory.

On the other hand we cannot just subtract the shared memory size from
the total size to get the real memory usage numbers, because in reality
each process has a different history of processed requests, therefore
the shared memory is not the same for all processes.

So how do we measure the real memory size used by the server we run?
It's probably too difficult to give the exact number, but I've found a
way to get a fair approximation, which was verified in the following
way. I calculated the real memory used by a technique you will see in
the moment, and then stopped the Apache server and saw that the memory
usage report indicated that the total used memory went down by almost
the same number I've calculated. Note that some OSs do smart memory
pages caching so you may not see the memory usage decrease as soon as it
actually happens when you quit the application.

This is a technique I've used:

1.  For each process sum up the difference between shared and system
    memory. To calculate a difference for a single process use:

          use GTop;
          my $proc_mem = GTop->new->proc_mem($$);
          my $diff     = $proc_mem->size - $proc_mem->share;
          print "Difference is $diff bytes\n";

2.  Now if we add the shared memory size of the process with maximum
    shared memory, we will get all the memory that actually is being
    used by all httpd processes, except for the parent process.
3.  Finally, add the size of the parent process.

Please note that this might be incorrect for your system, so you use
this number on your own risk.

I've used this technique to display real memory usage in the module
`Apache::VMonitor` (see the previous article), so instead of trying to
manually calculate this number you can use this module to do it
automatically. In fact in the calculations used in this module there is
no separation between the parent and child processes, they are all
counted indifferently using the following code:

      use GTop ();
      my $gtop = GTop->new;
      my $total_real = 0;
      my $max_shared = 0;
      # @mod_perl_pids is initialized by Apache::Scoreboard,
      # irrelevant here
      my @mod_perl_pids = some_code();
      for my $pid (@mod_perl_pids)
        my $proc_mem = $gtop->proc_mem($pid);
        my $size     = $proc_mem->size($pid);
        my $share    = $proc_mem->share($pid);
        $total_real += $size - $share;
        $max_shared  = $share if $max_shared < $share;
      }
      $total_real += $max_shared;

So as you see we that we accumulate the difference between the shared
and reported memory:

        $total_real  += $size-$share;

and at the end add the biggest shared process size:

      $total_real += $max_shared;

So now `$total_real` contains approximately the really used memory.

### [Are My Variables Shared?]{#are_my_variables_shared}

How do you find out if the code you write is shared between the
processes or not? The code should be shared, except where it is on a
memory page with variables that change. Some variables are read-only in
usage and never change. For example, if you have some variables that use
a lot of memory and you want them to be read-only. As you know the
variable becomes unshared when the process modifies its value.

So imagine that you have this 10Mb in-memory database that resides in a
single variable, you perform various operations on it and want to make
sure that the variable is still shared. For example if you do some
matching regular expression (regex) processing on this variable and want
to use the `pos()` function, will it make the variable unshared or not?

The `Apache::Peek` module comes to rescue. Let's write a module called
*MyShared.pm* which we preload at server startup, so all the variables
of this module are initially shared by all children.

      MyShared.pm
      ---------
      package MyShared;
      use Apache::Peek;
      
      my $readonly = "Chris";
      
      sub match    { $readonly =~ /\w/g;               }
      sub print_pos{ print "pos: ",pos($readonly),"\n";}
      sub dump     { Dump($readonly);                  }
      1;

This module declares the package `MyShared`, loads the `Apache::Peek`
module and defines the lexically scoped `$readonly` variable which is
supposed to be a variable of large size (think about a huge hash data
structure), but we will use a small one to simplify this example.

The module also defines three subroutines: `match()` that does a simple
character matching, `print_pos()` that prints the current position of
the matching engine inside the string that was last matched and finally
the `dump()` subroutine that calls the `Apache::Peek` module's `Dump()`
function to dump a raw Perl data-type of the `$readonly` variable.

Here is the script that prints the process ID (PID) and calls all three
functions. The goal is to check whether `pos()` makes the variable
*dirty* and therefore unshared.

      share_test.pl
      -------------
      use MyShared;
      print "Content-type: text/plain\r\n\r\n";
      print "PID: $$\n";
      MyShared::match();
      MyShared::print_pos();
      MyShared::dump();

Before you restart the server, in *httpd.conf* set:

      MaxClients 2

for easier tracking. You need at least two servers to compare the print
outs of the test program. Having more than two can make the comparison
process harder.

Now open two browser windows and issue the request for this script
several times in both windows, so you get different processes PIDs
reported in the two windows and each process has processed a different
number of requests to the *share\_test.pl* script.

In the first window you will see something like that:

      PID: 27040
      pos: 1
      SV = PVMG(0x853db20) at 0x8250e8c
        REFCNT = 3
        FLAGS = (PADBUSY,PADMY,SMG,POK,pPOK)
        IV = 0
        NV = 0
        PV = 0x8271af0 "Chris"\0
        CUR = 5
        LEN = 6
        MAGIC = 0x853dd80
          MG_VIRTUAL = &vtbl_mglob
          MG_TYPE = 'g'
          MG_LEN = 1

And in the second window:

      PID: 27041
      pos: 2
      SV = PVMG(0x853db20) at 0x8250e8c
        REFCNT = 3
        FLAGS = (PADBUSY,PADMY,SMG,POK,pPOK)
        IV = 0
        NV = 0
        PV = 0x8271af0 "Chris"\0
        CUR = 5
        LEN = 6
        MAGIC = 0x853dd80
          MG_VIRTUAL = &vtbl_mglob
          MG_TYPE = 'g'
          MG_LEN = 2

We see that all the addresses of the supposedly big structure are the
same (`0x8250e8c` and `0x8271af0`), therefore the variable data
structure is almost completely shared. The only difference is in
`SV.MAGIC.MG_LEN` record, which is not shared.

So given that the `$readonly` variable is a big one, its value is still
shared between the processes, while part of the variable data structure
is non-shared. But it's almost insignificant because it takes a very
little memory space.

Now if you need to compare more than variable, doing it by hand can be
quite time consuming and error prune. Therefore it's better to correct
the testing script to dump the Perl data-types into files (e.g
*/tmp/dump.\$\$*, where `$$` is the PID of the process) and then using
`diff(1)` utility to see whether there is some difference.

So correcting the `dump()` function to write the info to the file will
do the job. Notice that I use `Devel::Peek` and not `Apache::Peek`. The
both are almost the same, but `Apache::Peek` prints it output directly
to the opened socket so I cannot intercept and redirect the result to
the file. Since `Devel::Peek` dumps results to the STDERR stream I can
use the old trick of saving away the default STDERR handler, and open a
new filehandler using the STDERR. In our example when `Devel::Peek` now
prints to STDERR it actually prints to our file. When I'm done, I make
sure to restore the original STDERR filehandler.

So this is the resulting code:

      MyShared2.pm
      ---------
      package MyShared2;
      use Devel::Peek;
      
      my $readonly = "Chris";
      
      sub match    { $readonly =~ /\w/g;               }
      sub print_pos{ print "pos: ",pos($readonly),"\n";}
      sub dump{
        my $dump_file = "/tmp/dump.$$";
        print "Dumping the data into $dump_file\n";
        open OLDERR, ">&STDERR";
        open STDERR, ">".$dump_file or die "Can't open $dump_file: $!";
        Dump($readonly);
        close STDERR ;
        open STDERR, ">&OLDERR";
      }
      1;

When if I modify the code to use the modified module:

      share_test2.pl
      -------------
      use MyShared2;
      print "Content-type: text/plain\r\n\r\n";
      print "PID: $$\n";
      MyShared2::match();
      MyShared2::print_pos();
      MyShared2::dump();

And run it as before (with MaxClients 2), two dump files will be created
in the directory */tmp*. In our test these were created as
*/tmp/dump.1224* and */tmp/dump.1225*. When I run diff(1):

      % diff /tmp/dump.1224 /tmp/dump.1225
      12c12
      <       MG_LEN = 1
      ---
      >       MG_LEN = 2

We see that the two padlists (of the variable `readonly`) are different,
as we have observed before when I did a manual comparison.

In fact we if we think about these results again, we get to a conclusion
that there is no need for two processes to find out whether the variable
gets modified (and therefore unshared). It's enough to check the
datastructure before the script was executed and after that. You can
modify the `MyShared2` module to dump the padlists into a different file
after each invocation and than to run the `diff(1)` on the two files.

If you want to watch whether some lexically scoped (with `my())`
variables in your `Apache::Registry` script inside the same process get
changed between invocations you can use the `Apache::RegistryLexInfo`
module instead. Since it does exactly this: it makes a snapshot of the
padlist before and after the code execution and shows the difference
between the two. This specific module was written to work with
`Apache::Registry` scripts so it won't work for loaded modules. Use the
technique I have described above for any type of variables in modules
and scripts.

Surely another way of ensuring that a scalar is readonly and therefore
sharable is to either use the `constant` pragma or `readonly` pragma.
But then you won't be able to make calls that alter the variable even a
little, like in the example that I've just showen, because it will be a
true constant variable and you will get compile time error if you try
this:

      MyConstant.pm
      -------------
      package MyConstant;
      use constant readonly => "Chris";
      
      sub match    { readonly =~ /\w/g;               }
      sub print_pos{ print "pos: ",pos(readonly),"\n";}
      1;
      
      % perl -c MyConstant.pm
      
      Can't modify constant item in match position at MyConstant.pm line
      5, near "readonly)"
      MyConstant.pm had compilation errors.

However this code is just right:

      MyConstant1.pm
      -------------
      package MyConstant1;
      use constant readonly => "Chris";
      
      sub match { readonly =~ /\w/g; }
      1;

### [Preloading Perl Modules at Server Startup]{#preloading_perl_modules_at_server_startup}

You can use the `PerlRequire` and `PerlModule` directives to load
commonly used modules such as `CGI.pm`, `DBI` and etc., when the server
is started. On most systems, server children will be able to share the
code space used by these modules. Just add the following directives into
*httpd.conf*:

      PerlModule CGI
      PerlModule DBI

But an even better approach is to create a separate startup file (where
you code in plain perl) and put there things like:

      use DBI ();
      use Carp ();

Don't forget to prevent importing of the symbols exported by default by
the module you are going to preload, by placing empty parentheses `()`
after a module's name. Unless you need some of these in the startup
file, which is unlikely. This will save you a few more memory bits.

Then you `require()` this startup file in *httpd.conf* with the
`PerlRequire` directive, placing it before the rest of the mod\_perl
configuration directives:

      PerlRequire /path/to/start-up.pl

`CGI.pm` is a special case. Ordinarily `CGI.pm` autoloads most of its
functions on an as-needed basis. This speeds up the loading time by
deferring the compilation phase. When you use mod\_perl, FastCGI or
another system that uses a persistent Perl interpreter, you will want to
precompile the functions at initialization time. To accomplish this,
call the package function `compile()` like this:

      use CGI ();
      CGI->compile(':all');

The arguments to `compile()` are a list of method names or sets, and are
identical to those accepted by the `use()` and `import()` operators.
Note that in most cases you will want to replace `':all'` with the tag
names that you actually use in your code, since generally you only use a
subset of them.

Let's conduct a memory usage test to prove that preloading, reduces
memory requirements.

In order to have an easy measurement I will use only one child process,
therefore I will use this setting:

      MinSpareServers 1
      MaxSpareServers 1
      StartServers 1
      MaxClients 1
      MaxRequestsPerChild 100

I'm going to use the `Apache::Registry` script *memuse.pl* which
consists of two parts: the first one preloads a bunch of modules (that
most of them aren't going to be used), the second part reports the
memory size and the shared memory size used by the single child process
that I start. and of course it prints the difference between the two
sizes.

      memuse.pl
      ---------
      use strict;
      use CGI ();
      use DB_File ();
      use LWP::UserAgent ();
      use Storable ();
      use DBI ();
      use GTop ();

      my $r = shift;
      $r->send_http_header('text/plain');
      my $proc_mem = GTop->new->proc_mem($$);
      my $size  = $proc_mem->size;
      my $share = $proc_mem->share;
      my $diff  = $size - $share;
      printf "%10s %10s %10s\n", qw(Size Shared Difference);
      printf "%10d %10d %10d (bytes)\n",$size,$share,$diff;

First I restart the server and execute this CGI script when none of the
above modules preloaded. Here is the result:

         Size   Shared     Diff
      4706304  2134016  2572288 (bytes)

Now I take all the modules:

      use strict;
      use CGI ();
      use DB_File ();
      use LWP::UserAgent ();
      use Storable ();
      use DBI ();
      use GTop ();

and copy them into the startup script, so they will get preloaded. The
script remains unchanged. I restart the server and execute it again. I
get the following.

         Size   Shared    Diff
      4710400  3997696  712704 (bytes)

Let's put the two results into one table:

      Preloading    Size   Shared     Diff
         Yes     4710400  3997696   712704 (bytes)
          No     4706304  2134016  2572288 (bytes)
      --------------------------------------------
      Difference    4096  1863680 -1859584

You can clearly see that when the modules weren't preloaded the shared
memory pages size, were about 1864Kb smaller relative to the case where
the modules were preloaded.

Assuming that you have had 256M dedicated to the web server, if you
didn't preload the modules, you could have:

      268435456 = X * 2572288 + 2134016

      X = (268435456 - 2134016) / 2572288 = 103

103 servers.

Now let's calculate the same thing with modules preloaded:

      268435456 = X * 712704 + 3997696

      X = (268435456 - 3997696) / 712704 = 371

You can have almost 4 times more servers!!!

Remember that I have mentioned before that memory pages gets dirty and
the size of the shared memory gets smaller with time? So I have
presented the ideal case where the shared memory stays intact. Therefore
the real numbers will be a little bit different, but not far from the
numbers in our example.

Also it's obvious that in your case it's possible that the process size
will be bigger and the shared memory will be smaller, since you will use
different modules and a different code, so you won't get this fantastic
ratio, but this example is certainly helps to feel the difference.

### [References]{#references}

-   The mod\_perl site's URL: <http://perl.apache.org/>
-   `GTop`

    <http://search.cpan.org/search?dist=GTop>

    `GTop` relies in turn on libgtop library not available for all
    platforms

    Visit <http://home-of-linux.org/gnome/libgtop/> for more information

-   `Apache::Peek`

    <http://search.cpan.org/search?dist=Apache-Peek>

-   `Devel::Peek`

    <http://search.cpan.org/search?dist=Devel-Peek>


