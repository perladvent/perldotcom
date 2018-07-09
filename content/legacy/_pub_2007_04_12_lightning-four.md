{
   "authors" : [
      "shlomi-fish",
      "brian-d-foy",
      "bob-free",
      "mike-friedman"
   ],
   "draft" : null,
   "description" : " by Mike Friedman Good software design principles tell us that we should work to separate unrelated concerns. For example, the popular Model-View-Controller (MVC) pattern is common in web application designs. In MVC, separate modular components form a model, which...",
   "slug" : "/pub/2007/04/12/lightning-four.html",
   "tags" : [
      "aop",
      "cross-cutting-concerns",
      "glut",
      "opengl",
      "pogl",
      "subroutine-attributes",
      "test-counts",
      "c-and-perl"
   ],
   "thumbnail" : null,
   "categories" : "development",
   "image" : null,
   "title" : "Lightning Strikes Four Times",
   "date" : "2007-04-12T00:00:00-08:00"
}



by Mike Friedman

Good software design principles tell us that we should work to separate unrelated concerns. For example, the popular Model-View-Controller (MVC) pattern is common in web application designs. In MVC, separate modular components form a *model*, which provides access to a data source, a *view*, which presents the data to the end user, and a *controller*, which implements the required features.

Ideally, it's possible to replace any one of these components without breaking the whole system. A templating engine that translates the application's data into HTML (the *view*) could be replaced with one that generates YAML or a PDF file. The *model* and *controller* shouldn't be affected by changing the way that the *view* presents data to the user.

Other concerns are difficult to separate. In the world of aspect-oriented programming, a *crosscutting concern* is a facet of a program which is difficult to modularize because it must interact with many disparate pieces of your system.

Consider an application that logs copious trace data when in debugging mode. In order to ensure that it is operating correctly, you may want to log when it enters and exits each subroutine. A typical way to accomplish this is by conditionally executing a logging function based on the value of a constant, which turns debugging on and off.

        use strict;
        use warnings;

        use constant DEBUG => 1;

        sub do_something { 
            log_message("I'm doing something") if DEBUG;

            # do something here

            log_message("I'm done doing something") if DEBUG;
        }

This solution is simple, but it presents a few problems. Perhaps most strikingly, it's simply a lot of code to write. For each subroutine that you want to log, you must write two nearly identical lines of code. In a large system with hundreds or thousands of subroutines, this gets tedious fast, and can lead to inconsistently formatted messages as every copy-paste-edit cycle tweaks them a little bit.

Further, it offends the simple design goal of an MVC framework, because every component must talk to the logging system directly.

One way to improve this technique is to automatically wrap every interesting subroutine in a special logging function. There are a few ways to go about this. One of the simplest is to use subroutine attributes to install a dynamically generated wrapper.

### Attributes

Perl 5.6 introduced *attributes* that allow you to add arbitrary metadata to a variable. Attributes can be attached both to package variables, including subroutines, and lexical variables. Since Perl 5.8, attributes on lexical variables apply at runtime. Attributes on package variables activate at compile-time.

The interface to Perl attributes is via the [attributes](https://metacpan.org/pod/attributes) pragma. (The older attrs is deprecated.) The CPAN module [Attribute::Handlers](https://metacpan.org/pod/Attribute::Handlers) makes working with attributes a bit easier. Here's an example of how you might rewrite the logging system using an attribute handler.

        use strict;
        use warnings;

        use constant DEBUG => 1;

        use Attribute::Handlers;

        sub _log : ATTR(CODE) {
            my ($pkg, $sym, $code) = @_;

            if( DEBUG ) {
                my $name = *{ $sym }{NAME};

                no warnings 'redefine';

                *{ $sym } = sub {
                    log_message("Entering sub $pkg\:\:$name");
                    my @ret = $code->( @_ );
                    log_message("Leaving sub $pkg\:\:$name");
                    return @ret;
                };
            }
        }

        sub do_something : _log {
            print "I'm doing something.\n";
        }

Attributes are declared by placing a colon (:) and the attribute name after a variable or subroutine declaration. Optionally, the attribute can receive some data as a parameter; `Attribute::Handlers` goes to great lengths to massage the passed data for you if necessary.

To set up an attribute handler, the code declares a subroutine, `_log`, with the `ATTR` attribute, passing the string `CODE` as a parameter. `Attribute::Handlers` provides `ATTR`, and the `CODE` parameter tells it that the new handler only applies to subroutines.

During compile time, any subroutine declared with the `_log` attribute causes Perl to call the attribute handler with several parameters. The first three are the package in which the subroutine was compiled, a reference to the typeglob where its symbol lives, and a reference to the subroutine itself. These are sufficient for now.

If the `DEBUG` constant is true, the handler sets to work wrapping the newly compiled subroutine. First, it grabs its name from the typeglob, then it adds a new subroutine to its spot in the symbol table. Because the code redefines a package symbol, it's important to turn off warnings for symbol redefinitions in within this block.

Because the new function is a lexical closure over `$pkg`, `$name`, and most importantly `$code`, it can use those values to construct the logging messages and call the original function.

All of this may seem like a lot of work, but once it's done, all you need to do to enable entry and exit logging for any function is to simply apply the `_log` attribute. The logging messages themselves get manufactured via closures when the program compiles, so we know they'll always be consistent. If you want to change them, you only have to do it in one place.

Best of all, because attribute handlers get inherited, if you define your handler in a base class, any subclass can use it.

### Caveats

Although this is a powerful technique, it isn't perfect. The code will not properly wrap anonymous subroutines, and it won't necessarily propagate calling context to the wrapped functions. Further, using this technique will significantly increase the number of subroutine dispatches that your program must execute during runtime. Depending on your program's complexity, this may significantly increase the size of your call stack. If blinding speed is a major design goal, this strategy may not be for you.

### Going Further

Other common cross-cutting concerns are authentication and authorization systems. Subroutine attributes can wrap functions in a security checker that will refuse to call the functions to callers without the proper credentials.

### Perl Outperforms C with OpenGL

by Bob Free

Desktop developers often assume that compiled languages always perform better than interpreted languages such as Perl.

Conversely, most LAMP online service developers are familiar with mechanisms for preloading Perl interpreters modules (such as Apache mod\_perl and ActivePerl/ISAPI), and know that Perl performance often approaches that of C/C++.

However, few 3D developers think of Perl when it comes to performance. They should.

GPUs are increasingly taking the load off of CPUs for number-crunching. Modern GPGPU processing leverages C-like programs and loads large data arrays onto the GPU, where processing executes independent of the CPU. As a result, the overall contribution of CPU-bound programs diminish, while Perl and C differences become statistically insignificant in terms of GPU performance.

The author has recently published a open source update to CPAN's [OpenGL](https://metacpan.org/pod/OpenGL) module, adding support for GPGPU features. With this release, he has also posted OpenGL Perl versus C benchmarks--demonstrating cases where Perl outperforms C for OpenGL operations.

### What Is OpenGL?

OpenGL is an industry-standard, cross-platform language for rendering 3D images. Originally developed by Silicon Graphics Inc. (SGI), it is now in wide use for 3D CAD/GIS systems, game development, and computer graphics (CG) effects in film.

With the advent of Graphic Processing Units (GPU), realistic, real-time 3D rendering has become common--even in game consoles. GPUs are designed to process large arrays of data, such as 3D vertices, textures, surface normals, and color spaces.

It quickly became clear that the GPU's ability to process large amounts of data could expand well beyond just 3D rendering, and could applied to General Purpose GPU (GPGPU) processing. GPGPUs can process complex physics problems, deal with particle simluations, provide database analytics, etc.

Over the years, OpenGL has expanded to support GPGPU processing, making it simple to load C-like programs into GPU memory for fast execution, to load large arrays of data in the form of *textures*, and to quickly move data between the GPU and CPU via Frame Buffer Objects (FBO).

While OpenGL is in itself a portable language, it provides no interfaces to operating system (OS) display systems. As a result, Unix systems generally rely on an X11-based library called GLX; Windows relies on a WGL interface. Several libraries, such as [GLUT](http://www.opengl.org/resources/libraries/glut/), help to abstract these differences. However, as OpenGL added new extensions, OS vendors (Microsoft in particular) provided different methods for accessing the new APIs, making it difficult to write cross-platform GPGPU code.

### Perl OpenGL (POGL)

Bob Free of Graphcomp has just released a new, portable, open source Perl OpenGL module (POGL 0.55).

This module adds support for 52 new OpenGL extensions, including many GPGPU features such as Vertex Arrays, Frame Buffer Objects, Vertext Programs, and Fragment Programs.

In terms of 3D processing, these extensions allow developers to perform real-time dynamic vertex and texturemap generation and manipulation within the GPU. This module also simplifies GPGPU processing by moving data to and from the CPU through textures, and loading low-level, assembly-like instructions to the GPU.

POGL 0.55 is a binary Perl module (written in C via XS), that has been tested on Windows (NT/XP/Vista) and Linux (Fedora 6. Ubuntu/Dapper). Source and binaries are available via SVN, PPM, tarball, and ZIP at the [POGL homepage](http://graphcomp.com/opengl).

POGL OS Performance

The POGL homepage includes initial benchmarks comparing POGL on Vista, Fedora, and Ubuntu. These tests show that static texture rendering on an animated object on Fedora was 10x faster than Vista; Ubuntu was 15x faster (using the same nVidia cards, drivers, and machine).

A subsequent, tighter benchmark eliminated UI and FPS counters, and focused more on dynamic texturemap generation. These results, posted on [OpenGL C versus Perl benchmarks](http://graphcomp.com/opengl/bench.html), show comparable numbers for Fedora and Ubuntu, with both outperforming Vista by about 60 percent.

Note: a further performance on these benchmarks could be available through the use of GPU vertex arrays.

### Perl versus C Performance

These benchmarks also compare Perl against C code. It found no statistical difference between overall Perl and C performance on Linux. Inexplicably, Perl frequently outperformed C on Vista.

In general, C performed better than Perl on Vertex/Fragment Shader operations, while Perl outperformed C on FBO operations. In this benchmark, overall performance was essentially equal between Perl and C.

The similarity in performance is explained by several factors:

-   GPU is performing the bulk of the number-crunching operations
-   POGL is a compiled C module
-   Non-GPU operations are minimal

In cases where code dynamically generates or otherwise modifies the GPU's vetex/fragment shader code, it is conceivable that Perl would provide even better than C, due to Perl's optimized and interpreted string handling.

### Perl Advantages

Given that GPGPU performance will be a wash in most cases, the primary reason for using a compiled language is to obfuscate source for intellectual property (IP) reasons.

For server-side development, there's really no reason to use a compiled language for GPGPU operations, and several reasons to go with Perl:

-   Perl OpenGL code is more portable than C; therefore there are fewer lines of code
-   Numerous imaging modules for loading GPGPU data arrays (textures)
-   Portable, open source modules for system and auxiliary functions
-   Perl (under mod-perl/ISAPI) is generally faster than Java
-   It is easier to port Perl to/from C than Python or Ruby
-   As of this writing, there is no FBO support in Java, Python, or Ruby

There is a side-by-side code comparison between C and Perl posted on the above benchmark page.

Desktop OpenGL/GPU developers may find it faster to prototype code in Perl (e.g., simpler string handling and garbage collection), and then port their code to C later (if necessary). Developers can code in one window and execute in another--with no IDE, no compiling--allowing innovators/researchers to do real-time experiments with new shader algorithms.

Physicists can quickly develop new models; researchers and media developers can create new experimental effects and reduce their time to market.

### Summary

Performance is not a reason a reason to use C over Perl for OpenGL and GPGPU operations, and there are many cases where Perl is preferable to C (or Java/Python/Ruby).

By writing your OpenGL/GPU code in Perl, you will likely:

-   Reduce your R&D costs and time to market
-   Expand your platform/deployment options
-   Accelerate your company's GPGPU ramp up

### Using Test::Count

by Shlomi Fish

A typical [Test::More](https://metacpan.org/pod/Test::More) test script contains several checks. It is preferable to keep track of the number of checks that the script is running (using `use Test::More tests => $NUM_CHECKS` or the `plan tests => $NUM_CHECKS`), so that if some checks are not run (for whatever reason), the test script will still fail when being run by the harness.

If you add more checks to a test file, then you have to remember to update the plan. However, how do you keep track of how many tests *should* run? I've already encountered a case where [a DBI related module](http://dbi.perl.org/) had a different number of tests with an older version of DBI than with a more recent one.

Enter [Test::Count](https://metacpan.org/pod/Test::Count). Test::Count originated from a [Vim](http://www.vim.org/) script I wrote to keep track of the number of tests by using meta-comments such as `# TEST` (for one test) or `# TEST*3*5` (for 15 tests). However, there was a limit to what I could do with Vim's scripting language, as I wanted a richer syntax for specifying the tests as well as variables.

Thus, I wrote the Test::Count module and placed it on CPAN. [Test::Count::Filter](http://search.cpan.org/dist/Test-Count/lib/Test/Count/Filter.pm) acts as a filter, counts the tests, and updates them. Here's an example, taken from a code I wrote for a Perl Quiz of the Week:

    #!/usr/bin/perl -w

    # This file implements various functions to remove
    # all periods ("."'s) except the last from a string.

    use strict;

    use Test::More tests => 5;
    use String::ShellQuote;

    sub via_split
    {
        my $s = shift;
        my @components = split(/\./, $s, -1);
        if (@components == 1)
        {
            return $s;
        }
        my $last = pop(@components);
        return join("", @components) . "." . $last;
    }

    # Other Functions snipped.

    # TEST:$num_tests=9
    # TEST:$num_funcs=8
    # TEST*$num_tests*$num_funcs
    foreach my $f (@funcs)
    {
        my $ref = eval ("\\&$f");
        is($ref->("hello.world.txt"), "helloworld.txt", "$f - simple"); # 1
        is($ref->("hello-there"), "hello-there", "$f - zero periods"); # 2
        is($ref->("hello..too.pl"), "hellotoo.pl", "$f - double"); # 3
        is($ref->("magna..carta"), "magna.carta", "$f - double at end"); # 4
        is($ref->("the-more-the-merrier.jpg"),
           "the-more-the-merrier.jpg", "$f - one period"); # 5
        is($ref->("hello."), "hello.", "$f - one period at end"); # 6
        is($ref->("perl.txt."), "perltxt.", "$f - period at end"); # 7
        is($ref->(".yes"), ".yes", "$f - one period at start"); # 8
        is($ref->(".yes.txt"), "yes.txt", "$f - period at start"); # 9
    }

Filtering this script through `Test::Count::Filter` provides the correct number of tests. I then add this to my *.vimrc*:

    function! Perl_Tests_Count()
        %!perl -MTest::Count::Filter -e 'Test::Count::Filter->new({})->process()'
    endfunction

    autocmd BufNewFile,BufRead *.t map <F3> :call Perl_Tests_Count()<CR>

Now I can press F3 to update the number of checks.

`Test::Count` supports +,-,\*, /, as well as parentheses, so it is expressive enough for most needs.

### Acknowledgements

Thanks to mrMister from [Freenode](http://www.freenode.net/) for going over earlier drafts of this article and correcting some problems.

### What's In that Scalar?

by brian d foy

Scalars are simple, right? They hold single values, and you don't even have to care what those values are because Perl figures out if they are numbers or strings. Well, scalars show up just about anywhere and it's much more complicated than single values. I could have `undef`, a number or string, or a reference. That reference can be a normal reference, a blessed reference, or even a hidden reference as a tied variable.

Perhaps I have a scalar variable which should be an object (a blessed reference, which is a single value), but before I call a method on it I want to ensure it is to avoid the "unblessed reference" error that kills my program. I might try the `ref` built-in to get the class name:

       if( ref $maybe_object ) { ... }

There's a bug there. `ref` returns an empty string if the scalar isn't an object. It might return `0`, a false value, and yes, some Perl people have figured out how to create a package named `0` just to mess with this. I might think that checking for defined-ness would work:

       if( defined ref $maybe_object ) { ... }

... but the empty string is also defined. I want all the cases where it is not the one value that means it's not a reference.

       unless( '' eq ref $maybe_object ) { ... }

This still doesn't tell me if I have an object. I know it's a reference, but maybe it's a regular data reference. The `blessed` function from [Scalar::Util](https://metacpan.org/pod/Scalar::Util) can help:

       if( blessed $maybe_object ) { ... }

This almost has the same problem as `ref`. `blessed` returns the package name if it's an object, and `undef` otherwise. I really need to check for defined-ness.

       if( defined blessed $maybe_object ) { ... }

Even if `blessed` returns `undef`, I still might have a hidden object. If the scalar is a tied variable, there's really an object underneath it, although the scalar acts as if it's a normal variable. Although I normally don't need to interact with the secret object, the `tied` built-in returns the secret object if there is one, and `undef` otherwise.

            my $secret_object = tied $maybe_tied_scalar;

            if( defined $secret_object ) { ... }

Once I have the secret object in `$secret_object`, I treat it like any other object.

Now I'm sure I have an object, but that doesn't mean I know which methods I can call. The `isa` function in the `UNIVERSAL` package supposedly can figure this out for me. It tells me if a class is somewhere in an object's inheritance tree. I want to know if my object can do what a `Horse` can do, even if I have a `RaceHorse`:

       if( UNIVERSAL::isa( $object, 'RaceHorse' ) {
               $object->method;
               }

...what if the `RaceHorse` class is just a factory for objects in some other class that I'm not supposed to know about? I'll make a new object as a prototype just to get its reference:

       if( UNIVERSAL::isa( $object, ref RaceHorse->new() ) {
               $object->method;
               }

A real object-oriented programmer doesn't care what sort of object it is as long as it can respond to the right method. I should use `can` instead:

       if( UNIVERSAL::can( $object, $method ) {
               $object->method;
               }

This doesn't always work either. `can` only knows about defined subroutine names, and only looks in the inheritance tree for them. It can't detect methods from `AUTOLOAD` or traits. I could override the `can` method to handle those, but I have to call it as a method (this works for `isa` too):

       if( $object->can( $method ) ) {
               $object->method;
               }

What if `$object` wasn't really an object? I just called a method on a non-object! I'm back to my original problem, but I don't want to use all of those tests I just went through. I'll fix this with an `eval`, which catches the error for non-objects:

       if( eval{ $object->can( $method ) } ) {
               $object->method;
               }

...but what if someone installed a `__DIE__` handler that simply `exit`-ed instead of `die`-ing? Programmers do that sort of thing forgetting that it affects the entire program.

       $SIG{__DIE__} = sub { exit };

Now my `eval` tries to `die` because it caught the error, but the `__DIE__` handler says `exit`, so the program stops without an error. I have to localize the `__DIE__` handler:

       if( eval{ local $SIG{__DIE__}; $object->can( $method ) } ) {
               $object->method;
               }

If I'm the guy responsible for the `__DIE__` handler, I could use `$^S` to see if I'm in an `eval`:

       $SIG{__DIE__} = sub { $^S ? die : exit };

That's solved it, right? Not quite. Why do all of that checking? I can just call the method and hope for the best. If I get an error, so be it:

       my $result = eval { $object->method };

Now I have to wrap all of my method calls in an eval. None of this would really be a problem if Perl were an object language. Or is it? The [autobox](https://metacpan.org/pod/autobox) module makes Perl data types look like objects:

       use autobox;

       sub SCALAR::println { print $_[0], "\n" }

       'Hello World'->println;

That works because it uses a special package `SCALAR`, although I need to define methods in it myself. I'll catch unknown methods with `AUTOLOAD`:

       sub SCALAR::AUTOLOAD {}

Or, I can just wait for Perl 6 when these things get much less murky because everything is an object.
