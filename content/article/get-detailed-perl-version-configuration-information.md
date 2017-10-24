{
   "tags" : [
      "configuration",
      "version",
      "old_site"
   ],
   "image" : null,
   "draft" : false,
   "slug" : "41/2013/9/27/Get-detailed-Perl-version-configuration-information",
   "description" : "Most Perl programmers know they can find out the current Perl version by typing \"perl -v\" as the command line:",
   "title" : "Get detailed Perl version configuration information",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "tooling",
   "date" : "2013-09-27T01:25:18"
}


Most Perl programmers know they can find out the current Perl version by typing "perl -v" as the command line:

``` prettyprint
perl -v

This is perl 5, version 16, subversion 3 (v5.16.3) built for x86_64-linux

Copyright 1987-2012, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

To get detailed version information type "perl -**V**" (capital V) at the command line:

``` prettyprint
perl -V

Summary of my perl5 (revision 5 version 16 subversion 3) configuration:
   
  Platform:
    osname=linux, osvers=3.8.4-102.fc17.x86_64, archname=x86_64-linux
    uname='linux localhost.localdomain 3.8.4-102.fc17.x86_64 #1 smp sun mar 24 13:09:09 utc 2013 x86_64 x86_64 x86_64 gnulinux '
    config_args='-de -Dprefix=/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3 -Aeval:scriptdir=/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/bin'
    hint=recommended, useposix=true, d_sigaction=define
    useithreads=undef, usemultiplicity=undef
    useperlio=define, d_sfio=undef, uselargefiles=define, usesocks=undef
    use64bitint=define, use64bitall=define, uselongdouble=undef
    usemymalloc=n, bincompat5005=undef
  Compiler:
    cc='cc', ccflags ='-fno-strict-aliasing -pipe -fstack-protector -I/usr/local/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64',
    optimize='-O2',
    cppflags='-fno-strict-aliasing -pipe -fstack-protector -I/usr/local/include'
    ccversion='', gccversion='4.7.2 20120921 (Red Hat 4.7.2-2)', gccosandvers=''
    intsize=4, longsize=8, ptrsize=8, doublesize=8, byteorder=12345678
    d_longlong=define, longlongsize=8, d_longdbl=define, longdblsize=16
    ivtype='long', ivsize=8, nvtype='double', nvsize=8, Off_t='off_t', lseeksize=8
    alignbytes=8, prototype=define
  Linker and Libraries:
    ld='cc', ldflags =' -fstack-protector -L/usr/local/lib'
    libpth=/usr/local/lib /lib/../lib64 /usr/lib/../lib64 /lib /usr/lib /lib64 /usr/lib64 /usr/local/lib64
    libs=-lnsl -ldl -lm -lcrypt -lutil -lc
    perllibs=-lnsl -ldl -lm -lcrypt -lutil -lc
    libc=, so=so, useshrplib=false, libperl=libperl.a
    gnulibc_version='2.15'
  Dynamic Linking:
    dlsrc=dl_dlopen.xs, dlext=so, d_dlsymun=undef, ccdlflags='-Wl,-E'
    cccdlflags='-fPIC', lddlflags='-shared -O2 -L/usr/local/lib -fstack-protector'


Characteristics of this binary (from libperl): 
  Compile-time options: HAS_TIMES PERLIO_LAYERS PERL_DONT_CREATE_GVSV
                        PERL_MALLOC_WRAP PERL_PRESERVE_IVUV USE_64_BIT_ALL
                        USE_64_BIT_INT USE_LARGE_FILES USE_LOCALE
                        USE_LOCALE_COLLATE USE_LOCALE_CTYPE
                        USE_LOCALE_NUMERIC USE_PERLIO USE_PERL_ATOF
  Built under linux
  Compiled at Apr 15 2013 14:54:57
  %ENV:
    PERLBREW_BASHRC_VERSION="0.62"
    PERLBREW_HOME="/home/sillymoose/.perlbrew"
    PERLBREW_MANPATH="/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/man"
    PERLBREW_PATH="/home/sillymoose/perl5/perlbrew/bin:/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/bin"
    PERLBREW_PERL="perl-5.16.3"
    PERLBREW_ROOT="/home/sillymoose/perl5/perlbrew"
    PERLBREW_VERSION="0.62"
  @INC:
    /home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/lib/site_perl/5.16.3/x86_64-linux
    /home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/lib/site_perl/5.16.3
    /home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/lib/5.16.3/x86_64-linux
    /home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/lib/5.16.3
```

This prints detailed information on the installed Perl's configuration including: the options that Perl was compiled with, whether iThreads are enabled or not and a host of directory information.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
