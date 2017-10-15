{
   "image" : null,
   "thumbnail" : "/images/_pub_2005_12_21_a_timely_start/111-timely_start.gif",
   "date" : "2005-12-21T00:00:00-08:00",
   "categories" : "Tooling",
   "authors" : [
      "jean-louis-leroy"
   ],
   "title" : "A Timely Start",
   "tags" : [
      "perl-administration",
      "perl-installation",
      "perl-optimization",
      "perl-profiling"
   ],
   "slug" : "/pub/2005/12/21/a_timely_start.html",
   "draft" : null,
   "description" : " This article is a follow-up to the lightning talk I delivered at the recent YAPC::Europe 2005 that took place in Braga, Portugal: \"Perl Vs. Korn Shell: 1-1.\" I presented two case studies taken from my experience as Perl expert..."
}



This article is a follow-up to the lightning talk I delivered at the recent YAPC::Europe 2005 that took place in Braga, Portugal: "Perl Vs. Korn Shell: 1-1." I presented two case studies taken from my experience as Perl expert at the Agency (they have asked me to remain discreet about their real name, but rest reassured, it's not the CIA, it's a European agency).

In the first case, I explained how I had rewritten a heavily used Korn shell script in Perl, in the process bringing its execution time from a half-hour down to ten seconds. The audience laughed and applauded loudly at that point of my talk.

Then I proceeded to the second case, where the situation was not so rosy for Perl. One of my colleagues had rewritten a simple `ksh` script that did a few computations then transferred a file over FTP. The rewrite in Perl ran ten times slower.

### Slower?

My job was to investigate. I found a couple of obvious ways of speeding up the Perl script. First I removed hidden calls to subprocesses:

    use Shell qw( date which );
    # ...
    $now   = date();
    $where = which 'some_command';

Then I replaced a few `use` directives with calls to `require`. If you're going to use the features contained in a module only conditionally, `require` may be preferable, because `perl` always executes `use` directives at compile time.

Take this code:

    use Pod::Usage;

    # $help set from command-line option
    if ($help) {
        pod2usage(-exitstatus => 0);
    }

This loads [Pod::Usage](http://search.cpan.org/perldoc?Pod::Usage), even if `$help` is false. The following change won't help, though:

    # $help set from command-line option
    if ($help) {
        use Pod::Usage;
        pod2usage(-exitstatus => 0);
    }

This just gives the illusion that the program loads `Pod::Usage` only when necessary. The right answer is:

    # $help set from command-line option
    if ($help) {
        require Pod::Usage;
        Pod::Usage::pod2usage(-exitstatus => 0);
    }

After these changes the situation had improved: the Perl version was only five times slower now. I pulled out the profiler. Sadly, most of the time still went to loading modules, especially [Net::FTP](http://search.cpan.org/perldoc?Net::FTP). Of course, we *always* needed that.

If you dig in, you realize that `Net::FTP` is not the only culprit. It loads other modules that in turn load other modules, and so on. Here is the complete list:

    /.../libnet.cfg
    Carp.pm
    Config.pm
    Errno.pm
    Exporter.pm
    Exporter/Heavy.pm
    IO.pm
    IO/Handle.pm
    IO/Socket.pm
    IO/Socket/INET.pm
    IO/Socket/UNIX.pm
    Net/Cmd.pm
    Net/Config.pm
    Net/FTP.pm
    SelectSaver.pm
    Socket.pm
    Symbol.pm
    Time/Local.pm
    XSLoader.pm
    strict.pm
    vars.pm
    warnings.pm
    warnings/register.pm

This is not by itself a bad thing: modules are there to promote code reuse, after all, so in theory, the more modules a module uses, the better. It usually shows that it's not reinventing wheels. Modules are good and account for much of Perl's success. You can solve so many problems in ten lines: use this, use that, use this too, grab this from CPAN, write three lines yourself--bang! problem solved.

### Why Was Perl Slower?

In my case, though, the sad truth was that the Perl version of the FTP script spent 95 percent of its time getting started; the meat of the script, the code written by my colleague, accounted for only five percent of the execution time. The `ksh` version, on the other hand, started to work on the job nearly immediately.

My lightning talk ended with the conclusion that Perl needs a compiler--badly. In the final slides I addressed some popular objections against this statement, the more important one being that "it won't make your code run faster." I know: I want it to *start* faster.

Several hackers came for a discussion after my talk. Some of their objections were interesting but missed the point. ("The total execution time is good enough." Me: "It's not up to me to decide, there are specs; and the FTP version *is* five times faster. That's what I'm talking about.")

However, other remarks suggested that some stones remained unturned. One of the attendants timed `perl -MNet::FTP -e 0` under my eyes and indeed it loaded quite fast on his laptop. It loaded faster than on the Agency's multi-CPU, 25000-euro computers. How come?

The answer turned out to be the length of `PERL5LIB`. The Agency has collections of systems that build upon one another. Each system may contain one or several directories hosting Perl modules. The build system produces a value for `PERL5LIB` that includes the Perl module directories for the system, followed by the module directories of all of the systems it builds upon, recursively.

I wrote a small module, `Devel::Dependencies`, which uses `BEGIN` and `CHECK` blocks to find all of the modules that a Perl program loads. Optionally, it lists the path to each module, the position of that path within `@INC`, and the sum of all of the positions at the end. This gives a good idea of the number of directory searches Perl has to perform when loading modules.

I used it on a one-line script that just says `use Net::FTP`. Here's the result:

    $ echo $PERL5LIB
    XxB:
    /build/MAP/CONFIG!11.213/idl/stubs:
    /build/MAP/CONFIG!11.213/perl/lib:
    /build/MAP/CONFIG!11.213/pm:
    /build/LIB/UTILS!11.151/ftpstuff:
    /build/LIB/UTILS!11.151/alien/PA-RISC2.0:
    /build/LIB/UTILS!11.151/alien:
    /build/LIB/UTILS!11.151/perl/lib:
    /build/LIB/UTILS!11.151/pm:
    /build/MAP/MAP_SERVER!11.197/pm:
    /build/CONTROL/KLIBS!11.132/idl/stubs:
    /build/CONTROL/KLIBS!11.132/perl/lib:
    /build/CONTROL/KLIBS!11.132/pm:
    /build/CONTROL/ACME!11.177/idl/stubs:
    /build/CONTROL/ACME!11.177/pm:
    /build/CONTROL/ADAPTER!11.189/pm:
    /build/MAP/HMI!1.12.165/idl/stubs:
    /build/CONTROL/KERNEL_INIT!11.130/pm:
    /build/CONTROL/BUSINESS!11.176/pm:
    /build/CONTROL/KERNEL!11.130/pm:
    /build/BASIC/SSC!11.78/pm:
    /build/BASIC/LOG!11.78/perl/lib:
    /build/BASIC/LOG!11.78/pm:
    /build/BASIC/BSC!11.77/pm:
    /build/BASIC/POLYORB!11.39/idl/stubs:
    /build/BASIC/TEST!11.58/perl/lib/ldap/interface:
    /build/BASIC/TEST!11.58/perl/lib/ldap:
    /build/BASIC/TEST!11.58/perl/lib:
    /build/BASIC/TEST!11.58/pm:
    /build/BASIC/TANGRAM!11.53/perl/lib:
    /build/BASIC/TANGRAM!11.53/pm:
    /build/LIB/PERL!5.6.1.1.39/lib/site_perl:
    /build/LIB/PERL!5.6.1.1.39/lib:
    /build/LIB/PERL!5.6.1.1.39/alien:
    /build/LIB/PERL!5.6.1.1.39/pm:
    /build/LIB/GNU!11.30/pm:
    /build/CM/LIB!2.1.221/perl/lib/wle/interface:
    /build/CM/LIB!2.1.221/perl/lib:
    /build/CM/LIB!2.1.221/alien:
    /build/CM/LIB!2.1.221/pm:
    /build/CM/CM_LIB!2.1.96/perl/lib/MakeCfg:
    /build/CM/CM_LIB!2.1.96/perl/lib:
    /build/CM/CM_LIB!2.1.96/pm:
    /build/CM/EXT_LIBS!2.1.6/perl/lib:
    /build/CM/EXT_LIBS!2.1.6/alien:
    /build/CM/EXT_LIBS!2.1.6/pm:
    XxE

    $ perl -c -MDevel::Dependencies=origin ftp.pl
    Devel::Dependencies 23 dependencies:
      /build/LIB/UTILS!11.151/ftpstuff/Net/libnet.cfg /build/LIB/UTILS!11.151/ftpstuff/Net/libnet.cfg (6)
      Carp.pm /build/LIB/PERL!5.6.1.1.39/lib/Carp.pm (38)
      Config.pm /build/LIB/PERL!5.6.1.1.39/lib/PA-RISC2.0/Config.pm (37)
      Errno.pm /build/LIB/PERL!5.6.1.1.39/lib/PA-RISC2.0/Errno.pm (37)
      Exporter.pm /build/LIB/PERL!5.6.1.1.39/lib/Exporter.pm (38)
      Exporter/Heavy.pm /build/LIB/PERL!5.6.1.1.39/lib/Exporter/Heavy.pm (38)
      IO.pm /build/LIB/PERL!5.6.1.1.39/lib/PA-RISC2.0/IO.pm (37)
      IO/Handle.pm /build/LIB/PERL!5.6.1.1.39/lib/PA-RISC2.0/IO/Handle.pm (37)
      IO/Socket.pm /build/LIB/PERL!5.6.1.1.39/lib/PA-RISC2.0/IO/Socket.pm (37)
      IO/Socket/INET.pm /build/LIB/PERL!5.6.1.1.39/lib/IO/Socket/INET.pm (38)
      IO/Socket/UNIX.pm /build/LIB/PERL!5.6.1.1.39/lib/IO/Socket/UNIX.pm (38)
      Net/Cmd.pm /build/LIB/UTILS!11.151/ftpstuff/Net/Cmd.pm (6)
      Net/Config.pm /build/LIB/UTILS!11.151/ftpstuff/Net/Config.pm (6)
      Net/FTP.pm /build/LIB/UTILS!11.151/ftpstuff/Net/FTP.pm (6)
      SelectSaver.pm /build/LIB/PERL!5.6.1.1.39/lib/SelectSaver.pm (38)
      Socket.pm /build/LIB/PERL!5.6.1.1.39/lib/PA-RISC2.0/Socket.pm (37)
      Symbol.pm /build/LIB/PERL!5.6.1.1.39/lib/Symbol.pm (38)
      Time/Local.pm /build/LIB/PERL!5.6.1.1.39/lib/Time/Local.pm (38)
      XSLoader.pm /build/LIB/PERL!5.6.1.1.39/lib/PA-RISC2.0/XSLoader.pm (37)
      strict.pm /build/LIB/PERL!5.6.1.1.39/lib/strict.pm (38)
      vars.pm /build/LIB/PERL!5.6.1.1.39/lib/vars.pm (38)
      warnings.pm /build/LIB/PERL!5.6.1.1.39/lib/warnings.pm (38)
      warnings/register.pm /build/LIB/PERL!5.6.1.1.39/lib/warnings/register.pm (38)
    Total directory searches: 739
    ftp.pl syntax OK

Now it looked like I had found the wasted time.

### Making Perl Faster

Still pushing, I wrote a script that consolidates `@INC`. It creates a directory tree containing the union of all of the directory trees found in `@INC` and then populates them with symlinks to the .pm files. I could replace the lengthy `PERL5LIB` with one that contained just one directory. Here's the resulting dependency listing:

    ler@cougar: cm_perl -I lib/MAP/CONFIG -c -MDevel::Dependencies=origin ftp.pl
      Devel::Dependencies 23 dependencies:
      Carp.pm lib/MAP/CONFIG/Carp.pm (2)
      Config.pm lib/MAP/CONFIG/PA-RISC2.0/Config.pm (1)
      Errno.pm lib/MAP/CONFIG/PA-RISC2.0/Errno.pm (1)
      Exporter.pm lib/MAP/CONFIG/Exporter.pm (2)
      Exporter/Heavy.pm lib/MAP/CONFIG/Exporter/Heavy.pm (2)
      IO.pm lib/MAP/CONFIG/PA-RISC2.0/IO.pm (1)
      IO/Handle.pm lib/MAP/CONFIG/PA-RISC2.0/IO/Handle.pm (1)
      IO/Socket.pm lib/MAP/CONFIG/PA-RISC2.0/IO/Socket.pm (1)
      IO/Socket/INET.pm lib/MAP/CONFIG/IO/Socket/INET.pm (2)
      IO/Socket/UNIX.pm lib/MAP/CONFIG/IO/Socket/UNIX.pm (2)
      Net/Cmd.pm lib/MAP/CONFIG/Net/Cmd.pm (2)
      Net/Config.pm lib/MAP/CONFIG/Net/Config.pm (2)
      Net/FTP.pm lib/MAP/CONFIG/Net/FTP.pm (2)
      SelectSaver.pm lib/MAP/CONFIG/SelectSaver.pm (2)
      Socket.pm lib/MAP/CONFIG/PA-RISC2.0/Socket.pm (1)
      Symbol.pm lib/MAP/CONFIG/Symbol.pm (2)
      Time/Local.pm lib/MAP/CONFIG/Time/Local.pm (2)
      XSLoader.pm lib/MAP/CONFIG/PA-RISC2.0/XSLoader.pm (1)
      lib/MAP/CONFIG/Net/libnet.cfg lib/MAP/CONFIG/Net/libnet.cfg (2)
      strict.pm lib/MAP/CONFIG/strict.pm (2)
      vars.pm lib/MAP/CONFIG/vars.pm (2)
      warnings.pm lib/MAP/CONFIG/warnings.pm (2)
      warnings/register.pm lib/MAP/CONFIG/warnings/register.pm (2)
    Total directory searches: 39
    ftp.pl syntax OK

Why does Perl find *Carp.pm* in the *second* directory, considering Perl should search the directory passed via `-I` first? `perl -V` gives the answer:

        (extract)
      @INC:
        lib/MAP/CONFIG/PA-RISC2.0
        lib/MAP/CONFIG
        XxB
        /build/LIB/UTILS!11.162/ftpstuff/PA-RISC2.0
        /build/LIB/UTILS!11.162/ftpstuff
        /build/LIB/UTILS!11.162/alien/PA-RISC2.0

Under some circumstances, Perl adds architecture-specific paths to `@INC`; for more information on this, see the description of `PER5LIB` in the `perlrun` manpage.

Finally I timed the *ftp.pl* program twice: with the normal `PERL5LIB` and with the consolidated `PERL5LIB`. Here are the results (`u` stands for "user time," `s` for "system time," and `u+s` is the sum; times are in seconds):

    Running ft_ftp.pl..
    47-element PERL5LIB  : u: 0.07 s: 0.20 u+s: 0.27
    Consolidated PERL5LIB: u: 0.05 s: 0.04 u+s: 0.09

Therefore, I recommended incorporating the consolidation script as part of the process that builds the various systems.

### Conclusion

It may seem silly to have a `PERL5LIB` that contains 47 directories. On the other hand, that kind of situation naturally arises once you try to use Perl in complex developments such as the Agency's. After all, Perl "is a real programming language," we like to say, so why can't it do what C++ or Ada can do?

I still think that we need a Perl compiler. The problem is not the length of `PERL5LIB`, it's the fact that Perl processes it each time it runs the script. My workaround, in effect, amounts to "compiling" a fast Perl lib.
