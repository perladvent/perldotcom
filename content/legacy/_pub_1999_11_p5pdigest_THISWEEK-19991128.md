{
   "authors" : [
      "mark-jason-dominus"
   ],
   "draft" : null,
   "description" : " Notes New Meta-Information Thread Model Discussion Discussion of Line Disciplines Continues Shadow Passwords Bugs in NT Perl Sockets? Run Out of File Descriptors Lexical Variable Leak Control-Backslash Bitwise Operators Taint Bug? next Outside a Block Quiet List Various Notes...",
   "slug" : "/pub/1999/11/p5pdigest/THISWEEK-19991128.html",
   "title" : "This Week on p5p 1999/11/28",
   "image" : null,
   "categories" : "community",
   "date" : "1999-11-28T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : []
}



-   [Notes](#Notes)
-   [New Meta-Information](#New_Meta_Information_)
-   [Thread Model Discussion](#Thread_Model_Discussion)
-   [Discussion of Line Disciplines Continues](#Discussion_of_Line_Disciplines_Continues)
-   [Shadow Passwords](#Shadow_Passwords)
-   [Bugs in NT Perl Sockets?](#Bugs_in_NT_Perl_Sockets?)
-   [Run Out of File Descriptors](#Run_Out_of_File_Descriptors)
-   [Lexical Variable Leak](#Lexical_Variable_Leak)
-   [Control-Backslash](#Control_Backslash)
-   [Bitwise Operators](#Bitwise_Operators)
-   [Taint Bug?](#Taint_Bug?)
-   [`next` Outside a Block](#next_Outside_a_Block)
-   [Quiet List](#Quiet_List)
-   [Various](#Various)

### <span id="Notes">Notes</span>

This report is very late, because I was in London from 26--29 November, and then when I got back I had to finish preparing class materials for a class I was teaching in Chicago from 6--8 December, and when I got back from *that* I had to prepare class materials for a class I was teaching in New York from 14--16 December. Then I had to recover. Now I'm going to try to catch up on reports. My apologies for the delay.

#### <span id="New_Meta_Information_">New Meta-Information</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

### <span id="Thread_Model_Discussion">Thread Model Discussion</span>

In the last report, I posted an explanation by Dan Sugalski of the current threading model and the new one that would be used in 5.005\_53. [(Here it is.)](/pub/1999/11/p5pdigest/THISWEEK-19991121.html#Shared_Interpreter_threads_the_current_model)

This reopened debates about the feasibility of the new model, and Dan, Sarathy, and Ilya had a medium-long discussion about it. The debate centered around how much stuff gets cloned when you fork a new thread/process. Here's my probably-too-brief summary: Under the new model, when you start a new thread, the Perl stack is cloned and each thread gets a separate clone. But you can also request `fork()`-like semantics, in which case all global variables also get cloned. This will allow forkless Windows platforms to emulate `fork()` with threads. In either case, the op tree (which is read-only) is shared between threads.

The debate centered around the largeness of the amount of data that would need to be cloned. [Sarathy claims that even in the `fork` case the op tree outeighs the global data by a factor of 8.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00925.html)

The whole discussion was very interesting and is recommended reading. [The top of the discussion is here.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00912.html)

This and the ensuing discussion is worth reading if you are interested in the changes in Perl's threading model.

### <span id="Discussion_of_Line_Disciplines_Continues">Discussion of Line Disciplines Continues</span>

Much interesting discussion about line disciplines continues, this time in the context of having `<>` and `chomp()` behave properly, even when you have a remote-mounted NT fileststem where the files have `\r\n`-terminated lines. Goal: Perl should do the \`right thing' regardless of where the file is located. The subtext here is that Perl should also do the \`right thing' when reading from an ISO-Latin-1 file, an EUC-KR encoded file in Korean, or a SHIFT-JIS encoded file in Japanese.

> **Larry:** I expect people to expect Perl to do the right thing.

[Earlier Discussion](/pub/1999/11/p5pdigest/THISWEEK-19991121.html#Chomp)

[Still Earlier Discussion](/pub/1999/11/p5pdigest/THISWEEK-19991114.html#More_About_Line_Disciplines)

[Guess What](/pub/1999/11/p5pdigest/THISWEEK-19991107.html#Record_Separators_that_Contain_NUL)

### <span id="Shadow_Passwords">Shadow Passwords</span>

Jochen Wiedmann compained abuot the support for shadow password files. If your vendor supprots them transparently via the usual `getpw*` calls, Perl supports them too; otherwise you're out of luck. In fact this is a frequently asked question: How to get the shadow password?

There are at least two schools of thought on this. School of thought \#1 is that when you make a `getpw*` call, you should get back the usual seven items, except that if you're on a system with shadow passwords and you're not rnuning as root, you get back `x` or `*` or some such instead of the real password; thus no new interface is required. The author of the man page (see `perlfunc/getpwent`) apparently subscribes to this school of thought.

School of thought \#2 is that `getpw*` should always return a password of `x`, and instead there should be special calls, probably named `getsp*` or something similar, for reading the shadow password file.

Advantages of school \#1: No program needs to be rewritten or even modified when you switch from traditional password style to shadow passwords. Advantages of school \#2: No program will get the passwords written into its memory unless it specifically asks for them, regardless of whether or not it happens to be run by root; having programs suddenly become riskier just because they are running as root is a Bad Thing.

Anyway, Sarathy reports that as of 5.005\_57, Perl has gone entirely over to school \#1 and will emulate that behavior even if you are on a system that belongs to school \#2. If you call any of Perl's `getpw*` functions, and your program is running as root, then Perl will make a `getsp*` call to fill in the password as if it had been returned by the `getpw*` call in the first place.

I seem to remember that debate on whether or not this was advisable continued the following week, so I'll follow up in the next report.

### <span id="Bugs_in_NT_Perl_Sockets?">Bugs in NT Perl Sockets?</span>

Phil Pfeiffer posted an interesting analysis of peculiarities of Perl network sockets under NT. I found these interesting, but there was no discussion. Of course, it is probably NT's fault, but it would be nice to see these fixed anyway. As Larry has said \`\`The Golden Gate wasn't our fault either, but we still put a bridge across it.'' [Read it.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00898.html)

### <span id="Run_Out_of_File_Descriptors">Run Out of File Descriptors</span>

Yossi Klein was puzzled because Perl limited him to 256 open files, even when he used `sysopen` to try to open the files without using the Standard I/O library. Of course, even if you use `sysopen`, it then takes the file descriptor that it gets from the system and attaches it to a filehandle, and that means it uses `fdopen` to create the stdio stream structure, and there's Standard I/O again.

### <span id="Lexical_Variable_Leak">Lexical Variable Leak</span>

Barrie Slaymaker reported a bug in 5.005\_61 in which a lexical variable in one file leaked into a different file that was being processed by `do`.

### <span id="Control_Backslash">Control-Backslash</span>

The discussion about semantics of control-backslash in a double-quoted string continued much longer than it should have, with the original correspondent proposing every possible alternative set of rules, and Ilya Zakharevich pointing out what was wrong with all of them. The original querent finally gave in.

### <span id="Bitwise_Operators">Bitwise Operators</span>

Someone was caught by the changed behavior of the `&` operator between Perl 4 and Perl 5. Tom Christiansen posted [a clear explanation.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/1999-11/msg00950.html) For some reason this topic was omitted from `perltrap`.

The discussion then turned towards how you can tell whether or not a string has ever been used in a numeric context. Larry suggested:

        length($x & "")

Tom Phoenix posted a patch to add an explanation to `perltrap`.

### <span id="Taint_Bug?">Taint Bug?</span>

David Muir Sharnoff appears to have found a case where doing a match and copying data into `$1` yields a tainted value instead of an untainted one. There was no discussion and I did not see a patch. (I should mention that starting this week I began to watch the patch FTP directory, but because of my travel schedule I did not have time to understand the patches.)

### <span id="next_Outside_a_Block">`next` Outside a Block</span>

Someone complained that

        map { next if ... } ... ;

yields the error message \`Can't "next" outside a block'. He claimed that the message was bad because clearly the `next` is in a block. Larry agreed that it should say \`loop' instead of \`block'. I didn't see a patch, however.

### <span id="Quiet_List">Quiet List</span>

Traffic was low for a while, so Nat Torkington sent out a ping message:

> **Nat:** Just testing whether all of p5p has fallen quiet, or whether the mailing list manager is constipated.
> **Kurt Starsinic:** The perl5-porters are on vacation, and will be until noon on November 25. If your need is urgent, please contact `python-help@python.org`.
> Thank you.

### <span id="Various">Various</span>

A large collection of bug reports, bug fixes, non-bug reports, questions, answers, spam, and a small amount of flamage.

Until next time (probably Tuesday or Wednesday) I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199911+@plover.com)
