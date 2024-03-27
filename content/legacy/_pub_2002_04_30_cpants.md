{
   "slug" : "/pub/2002/04/30/cpants.html",
   "description" : " &quot;This is a great war long-planned, and we are but one piece in it, whatever pride may say. ... And now, all realms shall be put to the test.&quot; - Beregond, &lt;&lt;Lord of the Rings&gt;&gt; Introduction In CPANPLUS -...",
   "authors" : [
      "autrijus-tang"
   ],
   "draft" : null,
   "date" : "2002-04-30T00:00:00-08:00",
   "image" : null,
   "title" : "Becoming a CPAN Tester with CPANPLUS",
   "categories" : "cpan",
   "thumbnail" : "/images/_pub_2002_04_30_cpants/111-test_mods.gif",
   "tags" : [
      "cpanplus-testing-cpants-cpan"
   ]
}



> *"This is a great war long-planned,
> and we are but one piece in it,
> whatever pride may say.
> ... And now, all realms shall be put to the test."
> -- Beregond, &lt;&lt;Lord of the Rings&gt;&gt;*

### <span id="introduction">Introduction</span>

In [*CPANPLUS -- Like CPAN.pm only better?*](#f1), Jos Boumans recounted the tale of how his **CPANPLUS** project came to be; one of the original goals was to provide a modular backend to *CPANTS*, the CPAN Testing Service, so modules can be automatically built and tested on multiple platforms.

Although the initial **CPANPLUS** release did not support testing-related features, Jos considered them important enough to be listed near the top of his *Current and Future Developments* wish list, and quoted Michael Schwern's opinion on their potential benefits[<sup>\*</sup>](#f2):

> *It would alter the way free software is distributed. It would get a mark of quality; it would be tested and reviewed. And gosh darnit, it would be good.*

At that time, despite having participated in CPANPLUS's development for more than four months, I was blissfully unaware of the project's original vision. But it seemed like a worthwhile goal to pursue, so I quickly jotted down several pieces that need to work together:

-   Check test reports of modules before installation.

-   Report `make test` results to the author, and make them available for other users to check.

-   Tools to batch-test modules with or without human intervention.

-   A clean API for other programs to perform tests, reporting and queries.

Today, with the 0.032 release of **CPANPLUS**, all the above pieces are completed. This article will show you how to configure and use these tools, as well as describing some important new features in **CPANPLUS** that made them possible.

### <span id="setting up the environment">Setting Up the Environment</span>

First, you need a copy of **CPANPLUS** 0.032 or above. I recommend the tarball automatically built from the *distribution branch*, available at <http://egb.elixus.org/cpanplus-dist.tar.gz>; it should contain the latest bug-fixes and features marked as *stable*.

Since Jos' article and README already contain install instructions, I will not repeat the details. However, please note that the dependency detection logic in *Makefile.PL* has been changed since Jos' previous article, which means when faced with this prompt:

     [CPAN Test reporting]
     - Mail::Send           ...failed! (needs 0.01)
     - File::Temp           ...loaded. (0.13 >= 0.01)
     ==> Do you wish to install the 1 optional module(s)? [n]

You should generally answer `y` here, as only modules that can safely install on your machine are displayed. The default `n` does not mean we don't recommend it; it merely means it isn't mandatory for the bare-bone **CPANPLUS** to function.

For this article's purpose, you need to answer `y` to all such questions, since we will be using **LWP**, **Mail::Send** and **IPC::Run** extensively in testing-related functions.

After running *Makefile.PL*, you should run `make test`[<sup>\*</sup>](#f3) like every good user; if any dependent modules were selected in the previous step, then you will have to run `make test` as root, so it can fetch and install these modules automatically before testing itself.

After the comforting `All tests successful` message appears on your screen, just do a `make install`, and we are ready to go.

### <span id="why is testing important">Why Is Testing Important?</span>

... or not. What if, instead of `All tests successful`, you see a series of cryptic messages:

     % sudo make test
     /usr/bin/perl Makefile.PL --config=-target,skiptest
     --installdeps=Term::Size,0.01
     *** Installing dependencies...
     *** Installing Term::Size...
     Can't bless nonreference value at lib/CPANPLUS/Internals/Module.pm
     line 239.
     Compilation failed in require at Makefile.PL line 20.
     make: *** [installdeps] Error 255

An experienced Perl user will probably take the following steps:

-   Look at *lib/CPANPLUS/Internals/Module.pm* and see whether it's a trivial mistake. Unfortunately, it is not.
-   Search README for the project's mailing list address. Discovering that it's hosted in SourceForge, check Geocrawler (or any search engine) for existing bug reports and discussions. Unfortunately, there are none.
-   Copy-and-paste the error message into a bug-reporting e-mail to the mailing list, including your operating system name and version, Perl version, and wait for a fix.

Apparently, the above is exactly what Juerd Waalboer (the bug's original reporter) did when he ran into this trouble. Thanks, Juerd!

However, there are a number of problems with the procedure above. It might be thwarted at every step:

-   What if Juerd had been less experienced, and unaware of this bug-reporting procedure?

-   What if he decided to kluge around it by commenting out line 239, instead of taking the laborious copy-and-paste path to report it?
-   **CPANPLUS** has a mailing list; other modules might not. Worse, they may not even have a working contact address -- maybe the author is on vacation.
-   He might not have the sense to provide adequate debug-related data, and simply wrote `CPANPLUS didn't work! It can't install!#!@#@#!` in red-colored blinking HTML email, wasting bandwidth and causing developers to ignore his mail completely.
-   Even after a fix was made available, and posted as a patch on the mailing list, other people about to install **CPANPLUS** 0.03 still have no way to find out about it beforehand. Thus, when the same problem occurs again, they may forget to search in the archives, resulting in duplicate bug reports, or (worse) more dissatisfied users.
-   Actually, we had not mentioned the very likely scenario: What if Juerd didn't run `make test` at all? If so, the developers will have no way to know that this bug has ever happened.
-   Finally, while **CPANPLUS** (like most CPAN modules) includes a regression test suite, some modules may omit their tests altogether. Users may not feel comfortable to mail the author to request a test script to accompany the distribution; consequently, bugs will surface in harder-to-detect ways, and may never get fixed.

As you can see, both authors and users can certainly benefit a lot from an improved test reporting system -- one that simplifies the process of reporting a failed (or successful) installation, and allows users to check for existing reports before downloading a module.

Such a system already exists; it's called *CPAN Testers*.

### <span id="what is cpan testers">What Is *CPAN Testers*?</span>

When most people run `make test`, it's immediately followed by a `make install`; that is, people only test modules that they are going to use. But they may not have the time or inclination to report the outcome, for various reasons listed above.

*CPAN Testers* (<www.cpantesters.org>) is an effort to set up a *Quality Assurance* (*QA*) team for CPAN modules. As its homepage states:

     The objective of the group is to test as many of the
     distributions on CPAN as possible, on as many platforms
     as possible.

     The ultimate goal is to improve the portability of the
     distributions on CPAN, and provide good feedback to the
     authors.

Central to its operation is a mailing list, *<cpan-testers@perl.org>*, and a small program, *cpantest*. The program is a convenient way to report a distribution's test result, which is sent to the mailing list using an uniform format. For example:

     # test passed, send a report automatically (no comments)
     cpantest -g pass -auto -p CPANPLUS-0.032
     # test failed, launch an editor to edit the report, and cc to kane
     cpantest -g fail -p CPANPLUS-0.032 kane@cpan.org

The argument (`pass`/`fail`) after the **-g** option is called the *grade* -- the overall result of a test run. It may also be `na` (not available), which means the module is not expected to work on this platform at all (**Win32::Process** on FreeBSD, for example), and `unknown` in the case that no tests are provided in the distribution.

All recent CPAN uploads, as well as all test results, are forwarded to the `cpan-testers` mailing list's subscribers -- CPAN testers. After a distribution's release on CPAN, one or more testers will pick it up, test it, then feed the result back to the author and to the list. The testers don't have to know what the module is about; all they do is to ensure it's working as advertised.

Test reports on the mailing list are automatically recorded in a ever-growing database. [http://www.cpantesters.org/](http://www.cpantesters.org/) is its search interface, where you can query by distribution name, version, or the testing platform.

Theoretically, you can query that database before installing any CPAN module, to see whether it works on your platform, and check for associated bug reports. The same information is also present at each module's page in [MetaCPAN](https://metacpan.org/), and maybe [CPAN RT](http://rt.cpan.org/) in the near future.

Alas, while this system certainly works, it is far from perfect. Here are some of its shortcomings:

-   The integration between Web site and mailing list hadn't extended to the *CPAN.pm* shell, so checking for test results requires an additional step to navigate the Web browser.
-   People who aren't subscribed to the `cpan-testers` list rarely submit test reports, so coverage of platforms is limited to a few popular ones; a heavily used module may still be tested in only two or three platforms, hardly representing its entire user base.
-   There are no *smoking* (automatic cross-platform testing) mechanisms; all testers must manually fetch, extract, test and submit their test reports, including the same copy-and-paste toil we described earlier. This entry barrier has seriously limited the number of active volunteer testers.

Fortunately, **CPANPLUS** addressed most of these issues, and made it significantly easier to participate in testing-related activities. Let's walk through them in the following sections.

### <span id="checking test reports">Checking test reports</span>

CPANPLUS offers a straightforward way to check existing reports. Simply enter `cpanp -c ModuleName` in the command line:

     % cpanp -c CPANPLUS
     [/K/KA/KANE/CPANPLUS-0.032.tar.gz]
     PASS freebsd 4.5-release i386-freebsd

As you can see, this reports the most recent version of **CPANPLUS**, which passed its tests on FreeBSD as of this writing.

You can also specify a particular version of some distribution. For example, the version Juerd was having problems with is 0.03, so he can do this:

     % cpanp -c CPANPLUS-0.03
     [/K/KA/KANE/CPANPLUS-0.03.tar.gz]
         FAIL freebsd 4.2-stable i386-freebsd (*)
         PASS freebsd 4.5-release i386-freebsd (*)
         PASS linux 2.2.14-5.0 i686-linux
     ==> http://testers.cpan.org/search?request=dist&dist=CPANPLUS

As you can see, there are three reports, two of which contain additional details (marked with `*`), available at the URL listed above. The failed one's says:

     This bug seems to be present in machines upgrading to 0.03
     from 0.01/0.02 releases.
     (It has since been fixed in the upcoming 0.031 release.)

Which exactly addressed Juerd's original problem.

Another useful trick is using the `o` command in the CPANPLUS Shell to list newer versions of installed modules on CPAN, and check on them all with `c *`:

     % cpanp
     CPAN Terminal> o
     1   0.14     0.15   DBD::SQLite        MSERGEANT
     2   2.1011   2.1014 DBD::mysql         JWIED

     CPAN Terminal> c *
     [/M/MS/MSERGEANT/DBD-SQLite-0.15.tar.gz]
         FAIL freebsd 4.5-release i386-freebsd (*)
         PASS linux 2.2.14-5.0 i686-linux
         PASS solaris 2.8 sun4-solaris
     ==> http://testers.cpan.org/search?request=dist&dist=DBD-SQLite

     [/J/JW/JWIED/DBD-mysql-2.1014.tar.gz]
         FAIL freebsd 4.5-release i386-freebsd (*)
         PASS freebsd 4.5-release i386-freebsd
     ==> http://testers.cpan.org/search?request=dist&dist=DBD-mysql

This way, you can safely upgrade your modules, confident in the knowledge that the newer version won't break the system.

### <span id="reporting test results">Reporting Test Results</span>

Despite the handy utility of the `c` command, there will be no reports if nobody submits them. **CPANPLUS** allows you to send a report whenever you've done a `make test` in the course of installing a module; to enable this feature, please turn on the `cpantest` configuration variable:

     CPAN Terminal> s cpantest 1
     CPAN Terminal> s save
     Your CPAN++ configuration info has been saved!

Afterward, just use CPANPLUS as usual. You will be prompted during an installation, like below:

     CPAN Terminal> i DBD::SQLite
     Installing: DBD::SQLite
     # ...
     t/30insertfetch....ok
     t/40bindparam......FAILED test 25
         Failed 1/28 tests, 96.43% okay
     t/40blobs..........dubious
         Test returned status 2 (wstat 512, 0x200)
         DIED.  FAILED tests 8-11
         Failed 4/11 tests, 63.64% okay
     Failed 2/19 test scripts, 89.47% okay.
     5/250 subtests failed, 98.00% okay.
     *** Error code 9
     Report DBD-SQLite-0.15's testing result (FAIL)? [y/N]: y

It always defaults to `n`, so you won't send out bogus reports by mistake. If you enter `y`, then different actions will happen, depending on the test's outcome:

-   For modules that passed their tests, a `pass` report is sent out immediately to the `cpan-testers` list.
-   For modules that didn't define a test, an `unknown` report is sent to the author and `cpan-testers`; the report will include a simple test script, encourage the module author to include it in the next release, and contain a URL of Michael Schwern's **Test::Tutorial** manpage.
-   If the module fails at any point (`perl Makefile.PL`, `make`, or `make test`), then the default editor is launched to edit its `fail` report, which includes the point of failure and the captured error buffer.

    You are free to add any text below the `Additional comments` line; to cancel a report, just delete everything and save an empty file.

Before sending out a `fail` report, be sure to double-check if it is really the module's problem. For example, if there's no *libgtk* on your system, then please don't send a report about failing to install **Gtk**.

Also, be prepared to follow up with additional information when asked. The author may ask you to apply some patches, or to try out an experimental release; do help the author whenever you can.

### <span id="batch testing and cpansmoke">Batch Testing and *cpansmoke*</span>

While regular users can test modules as they install via the `cpantest` option, and often provide important first-hand troubleshooting information, we still need dedicated testers -- they can broaden the coverage of available platforms, and may uncover problems previously unforeseen by the author. Dedicated testing and regular reports are complementary to each other.

Historically, CPAN testers would watch for notices of recent *PAUSE* uploads posted on the `cpan-testers` list, grab them, test them manually, and run the *cpantest* script, as we've seen in [What is *CPAN Testers*?](#what%20is%20i%3Ccpan%20testers%3E). That script is bundled with **CPANPLUS**; please refer to its POD documentation for additional options.

However, normally you won't be using it directly, as **CPANPLUS** offers the *cpansmoke* wrapper, which consolidates the *download =&gt; test =&gt; copy buffer =&gt; run cpantest =&gt; file report* procedure into a single command:
     % cpansmoke Mail::Audit Mail::SpamAssassin          # by module
     % cpansmoke Mail-Audit-2.1 Mail-SpamAssassin-2.20   # by distname
     % cpansmoke /S/SI/SIMON/Mail-Audit-2.1.tar.gz       # or full name

Due to the need of testing new distributions as they are uploaded, *cpansmoke* will use <https://www.cpan.org/> as its primary host, instead of the local mirror configured in your **CPANPLUS** settings. This behavior may be overridden with the **-l** flag.

Since *cpansmoke* will stop right after `make test` rather than installing any modules, it can test modules with different versions than the ones installed on the system. However, since it won't resolve prerequisites by default, you'll need to specify the **-p** flag to test and report them.

The **-d** flag will display previous results before testing each module; similarly, **-s** will skip testing altogether if the module was already tested on the same platform. The latter should only be used with automated test (to reduce spamming), since the same platform can have different results.

There are numerous other flags available; please consult *cpansmoke*'s manpage for further information.

### <span id="automatic testing">Automatic Testing</span>

Besides interactive batch-testing, *cpansmoke* also provides the capability of *unattended testing*; this concept is also covered by Mozilla Project's **Tinderbox** toolkit, as explained in its homepage:

     There is a flock of dedicated build machines that do
     nothing but continually check out the source tree and
     build it, over and over again.

Essentially, if you have a machine with plenty of hard disk space and adequate bandwidth, you can set up *cpansmoke* so it tests each new module as it is uploaded.

The **-a** option lets *cpansmoke* enter the non-interactive mode. In this mode, only failures during `make test` are reported, because errors that occured during `Makefile.PL` or `make` are more likely the machine's problem, not the module's.

Additionally, you should specify the *-s* flag to avoid duplicate reports, and *-p* to avoid false-negatives caused by unsatisfied dependencies.

Setting up an auto-smoking machine is simple, using a mail filtering mechanism; just join the CPAN Testers list by sending an empty email to *<cpan-testers-subscribe@perl.org>*, and add the lines below to your [**Mail::Audit** filter](#f4):

     fork || exec("sleep 40000 && cpansmoke -aps $1 >/dev/null 2>&1")
         if $mail->subject =~ /^CPAN Upload: (.*)$/;

This rule will fork out a new *cpansmoke* process for each incoming mail about a CPAN upload. Note that it works only if incoming mail arrives no less than once every hour; otherwise it might fork-bomb your system to a grinding halt.

In case you're wondering, the `sleep 40000` line is due to the fact that a PAUSE upload needs several hours to appear on *www.cpan.org*. Michael Schwern suggested that using a *smoke queue* would be a better solution, since it allows error-checking and logging; implementations are welcome.

If you are stuck with **procmail**, then here's the recipe that does the same (but do consider upgrading to **Mail::Audit**):

     :0hc
     * ^Subject: CPAN Upload:
     |sh -c "sleep 40000 && grep Subject|cut -f4 -d' '|xargs cpansmoke -aps >/dev/null 2>&1"

If you have suggestions on how to make this work on non-unix systems, please do let me know.

### <span id="testingrelated apis">Testing-Related APIs</span>

A programmable interface is the primary strength of **CPANPLUS**. All features listed above are available as separate methods of the **CPANPLUS::Backend** object. Since the module's manpage already contains detailed information, I'll just list some sample snippets below.

To show all reports of **Acme::\*** on FreeBSD:

     use CPANPLUS::Backend;
     my $cp = CPANPLUS::Backend->new;
     my $reports = $cp->reports( modules => [ map $_->{package}, values(
         %{ $cp->search(type => 'module', list => ['^Acme::\b']) }
     ) ] );

     while ( my ($name, $href) = each (%$reports) ) {
         next unless $href;
         my @entries = grep { $_->{platform} =~ /\bfreebsd\b/ } @$href;
         next unless @entries;

         print "[$name]\n";
         for my $rv (@entries) {
             printf "%8s %s%s\n", @{$rv}{'grade', 'platform'},
                                  ($rv->{detail} ? ' (*)' : '');
         }
     }

To test all **Acme::\*** modules, but install all needed prerequisites:

     use CPANPLUS::Backend;
     my $cp = CPANPLUS::Backend->new;
     $cp->configure_object->set_conf( cpantest => 1 );
     $cp->install(
         modules => [ map $_->{package}, values(
             %{ $cp->search(type => 'module', list => ['^Acme::\b']) }
         ) ],
         target        => 'test',
         prereq_target => 'install',
     );

If you need to fine-tune various aspects during testing (timeout, prerequisite handling, etc.), then please consult the source code of *cpansmoke*; most tricks involved are documented in comments.

Unfortunately, the process of editing and sending out reports remains as the only non-programmable part, since the *cpantest* script doesn't exist as a module. Although Skud has a **CPAN::Test::Reporter** on CPAN, its format is sadly out-of-sync with *cpantest*, and may generate invalid reports (as of version `0.02`). Any offers to back-port the *cpantest* script into that module would be greatly appreciated.

### <span id="conclusion">Conclusion</span>

As [*purl*](#f5) said, \`\`CPAN is a cultural mechanism.'' It is not an abstraction filled with code, but rather depends on people caring enough to share code, as well as sharing useful feedback in order to improve each other's code.

With the advent of [bug-tracking service](#f6) and automatic testing, the social collaboration aspect of CPAN is greatly extended, and could be developed further into a full-featured Tinderbox system, or linked with each module's source-control repositories.

Also, since **CPANPLUS** is designed to accommodate different package formats and distribution systems, it provides a solid foundation for projects like **Module::Build** (`make`-less installs), **NAPC** (distributed CPAN) and **ExtUtils::AutoInstall** (feature-based dependency probing)... the possibilities are staggering, and you certainly won't be disappointed in finding an interesting project to work on. Happy hacking!

### <span id="acknowledgements">Acknowledgements</span>

Although I have done some modest work in integrating **CPANPLUS** with CPAN testing, the work is really built on contributions from several brilliant individuals:

First, I'd like to dedicate this article to Elaine -HFB- Ashton, for her tireless efforts on Perl advocacy, and for sponsoring my works as described in this article.

Thanks also goes to Graham Barr and Chris Nandor, for establishing the CPAN Testers at the first place, and coming up with two other important cultural mechanisms: *CPAN Search* and *Use Perl;* respectively.

To Jos Boumans, Joshua Boschert, Ann Barcomb and everybody in the **CPANPLUS** team -- you guys rock! Special thanks for another team member, Michael Schwern, for reminding everybody constantly that *Kwalitee Is Job One*.

To Paul Schinder, the greatest tester of all time, who submitted 10551 reports by hand out of 23203 to date, and kept CPAN Testers alive for a long time. And thanks for every fellow CPAN Tester who have committed their valuable time -- I hope *cpansmoke* can shoulder your burden a little bit.

To Simon Cozens, for his swiss-nuke **Mail::Audit** module, and for keep asking me to write 'something neat' for *perl.com*. :-)

To Jarkko Hietaniemi, for establishing **CPAN**; and to Andreas J. Koenig, for maintaining **PAUSE** and showing us what is possible with **CPAN.pm**.

Finally, if you decide to follow the steps in this article and participate in the testing process, then you have my utmost gratitude; let's make the world a better place.

### <span id="footnotes">Footnotes</span>

1.  <span id="f1">It's an introductory text for the **CPANPLUS** project, available at</span>[http://www.perl.com/pub/2002/03/26/cpanplus.html](/pub/2002/03/26/cpanplus.html).
2.  <span id="f2">Jos later confessed that these are not exactly Schwern's words; he just made the quote up for dramatic effect.</span>
3.  <span id="f3">With ActivePerl on Windows, simply replace all `make` with `nmake`. If you don't have *nmake.exe* in your `%PATH`, our *Makefile.PL* is smart enough to fetch and install it for you.</span>
4.  <span id="f5">Purl, the magnet \#perl infobot, is also a cultural mechanism herself; see</span><http://www.infobot.org/> for additional information.
5.  <span id="f6">That's Jesse Vincent's</span><http://rt.cpan.org/>, which tracks bugs in every distribution released through CPAN.

