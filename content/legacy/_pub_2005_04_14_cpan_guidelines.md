{
   "draft" : null,
   "authors" : [
      "rob-kinyon"
   ],
   "slug" : "/pub/2005/04/14/cpan_guidelines.html",
   "description" : " When you are planning to release a module to CPAN, one of your first tasks is figure out what OS, Perl version(s), and other environments you will and will not support. Often, the answers will come from what you...",
   "thumbnail" : "/images/_pub_2005_04_14_cpan_guidelines/111-good_mods.gif",
   "tags" : [
      "compatibility",
      "cpan",
      "cpan-modules",
      "cross-platform",
      "perl-modules",
      "perl-porting",
      "writing-open-source-perl-code"
   ],
   "image" : null,
   "title" : "Building Good CPAN Modules",
   "categories" : "cpan",
   "date" : "2005-04-14T00:00:00-08:00"
}



When you are planning to release a module to CPAN, one of your first tasks is figure out what OS, Perl version(s), and other environments you will and will not support. Often, the answers will come from what you can and cannot support, based on the features you want to provide and the modules and libraries you have used.

Many CPAN modules, however, unintentionally limit the places where they can work. There are several steps you can take to remove those limitations. Often, these steps are very simple changes that can actually enhance your module's functionality and maintainability.

### It Runs On My Machine

You have the latest PowerBook, update from CPAN every day, and run the latest Perl version. The people using your module are not. Remember, just because an application or OS is older than your grandmother doesn't mean that it isn't useful anymore. Code doesn't spontaneously develop bugs over time, nor does it collect cruft that makes it run slower. Some vitally important applications have run untouched for 30+ years in languages that were deprecated when you were in diapers. These applications keep the lights on and keep track of all the money in the world, for example, and they typically run on very old computers.

Companies want to keep using their older systems because these systems work and they want to use Perl because Perl works everywhere. If you can leverage CPAN, you already have 90 percent of every Perl application written.

#### When in Rome

[Perl runs on at least 93 different operating systems](http://www.cpan.org/ports/index.html). In addition, there are [18 different productionized Perl 5 versions](http://ftp.funet.fi/pub/CPAN/src/) floating around out there (not counting the development branches and build options). `93 x 18 = 1674`. That means your module could run on one of well over 1500 different OS/Perl version environments. Add in threading, Unicode, and other options, and there is simply no way you can test your poor module in all of the places it will end up!

Luckily, Perl also provides (many of) the answers.

##### Defining Your Needs

If you know that your module simply will not run in a certain environment, you should set up prerequisites. These allow you to provide a level of safety for your users. Prerequisites include:

-   OSes that your module will not run under

    Check `$^O` and `%Config` for this. `$^O` will tell you the name of the operating system. Sometimes, this isn't specific enough, so you can check `%Config`.

        use Config;

        if ( $Config{ osname } ne 'solaris' || $Config{ osver } < 2.9 )
        {
            die "This module needs Solaris 2.9 or higher to run.\n";
        }

    It's usually better to limit yourself to a specific set of OSes that you know to be good. As your module's popularity grows, users will let you know if it works elsewhere.

-   Perl versions/features

    Check `$]` and `%INC` for this. `$]` holds the Perl version and `%INC` contains a list of loaded Perl modules so far. (See the [Threading section](/pub/2005/04/14/cpan_guidelines.html?page=2#threading) for an example.) If your module simply cannot be run in Perl before a certain version, make sure you have a `use 5.00#` (where `#` is the version you need) within your module. Additionally, [Module::Build]({{<mcpan "Module::Build" >}}) allows you to specify a minimum Perl version in the `requires` option for the constructor.

-   Modules/libraries

    In [ExtUtils::MakeMaker]({{<mcpan "ExtUtils::MakeMaker" >}}), you can specify a `PREREQ_PM` in your call to `WriteMakefile()` to indicate that your module needs other modules to run. That can include version numbers, both the minimum and maximum acceptable. `Module::Build` has a similar feature with the `requires` option to the constructor.

    If you depend on external, non-Perl libraries, you should see if they exist before continuing onwards. Like everything else, CPAN has a solution: [App::Info]({{<mcpan "App::Info" >}}).

        use App::Info::HTTPD::Apache;

        my $app = App::Info::HTTPD::Apache->new;

        unless ( $app->installed ) {
            die "Apache isn't installed!\n";
        }

##### Operating System

What OS your module happens to land on is both less and more of an issue than most people realize. Most of us have had to work in both Unix-land and Windows-land, so we know of pitfalls with directory separators and hard-coding outside executables. However, there are other problems that only arise when your module lands in a place like VMS.

The VMS filesystem, for example, has the idea of a volume in a fully qualified filename. VMS also handles file permissions and file versioning very differently than the standard Unix/Win32/Mac model. An excellent example of how to handle these differences is the core module [File::Spec]({{<mcpan "File::Spec" >}}).

Because this is an issue most authors have had to face at some point, there is a standard `perlpod` called, fittingly, [`perlport`]({{< perldoc "perlport" >}}). If you follow what's in there, you will be just fine.

##### Perl Version

It's been over ten years since the release of Perl 5.0.0, and Perl has changed a lot in that time. Most installations, however, are not the latest and greatest version. The main reason is "*If it ain't broke, don't fix it*." There is no such thing as a *safe upgrade*.

Most applications have no need for the latest features and will never trip most of the bugs or security holes. They just aren't that complex. If you restrict your module to features only found in 5.8, or even 5.6, you will ignore a large number of potential users.

##### Security Improvements

Most security fixes are transparent to the programmer. If the algorithms behind Perl hashes improve, you won't see it. If a new release fixes a hole in `suidperl`, your module won't care.

Sometimes, however, a security fix is a new feature whose usage will (and should) become the accepted norm: for example, the three-arg form of `open()` of 5.6. In these cases, I use `string-eval` to try to use the new feature and default to the old feature if it doesn't work. (Checking `$]` here isn't helpful because if your Perl version is pre-5.6, it will still try to compile the three-arg form and complain.)

    eval q{
        open( INFILE, ">", $filename )
              or die "Cannot open '$filename' for writing: $!\n";
    }; if ( $@ ) {
        # Check to see if it's a compile error
        if ( $@ =~ /Too many arguments for open/ ) {
            open( INFILE, "> $filename" )
                or die "Cannot open '$filename' for writing: $!\n";
        }
        else {
            # Otherwise, rethrow the error
            die $@;
        }
    }

##### Bug Fixes

Like security fixes, most bug fixes are transparent to the programmer. Most of us didn't notice that the hashing algorithm was less than optimal in 5.8.0 and had several improvements in 5.8.1. I know I didn't. In general, these will not affect you at all.

Unlike security fixes, if your module breaks on a bug in a prior version of Perl, there's probably not much you can do other than require the version where the bug fix occurred.

##### New Features

Everyone knows about `use warnings;` and `our` appearing in 5.6.0. You may, however, not know about the smaller changes. A good example is sorting.

5.8.0 changed sorting to be stable. This means that if the two items compare equally, the resulting list will preserve their original order. Prior versions of Perl made no such guarantee. This means that code like this may not do what you expect:

    my @input = qw( abcd abce efgh );
    my @output = sort {
        substr( $a, 0, 3 ) cmp substr( $b, 0, 3 )
    } @input;

If you depend on the fact that `@output` will contain `qw( abcd abce efgh )`, your module may be run into problems on versions prior to 5.8.0. `@output` could contain `qw( abce abcd efgh)` because the sorting function considers `abcd` and `abce` identical.

##### Gotchas With OS and Perl Versions

Your module may be pristine when it comes to OS or Perl versions. Is the rest of your distribution? Your tests may betray a dependency that you weren't aware of.

For example, 5.6.0 added lexically scoped warnings. Instead of using the `-w` flag to the Perl executable, you can now say `use warnings`. Because enabling warnings is generally a good thing, this is a very common header for test files written by conscientious programmers using Perl 5.6.0+:

    use strict;
    use warnings;

    use Test::More tests => 42;

Now, even if your module runs with Perls older than 5.6.0, your tests won't! This means your distribution will not install through CPAN or CPANPLUS. For administrators who install modules this way and who have better things to do that debug a module's tests, they won't install it.

#### Major New Features

Some new features are so large that they change the name of the game. These include Unicode and threading. Unicode has had support, in one form or another, in every version of Perl 5. That support has slowly moved from modules (such as [Unicode::String]({{<mcpan "Unicode::String" >}})) to the Perl core itself.

##### Threading

In 5.8.0, Perl's threading model changed from the 5.005 model (which never worked very well) to ithreads (which do). Additionally, multi-core processors are coming to the smaller servers. More and more, developers using 5.8+ choose to write threaded applications.

This means that your module might have to play in a threaded playground, which is a weird place indeed to process-oriented folks. Now, Perl's threading model is unshared by default, which means that global variables are safe from clobbering each other. This is different from the standard threading model, like Java's, which shares all variables by default. Because of this decision, most modules will run under threads with little to no changes.

The main issue you will need to resolve is what happens with your stateful variables. These are the variables that persist and keep a value in between invocations of a subroutine, yet need coordination across threads. A good example is:

    {
        my $counter;
        sub next_value ( return ++$counter; }
    }

If you depend on this counter being coordinated across every invocation of the `next_value()` subroutine, you need to take three steps.

-   Sharing

    Because Perl doesn't share your variables for you, you must explicitly share `$counter` to make sure that it is correctly updated across threads.

-   Locking

    Because a context-switch between threads can happen at any time, you need to lock `$counter` within the `next_value()` subroutine.

-   Version safety

    Also, because ithreads is an optional 5.8.0+ feature and the `lock()` subroutine is undefined before 5.6.0+, you may want to do some version checks.

        {
            my $counter = 0;
            if ( $] >= 5.008 && exists $INC{'threads.pm'} ) {
                require threads::shared;
                import threads::shared qw(share);
                share( $counter );
            }
            else {
                *lock = sub (*) {}
            }

            sub next_value {
                lock( $counter );
                $counter++;
            }
        }

The best description that I've seen of what you need to do to port your application to a threaded works successfully is "[Where Wizards Fear to Tread](/pub/2002/06/11/threads.html)" on Perl 5.8 threads.

##### Unicode

Although Unicode had some support prior to 5.8.0, a major feature in 5.8.0 was the near-seamless handling of Unicode within Perl itself. Prior that that, developers had to use Unicode::String and other modules. This means that you should look to handling strings as gingerly as possible if you consider support for Unicode on Perls prior to 5.8.0 as important. Luckily, most major modules already do this for you without you having to worry about it.

Discussing how to handle Unicode cleanly is an article in itself. Please see [`perlunicode`]({{< perldoc "perlunicode" >}}) and [`perluniintro`]({{< perldoc "perluniintro" >}}) for more information.

#### Playing Nicely with Others

If you're like me, you heard "Doesn't play well with others" a lot in kindergarten. While that's an admirable trait for a hacker, it's not something to praise in any modules that production systems depend upon. There are several common items to look out for when trying to play nicely with others.

##### Persistent Environments

Persistent environments, like `mod_perl` and FastCGI, are a fact of life. They make the WWW work. They are also a very different beast than a basic script that runs, does its thing, and ends. Basically, a persistent environment, such as `mod_perl`, does a few things.

-   Persistent interpreter

    Launching the Perl executable is expensive, relatively speaking. In an environment such as a web application, every request is a separate invocation of a Perl script. Persistence keeps a Perl interpreter around in memory between invocations, reducing the startup overhead dramatically.

-   Forked children

    In order to handle multiple requests at once, persistent environments tend to provide the capability for forked child processes, each with its own interpreter. Normally, this requires a copy of each module in every child's memory area.

-   Shared memory

    Nearly every request will use the same modules (CGI, DBI, etc). Instead of loading them every time, persistent environments load them into shared memory that each of the child processes can access. This can save a lot of memory that would otherwise be required to load DBI once for every child. This allows the same machine to create many more children to handle many more requests simultaneously on the same machine.

Caching needs a special mention. Because most persistent environments load most of the code into shared memory before forking off children, it makes sense to load as much code that won't change as possible before forking. (If the code does change, the child process receives a fresh copy of the modified memory space, reducing the benefit of shared memory.) This means that modules need to be able to pre-load what they need on demand. This is why CGI, which normally defers loading anything as much as possible, provides the `:all` option to load everything at once.

The `mod_perl` folks have an excellent set of documentation as to what's different about persistent environments, why you should care, and what you need to do for your module to work right.

##### Overloading

It's very easy to create an overloaded class that cannot work with other overloaded classes. For example, if I'm using Overload::Num1 and Overload::Num2, I would expect `$num1 + $num2` to DWIM. Unfortunately, with most overloaded classes written as below, they won't. (For more information as to how this code works, please read [`overload`]({{< perldoc "overload" >}}), or the excellent article "[Overloading](/pub/2003/07/22/overloading.html).")

    sub add {
        my ($l, $r, $inv) = @_;
        ($l, $r) = ($r, $l) if $inv;

        $l = ref $l ? $l->numify : $l;
        $r = ref $r ? $r->numify : $r;

        return $l + $r;
    }

Overload::Num1 uses the `numify()` method to retrieve the number associated with the class. Overload::Num2 uses the `get_number()` method. If I tried to use the two classes together, I would receive an error that looks something like *Can't locate object method "numify" via package "Overload::Num2"*.

The solution is very simple--don't define an `add()` method. Define a `numify` (`0+`) method, set fallback to true, and walk away. You don't need to define a method for each option. You only need to do so if you have to do something special as part of doing that operation. For example, complex numbers have to add the rational and complex parts separately.

If you absolutely have to define `add()`, though, use something like this:

    sub add {
        my ($l, $r, $inv) = @_;
        ($l, $r) = ($r, $l) if $inv;

        my $pkg = ref($l) || ref($r);

        # This is to explicitly call the appropriate numify() method
        $l = do {
            my $s = overload::Method( $l, '0+' );
            $s ? $s->($l) : $l
        };

        $r = do {
            my $s = overload::Method( $r, '0+' );
            $s ? $s->($r) : $r
        };

        return $pkg->new( $l + $r );
    }

This way, each overloaded class can handle things its way. The assumption, you'll notice, is to bless the return value into the class whose `add()` the caller called. This is acceptable; someone called its method, so *someone* thought it was top dog! (If you have an `add` method, no `numify` method, and fallback activated, you will enter an infinite loop because `numify` falls back to `$x + 0`.)

##### Finding Out What Something Is

At some point, your module needs to accept some data from somewhere. If you're like me, you want your module to DWIM based on what data it has received. Eventually, you want to know "Is it a scalar, arrayref, or hashref?" (Yes, I know there are seven different types in Perl.) There are many, many ways to do this. Some even work.

-   `ref()`

    `ref()` is the time-honored way to dispatch based on datatype, resulting in code that looks like:

        my $is_hash = ref( $data ) eq 'HASH';

    The problem is that `ref( $data )` will return the class name of `$data` if it's an object. If someone has defined a class named `HASH` (don't do that!) that uses blessed array references, this will also break spectacularly.

-   `isa()`

    `isa()` will tell you whether a reference inherits from a class. The various datatypes are actually class-like. Some people suggest writing code like:

        my $is_hash = UNIVERSAL::isa( $data, 'HASH' );

    This will work whether or not `$data` is blessed. Again, though, if someone is mean enough to call a class `HASH` and bless an arrayref into it, you'll have trouble. Worse, this technique may break polymorphism spectacularly if `$data` is an object with an overloaded `isa()` method.

-   `eval` blocks

    Just try the data as a hashref and see if it succeeds.

        my $is_hash = eval { %{$data}; 1 };

    This avoids the primary issue of the two options listed above, but this may unexpectedly succeed in the case of overloaded objects. If `$data` is a Number::Fraction, you will mistakenly use `$data` as a hash because Number::Fraction uses blessed hashes for objects, even though the intent is to use them as scalars.

-   Assume that objects are special

    By using [Scalar::Util]({{<mcpan "Scalar::Util" >}})'s `blessed()` and `reftype()` functions, you can determine if a given scalar is a blessed reference or what type of reference it really is. If you want to find out if something is a hash reference, but you want to avoid the pitfalls listed above, write:

        my $is_hash = ( !blessed( $data ) && ref $data eq 'HASH' );
        # or
        my $is_hash = reftype( $data ) eq 'HASH';

    Nearly every use of overloading is to make an object behave as a scalar, as in Number::Fraction and similar classes. Using this technique allows you to respect the client's wishes more easily. You will still miss a few possibilities, such as (the somewhat eccentric) [Object::MultiType]({{<mcpan "Object::MultiType" >}}) (an excellent example of what you *can* do in Perl, if you put your mind to it).

    My personal preference is to let `$data` tell *you* what it can do.

-   Object representations

    Not all objects are blessed hashrefs. I like to represent my objects as arrayrefs, and other people use Inside-Out objects which are references to undef that work with hidden data. This means that my overloaded numbers are arrays, but I want you to treat them as scalars. Unless you ask `$data` how it wants you to treat it, how will you handle it correctly?

-   Overloading accessors

    [`overload`]({{< perldoc "overload" >}}) allows you to overload the accessor operators, such as `@{}` and `%{}`. This means that one can theoretically bless an array reference and provide the ability to access it as a hash reference. Object::MultiType is an example of this. It is a hashref that provides array-like access.

    Unfortunately, the CPAN module that would do this doesn't exist, yet.

#### Letting Others Do Your Dirty Work

The modules that you and I use on a daily basis are, in general, as OS-portable, version-independent, and polite as possible. This means that the more your module depends upon other modules to do the dirty work, the less you have to worry about it. Modules like File::Spec and Scalar::Util exist to help you out. Other modules like [XML::Parser]({{<mcpan "XML::Parser" >}}) will do their jobs, but also handle things like any Unicode you encounter so that you don't have to.

That said, you still have to be careful with whom your young module fraternizes with. Every module you add as a dependency is another module that can restrict where your module can live. If one of your module's dependencies is Windows-only, such as anything from the Win32 namespace, then your module is now Windows-only. If one of your dependencies has a bug, then you also have that bug. Fortunately, there are a few ways to bypass these problems.

-   Buggy dependencies

    Generally, module authors fix bugs relatively quickly, especially if you've provided a test file that demonstrates the bug and a patch that makes those tests pass. Once your module's dependency has a new version released, you can release a new version that requires the version with the bug fix.

-   OS-specific dependencies

    The first option is to accept it. If no one on Atari MiNT cares, then why should you? Alternatively, you can encapsulate the OS-dependent module and find another module that provides the same features on the OS you're trying to support. File::Spec is an excellent example of how to encapsulate OS-specific behavior behind a common API.

There's a lot to keep in mind when writing a module for CPAN: OS and Perl versions, Unicode, threading, persistence--it can be very overwhelming at times. With a few simple steps and a willingness to let your users tell you what they need, you'll be the toast of the town.
