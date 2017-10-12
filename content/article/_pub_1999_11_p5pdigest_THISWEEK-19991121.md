{
   "thumbnail" : null,
   "draft" : null,
   "description" : "This week on perl5-porters (15-21 November 1999) Notes XSLoader.pm Threads Shared Interpreter threads (the current model) Cloned interpreter threads (upcoming in 5.005_63) chomp() Threading and Regexes Safe::Hole PREPARE Marshalling Modules Local Address in LWP local()izing select() and chdir() Wandering Environment...",
   "image" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "tags" : [],
   "title" : "This Week on p5p 1999/11/21",
   "date" : "1999-11-21T00:00:00-08:00",
   "slug" : "/pub/1999/11/p5pdigest/THISWEEK-19991121",
   "categories" : "community"
}





This week on perl5-porters\
(15-21 November 1999)
---------------------------

\
\
-   [Notes](#Notes)
-   [`XSLoader.pm`](#XSLoaderpm)
-   [Threads](#Threads)
-   [Shared Interpreter threads (the current
    model)](#Shared_Interpreter_threads_the_current_model)
-   [Cloned interpreter threads (upcoming in
    5.005\_63)](#Cloned_interpreter_threads_upcoming_in_5005_63)
-   [`chomp()`](#chomp)
-   [Threading and Regexes](#Threading_and_Regexes)
-   [`Safe::Hole`](#Safe::Hole)
-   [`PREPARE`](#PREPARE)
-   [Marshalling Modules](#Marshalling_Modules)
-   [Local Address in `LWP`](#Local_Address_in_LWP)
-   [`local()`izing `select()` and
    `chdir()`](#localizing_select_and_chdir)
-   [Wandering Environment](#Wandering_Environment)
-   [Localized Assignment](#Localized_Assignment)
-   [`goto` out of scope of `local`](#goto_out_of_scope_of_local)
-   [`use foo if bar`;](#use_foo_if_bar;)
-   [`croak` confounds `eval`](#croak_confounds_eval)
-   [Control-backslash](#Control_backslash)
-   [Empty Conditional in `while()`](#Empty_Conditional_in_while)
-   [Undefined Function Warning](#Undefined_Function_Warning)
-   [Static Extensions](#Static_Extensions)
-   [POD Hack](#POD_Hack)
-   [Perl Art](#Perl_Art)
-   [`localtime()` Contest Continues](#localtime_Contest_Continues)
-   [Various](#Various)

### [Notes]{#Notes}

I thought it was going to be a quiet week, but then bang, 140 messages
arrived on Friday. Fortunately for you, most of them are ignorable. Did
I mention that these reports are made possible through the generosity of
O'Reilly and Associates, who pay me a salary?

Next week's report will be late, because on Sunday I will be in London
with the Perl Mongers. Expect the next report sometime in early
December.

You can subscribe to an email version of this summary by sending an
empty message to
[`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to
`mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year
and month.

### [`XSLoader.pm`]{#XSLoaderpm}

Ilya contributed a new module, `XSLoader`, which is a cut-down version
of `Dynaloader`. It uses less memory and has a simpler interface. He
patched the standard dynamically-loaded modules to use `XSLoader`
instead of `DynaLoader`. [Read about
it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00585.html)

### [Threads]{#Threads}

Dan Sugalski submitted a patch that makes a new locking macro available
to XS code, but Sarathy said:

> Every time I see people patching `USE_THREADS` code I wonder if it's
> all going to be for nothing. I don't see much hopefor salvaging the
> existing model of `USE_THREADS` where prolific locking is needed.

In case you missed the point of this: 5.005\_63 is going to have a
drastically different threading model than previous versions of Perl. I
asked Dan to explain the two models to me, and he very kindly
contributed the following:

------------------------------------------------------------------------

#### [Shared Interpreter threads (the current model)]{#Shared_Interpreter_threads_the_current_model}

This threading model corresponds pretty closely to what most folks think
of when they think of threads. There is a single, shared executable (or
optree, in perl's case), and a single pool of variables. Any thread can
see, and affect, anything that's in its lexical scope. Data sharing
between threads is cheap, but the onus is on the programmer to maintain
consistency.

As an analogy, consider a thread a hamster, and your program as a giant
habitrail. Starting another thread means releasing another hamster into
the environment. Threads don't really collide (You ever see two hamsters
get stuck in a habitrail tube?) but the only thing that keeps two or
more hamsters from running on an exercise wheel at once is careful
design of the set.

#### [Cloned interpreter threads (upcoming in 5.005\_63)]{#Cloned_interpreter_threads_upcoming_in_5005_63}

This threading model corresponds more to the traditional unix fork
model. There is one copy of the optree per thread. One thread can't see
or affect anything in another thread unless that thing is explicitly
shared. Data sharing and coordination between threads is mildly
expensive and a bit cumbersome, but the onus is on the perl interpreter
to keep one thread from messing with another thread's toys.

Continuing the hamster analogy, creating a new thread in this model gets
you a whole new, separate habitrail for your new hamster. The two
habitrails may share exercise wheels, but only at very specific,
explicit spots, and there are little exclusion gates built in so only
one hamster can be on a wheel at once.

My personal preference is a bit mixed--I want shared threads because
they let me build all sorts of cheap, nifty tools (Threaded objects, and
a subclassable `Thread::Object`, are I&lt;trivial&gt;. I know, I wrote a
package to do it. One thread per object. Wheee!), but I think most folks
(including me, when writing 'normal' code) are better off with the
protection cloned threads get you.

The trickier bit is under the hood. Getting perl thread-safe (which is
to say, it won't core or segfault if the programmer doesn't sync access)
is a PITA. I've already run through a couple of different plans--the
first was paranoid and I, the second bloated `libperl.so` with a lot of
shadow routines for XS, and the third I'm not gonna bother with if
threads are dead anyway.

It does chew up more memory, too. To do it right means each and every
variable needs a mutex as well, otherwise you run into deadlock issues
and uneccesary lock contention. 'Course, it makes `$foo[time]` cost even
more than it does now. The alternative is "e;just don't do that"e;, but
that's not really an option I like.

Most of the p5p folks with an opinion prefers the forkish version. I
think they're all wrong, of course, but that's just me. :-)

------------------------------------------------------------------------

Thank you very much, Dan.

Dan requested that Sarathy commit one way or the other on the existing
threading model. Sarathy said that he wasn't sure yet, because he needs
to see how the new way works out, but he guesses that Perl will go with
the new way.

### [`chomp()`]{#chomp}

Ben Tilly askied if perhaps `chomp()` could be made to chomp any of
`"\n"`, `"\r"`, or `"\r\n"`. Of course, this is out of the question.

Mike Guy pointed out, and others concurred, that the correct solution
here is for the I/O subsystem to figure out what kind of file it is
reading and translate the line endings to `\n` regardless of what they
might have been originally. This then falls under the general heading of
\`line disciplines'.

[Earlier
discussion.](/pub/1999/11/p5pdigest/THISWEEK-19991114.html#More_About_Line_Disciplines)

[Still earlier
discussion.](/pub/1999/11/p5pdigest/THISWEEK-19991107.html#Record_Separators_that_Contain_NUL)

> **Larry Wall:** Seriously, we are entering an era when dwimmerly
> action on input will be a necessary evil. I could wish it were
> otherwise, but my supply of divine fiats is low.

### [Threading and Regexes]{#Threading_and_Regexes}

A few weeks ago Rob Cunningham reported that he and Brian Mancuso at MIT
were working on fixing regexes under threaded Perl. On Friday, Brian
wrote in with his patch. Ilya did not like it because it indirects the
match variables through a global variable rather than through the pads
(which is the right approach), and because he thinks the MIT solution
will be slow. Rob replied that they need it to work now, and it is more
important for it to work than for it to work speedily. [Sarathy's reply
to the
patch](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00853.html)

is probably the most illuminating. Rob said that they probably don't
have time to do it the right way.

### [`Safe::Hole`]{#Safe::Hole}

Yasushi Nakajima announced a new module, `Safe::Hole`, which allows you
to install a subroutine into a `Safe` compartment so that it can be
called by code in the compartment but still run in the original
compartment; similarly you can install an object into a compartment so
that method calls on the object proceed outside the compartment.
Yasushi's example is:

Suppose you have a CGI program that wants to evaluate some user code in
a safe compartment and to give it access to the `CGI` object. Just
installing the `CGI` object into the compartment is not enough because
then the object's methods are inaccessible. Instead, wrap up the `CGI`
object in a `Safe::Hole` object and install the `Safe::Hole` object into
the compartment. Now you can make method calls on the `Safe::Hole`
object inside the compartment and they will be forwarded to the
appropriate subroutines outside.

### [`PREPARE`]{#PREPARE}

( [Earlier
summary](/pub/1999/10/p5pdigest/THISWEEK-19991017.html#prepare))

Following [Sarathy's earlier
request](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-10/msg00356.html),
Ilya reworked his earlier `PREPARE` patch so that invocation of
`PREPARE` methods is enabled by a compile-time pragma.

[The
patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00882.html)

### [Marshalling Modules]{#Marshalling_Modules}

David Muir Sharnoff has some module which, like `MLDBM`, needs to talk
to an unknown marshalling module such as `Storable` or `Freezethaw`.
[Last
week](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00567.html),
he noted that `MLDBM` contained a lot of code that informed it about how
to talk to these various serializers. David suggested that authors of
marshalling modules try to adhere to a common intereface.

Raphael Manfredi, one of the authors of `MLDBM`, said that this would be
unlikely, since the various marshalling modules have different
interfaces for a good reason, namely that they do not all do the same
thing. For example, `Storable` has an `nstore` method that guarantees
network byte order. But byte order is totally irrelevant to the
representation used by `Data::Dumper`.

David then suggested that someone extract the serializer-interface code
from `MLDBM` so that it could be borrowed by other modules that need
serializers. If anyone was looking for a useful project to do, this
might be a good opportunity.

### [Local Address in `LWP`]{#Local_Address_in_LWP}

[A few weeks ago](../10/THISWEEK-19991031) Gisle Aas suggested having
`IO::Socket` pay attention to the `LocalAddr` environment variable. This
week, [Graham explained why this would be a bad
idea](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00577.html).

### [`local()`izing `select()` and `chdir()`]{#localizing_select_and_chdir}

Jeff Pinyan suggested that `local()` be extended to apply to these,
although he did not provide a patch. I pointed out that such semantics
are already implemented by modules like `SelectSaver`, and that the
`Alias` module shows how an XS module can export arbitrary semantics
into a block that will be undone automatically when the block is exited.
I also pointed out (apparently unintelligibly, since Sarathy repeated it
in the next message) that it owuld be easy to write an XS module which
specifies that an arbitrary user-supplied anonymous function be invoked
at block exit time; then it would be easy to write a `temp_chdir()`
function whose effect was automatically undone at the end of the block.
Someone should write this.

### [Wandering Environment]{#Wandering_Environment}

Joerg Schumacher found a core-dmuping bug. Here is the explanation: He
uses the `Term::Readline::Gnu` module. When this is laoded, it checks
for `LINES` and `COLUMNS` environment variables and installs them if
they are not present. It uses the `putenv` function for this, and in
this case `putenv` relocates the entire environment. Later, he uses the
`%ENV` hash to set an environment variable. Normally, the first time you
set an environment variable, perl relocates the environment elsewhere so
that it can do memory management on it in a more convenient way,
including freeing individual environment variable strings. How does Perl
know whether it is the first time or not? It compares the current
location of the environment ( `environ`) with the location that the
environment was in at the time perl started ( `PL_origenviron`); if they
are the same, it relocates the environment.

However, in Joerg's case, the environment had already been relocated by
`putenv()`. The \`first-time' test failed when it should have succeeded,
and Perl supposed that it had already relocated the environment itself.
Then it tried to do memory management on the environment which it
thought it had but allocated but had not, and the result was a core
dump. Joerg supplied a patch that has perl keep an explicit boolean
variable that records whether or not it has moved the environment,
instead of depending on the hack of testing to see whather or not it is
in the same place it was when Perl started.

Ilya appeared not to understand the problem description, and argued with
Joerg a lot, but if there was anything in his argument I was not able to
discern it. Joerg was remarkably patient through all of this.

Then Tom and Ilya had a big worthless argument which should have been
carried on in private email.

There were fifty-four messages in this thread. I will generously award
it a S/N ratio of 1.21e-01.

### [Localized Assignment]{#Localized_Assignment}

Andre Pimlott reported that

     { local ($/ = undef); ... }

not only doesn't do what was wanted, but doesn't appear to do anything
sensible at all. (For example, someone suggested that it does the
assignment to `$/` first, and then localizes, but this appears not to be
so.) It appears to be a real bug.

### [`goto` out of scope of `local`]{#goto_out_of_scope_of_local}

Ilya complained that using magical `goto` to exit the scope of a `local`
undoes the localization:

     $a = 5;
     sub a { print $a }
     sub b {local $a = 9; goto &a}
     b();

This prints 5, and he wants it to print 9. (Note that Ilya's original
report contains an error; he has `local $b` instead of `local $a`.) The
reason he wants this is so that he can do:

     local @ISA = (@ISA, 'DynaLoader');
     goto \&DynaLoader::bootstrap;

Nick Ing-Simmons suggested that he do this instead:

     {
       local @ISA = (@ISA, 'DynaLoader');
       &DynaLoader::bootstrap;
     }

Of course, that leaves the original call on the call stack so that (for
example) messages from `Carp` might be confused about where to report an
error from. In the case of `Carp` there actually is no problem.
Discussion ended abruptly.

### [`use foo if bar`;]{#use_foo_if_bar;}

Ilya contributed a patch to enable this syntax, and similarly `unless`.
It does this by faking up a `BEGIN` block, but without the scoping
effects of a real block. (The scoping effects are the reason why the
programmer cannot simply use `BEGIN` here in the first place.)

Steve Fink contributed an amendment to Ilya's patch. Tom Christiansen
sent a giant message complaining that the feature was yet another weird
special case. Some discussion of alternatives ensued, with no conclusion
that I could see.

Tom Christiansen suggested a `no scope` pragma, which would \`erase' one
set of braces. Then you could say something like

     BEGIN {
       no scope;
       if (SOMETHING) {
         no scope;
         use integer;
       }
     }

And the `no scope` declarations would upscope the effectof the
`use integer` pragma so that its effect continued to the end of the
file.

Larry had [many interesting things to say about
this](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00866.html);
the most straightforward was that something like `use comppad` should
just upstack declarations all the way to the top of whatever code was
currently being compiled.

[Ilya
said](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00873.html)
that that behavior was already available to any module that uses the
hints variables `$^H` or `%^H`.

### [`croak` confounds `eval`]{#croak_confounds_eval}

David Blumenthal reported a problem in `IPC::Open3`: It forks a child,
which tries to exec your command, and if it can't, the child croaks. If
the `open3` call was inside an `eval` block, that means that the child
returns from the `eval` block without exiting and your program gets a
big surprise. David suggests that it should use `carp` instead and then
call `exit`.

I mention this because probably a lot of other modules have similar
problems. Modules should never call `croak` or `die`.

### [Control-backslash]{#Control_backslash}

Philip Newton pointed out that there was no way to generate a
control-backslash using the `\c` notation. Neither `"\c\"` nor `"\c\\"`
works. The first complains about an unmatched quotation mark, and the
second generates a control-backslash followed by a regular backslash. (
`\x1c` and the like do work.)

The reason for this is explained in detail in `perlop`, in the section
titled \`Gory details of parsing quoted constructs'.

### [Empty Conditional in `while()`]{#Empty_Conditional_in_while}

Greg Bacon reported that

     while () { CODE }

is legal, and is an infinite loop. This turns out not to be a bug; it is
because you are supposed to get an empty loop if you leave out the
condition in a `for (;;)` block, and `for(;;)` and `while()` are the
same thing. Larry even said he allowed the empty condition in `while()`
on purpose back in Perl 1. Ilya asked why not get rid of it, similar to
the way that `if BLOCK BLOCK` was gotten rid of. Larry pointed out that
the two cases are not really analogous: `if BLOCK BLOCK` was removed (or
broken) entirely by accident and that the only reason this was never
fixed was that nobody at all complained about it.

### [Undefined Function Warning]{#Undefined_Function_Warning}

Mike Taylor wrote in to ask for a warning that would announce (at
compile time) the presence of calls to undefined functions. Dan Sugalski
enumerated some of the reasons why there isn't already such a warning:
`AUTOLOAD`ed functions; calls to platform-specific functions guarded by
`if ($^O eq 'Eniac')`; functions loaded by `require`; people getting
funky with the symbol table.

Tom Christiansen pointed out that
`perl -MO=Lint,-context,-undefined-subs    program` does something like
this already. That seemed to satisfy Mike.

### [Static Extensions]{#Static_Extensions}

Margie Levine asked about compiling perl with statically-linked
extensions. Andy Dougherty replied that all the documentation may have
gotten lost, the best way it to just dro pthem in the `ext/` directory
before you run `Configure`, which is supposed to notice the extensions
and built them as if they were part of the standard set.

### [POD Hack]{#POD_Hack}

Ilya points out that a construction like this:

     C<S<
      code with I<..> or L<...> escapes or whatever
     >>

Will generate an indented code paragraph that can still contain pod
escapes for hyperlinks or whatever.

### [Perl Art]{#Perl_Art}

Greg Bacon reported [an
entertainment](http://www4.telge.kth.se/~d99_kme/). (The background is
Perl code.) There was some discussion about generating pictures of
llamas and the like in a similar medium.

### [`localtime()` Contest Continues]{#localtime_Contest_Continues}

Try to guess how many bogus bug reports about the `localtime()` function
will be submitted next year. Visit
[http://www.plover.com/\~mjd/perl/y2k/y2k.cgi.](http://www.plover.com/~mjd/perl/y2k/y2k.cgi)

### [Various]{#Various}

A large collection of bug reports, bug fixes, non-bug reports,
questions, answers, and a small amaount of flamage. (No spam this week.)

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199911+@plover.com)


