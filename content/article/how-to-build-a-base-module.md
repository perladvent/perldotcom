
  {
    "title"  : "How to build a base module",
    "authors": ["david-farrell"],
    "date"   : "2016-11-30T08:47:58",
    "tags"   : ["exporter","import-base","mastering-perl"],
    "draft"  : false,
    "image"  : "",
    "description" : "Establish consistency and reduce boilerplate across your project",
    "categories": "development"
  }

When working on large Perl projects, a base module is a nice way to setup a standard set of imported routines for the other modules in the project. With a base module you can configure a logger, turn on pragmas and import any other useful routines. Instead of typing:

```perl
use warnings;
use strict;
use Data::Dumper 'Dumper';
use Log::Log4perl 'get_logger';
...
```

and so on, you can type:

```perl
use MyBase;
```

This saves typing all those boilerplate `use` statements at the top of every module in the project, and it establishes a consistent base so that all modules all start by operating under the same pragmas and so on. And it also provides a central location to configure application paths and other global compile-time essentials.

### Building your own base module

I'll write an example base module called `MyBase.pm` to show you how I do it. There are three basic cases I need to be able to export: pragmas, symbols defined in the MyBase namespace and symbols from other namespaces. In Perl a symbol is usually a reference to a variable or a subroutine. This is my starting code:

```perl
package MyBase;

sub import {}

1;
```

In Perl the `import` subroutine is important: it's called every time the module is imported via `use`, so that will be my trigger for importing the pragmas and code I want from the base module.

### Handling pragmas

Take a look at the [Modern::Perl](https://metacpan.org/pod/Modern::Perl) [source](https://metacpan.org/source/CHROMATIC/Modern-Perl-1.20150127/lib/Modern/Perl.pm#L30). The `import` subroutine just calls `import` on the pragmas *it* wants to import. Clever and easy!

```perl
package MyBase;
use v5.10.0;
use warnings;
use strict;

sub import {
  warnings->import;
  strict->import;
  feature->import(':5.10');
}

1;
```

Now any module that includes `use MyBase;` will get warnings, strict and all of the Perl 5.10 features imported (e.g. `say`, `state` and so on).

### Handling foreign symbols

By foreign symbols I mean subroutines and variables declared in other modules, like `Data::Dumper::Dumper`. That's a subroutine that's always handy to have available:

```perl
package MyBase;
use v5.10.0;
use warnings;
use strict;
use Data::Dumper;

sub import {
  warnings->import;
  strict->import;
  feature->import(':5.10');

  # get the importing package name
  my $caller = caller(0);

  do {
    no strict 'refs';
    *{"$caller\:\:Dumper"}  = *{"Data\:\:Dumper\:\:Dumper"};
  };
}

1;
```

Here I've added `use Data::Dumper;` to import the module. Later within `import()` I save the calling package name in `$caller`, and then within a `do` block I copy the `Dumper` subroutine from Data::Dumper into the caller's namespace. I escape the semicolons in the package reference because some versions of Perl might need that, but I can't remember which ones - modern Perls don't. If you find the symbol table copying syntax confusing, chapters 7 & 8 of [Mastering Perl](https://www.amazon.com/Mastering-Perl-Creating-Professional-Programs/dp/144939311X) has an in-depth explanation of how it works.

### Handling local symbols

There are many types of local symbols that might be useful to export: global config hashrefs (maybe one for dev and another for production), accessors for singletons like loggers and queues and so on. My application uses [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl), so I'll export a subroutine to get the logger:

```perl
package MyBase;
use v5.10.0;
use warnings;
use strict;
use Data::Dumper;
use Log::Log4perl;

BEGIN {
  my $default_conf = q(
    log4perl.logger.Root           = DEBUG, Root
    log4perl.appender.Root         = Log::Log4perl::Appender::Screen
    log4perl.appender.Root.stderr  = 1
    log4perl.appender.Root.utf8    = 1
    log4perl.appender.Root.layout  = PatternLayout
    log4perl.appender.Root.layout.ConversionPattern = %C %m%n
  );
  Log::Log4perl->init(\$default_conf);
}

sub logger { Log::Log4perl->get_logger('Root') }

sub import {
  warnings->import;
  strict->import;
  feature->import(':5.10');

  # get the importing package name
  my $caller = caller(0);

  do {
    no strict 'refs';
    *{"$caller\:\:Dumper"}  = *{"Data\:\:Dumper\:\:Dumper"};
    *{"$caller\:\:logger"}  = *{"MyBase\:\:logger"};
  };
}

1;
```

I've imported the Log::Log4perl module, and initialized it within a `BEGIN` block (so it happens at compile time). I've added a new subroutine, `logger` which is later copied into the symbol table of caller within the `import` sub. Now any module which uses `MyBase` can simply call `logger` to get the Log4perl object.

One thing to consider when adding functionality like this is to do the initialization outside of `import` if possible. That's because the module code is loaded once, but `import` is called every time `MyBase` is used. So keep the code inside `import` to the minimum required - you don't want to initialize Log4perl over and over!

Scalars are easy too, here's how I might export the project version:

```perl
${"$caller\:\:VERSION"}  = *{"MyBase\:\:VERSION"};
```

Notice that the first character of that line has changed from an asterisk (for typeglob) to a dollar sign (for scalar).


### Enable stack traces

Perl has pretty helpful error messages, but I like to see stack traces to figure out what caused an exception. This is easy to add to a base module using the `confess` subroutine from the [Carp](https://metacpan.org/pod/Carp) module:

```perl
package MyBase;
use v5.10.0;
use warnings;
use strict;
use Data::Dumper;
use Log::Log4perl;
use Carp 'confess';

BEGIN {
  $SIG{'__DIE__'} = sub { confess(@_) };
  my $default_conf = q(
    log4perl.logger.Root           = DEBUG, Root
    log4perl.appender.Root         = Log::Log4perl::Appender::Screen
    log4perl.appender.Root.stderr  = 1
    log4perl.appender.Root.utf8    = 1
    log4perl.appender.Root.layout  = PatternLayout
    log4perl.appender.Root.layout.ConversionPattern = %C %m%n
  );
  Log::Log4perl->init(\$default_conf);
}

sub logger { Log::Log4perl->get_logger('Root') }

sub import {
  warnings->import;
  strict->import;
  feature->import(':5.10');

  # get the importing package name
  my $caller = caller(0);

  do {
    no strict 'refs';
    *{"$caller\:\:Dumper"}  = *{"Data\:\:Dumper\:\:Dumper"};
    *{"$caller\:\:logger"}  = *{"MyBase\:\:logger"};
  };
}

1;
```

I've added a line to import the Carp module, and within the `BEGIN` block I install a signal handler for the pseudo-signal `__DIE__`. This will be called any time the application throws an exception. The handler is an anonymous subroutine which calls `confess` on the exception. This prints a stack trace and exits.

### Consider using Import::Base

I'm not sure my code handles all edge cases. It works for my needs, but if you're sharing the project code, consider using [Import::Base](https://metacpan.org/pod/Import::Base) which can do all of this for you. Here's what my base module looks like, re-written to use Import::Base:

```perl
package MyBase;
use base 'Import::Base';
use v5.10.0;
use warnings;
use strict;
use Data::Dumper;
use Log::Log4perl;
use Carp 'confess';

BEGIN {
  $SIG{'__DIE__'} = sub { confess(@_) };
  my $default_conf = q(
    log4perl.logger.Root           = DEBUG, Root
    log4perl.appender.Root         = Log::Log4perl::Appender::Screen
    log4perl.appender.Root.stderr  = 1
    log4perl.appender.Root.utf8    = 1
    log4perl.appender.Root.layout  = PatternLayout
    log4perl.appender.Root.layout.ConversionPattern = %C %m%n
  );
  Log::Log4perl->init(\$default_conf);
}

sub logger { Log::Log4perl->get_logger('Root') }

our @IMPORT_MODULES = (
  'warnings',
  'strict',
  'feature' => [':5.10'],
  'Data::Dumper' => ['Dumper'],
  'MyBase',
);

our @EXPORT = ( 'logger' );

1;
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
