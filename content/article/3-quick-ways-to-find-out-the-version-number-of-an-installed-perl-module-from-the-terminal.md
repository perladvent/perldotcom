{
   "title" : "3 quick ways to find out the version number of an installed Perl module from the terminal",
   "draft" : false,
   "image" : null,
   "categories" : "tooling",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "configuration",
      "module",
      "sysadmin",
      "powershell",
      "bash"
   ],
   "date" : "2013-03-24T17:30:19",
   "description" : "Perl module features and behaviour can change from version to version and so knowing the version number of an installed Perl module can be useful in several scenarios. Below are three different command line methods for finding out the version number of an installed module that work on Bash and Windows Powershell. So fire up the terminal and get typing!",
   "slug" : "1/2013/3/24/3-quick-ways-to-find-out-the-version-number-of-an-installed-Perl-module-from-the-terminal"
}


Perl module features and behaviour can change from version to version and so knowing the version number of an installed Perl module can be useful in several scenarios. Below are three different command line methods for finding out the version number of an installed module that work on Bash and Windows Powershell. So fire up the terminal and get typing!

### 1. Use CPAN with the -D flag

``` prettyprint
cpan -D Moose
```

Type the code above into the terminal replacing 'Moose' with the Perl module name of your choice (in the typical Perl format of Namespace::ModuleName, e.g. Catalyst::Runtime). CPAN will report the module's version, installed location, the latest version number available on CPAN, and whether the locally installed version of the module is up to date or not. The resulting output looks like this:

``` prettyprint
D/DO/DOY/Moose-2.0604.tar.gz
/home/sillymoose/perl5/perlbrew/perls/perl-5.14.2/lib/site_perl/5.14.2/x86_64-linux/Moose.pm
Installed: 2.0603
CPAN:      2.0604  Not up to date
Jesse Luehrs (DOY)
doy@cpan.org
```

### 2. Use a Perl one-liner to load and print the module version number

``` prettyprint
perl -MMoose -e 'print $Moose::VERSION ."\n";'
```

This command loads the module with Perl's -M flag, and then prints the version variable. This should always be available under $MODULENAME::VERSION. Using a one-liner avoids the need to use CPAN, plus it neatly returns only the version number, which can easily be used for further processing:

``` prettyprint
2.0603
```

### 3. Use Perldoc with the -m flag to load the module's source code and extract the version number.

``` prettyprint
# If you are using Bash:
perldoc -m Moose | grep VERSION

# If you are using Powershell:
perldoc -m Moose | select-string VERSION
```

Admittedly somewhat of a hack, but this will usually work. Don't forget to replace Moose with the module name you are searching for.The output can be a messy, but you can usually locate the version number. This is a good option if methods 1 and 2 above do not work.

``` prettyprint
$Moose::VERSION = '2.0603';
die "Class::MOP version $Moose::VERSION required--this is version $Class::MOP::VERSION"
    if $Moose::VERSION && $Class::MOP::VERSION ne $Moose::VERSION;
=head1 VERSION
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
