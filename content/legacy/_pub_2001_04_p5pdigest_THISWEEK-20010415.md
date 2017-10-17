{
   "thumbnail" : null,
   "tags" : [],
   "date" : "2001-04-15T00:00:00-08:00",
   "image" : null,
   "title" : "This Week on p5p 2001/04/15",
   "categories" : "community",
   "slug" : "/pub/2001/04/p5pdigest/THISWEEK-20010415.html",
   "description" : " Notes You can subscribe to an email version of this summary by sending an empty message to perl5-porters-digest-subscribe@netthink.co.uk. Please send corrections and additions to perl-thisweek-YYYYMM@simon-cozens.org where YYYYMM is the current year and month. Changes and additions to the perl5-porters...",
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null
}



### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`perl5-porters-digest-subscribe@netthink.co.uk`.](mailto:perl5-porters-digest-subscribe@netthink.co.uk)

Please send corrections and additions to `perl-thisweek-YYYYMM@simon-cozens.org` where `YYYYMM` is the current year and month. Changes and additions to the [perl5-porters](http://simon-cozens.org/writings/whos-who.html) biographies are particularly welcome.

There were just under 300 messages this week.

### <span id="perl_beginners_list">perl-beginners list</span>

Casey West came up with the great idea of having a mailing list for Perl beginners. It's worth quoting extensively from his post:

> I have been throwing around the idea of a central place where Perl newcomers can come and ask FAQ questions and the like. My dream is to funnel all the RTFM traffic from p5p, c.l.p.\* and other such places. I would like to see a place where the newbies are accepted as people who just don't know yet. ...
>
> There are a few crucial things that must take place in order to make this list as effective as possible:
>
> \* Moderation. Flames must be removed at all times. It should be easy to be the newbie.
>
> \* Direction. Archives are a valuable resource. We don't do homework.
>
> \* Publicity. List and News Group FAQ's can and should list perl-newbies as the primary source for simple, 'new commer' questions. Questions of this nature should be immediatly redirected to perl-newbies.
>
> \* Teachers. They can and will ask, we must answer.
>
> At first I thought PerlMonks was this thing, however, PerlMonks is not an environment where newbies are alowed to ask simple questions answered in the documentation.

Abigail suggested that "learning how to uses available documentation isn't something unique for Perl - it should be standard practise for anyone out of primary school". While I personally agree with that, I think there's definitely a need for hand-holding as well, and I take my hat off to Casey for having done something about it.

Accordingly, the mailing list - called "beginners" to avoid people feeling demeaned by the "newbie" tag - has been set up. Mail `beginners-subscribe@perl.org` to get involved, whether you want to ask questions or to answer them.

Kevin Lenzo noted that he's set up a help IRC channel with Casey's goals in mind at `#perl-help` on `irc.rhizomatic.net`. Feel free to join in, but remember - no flames, no RTFMs, be nice.

### <span id="Dynamically_scoped_last">Dynamically scoped last()</span>

There was a very long and very pointless thread which started when Michael Schwern found the following bit of functionality:

        $ perl -wle 'sub foo { last; } while(1) { foo() }  print "Bar"'
        Exiting subroutine via last at -e line 1.
        Bar

He expected that to be an infinite loop, but the `last` actually ended the nearest loop, which is the `while` loop - `sub` isn't a loop, which is why you're not supposed to exit one with `last`. A million and one people pointed out that this was documented in `perlsyn`, but it seemed to be documented very confusingly.

But what about bare blocks, he cried? Well, they're actually loops, they're just loops that are executed once, replied Abigail, Dan and Graham in chorus. Schwern asked why Perl behaved like this; Dan answered:

> I think it makes the parser a bit simpler, because otherwise it would need to track loop starts and subroutine declarations and such to match up loops with lasts/redos/nexts. Plus you'd still need to walk the call stack with string evals, which'd be a bit of a mess.
>
> I can't really see any reason that last, redo, or next should propagate outside a subroutine, but it's probably a bit late to change this in perl 5

Abigail patched the documentation to make it explicit what's going on, and after a few iterations, came up with a patch that everyone broadly agreed on. After this brief burst of productivity, the discussion then got silly, and the referees started blowing whistles and giving free kicks.

In the end, Michael Schwern came up with some tests for the existing behaviour, plus some patches to rewrite the warnings to call the behaviour "deprecated".

Schwern also added tests for Exporter, which amazingly didn't have any to date - they even found a bug in `require_version`. He tried to open the `B::walkoptree_slow` container of annelids again, but Jarkko didn't take the bait.

### <span id="perlbug_Administration">perlbug Administration</span>

Jarkko reminded the world that there are - or at least, were - 1777 open bug ids, and suggested that the bug administrators get 5.6.1 installed and attack the bug database with all their might. Merijn found that all the HP/UX bugs were his smoke reports - how convenient! Ask suggested that Chris Nandor advertise for bug administrators on [Use Perl](http://use.perl.org/), and I shall do it here as well:

If you want to help out squashing Perl bugs, please get in touch with [Richard Foley](mailto:perlbug@rfi.net) who will tell you how to get involved. You don't need to be able to fix the bugs, although if you can, it obviously helps - we just need people to be able to run through the database and say "This is still a problem as of 5.6.1" or "I don't see this in 5.6.1 any more", and report back to us at P5P. A knowledge of the way P5P and bug squashing works - which you can get through the [P5P FAQ](http://simon-cozens.org/writings/p5p-faq) will be useful, although Richard will tell you all you need to know about the actual [bug database](http://bugs.perl.org/perlbug.cgi?req=webhelp) side of things. You can also subscribe to the [Bug Mongers mailing list](mailto:bugmongers@perl.org), but I have a feeling you're better off talking to Richard first.

### <span id="Problems_with_tar">Problems with tar</span>

Mike Guy found that he was unable to untar Perl 5.6.1 on Solaris and SunOS - Sarathy explained that the Solaris tar is broken for archives which contain long path names, so he used GNU tar instead. Robert Spier documented this fact in the README for CPAN.

Calle Dybedahl explained that it was the usual case of GNU versus the world:

> For paths longer than 100 characters, there are two incompatible standards for tar archives: GNU tar and the rest of the world. If you have such paths and built the archive with GNU tar, you must have GNU tar to unpack it.

Great, thought Sarathy - but we don't use any paths over 100 characters. It turned out that there were at least three different problems intersecting here: firstly, Mike's download was busted. Second, Solaris' tar is busted, but a patch has been issued, and thirdly, there are two different standards for tars - [Alan](http://simon-cozens.org/writings/whos-who.html#BURLISON) explained it [beautifully](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg00527.html).

### <span id="NetPing_and_the_stream_protocol">Net::Ping and the "stream" protocol</span>

Scott Bronson came up with an interesting idea for `Net::Ping`: because dynamic IPs exist, he needed to be able to both ping a host and ensure it was the same host he's pung in the past. So, he added a protocol to `Net::Ping` which keeps the connection alive between pings, and duly submitted the patch to P5P.

Colin McMillen, the maintainer of `Net::Ping`, recommended it for inclusion into bleadperl, and came up with some changes of his own, particularly to replace the `alarm` timeout with non-blocking IO using `select`. This made Scott unhappy:

> First of all, tcp ping is broken. Select won't return if you haven't written any data to be echoed. If you were to write data, however, that would disagree with the documentation: "No data bytes are actually sent since the successful establishment of a connection is proof enough of the reachability of the remote host." Which is it to be? And, how about warning me that it doesn't work before I start trying to figure out what I broke?
>
> I fixed this in the patch by writing some bytes to be echoed and reading them back. But I think this is a very bad idea. Also from the docs, "tcp is expensive and doesn't need our help to add to the overhead." You're changing Net::Ping's personality.

Colin defended his changes, saying that the current behaviour is horribly broken anyway, as has been discussed several times in the past. He also defended forking a new process for ping on Win32, since expensive Win32 functionality is better than none. Graham Barr also chimed in, demonstrating how to do a non-blocking connect and select with timeout, and noting that `alarm` is best avoided.

### <span id="Various">Various</span>

Rich Williams found a little bug with the regular expression optimizer in Perl 5.6.1 - apparently it only strikes when using `.*` together with `/sg`. However, he put in the time and the detective work to isolate it to a couple of patches, from which Sarathy and Hugo managed to squash the bug; [Gisle](http://simon-cozens.org/writings/whos-who.html#AAS) fixed `Digest::MD5` for UTF8 strings.

Peter Prymmer updated the `perlebcdic` documentation to document Nick Ing-Simmon's heroic UTF-EBCDIC effort. Tom Horsley complained about `perlbug` occasionally putting `~s ...the subject` and `~c ...the sender's email address` in the body of the mail instead of actually writing the headers properly - Kurt Starsinic explained that it was actually a bug in `Mail::Mailer` and a workaround is to set `PERL_MAILERS=mail:/no/such/thing`

Jonathan Stowe found some horrible bugs in SCO's `NaN` handling - `NaN` compares equal to 1.0 and less than 1.0. Urgh. Andy Dougherty suggested that we whip up a C program which tests for platforms with broken `NaN` and papers over the cracks in the test suite; Jarkko, on the other hand, was more sanguine as suggested that 5.7.2 will have to bite the `NaN` and `inf` bullets. Nick Clark pointed out that `$_ & ~0` will do weird things for many values of `$_`.

Vadim Konovalov found a problem with the `-f` operator in Cygwin - it interprets `-f "foo"` as `-f "foo" || -f "foo.exe"`. Urgh. Mike Giroux explained that it made some sense - programs on Windows want to execute `foo.exe` by saying just `foo`. Fair enough, but Vadim pointed out that there's code in `win32/win32.c` to work around this for Borland's C compiler, so this could be extended to Cygwin.

Robin Houston continued his conquest of `B::*`. His changes were [numerous](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2001-04/msg00641.html).

Jarkko has suggested that he wants to integrate `Time::HiRes` into 5.7.2 - after some time, the maintainer of the module was tracked down and subdued. There'll be a lot more about new module integration next week.

Aaron Mackey reported that building Perl on Mac OS X doesn't work properly because of problems with case-folding in the file system - if you're finding this, try adding `-Dmakefile=GNUmakefile` to the Configure command, and/or set the environment variable `LC_ALL=C`.

The `FETCHSLICE`/ `STORESLICE` idea reared its ugly head again, with Rick Delaney implementing a `FETCHSIZE` method. While it's certainly a good idea, Dave Mitchell pointed out it may well have the same problems as `*SLICE` when it comes to unscrupulously inheriting modules.

Eric Kolve noted that Perl does [Weird Things](http://bugs.perl.org/perlbug.cgi?req=bug_id&bug_id=20010411.004&format=H&trim=25&range=1277&target=perbug) if you try doing a `tie` inside of a `FETCH` from a tied variable - this isn't surprising, but it would be a good thing for someone with a bit of spare time to look into.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Simon Cozens](mailto:simon@brecon.co.uk)
-   [Notes](#Notes)
-   [perl-beginners list](#perl_beginners_list)
-   [Dynamically scoped last()](#Dynamically_scoped_last)
-   [perlbug Administration](#perlbug_Administration)
-   [Problems with tar](#Problems_with_tar)
-   [Net::Ping and the "stream" protocol](#NetPing_and_the_stream_protocol)
-   [Various](#Various)

