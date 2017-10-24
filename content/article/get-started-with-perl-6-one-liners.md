{
   "title" : "Get started with Perl 6 one liners",
   "categories" : "perl-6",
   "image" : "/images/136/76F864F4-70BD-11E4-97E0-E519A241EDA8.png",
   "description" : "One liners in Perl are better than ever",
   "slug" : "136/2014/11/20/Get-started-with-Perl-6-one-liners",
   "date" : "2014-11-20T14:04:56",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "tags" : [
      "windows",
      "one_liner",
      "perl",
      "terminal",
      "command_line",
      "perl-6",
      "rakudo",
      "old_site"
   ]
}


One thing that sets Perl apart from other languages is the ability to write small programs in a single line of code, known as a "one liner". It's often faster to type a program directly into the terminal than to write a throwaway script. And one liners are powerful too; they're complete Perl programs that can load external libraries but also integrate into the terminal. You can pipe data in or out of a one liner.

Like its predecessor, Perl 6 supports one liners. And in the same way Perl 6 cleaned up Perl 5's warts elsewhere, the one liner syntax is also better. It's cleaner with fewer special variables and options to memorize. This article aims to get you up-and-running with Perl 6 one liners.

### The basics

To get started with one liners, all you really need to understand is the `-e` option. This tells Perl to execute what follows as a program. For example:

    perl6 -e 'say "Hello, World!"'

Let's step through this code.

1.  `perl6` invokes the Perl 6 program
2.  `-e` tells Perl 6 to execute
3.  `'say "Hello, World!"'` is the program. Every program must be surrounded in single quotes (except on Windows, see ([converting for Windows](https://github.com/sillymoose/Perl6-One-Liners#converting-for-windows)).

To run a one-liner, just type it into the terminal:

``` prettyprint
> perl6 -e 'say "Hello, World!"'
Hello, World!
```

### File processing

If you want to load a file, just add the path to the file after the program code:

``` prettyprint
> perl6 -e 'for (lines) { say $_ }' /path/to/file.txt
```

This program prints every line in `/path/to/file.txt`. You may know that `$_` is the default variable, which in this case is the current line being looped through. `lines` is a list that is automatically created for you whenever you pass a filepath to a one-liner. Now let's re-write that one liner, step-by-step. These one liners are all equivalent:

``` prettyprint
> perl6 -e 'for (lines) { say $_ }' /path/to/file.txt
> perl6 -e 'for (lines) { $_.say }' /path/to/file.txt
> perl6 -e 'for (lines) { .say }' /path/to/file.txt
> perl6 -e '.say for (lines)' /path/to/file.txt
> perl6 -e '.say for lines' /path/to/file.txt
```

Just like `$_` is the default variable, methods called on the default variable can omit the variable name. They become default methods. So `$_.say` becomes `.say`. This brevity pays off with one liners - it's less typing!

The `-n` option changes the behavior of the program: it executes the code once for every line of the file. To uppercase and print every line of `/path/to/file.txt` you can type:

``` prettyprint
> perl6 -ne '.uc.say' /path/to/file.txt
```

The `-p` option is just like `-n` except that it will automatically print `$_`. This means that another way we could uppercase a file would be:

``` prettyprint
> perl6 -pe '$_ = $_.uc' /path/to/file.txt
```

Or by applying a shortcut, this does the same thing:

``` prettyprint
> perl6 -pe '.=uc' /path/to/file.txt
```

The `-n` and `-p` options are really useful and often spare the programmer from extra typing.

### Load modules

The final thing you should know is how to load a module. This is really powerful as you can extend Perl 6's capabilities by importing external libraries. The `-M` switch stands for load module:

``` prettyprint
> perl6 -M URI::Encode -e 'say encode_uri("/10 ways to crush it with Perl 6")'
```

The code `-M URI::Encode` loads the URI::Encode module, which exports the `encode_uri` subroutine. It prints:

``` prettyprint
%2F10%20ways%20to%20crush%20it%20with%20Perl%206
```

What if you have a module that is not installed in a standard location? In this case using `-M` alone won't work, as Perl won't find the module. For these scenarios, just pass use the `-I` switch to include the directory:

``` prettyprint
> perl6 -I lib -M URI::Encode -e 'say encode_uri("www.example.com/10 ways to crush it with Perl 6")'
```

Now Perl 6 will search for URI::Encode in `lib` as well as the standard install locations.

Finally, if you want a summary of all of these options, just use the `-h` option:

``` prettyprint
> perl6 -h
```

This will print:

``` prettyprint
    With no arguments, enters a REPL. With a "[programfile]" or the "-e" option, compiles the given program and by default also executes the compiled code.
 
    -c                   check syntax only (runs BEGIN and CHECK blocks)
    --doc                extract documentation and print it as text
    -e program           one line of program
    -h, --help           display this help text
    -n                   run program once for each line of input
    -p                   same as -n, but also print $_ at the end of lines
    -I path              adds the path to the module search path
    -M module            loads the module prior to running the program
    --target=[stage]     specify compilation stage to emit
    --optimize=[level]   use the given level of optimization (0..3)
    -t, --trace=[flags]  enable trace flags, see 'parrot --help-debug'
    --encoding=[mode]    specify string encoding mode
    -o, --output=[name]  specify name of output file
    -v, --version        display version information
    --stagestats         display time spent in the compilation stages
    --ll-exception       display a low level backtrace on errors
    --profile            print profile information to standard error
    --doc=[module]       Use Pod::To::[module] to render inline documentation.
     
    Note that only boolean single-letter options may be bundled.

    Output from --profile can be visualized by kcachegrind.

    To modify the include path, you can set the PERL6LIB environment variable:

    PERL6LIB="lib" perl6 example.pl

    For more information, see the perl6(1) man page.
```

### Conclusion

This article was adapted from my open source [book](https://github.com/sillymoose/Perl6-One-Liners), which has lots of example Perl 6 one liners, many of which were contributed by the Perl 6 community. If you're interested in learning more Perl 6, I'd recommend visiting the official [website](http://perl6.org/), which has links to the IRC channel and official documentation.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
