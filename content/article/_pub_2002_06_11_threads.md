{
   "slug" : "/pub/2002/06/11/threads",
   "tags" : [
      "threads-ithreads-thread-safety"
   ],
   "date" : "2002-06-11T00:00:00-08:00",
   "draft" : null,
   "image" : null,
   "authors" : [
      "artur-bergman"
   ],
   "thumbnail" : null,
   "categories" : "development",
   "description" : " One of the big new features in perl 5.8 is that we now have real working threads available to us through the threads pragma. However, for us module authors who already have to support our modules on different versions...",
   "title" : "Where Wizards Fear To Tread"
}





One of the big new features in perl 5.8 is that we now have real working
threads available to us through the threads pragma.

However, for us module authors who already have to support our modules
on different versions of perl and different platforms, we now have to
deal with another case: threads! This article will show you how threads
relate to modules, how we can take old modules and make them
thread-safe, and round off with a new module that alters perl's behavior
of the "current working directory".

To run the examples I have shown here, you need perl 5.8 RC1 or later
compiled with threads. On Unix, you can use
`Configure -Duseithreads -Dusethreads`; On Win32, the default build will
always have threading enabled.

### [How do threads relate to modules?]{#how_do_threads_relate_to_modules}

Threading in Perl is based on the notion of explicit shared data. That
is, only data that is explicitly requested to be shared will be shared
between threads. This is controlled by the `threads::shared` pragma and
the "`: shared`" attribute. Witness how it works:

         use threads;
         my $var = 1;
         threads->create(sub { $var++ })->join();
         print $var;

If you are accustomed to threading in most other languages, (Java/C) you
would expect \$var to contain a 2 and the result of this script to be
"2". However since Perl does not share data between threads, \$var is
copied in the thread and only incremented in the thread. The original
value in the main thread is not changed, so the output is "1".

However if we add in `threads::shared` and a `: shared` attribute we get
the desired result:

         use threads;
         use threads::shared;
         my $var : shared = 1;
         threads->create(sub { $var++ })->join();
         print $var

Now the result will be "2", since we declared \$var to be a shared
variable. Perl will then act on the same variable and provide automatic
locking to keep the variable out of trouble.

This makes it quite a bit simpler for us module developers to make sure
our modules are thread-safe. Essentially, all pure Perl modules are
thread-safe because any global state data, which is usually what gives
you thread-safety problems, is by default local to each thread.

#### [Definition of thread-safe levels]{#definition_of_threadsafe_levels}

To define what we mean by thread-safety, here are some terms adapted
from the Solaris thread-safety levels.

**[thread-safe]{#item_thread%2dsafe}**\
:   This module can safely be used from multiple threads. The effect of
    calling into a safe module is that the results are valid even when
    called by multiple threads. However, thread-safe modules can still
    have global consequences; for example, sending or reading data from
    a socket affects all threads that are working with that socket. The
    application has the responsibility to act sane with regards to
    threads. If one thread creates a file with the name *file.tmp* then
    another file which tries to create it will fail; this is not the
    fault of the module.

**[thread-friendly]{#item_thread%2dfriendly}**\
:   Thread-friendly modules are thread-safe modules that know about and
    provide special functions for working with threads or utilize
    threads by themselves. A typical example of this is the core
    `threads::queue` module. One could also imagine a thread-friendly
    module with a cache to declare that cache to be shared between
    threads to make hits more likely and save memory.

**[thread-unsafe]{#item_thread%2dunsafe}**\
:   This module can not safely be used from different threads; it is up
    to the application to synchronize access to the library and make
    sure it works with it the way it is specified. Typical examples here
    are XS modules that utilize external unsafe libraries that might
    only allow one thread to execute them.

Since Perl only shares when asked to, most pure Perl code probably falls
into the thread-safe category, that doesn't mean you should trust it
until you have review the source code or they have been marked with
thread-safe by the author. Typical problems include using alarm(),
mucking around with signals, working with relative paths and depending
on `%ENV`. However remember that ALL XS modules that don't state
anything fall into the definitive thread-unsafe category.

### [Why should I bother making my module thread-safe or thread-friendly?]{#why_should_i_bother_making_my_module_threadsafe_or_threadfriendly}

Well, it usually isn't much work and it will make the users of this
modules that want to use it in a threaded environment very happy. What?
Threaded Perl environments aren't that common you say? Wait until Apache
2.0 and mod\_perl 2.0 becomes available. One big change is that Apache
2.0 can run in threaded mode and then mod\_perl will have to be run in
threaded mode; this can be a huge performance gain on some operating
systems. So if you want your modules to work with mod\_perl 2.0, taking
a look at thread-safety levels is a good thing to do.

### [So what do I do to make my module thread-friendly?]{#so_what_do_i_do_to_make_my_module_threadfriendly}

A good example of a module that needed a little modification to work
with threads is Michael Schwern's most excellent `Test::Simple` suite
(`Test::Simple`, `Test::More` and `Test::Builder`). Surprisingly, we had
to change very little to fix it.

The problem was simply that the test numbering was not shared between
threads.

For example

         use threads;
         use Test::Simple tests => 3;
         ok(1);
         threads->create(sub { ok(1) })->join();
         ok(1);

Now that will return

         1..3
         ok 1
         ok 2
         ok 2

Does it look similar to the problem we had earlier? Indeed it does,
seems like somewhere there is a variable that needs to shared.

Now reading the documentation of `Test::Simple` we find out that all
magic is really done inside `Test::Builder`, opening up *Builder.pm* we
quickly find the following lines of code:

         my @Test_Results = ();
         my @Test_Details = ();
         my $Curr_Test = 0;

Now we would be tempted to add `use threads::shared` and `:shared`
attribute.

         use threads::shared;
         my @Test_Results : shared = ();
         my @Test_Details : shared = ();
         my $Curr_Test : shared = 0;

However `Test::Builder` needs to work back to Perl 5.4.4! Attributes
were only added in 5.6.0 and the above code would be a syntax error in
earlier Perls. And even if someone were using 5.6.0, `threads::shared`
would not be available for them.

The solution is to use the runtime function `share()` exported by
`threads::shared`, but we only want to do it for 5.8.0 and when threads
have been enabled. So, let's wrap it in a `BEGIN` block and an `if`.

         BEGIN{
             if($] >= 5.008 && exists($INC{'threads.pm'})) {
                 require threads::shared;
                 import threads::shared qw(share);
                 share($Curr_Test);
                 share(@Test_Details)
                 share(@Test_Results);
             }

So, if 5.8.0 or higher and threads has been loaded, we do the runtime
equivalent of `use threads::shared qw(share);` and call `share()` on the
variables we want to be shared.

Now lets find out some examples of where `$Curr_Test` is used. We find
`sub ok {}` in `Test::Builder`; I won't include it here, but only a
smaller version which contains:

         sub ok {
             my($self, $test, $name) = @_;
             $Curr_Test++;
             $Test_Results[$Curr_Test-1] = 1 unless($test);
         }

Now, this looks like it should work right? We have shared \$Curr\_Test
and `@Test_Results`. Of course, things aren't that easy; they never are.
Even if the variables are shared, two threads could enter `ok()` at the
same time. Remember that not even the statement `$CurrTest++` is an
atomic operation, it is just a shortcut for writing
`$CurrTest = $CurrTest + 1`. So let's say two threads do that at the
same time.

         Thread 1: add 1 + $Curr_Test
         Thread 2: add 1 + $Curr_Test
         Thread 2: Assign result to $Curr_Test
         Thread 1: Assign result to $Curr_Test

The effect would be that \$Curr\_Test would only be increased by one,
not two! Remember that a switch between two threads could happen at
**ANY** time, and if you are on a multiple CPU machine they can run at
exactly the same time! Never trust thread inertia.

So how do we solve it? We use the `lock()` keyword. `lock()` takes a
shared variable and locks it for the rest of the scope, but it is only
an advisory lock so we need to find every place that \$Curr\_Test is
used and modified and it is expected not to change. The `ok()` becomes:

         sub ok {
             my($self, $test, $name) = @_;
             lock($Curr_Test);
             $Curr_Test++;
             $Test_Results[$Curr_Test-1] = 1 unless($test);
         }

So are we ready? Well, `lock()` was only added in Perl 5.5 so we need to
add an else to the BEGIN clause to define a lock function if we aren't
running with threads. The end result would be.

         my @Test_Results = ();
         my @Test_Details = ();
         my $Curr_Test = 0;
         BEGIN{
             if($] >= 5.008 && exists($INC{'threads.pm'})) {
                 require threads::shared;
                 import threads::shared qw(share);
                 share($Curr_Test);
                 share(@Test_Details)
                 share(@Test_Results);
             } else {
                 *lock = sub(*) {};
             }
         }
         sub ok {
             my($self, $test, $name) = @_;
             lock($Curr_Test);
             $Curr_Test++;
             $Test_Results[$Curr_Test-1] = 1 unless($test);
         }

In fact, this is very like the code that has been added to
`Test::Builder` to make it work nice with threads. The only thing not
correct is `ok()` as I cut it down to what was relevant. There were
roughly 5 places where `lock()` had to be added. Now the test code would
print

         1..3
         ok 1
         ok 2
         ok 3

which is exactly what the end user would expect. All in all this is a
rather small change for this 1291 line module, we change roughly 15
lines in a non intrusive way, the documentation and testcase code makes
up most of the patch. The full patch is at
<http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2002-06/msg00816.html>

### [Altering Perls behavior to be thread-safe, ex::threads::cwd]{#altering_perls_behavior_to_be_threadsafe,_ex::threads::cwd}

Somethings change when you use threads; some things that you or a module
might do are not like what they used to be. Most of the changes will be
due to the way your operating system treats processes that use threads.
Each process has typically a set of attributes, which include the
current working directory, the environment table, the signal subsystem
and the pid. Since threads are multiple paths of execution inside a
single process, the operating system treats it as a single process and
you have a single set of these attributes.

Yep. That's right - if you change the current working directory in one
thread, it will also change in all the other threads! Whoops, better
start using absolute paths everywhere, and all the code that uses your
module might use relative paths. Aaargh...

Don't worry, this is a solvable problem. In fact, it's solvable by a
module.

Perl allows us to override functions using the `CORE::GLOBAL` namespace.
This will let us override the functions that deal with paths and set the
`cwd` correctly before issuing the command. So let's start off

         package ex::threads::safecwd;

         use 5.008;
         use strict;
         use warnings;
         use threads::shared;
         our $VERSION = '0.01';

Nothing weird here right? Now, when changing and dealing with the
current working directory one often uses the `Cwd` module, so let us
make the cwd module safe first. How do we do that?

      1) use Cwd;
      2) our $cwd = cwd;  #our per thread cwd, init on startup from cwd
      3) our $cwd_mutex : shared; # the variable we use to sync
      4) our $Cwd_cwd = \&Cwd::cwd;
      5) *Cwd::cwd = *my_cwd;     
         sub my_cwd {
      6)     lock($cwd_mutex);
      7)     CORE::chdir($cwd);
      8)     $Cwd_cwd->(@_);
         }

What's going on here? Let's analyze it line by line:

1.  We include `Cwd`.
2.  We declare a variable and assign to it the cwd we start in. This
    variable will not be shared between threads and will contain the cwd
    of this thread.
3.  We declare a variable we will be using to lock for synchronizing
    work.
4.  Here we take a reference to the `&Cwd::cwd` and store in `$Cwd_cwd`.
5.  Now we hijack `Cwd::cwd` and assign to it our own `my_cwd` so
    whenever someone calls `Cwd::cwd`, it will call `my_cwd` instead.
6.  `my_cwd` starts of by locking \$cwd\_mutex so no one else will muck.
    around with the cwd.
7.  After that we call `CORE::chdir()` to actually set the cwd to what
    this thread is expecting it to be.
8.  And we round off by calling the original `Cwd::cwd` that we stored
    in step 4 with any parameters that we were handed to us.

In effect we have hijacked `Cwd::cwd` and wrapped it around with a lock
and a `chdir` so it will report the correct thing!

Now that `cwd()` is fixed, we need a way to actually change the
directory. To do this, we install our own global `chdir`, simply like
this.

         *CORE::GLOBAL::chdir = sub {
             lock($cwd_mutex);
             CORE::chdir($_[0]) || return undef;
             $cwd = $Cwd_cwd->();
         };

Now, whenever someone calls `chdir()` our `chdir` will be called
instead, and in it we start by locking the variable controlling access,
then we try to chdir to the directory to see if it is possible,
otherwise we do what the real chdir would do, return undef. If it
succeeds, we assign the new value to our per thread `$cwd` by calling
the original `Cwd::cwd()`

The above code is actually enough to allow the following to work:

         use threads
         use ex::threads::safecwd;
         use Cwd;
         chdir("/tmp");
         threads->create(sub { chdir("/usr") } )->join();
         print cwd() eq '/tmp' ? "ok" : "nok";

Since the `chdir("/usr");` inside the thread will not affect the other
thread's `$cwd` variable, so when `cwd` is called, we will lock down the
thread, `chdir()` to the location the thread `$cwd` contains and perform
a `cwd()`.

While this is useful, we need to get along and provide some more
functions to extend the functionality of this module.

         *CORE::GLOBAL::mkdir = sub {
             lock($cwd_mutex);
             CORE::chdir($cwd);
             if(@_ > 1) {
                 CORE::mkdir($_[0], $_[1]);
             } else {
                 CORE::mkdir($_[0]);
             }
         };

         *CORE::GLOBAL::rmdir = sub {
             lock($cwd_mutex);
             CORE::chdir($cwd);
             CORE::rmdir($_[0]);
         };

The above snippet does essentially the same thing for both `mkdir` and
`rmdir`. We lock the \$cwd\_mutex to synchronize access, then we `chdir`
to `$cwd` and finally perform the action. Worth noticing here is the
check we need to do for `mkdir` to be sure the prototype behavior for it
is correct.

Let's move on with `opendir`, `open`, `readlink`, `readpipe`, `require`,
`rmdir`, `stat`, `symlink`, `system` and `unlink`. None of these are
really any different from the above with the big exception of `open`.
`open` has a weird bit of special case since it can take both a HANDLE
and an empty scalar for autovification of an anonymous handle.

         *CORE::GLOBAL::open = sub (*;$@) {
             lock($cwd_mutex);
             CORE::chdir($cwd);
             if(defined($_[0])) {
                 use Symbol qw();
                 my $handle = Symbol::qualify($_[0],(caller)[0]);
                 no strict 'refs';
                 if(@_ == 1) {
                     return CORE::open($handle);
                 } elsif(@_ == 2) {
                   return CORE::open($handle, $_[1]);
                 } else {
                   return CORE::open($handle, $_[1], @_[2..$#_]);
                 }
             }

Starting off with the usual lock and `chdir()` we then need to check if
the first value is defined. If it is, we have to qualify it to the
callers namespace. This is what would happen if a user does
`open FOO, "+>foo.txt"`. If the user instead does
`open main::FOO, "+>foo.txt"`, then Symbol::qualify notices that the
handle is already qualified and returns it unmodified. Now since `$_[0]`
is a readonly alias we cannot assign it over so we need to create a
temporary variable and then proceed as usual.

Now if the user used the new style `open my $foo, "+>foo.txt"`, we need
to treat it differently. The following code will do the trick and
complete the function.

         else {
                 if(@_ == 1) {
                     return CORE::open($_[0]);
                 } elsif(@_ == 2) {
                     return CORE::open($_[0], $_[1]);
                 } else {
                     return CORE::open($_[0], $_[1], @_[2..$#_]);
                 }
             }
         };

Wonder why we couldn't just assign `$_[0]` to `$handle` and unify the
code path? You see, `$_[0]` is an alias to the `$foo` in
`open my $foo, "+>foo.txt"` so `CORE::open` will correctly work.

However, if we do `$handle = $_[0]` we take a copy of the undefined
variable and `CORE::open` won't do what I mean.

So now we have a module that allows the you to safely use relative paths
in most of the cases and vastly improves your ability to port code to a
threaded environment. The price we pay for this is speed, since every
time you do an operation involving a directory you are serializing your
program. Typically, you never do those kinds of operations in a hot path
anyway. You might do work on your file in a hot path, but as soon as we
have gotten the filehandle no more locking is done.

A couple of problems remain. Performance-wise, there is one big problem
with `system()`, since we don't get control back until the
`CORE::system()` returns, so all path operations will hang waiting for
that. To solve that we would need to revert to XS and do some magic with
regard to the system call. We also haven't been able to override the
file test operators (`-x` and friends), nor can we do anything about
`qx {}`. Solving that problem requires working up and down the optree
using `B::Generate` and `B::Utils`. Perhaps a future version of the
module will attempt that together with a custom op to do the locking.

### [Conclusion]{#conclusion}

Threads in Perl are simple and straight forward, as long as we stay in
pure Perl land everything behaves just about how we would expect it to.
Converting your modules should be a simple matter of programming without
any big wizardly things to be done. The important thing to remember is
to think about how your module could possibly take advantage of threads
to make it easier to use for the programmer.

Moving over to XS land is altogether different; stay put for the next
article that will take us through the pitfalls of converting various
kinds of XS modules to thread-safe and thread-friendly levels.


