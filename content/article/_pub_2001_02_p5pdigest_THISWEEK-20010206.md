{
   "date" : "2001-02-06T00:00:00-08:00",
   "categories" : "community",
   "title" : "This Week on p5p 2001/02/06",
   "image" : null,
   "tags" : [],
   "thumbnail" : null,
   "slug" : "/pub/2001/02/p5pdigest/THISWEEK-20010206.html",
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to p5p-digest-subscribe@plover.com. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Wow. 600 messages this week, and...",
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ]
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [p5p-digest-subscribe@plover.com.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month.

Wow. 600 messages this week, and that's not counting a lot of the test result messages.

### <span id="Perl_561_not_delayed_after_all">Perl 5.6.1 not delayed after all</span>

It had to happen. Just after I announced last week that 5.6.1 would be delayed, Sarathy announced the release of 5.6.1 trial 2. This is available for testing on CPAN at [$CPAN/authors/id/G/GS/GSAR/perl-5.6.1-TRIAL2.tar.gz](http://www.cpan.org/authors/id/G/GS/GSAR/perl-5.6.1-TRIAL2.tar.gz). Sarathy says:

> Thanks largely to Jarkko's help, the second trial version of perl v5.6.1 is now available. (CPAN may need some time to catch up.)
>
> If this release passes muster, I will update perldelta.pod and send it to CPAN as v5.6.1. Owing to the large number of patches, testing is very very important. So give it all you've got on all your favourite platforms!
>
> In particular, I'd like to see some purify (or similar) runs. Patches to documentation are also welcome. Changes to \*.\[ch\] are probably out unless they are fixing serious bugs.

Naturally, this produced a deluge of test results, the vast majority of which were successful. As usual, if you've got any weird and funky platforms, give it a spin.

And, of course, well done to Jarkko and Sarathy for putting this one together.

### <span id="MacPerl">MacPerl</span>

I forgot to mention this last week, but it's important enough for me to mention it this week: Chris Nandor has taken over the MacPerl pumpkin. If you have a Mac and you want to run Perl on it, (or even better, help move MacPerl up to 5.6.1) then you really ought to read Chris' [State of MacPerl](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-01/msg01724.html) posting.

### <span id="select_on_Win32">select() on Win32</span>

Barrie Slaymaker mentioned that he wanted to get `select()` working on Win32, and that Perforce were interested in funding the work. Nick Ing-Simmons said that the PerlIO abstraction layer would help with this:

> he problem is that on Win32 to use `select()` the Socket has to be in synchronous mode. While to use `WaitForMultipleEvents()` the Socket has to be in asynchronous mode - thus if you want to use Win32's native "poll-oid" API you cannot use `select()`. In addition MS's C runtime ( `read`/ `fread` etc) will not work on sockets in asynchronous mode (or non-blocking IO in general).
>
> So you need to replace `read` and `stdio` with another IO subsystem and get perl to use it - hence PerlIO.

Uri Guttman predictably took this as a cue to push for a portable event interface; Rocco Caputo said that he'd added an event-driven `IPC::Run`-style process communication model to his `POE` module which worked fine on Win32, using TCP sockets as a form of `select()`-able pipe emulation.

Nick wanted to work at the problem from the other end, by building up a new PerlIO bottom layer for Windows, using the native Windows IO calls. Sean McCune, who's working with Barrie on this, said that's what he would try to do. As Jarkko pointed out:

> First fork() emulation and now select()? If we are not careful in ten years or so NT/W2K/W2010 will be almost as useful as UNIX was in mid-1980's.

### <span id="TestHarness">Test::Harness</span>

At last, Schwern's Test::Harness patch made it in, after a tiny bit more messing around. The discussion turned into a useful thread on patching strategies. For instance, it's apparently not very widely known that if you add a new file to the Perl distribution, you also need to patch the `MANIFEST` file. There's also a load of good information in the file `Porting/patching.pod`. Andreas Koenig also put in a plug for Johan Vroman's `makepatch` utility:

> Johan Vromans has written a powerful utility to create patches based on large diretory trees -- makepatch. See the JV directory on CPAN for the current version. If you have this program available, it is recommended to create a duplicate of the perl directory tree against which you are intending to provide a patch and let makepatch figure out all the changes you made to your copy of the sources. As perl comes with a MANIFEST file, you need not delete object files and other derivative files from the two directory trees, makepatch is smart about them.

Nicholas Clark suggested that each time you plan to make a change, you can call configure with `-Dmksynlinks` which creates a symlink farm. Then when you change a file, remove the symlink and replace it with a real copy of the file. This means you can maintain multiple patch trees without the space overhead of full source trees. Other suggestions included various version control systems, and some people provided programs to sync up `bleadperl` with their local version control repository.

Schwern also came out with a load of documentation patches explaining the difference between `chop` and `chomp` from a portability point of view, and changing the examples to use `chomp` where they previously used `chop`.

### <span id="CHECK_blocks">CHECK blocks</span>

Piers Cawley asked about `CHECK` blocks

> I have a CHECK block that checks that all the methods requested by the interface are accessible. No problem.
>
> Until, one of my class's client classes comes to do a deferred load using require and everything falls over in a heap because it's
>
>      Too late to run CHECK block.
>
> And I can't, for the life of me, understand why.

So, what's a `CHECK` block? The idea is that they're supposed to be called after compilation is completed. They're intended to be used by the compiler backends, to save the program state once everything's been assembled into an op tree. However, there's no reason why you can't use them for other things instead.

The problem that Piers was coming up against was that we expect `CHECK` blocks to be run every time something is compiled, but this doesn't happen yet; Sarathy explains:

> In the current implementation, there is exactly one point at which CHECK and INIT blocks are run (this being the point at which the Compiler would do its work, when it saves and restores program state, respectively).
>
> But I believe Larry has stated that CHECK blocks should be able to run at the end of compilation of every individual "compilation unit", whatever that happens to be (file/BEGIN block/eval"").

As far as I'm aware, nobody is currently working on making those new semantics reality, but I don't think it would be too difficult.

### <span id="C_library_functions_in_the_core">C library functions in the core</span>

I compiled a list of standard C library functions that are either reimplemented in the Perl core, or redefined to have more predictable semantics. This helps you write more \`politically correct' internals code. For instance, instead of saying

     char *foo = malloc(10);

you should really say

     New(0, foo, 10, char);
    Read about it.

### <span id="Perl_for_Windows_CE">Perl for Windows CE</span>

So they beat me to it. Perl for Windows CE is finally available, at <http://www.rainer-keuchel.de/software.html>

Well done, Rainer, you mad individual.

### <span id="Various">Various</span>

Lupe Christoph came up with some patches to make Solaris's `malloc` the default rather than Perl's `malloc` on that platform; this works around a known problem with Perl's `malloc` with more than 2G of memory.

Doug MacEachern had a really neat patch which shared globs containing XSUBs across cloned Perl interpreters, something that could save a lot of memory for those embedding Perl. (Especially things that clone a lot of interpreters, like `mod_perl`)

And that's about it. Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
