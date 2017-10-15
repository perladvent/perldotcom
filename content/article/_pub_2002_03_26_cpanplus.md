{
   "description" : " Setting: A warm August day, somewhere in Amsterdam. In the bar of Yet Another Hotel. A large number of people are gathered. Judging by their attire, they're not here for business - or at least not the business of...",
   "slug" : "/pub/2002/03/26/cpanplus.html",
   "draft" : null,
   "authors" : [
      "jos-boumans"
   ],
   "thumbnail" : null,
   "tags" : [
      "cpan-cpanplus"
   ],
   "date" : "2002-03-26T00:00:00-08:00",
   "image" : null,
   "title" : "CPAN PLUS",
   "categories" : "cpan"
}



Setting: A warm August day, somewhere in Amsterdam. In the bar of Yet Another Hotel. A large number of people are gathered. Judging by their attire, they're not here for business -- or at least not the business of selling vacuum cleaners. They notice the sun and appreciate it, but it is the shining light of their laptops that captivates them.

A man with long dark hair stands up -- he appears to be the leader of this unusal congregation. He's wearing overalls and is barefoot.

He begins to speak of something called "see pants," which has the potential to change the world of the laptop-people. It would alter the way free software is distributed. It would receive a mark of quality; it would be tested and reviewed. And gosh darnit, it would be good.

That man was Michael Schwern. His idea was CPANTS, the "CPAN Testing Service," and the occasion was YAPC::Europe 2001. But CPANTS required work. Each of us set off with our own little part, trying to make the world a better place.

Being a novice to the Perl community and eager for a challenging project to sink my teeth into, I offered to patch `CPAN.pm` so that CPANTS could automatically build modules and test them. I imagined this would be a simple role.

I started looking through the sources of `CPAN.pm`. Although in my experience as a user, `CPAN.pm` had always worked as advertised, as a developer I was confronted with its limitations: It was not very modular, allowing few additions to its functionality; it had a limited programming interface, being basically designed for interactive use.

So there I stood, having made a commitment to ameliorate the CPAN-interface and lacking the code base to do so, with two choices: Complain or Fix. Since complaining wouldn't give the desired result, the only remaining option was to start anew.

Thus CPANPLUS was born. Its objective is simple: do what `CPAN.pm` does, but do it better. We'd start with a clean code base designed to accommodate different types of use. But at the same time, this code should be a starting point, not the end point.

So is CPANPLUS better? That's for you to decide. The project began in October 2001, and late March 2002 marks the first official release on CPAN, timed to accompany this article.

#### Setting Up CPANPLUS

Setting up CPANPLUS should be simple. It is installed like any other Perl module:

        perl Makefile.PL
        make
        make test
        make install

The setup of CPANPLUS happens with "perl Makefile.PL." CPANPLUS will attempt to do two things at this point:

-   write an appropriate configuration for your system; and
-   probe for modules CPANPLUS would like to have, but which are not required.

Currently, the configuration is not automatic, so you will be prompted to answer some questions about your system, although in many cases the default values are acceptable. CPANPLUS will then fetch the index files for the first time and ask you to choose your favorite CPAN mirrors. You can pick from a list, or specify your own.

One question remains: Should we probe for missing modules? It is recommended that you do so, because CPANPLUS is faster and better with those modules installed. It's up to you, however: CPANPLUS does not require any noncore modules to run.

Continue with `make` and `make test`. All tests should pass -- if they don't, something is wrong. A list of tested platforms is available at [the CPANPLUS FAQ site](http://cpanplus.sourceforge.net/faq.html). Finally, run "make install" and CPANPLUS will be installed on your system!

#### The Structure of CPANPLUS

As you may have noticed if you've looked at the sources, CPANPLUS is spread out over many modules. This is because of heavy subclassing: We believe that each specific task should have its own space in the CPANPLUS library. This modular build allows for extensions to the library and many plugins.

There are two modules that are of particular interest to users of CPANPLUS. One is the user-interface `CPANPLUS::Shell`, and the other is the programming-interface `CPANPLUS::Backend`. Both modules will be explained in more depth later. Two other modules allow you to alter the behavior of the library at run time. These are `CPANPLUS::Error`, which allows you to manipulate error messages to and from CPANPLUS; and `CPANPLUS::Configure`, which allows you to change the configuration at runtime. They're definately worth looking at if you are a developer using CPANPLUS.

### The User's Interface: '`Shell`'

In truth, it isn't fair to say that "Shell" is *the* user's interface; CPANPLUS is designed to work with any number of shells. In fact, if you want to write your own shell, then that's possible. At the moment, only the default shell exists, but Jouke Visser is at work on a `wxPerl` shell.

You can specify which shell you wish to run in your configuration file. The default is `CPANPLUS::Shell::Default`.

There are two ways to invoke the shell. One is the familiar way:

`perl -MCPANPLUS -eshell`

There is also an executable in your Perl bin directory:

` cpanp`

The `-M` syntax also accepts a few flags that allow you to install modules from the command line. See the perldoc for CPANPLUS for details.

Now let's look at using the default shell.

One of its features is that each command works with a single letter. This could be called the "compact shell" as it is designed to be small, but still provide all the basic commands you need.

Here is a short summary of the command options available, which can also be seen by typing "h" or "?" at the shell prompt:

        a AUTHOR [ AUTHOR]    Search by author or authors
        m MODULE [ MODULE]    Search by module or modules
        i MODULE | NUMBER     Install a module by name or previous result
        d MODULE | NUMBER     Download a module to the current directory
        l MODULE [ MODULE]    Display detailed information about a module
        e DIR    [ DIR]       Add directories to your @INC
        f AUTHOR [ AUTHOR]    List all distributions by an author
        s OPTION VALUE        Set configuration options for this session
        p [ FILE]             Print the error stack (optionally to a file)
        h | ?                 Display help
        q                     Exit the shell

Let's assume you want to see whether you can install a module in the `Acme::` namespace.

First, you'd look for modules that match your criteria with a module search:

`    m ^acme::`

As you can see, a search can take a regular expression. It's a feature of the default shell that all searches are case-insensitive.

This search will return a result like this:

        0001  Acme::Bleach          1.12    DCONWAY
        0002  Acme::Buffy           undef   LBROCARD
        0003  Acme::Colour          0.16    LBROCARD
        0004  Acme::ComeFrom        0.05    AUTRIJUS
        0005  Acme::DWIM            1.05    DCONWAY

The first number is simply the ID for this search, which can be used as a shortcut for subsequent commands. The next column is the name of the module, followed by a version number. The last is the CPAN id of the author.

Imagine you'd like to get more information about `Acme::Buffy`. Simply type:

     l Acme::Buffy

Or, to save effort, the ID from the most recent search can be used:

` l 2`

This will give results like this:

      Details for Acme::Buffy:
      Description               An encoding scheme for Buffy fans
      Development Stage         Released
      Interface Style           hybrid, object and function interfaces available
      Language Used             Perl-only, no compiler needed, should be platform independent
      Package                 Acme-Buffy-1.2.tar.gz
      Support Level             Developer
      Version                   undef

If "Acme::Buffy" looks appealing, then you can install it:

`i 2`

That's all you need to install modules with CPANPLUS.

### The Programmer's Interface: '`Backend`'

CPANPLUS shells are built upon the CPANPLUS::Backend module. Backend provides generic functions for module management tasks. It is suitable for creating not only shells, but also autonomous programs.

Rather than describe in detail all the available methods, which are documented in the CPANPLUS::Backend pod, I will give a few bits of sample code to show what you can do with Backend.

        ### Install all modules in the POE:: namespace ###
        my $cb = new CPANPLUS::Backend;
        my $hr = $cb->search( type => 'module', list => [qw|^POE$ ^POE::.*|] );
        my $rv = $cb->install( modules => [ keys %$hr ] );

The variable `$rv` is a hash reference where the keys are the names of the modules and the values are exit states. This allows you to check how the installation went for each module. You can also get an error object from `Backend` with a complete history of what CPANPLUS did while installing these modules.

        ### Fetch a certain version of LWP ###
        my $cb = new CPANPLUS::Backend;
        my $rv = $cb->fetch( modules => ['/G/GA/GAAS/libwww-perl-5.62.tar.gz'] );

Once again, `$rv` is a hash reference, where the key is the module you tried to fetch and the value is the location on your disk where it was stored. Some people might not care for the way searches are handled and would rather roll their own. `Backend` allows you to take matters into your own hands:

        ### Do your own thing ###
        my $cb = new CPANPLUS::Backend;
        my $mt = $cb->module_tree();

`$mt` now holds the complete module tree, which is the same tree CPANPLUS uses internally. For this hash reference, the keys are the names of modules, and values are `CPANPLUS::Internals::Module` objects.

        for my $name ( keys %$mt ) {
            if ($name =~ /^Acme/) {
                my $href = $mt->{$name}->modules();
                
                while ( my ($mod,$obj) = each %$href ) {
                    print $obj->install()
                        ? "$mod installed succesfully\n"
                        : "$mod installation failed!\n";
                }
            }
        }

This traverses the module tree, looking for module names that match the regular expression `'/^Acme/'` and installing all modules by the same author.

Why would you want to do this? We all have our reasons, and mine is that the `Acme::` namespace is CPAN's bleeding edge codebase. Authors who have modules there must be trustworthy!

### Merits of the Interfaces

In addition to the modules I've mentioned, there are plenty more: CPANPLUS currently contains 17 modules. These modules are part of a three-tiered approach. Underneath everything sits `Internals`, which performs the nitty-gritty work; `Backend` rests on top of it; and finally `Shell` provides a user interface.

The logic beyond the layered structure is that everyone wants something different from CPANPLUS. Some people just want a working shell like `CPAN.pm` provided. Others need a way to write applications that manage Perl installations. Still others dream of more elaborate plugins, like CPANTS or an automatic bug ticketing with RT -- something which is already planned.

The division allows us to stay flexible. There is something for everyone in CPANPLUS -- and if it's not there yet, it can probably be built upon the existing codebase.

### Current and Future Developments

CPANPLUS was just released, but we're not resting. There's still a lot of functionality we want to provide.

It's high priority to create backward compatibility with the current `CPAN.pm` so CPANPLUS can eventually be released as `CPAN.pm`, possibly taking over its place in the core Perl distribution.

Another development that was already mentioned is automatic bug reporting, which would give authors of modules feedback on the performance of their modules on varying platforms, under various configurations. Of course, there's also CPANTS, the idea that sparked the entire CPANPLUS project. CPANTS is intended to provide automated testing of CPAN modules to make certain they meet minimal standards.

We have thoughts about integrating with known package managers like `PPM`, `RPM` and `dpkg`.

We also plan to develop more shells, both for the command-line and for the Windows and X environments.

Naturally, we don't want to stop there. There are a million possibilities with CPANPLUS, and hopefully they'll all be explored and developed.

If you have a good idea, then mail us your suggestion; or better yet, join as a developer and contribute!

#### Support and Contributing

If you have questions or suggestions, or want to join up as a developer, then send mail to: <cpanplus-info@lists.sourceforge.net>. This is the general mailing list.

Reports of bugs should be sent to: <cpanplus-bugs@lists.sourceforge.net> Some of the developers are also regulars on the IRC channel \#CP on magnet.

### Where to Get CPANPLUS

There are two places where you can obtain CPANPLUS. The first is, of course, to check your local CPAN mirror (or look it up on [search.cpan.org](http://search.cpan.org/)). The latest stable release will always be there.

If you are interested in development versions, then look at [Sourceforge](http://cpanplus.sourceforge.net/downdev.html).

#### More Information

In addition to the documents that come with CPANPLUS, information is available on our [Web site](http://cpanplus.sourceforge.net). All good things stem from there.

On a side note, I will be giving speeches and tutorials on CPANPLUS at both [YAPC::America::North](http://www.yapc.org/America/) and [YAPC::Europe](http://www.yapc.org/Europe), as well as [TPC](http://conferences.oreillynet.com/os2002/). Come by and share your ideas!

#### Credits

Of course, I couldn't end without giving credit to the other developers. Although I started CPANPLUS, it would never have become what it is now without Joshua Boschert and Autrijus Tang. Ann Barcomb wrote all the documentation and Michael Schwern provided tests and just general good ideas. Thanks also goes to everyone who contributed with posts to the development and bug mailing lists.

#### Conclusion

So here we are, eight months after that first magical gathering. One step closer to the goal. And one step closer to Yet Another Venue. And perhaps there, I'll be standing up, talking about new things, or at least CPANPLUS.

Hopefully I'll be able to meet you there, in a circle of laptops, and we'll continue to make our world a better place!
