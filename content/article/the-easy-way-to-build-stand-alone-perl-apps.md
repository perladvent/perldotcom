{
   "date" : "2014-01-05T23:21:55",
   "categories" : "apps",
   "image" : "/images/58/EC0FEBBE-FF2E-11E3-8A2A-5C05A68B9E16.png",
   "slug" : "58/2014/1/5/The-easy-way-to-build-stand-alone-Perl-apps",
   "description" : "Making dependency-free Perl applications is simple with App::FatPacker",
   "authors" : [
      "david-farrell"
   ],
   "thumbnail" : "/images/58/thumb_EC0FEBBE-FF2E-11E3-8A2A-5C05A68B9E16.png",
   "title" : "The easy way to build stand-alone Perl apps",
   "tags" : [
      "configuration",
      "app"
   ],
   "draft" : false
}


The Perl toolchain has such a large install base it's tempting to just upload your app to PAUSE and let users install it via CPAN. [Many authors](https://metacpan.org/search?q=App%3A%3A) have taken this approach and it makes sense in most cases to reuse the power of the CPAN in providing a common install, dependency management and update mechanism. Sometimes however you want to distribute a dependency-free Perl app in a single executable file, and for these cases you'll want to look at [App::FatPacker]({{<mcpan "App::FatPacker" >}}).

### Requirements

You'll need a Unix-based system (Linux, OSX, BSD) and to install [App::FatPacker]({{<mcpan "App::FatPacker" >}}). It runs on every version of Perl from 5.8.8 upwards, so just fire up the terminal and enter the following:

```perl
cpan App::FatPacker
```

### Coding your app

You can convert any typical Perl script into a standalone app, as long as it doesn't have XS dependencies (see "Alternatives to App::Fatpacker" below for more info on how to create apps with XS dependencies). One suggestion would be to use the following shebang line:

```perl
#!/usr/bin/env perl
```

This shebang line will call the "env" program passing "perl" as a parameter. This deals with the issue of the Perl binary beng installed in different locations on platforms as it will use the Perl binary in the user's $PATH. This is documented in [perlrun]({{< perldoc "perlrun" >}}). It is also compatible with Perlbrew.

### Producing the single file app

This couldn't be simpler: once you have your Perl script ready to go, open the terminal and enter the following, replacing the paths with your own:

```perl
fatpack pack /path/to/script > /path/to/app
```

This will pack all of the dependencies used by your script into a single executable app.

### Running the app

Now that your app is in a single file, distributing and running it is a piece of cake. Simply copy the file to any directory in your $PATH. In order to be able to run your new app, you'll need to set it's permission to be executable. You can do this with chmod:

```perl
chmod 755 /path/to/app
```

Now the app should run simply by entering the app filename in the terminal.

### A simple example

Let say we have the following script, BillCalc.pl which calculates how much each person should pay at dinner using the fictitious "Math::Bill" library.

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use Math::Bill;
use feature 'say';
use Carp 'croak';

croak "Error: missing arguments. Requires a bill total and number of people at dinner. e.g:\n   BillCalc 100.40 3" unless @ARGV == 2;

my $bill = Math::Bill->new($ARGV[0], $ARGV[1]);

say 'Each person should pay: ' . $bill->apportion . ' each';
```

We can pack BillCalc.pl into a single file app using App::Fatpacker:

```perl
fatpack pack BillCalc.pl > BillCalc
BillCalc.pl syntax OK
```

App::Fatpacker prints out a confirmation message ("BillCalc.pl syntax OK") and we should now have a new file, called "BillCalc" in our current directory. This file will contain all of the contents of "Math::Bill" and any other dependencies in BillCalc.pl.

Let's move this to a directory in my $PATH, /home/sillymoose/local/bin

```perl
mv BillCalc /home/sillymoose/local/bin
```

And change the file permissions to be executable:

```perl
chmod 755 /home/sillymoose/local/bin/BillCalc
```

Now we can run the BillCalc app at the command line:

```perl
BillCalc 120 3
Each person should pay: 40 each
```

For an example of a real-world Perl app created with App::FatPacker, check out our article on [every](http://perltricks.com/article/55/2013/12/22/Schedule-jobs-like-a-boss-with-every), the cron scheduling app.

### Alternatives to App::FatPacker

[PP]({{<mcpan "pp" >}}) is another Perl tool that can create stand-alone Perl apps. It also supports XS module dependencies (unlike App::FatPacker).

Of course you can also distribute an application via CPAN, where you have the flexibility of including the dependent modules in your application's inc directory, or include the modules as dependencies in the makefile, and let CPAN install them for you - this is also more disk space efficient. Perl applications on CPAN place the app in the application's bin directory and use "EXE\_FILES" directive in the makefile to install the app to the Perl bin directory. If you're interested in this approach, check out the [Module::Starter source]({{<mcpan "Module::Starter" >}}) as a good example to copy from.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
