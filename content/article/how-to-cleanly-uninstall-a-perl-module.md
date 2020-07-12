{
   "description" : "How to write your own uninstall modules script",
   "slug" : "3/2013/3/27/How-to-cleanly-uninstall-a-Perl-module",
   "categories" : "tooling",
   "date" : "2013-03-27T00:00:17",
   "title" : "How to cleanly uninstall a Perl module",
   "image" : null,
   "tags" : [
      "configuration",
      "cpan",
      "module",
      "sysadmin",
      "cpanm",
      "cpanminus"
   ],
   "authors" : [
      "david-farrell"
   ],
   "draft" : false
}


CPAN makes installing Perl modules easy but when it comes to removing Perl modules, you have to roll your own solution\*. Fortunately the Perl core includes the ExtUtils modules that can help. The script below accepts the Module::Name as an argument, and will delete all files and empty directories associated with that module.

```perl
# uninstall_perl_module.pl from PerlTricks.com

use 5.14.2;
use ExtUtils::Installed;
use ExtUtils::Packlist;

# Exit unless a module name was passed
die ("Error: no Module::Name passed as an argument. E.G.\n\t perl $0 Module::Name\n") unless $#ARGV == 0;

my $module = shift @ARGV;

my $installed_modules = ExtUtils::Installed->new;

# iterate through and try to delete every file associated with the module
foreach my $file ($installed_modules->files($module)) {
    print "removing $file\n";
    unlink $file or warn "could not remove $file: $!\n";
}

# delete the module packfile
my $packfile = $installed_modules->packlist($module)->packlist_file;
print "removing $packfile\n";
unlink $packfile or warn "could not remove $packfile: $!\n";

# delete the module directories if they are empty
foreach my $dir (sort($installed_modules->directory_tree($module))) {
    print("removing $dir\n");
    rmdir $dir or warn "could not remove $dir: $!\n";
}
```

Save the script code above into a text file saved as 'uninstall\_perl\_module.pl'. So if we wanted to uninstall the venerable `Acme::Dot` module, we would open up the terminal, navigate to directory containing uninstall\_perl\_module.pl and type:

```perl
$ perl uninstall_perl_module.pl Acme::Dot
```

and the script will remove the module for you. It will **retain non-empty directories**, as it uses [rmdir]({{< perlfunc "rmdir" >}}).

```perl
removing /home/sillymoose/perl5/perlbrew/perls/perl-5.14.2/man/man3/Acme::Dot.3
removing /home/sillymoose/perl5/perlbrew/perls/perl-5.14.2/lib/site_perl/5.14.2/Acme/Dot.pm
...
```

### \*App::cpanminus

[App::cpanminus]({{<mcpan "App::cpanminus" >}}) is a popular alternative CPAN client that can be used to manage Perl distributions. It has many great features, including uninstalling modules. Once you've installed App::cpanminus, to remove the `Acme::Dot` module, at the command line type:

```perl
$ cpanm --uninstall Acme::Dot
```

App::cpanminus has loads of other great features, to see them, just run `cpanm --help`.

**Updated:** added cpanm example and clarified directory removal process. 2015-02-21**

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
