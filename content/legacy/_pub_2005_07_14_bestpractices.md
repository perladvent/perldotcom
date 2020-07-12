{
   "description" : " The following ten tips come from Perl Best Practices, a new book of Perl coding and development guidelines by Damian Conway. 1. Design the Module's Interface First The most important aspect of any module is not how it implements...",
   "slug" : "/pub/2005/07/14/bestpractices.html",
   "authors" : [
      "damian-conway"
   ],
   "draft" : null,
   "thumbnail" : "/images/_pub_2005_07_14_bestpractices/111-best_practices.gif",
   "tags" : [
      "maintainable-perl",
      "perl-best-practices",
      "perl-development",
      "perl-discipline",
      "perl-style",
      "serious-perl",
      "style-guides",
      "troubleshooting"
   ],
   "date" : "2005-07-14T00:00:00-08:00",
   "title" : "Ten Essential Development Practices",
   "image" : null,
   "categories" : "development"
}



The following ten tips come from *[Perl Best Practices](http://www.oreilly.com/catalog/perlbp/)*, a new book of Perl coding and development guidelines by Damian Conway.

### 1. Design the Module's Interface First

The most important aspect of any module is not how it implements the facilities it provides, but the way in which it provides those facilities in the first place. If the module's API is too awkward, or too complex, or too extensive, or too fragmented, or even just poorly named, developers will avoid using it. They'll write their own code instead. In that way, a poorly designed module can actually reduce the overall maintainability of a system.

Designing module interfaces requires both experience and creativity. Perhaps the easiest way to work out how an interface should work is to "play test" it: to write examples of code that will use the module before implementing the module itself. These examples will not be wasted when the design is complete. You can usually recycle them into demos, documentation examples, or the core of a test suite.

[<img src="http://conferences.oreillynet.com/images/os2005/banners/120x240.gif" alt="O&#39;Reilly Open Source Convention 2005." width="120" height="240" />](http://conferences.oreillynet.com/os2005/)
The key, however, is to write that code as if the module were already available, and write it the way you'd most like the module to work.

Once you have some idea of the interface you want to create, convert your "play tests" into actual tests (see Tip \#2). Then it's just a Simple Matter Of Programming to make the module work the way that the code examples and the tests want it to.

Of course, it may not be possible for the module to work the way you'd most like, in which case attempting to implement it that way will help you determine what aspects of your API are not practical, and allow you to work out what might be an acceptable alternative.

### 2. Write the Test Cases Before the Code

Probably the single best practice in all of software development is writing your test suite first.

A test suite is an executable, self-verifying specification of the behavior of a piece of software. If you have a test suite, you can--at any point in the development process--verify that the code works as expected. If you have a test suite, you can--after any changes during the maintenance cycle--verify that the code still works as expected.

Write the tests first. Write them as soon as you know what your interface will be (see \#1). Write them before you start coding your application or module. Unless you have tests, you have no unequivocal specification of what the software should do, and no way of knowing whether it does it.

Writing tests always seems like a chore, and an unproductive chore at that: you don't have anything to test yet, so why write tests? Yet most developers will--almost automatically--write driver software to test their new module in an ad hoc way:<span id="OLE_LINK428"></span>

    > cat try_inflections.pl

    # Test my shiny new English inflections module...

    use Lingua::EN::Inflect qw( inflect );

    # Try some plurals (both standard and unusual inflections)...

    my %plural_of = (
       'house'         => 'houses',
       'mouse'         => 'mice',
       'box'           => 'boxes',
       'ox'            => 'oxen',
       'goose'         => 'geese',
       'mongoose'      => 'mongooses',
       'law'           => 'laws',
       'mother-in-law' => 'mothers-in-law',
    );

    # For each of them, print both the expected result and the actual inflection...

    for my $word ( keys %plural_of ) {
       my $expected = $plural_of{$word};
       my $computed = inflect( "PL_N($word)" );

       print "For $word:\n",
             "\tExpected: $expected\n",
             "\tComputed: $computed\n";
    }

A driver like that is actually harder to write than a test suite, because you have to worry about formatting the output in a way that is easy to read. It's also much harder to use the driver than it would be to use a test suite, because every time you run it you have to wade though that formatted output and verify "by eye" that everything is as it should be. That's also error-prone; eyes are not optimized for picking out small differences in the middle of large amounts of nearly identical text.

Instead of hacking together a driver program, it's easier to write a test program using the standard [Test::Simple]({{<mcpan "Test::Simple" >}}) module. Instead of `print` statements showing what's being tested, you just write calls to the `ok()` subroutine, specifying as its first argument the condition under which things are okay, and as its second argument a description of what you're actually testing:<span id="OLE_LINK429"></span>

    > cat inflections.t

    use Lingua::EN::Inflect qw( inflect);

    use Test::Simple qw( no_plan);

    my %plural_of = (
       'mouse'         => 'mice',
       'house'         => 'houses',
       'ox'            => 'oxen',
       'box'           => 'boxes',
       'goose'         => 'geese',
       'mongoose'      => 'mongooses',
       'law'           => 'laws',
       'mother-in-law' => 'mothers-in-law',
    );

    for my $word ( keys %plural_of ) {
       my $expected = $plural_of{$word};
       my $computed = inflect( "PL_N($word)" );

       ok( $computed eq $expected, "$word -> $expected" );
    }

Note that this code loads `Test::Simple` with the argument `qw( no_plan )`. Normally that argument would be `tests => count`, indicating how many tests to expect, but here the tests are generated from the `%plural_of` table at run time, so the final count will depend on how many entries are in that table. Specifying a fixed number of tests when loading the module is useful if you happen know that number at compile time, because then the module can also "meta-test:" verify that you carried out all the tests you expected to.

The `Test::Simple` program is slightly more concise and readable than the original driver code, and the output is much more compact and informative:

    > perl inflections.t

    ok 1 - house -> houses
    ok 2 - law -> laws
    not ok 3 - mongoose -> mongooses
    #     Failed test (inflections.t at line 21)
    ok 4 - goose -> geese
    ok 5 - ox -> oxen
    not ok 6 - mother-in-law -> mothers-in-law
    #     Failed test (inflections.t at line 21)
    ok 7 - mouse -> mice
    ok 8 - box -> boxes
    1..8
    # Looks like you failed 2 tests of 8.

More importantly, this version requires far less effort to verify the correctness of each test. You just scan down the left margin looking for a `not` and a comment line.

You might prefer to use the [Test::More]({{<mcpan "Test::More" >}}) module instead of `Test::Simple`. Then you can specify the actual and expected values separately, by using the `is()` subroutine, rather than `ok()`:

    use Lingua::EN::Inflect qw( inflect );
    use Test::More qw( no_plan ); # Now using more advanced testing tools

    my %plural_of = (
       'mouse'         => 'mice',
       'house'         => 'houses',
       'ox'            => 'oxen',
       'box'           => 'boxes',
       'goose'         => 'geese',
       'mongoose'      => 'mongooses',
       'law'           => 'laws',
       'mother-in-law' => 'mothers-in-law',
    );

    for my $word ( keys %plural_of ) {
       my $expected = $plural_of{$word};
       my $computed = inflect( "PL_N($word)" );

       # Test expected and computed inflections for string equality...
       is( $computed, $expected, "$word -> $expected" );
    }

Apart from no longer having to type the `eq` yourself, this version also produces more detailed error messages:

    > perl inflections.t

    ok 1 - house -> houses
    ok 2 - law -> laws
    not ok 3 - mongoose -> mongooses
    #     Failed test (inflections.t at line 20)
    #          got: 'mongeese'
    #     expected: 'mongooses'
    ok 4 - goose -> geese
    ok 5 - ox -> oxen
    not ok 6 - mother-in-law -> mothers-in-law
    #     Failed test (inflections.t at line 20)
    #          got: 'mothers-in-laws'
    #     expected: 'mothers-in-law'
    ok 7 - mouse -> mice
    ok 8 - box -> boxes
    1..8
    # Looks like you failed 2 tests of 8.

The [Test::Tutorial]({{<mcpan "Test::Tutorial" >}}) documentation that comes with Perl 5.8 provides a gentle introduction to both `Test::Simple` and `Test::More`.

### 3. Create Standard POD Templates for Modules and Applications

One of the main reasons documentation can often seem so unpleasant is the "blank page effect." Many programmers simply don't know how to get started or what to say.

Perhaps the easiest way to make writing documentation less forbidding (and hence, more likely to actually occur) is to circumvent that initial empty screen by providing a template that developers can cut and paste into their code.

For a module, that documentation template might look something like this:

    =head1 NAME

    <Module::Name> - <One-line description of module's purpose>

    =head1 VERSION

    The initial template usually just has:

    This documentation refers to <Module::Name> version 0.0.1.

    =head1 SYNOPSIS

       use <Module::Name>;

       # Brief but working code example(s) here showing the most common usage(s)
       # This section will be as far as many users bother reading, so make it as
       # educational and exemplary as possible.

    =head1 DESCRIPTION

    A full description of the module and its features.

    May include numerous subsections (i.e., =head2, =head3, etc.).

    =head1 SUBROUTINES/METHODS

    A separate section listing the public components of the module's interface.

    These normally consist of either subroutines that may be exported, or methods
    that may be called on objects belonging to the classes that the module
    provides.

    Name the section accordingly.

    In an object-oriented module, this section should begin with a sentence (of the
    form "An object of this class represents ...") to give the reader a high-level
    context to help them understand the methods that are subsequently described.

    =head1 DIAGNOSTICS

    A list of every error and warning message that the module can generate (even
    the ones that will "never happen"), with a full explanation of each problem,
    one or more likely causes, and any suggested remedies.

    =head1 CONFIGURATION AND ENVIRONMENT

    A full explanation of any configuration system(s) used by the module, including
    the names and locations of any configuration files, and the meaning of any
    environment variables or properties that can be set. These descriptions must
    also include details of any configuration language used.

    =head1 DEPENDENCIES

    A list of all of the other modules that this module relies upon, including any
    restrictions on versions, and an indication of whether these required modules
    are part of the standard Perl distribution, part of the module's distribution,
    or must be installed separately.

    =head1 INCOMPATIBILITIES

    A list of any modules that this module cannot be used in conjunction with.
    This may be due to name conflicts in the interface, or competition for system
    or program resources, or due to internal limitations of Perl (for example, many
    modules that use source code filters are mutually incompatible).

    =head1 BUGS AND LIMITATIONS

    A list of known problems with the module, together with some indication of
    whether they are likely to be fixed in an upcoming release.

    Also, a list of restrictions on the features the module does provide: data types
    that cannot be handled, performance issues and the circumstances in which they
    may arise, practical limitations on the size of data sets, special cases that
    are not (yet) handled, etc.

    The initial template usually just has:

    There are no known bugs in this module.

    Please report problems to <Maintainer name(s)> (<contact address>)

    Patches are welcome.

    =head1 AUTHOR

    <Author name(s)>  (<contact address>)

    =head1 LICENSE AND COPYRIGHT

    Copyright (c) <year> <copyright holder> (<contact address>).
    All rights reserved.

    followed by whatever license you wish to release it under.

    For Perl code that is often just:

    This module is free software; you can redistribute it and/or modify it under
    the same terms as Perl itself. See L<perlartistic>.  This program is
    distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
    PARTICULAR PURPOSE.

Of course, the specific details that your templates provide may vary from those shown here, according to your other coding practices. The most likely variation will be in the license and copyright, but you may also have specific in-house conventions regarding version numbering, the grammar of diagnostic messages, or the attribution of authorship.

### 4. Use a Revision Control System

Maintaining control over the creation and modification of your source code is utterly essential for robust team-based development. And not just over source code: you should be revision controlling your documentation, and data files, and document templates, and makefiles, and style sheets, and change logs, and any other resources your system requires.

Just as you wouldn't use an editor without an Undo command or a word processor that can't merge documents, so too you shouldn't use a file system you can't rewind, or a development environment that can't integrate the work of many contributors.

Programmers make mistakes, and occasionally those mistakes will be catastrophic. They will reformat the disk containing the most recent version of the code. Or they'll mistype an editor macro and write zeros all through the source of a critical core module. Or two developers will unwittingly edit the same file at the same time and half their changes will be lost. Revision control systems can prevent those kinds of problems.

Moreover, occasionally the very best debugging technique is to just give up, stop trying to get yesterday's modifications to work correctly, roll the code back to a known stable state, and start over again. Less drastically, comparing the current condition of your code with the most recent stable version from your repository (even just a line-by-line `diff`) can often help you isolate your recent "improvements" and work out which of them is the problem.

Revision control systems such as RCS, CVS, Subversion, Monotone, `darcs`, Perforce, GNU arch, or BitKeeper can protect against calamities, and ensure that you always have a working fallback position if maintenance goes horribly wrong. The various systems have different strengths and limitations, many of which stem from fundamentally different views on what exactly revision control is. It's a good idea to audition the various revision control systems, and find the one that works best for you. *Pragmatic Version Control Using Subversion*, by Mike Mason (Pragmatic Bookshelf, 2005) and [*Essential CVS*](http://www.oreilly.com/catalog/cvs/), by Jennifer Vesperman (O'Reilly, 2003) are useful starting points.

### 5. Create Consistent Command-Line Interfaces

Command-line interfaces have a strong tendency to grow over time, accreting new options as you add features to the application. Unfortunately, the evolution of such interfaces is rarely designed, managed, or controlled, so the set of flags, options, and arguments that a given application accepts are likely to be ad hoc and unique.

This also means they're likely to be inconsistent with the unique ad hoc sets of flags, options, and arguments that other related applications provide. The result is inevitably a suite of programs, each of which is driven in a distinct and idiosyncratic way. For example:

    > orchestrate source.txt -to interim.orc

    > remonstrate +interim.rem -interim.orc

    > fenestrate  --src=interim.rem --dest=final.wdw
    Invalid input format

    > fenestrate --help
    Unknown option: --help.
    Type 'fenestrate -hmo' for help

Here, the `orchestrate` utility expects its input file as its first argument, while the `-to` flag specifies its output file. The related `remonstrate` tool uses `-infile` and `+outfile` options instead, with the output file coming first. The `fenestrate` program seems to require GNU-style "long options:" `--src=infile` and `--dest=outfile`, except, apparently, for its oddly named help flag. All in all, it's a mess.

When you're providing a suite of programs, all of them should appear to work the same way, using the same flags and options for the same features across all applications. This enables your users to take advantage of existing knowledge--instead of continually asking you.

Those three programs should work like this:

    > orchestrate -i source.txt -o dest.orc

    > remonstrate -i source.orc -o dest.rem

    > fenestrate  -i source.rem -o dest.wdw
    Input file ('source.rem') not a valid Remora file
    (type "fenestrate --help" for help)

    > fenestrate --help
    fenestrate - convert Remora .rem files to Windows .wdw format
    Usage: fenestrate [-i <infile>] [-o <outfile>] [-cstq] [-h|-v]
    Options:
       -i <infile> Specify input source [default: STDIN]
       -o <outfile> Specify output destination [default: STDOUT]
       -c Attempt to produce a more compact representation
       -h Use horizontal (landscape) layout
       -v Use vertical (portrait) layout
       -s Be strict regarding input
       -t Be extra tolerant regarding input
       -q Run silent
       --version Print version information
       --usage Print the usage line of this summary
       --help Print this summary
       --man Print the complete manpage

Here, every application that takes input and output files uses the same two flags to do so. A user who wants to use the `substrate` utility (to convert that final .wdw file to a subroutine) is likely to be able to guess correctly the required syntax:

    > substrate  -i dest.wdw -o dest.sub

Anyone who can't guess that probably can guess that:

    > substrate --help

is likely to render aid and comfort.

A large part of making interfaces consistent is being consistent in specifying the individual components of those interfaces. Some conventions that may help to design consistent and predictable interfaces include:

-   Require a flag preceding every piece of command-line data, except filenames.

    Users don't want to have to remember that your application requires "input file, output file, block size, operation, fallback strategy," and requires them in that precise order:

        > lustrate sample_data proc_data 1000 normalize log

    They want to be able to say explicitly what they mean, in any order that suits them:

        > lustrate sample_data proc_data -op=normalize -b1000 --fallback=log

-   Provide a flag for each filename, too, especially when a program can be given files for different purposes.

    Users might also not want to remember the order of the two positional filenames, so let them label those arguments as well, and specify them in whatever order they prefer:

        > lustrate -i sample_data -op normalize -b1000 --fallback log -o proc_data

-   Use a single `-` prefix for short-form flags, up to three letters (`-v`, `-i`, `-rw`, `-in`, `-out`).

    Experienced users appreciate short-form flags as a way of reducing typing and limiting command-line clutter. Don't make them type two dashes in these shortcuts.

-   Use a double `--` prefix for longer flags (`--verbose`, `--interactive`, `--readwrite`, `--input`, `--output`).

    Flags that are complete words improve the readability of a command line (in a shell script, for example). The double dash also helps to distinguish between the longer flag name and any nearby file names.

-   If a flag expects an associated value, allow an optional `=` between the flag and the value.

    Some people prefer to visually associate a value with its preceding flag:

        > lustrate -i=sample_data -op=normalize -b=1000 --fallback=log -o=proc_data

    Others don't:

        > lustrate -i sample_data -op normalize -b1000 --fallback log -o proc_data

    Still others want a bit each way:

        > lustrate -i sample_data -o proc_data -op=normalize -b=1000 --fallback=log

    Let the user choose.

-   Allow single-letter options to be "bundled" after a single dash.

    It's irritating to have to type repeated dashes for a series of flags:

        > lustrate -i sample_data -v -l -x

    Allow experienced users to also write:

        > lustrate -i sample_data -vlx

-   Provide a multi-letter version of every single-letter flag.

    Short-form flags may be nice for experienced users, but they can be troublesome for new users: hard to remember and even harder to recognize. Don't force people to do either. Give them a verbose alternative to every concise flag; full words that are easier to remember, and also more self-documenting in shell scripts.

-   Always allow `-` as a special filename.

    A widely used convention is that a dash (`-`) where an input file is expected means "read from standard input," and a dash where an output file is expected means "write to standard output."

-   Always allow `--` as a file list marker.

    Another widely used convention is that the appearance of a double dash (`--`) on the command line marks the end of any flagged options, and indicates that the remaining arguments are a list of filenames, even if some of them look like flags.

### 6. Agree Upon a Coherent Layout Style and Automate It with `perltidy`

Formatting. Indentation. Style. Code layout. Whatever you choose to call it, it's one of the most contentious aspects of programming discipline. More and bloodier wars have been fought over code layout than over just about any other aspect of coding.

What is the best practice here? Should you use classic Kernighan and Ritchie style? Or go with BSD code formatting? Or adopt the layout scheme specified by the GNU project? Or conform to the Slashcode coding guidelines?

Of course not! Everyone knows that *&lt;insert your personal coding style here&gt;* is the One True Layout Style, the only sane choice, as ordained by *&lt;insert your favorite Programming Deity here&gt;* since Time Immemorial! Any other choice is manifestly absurd, willfully heretical, and self-evidently a Work of Darkness!

That's precisely the problem. When deciding on a layout style, it's hard to decide where rational choices end and rationalized habits begin.

Adopting a coherently designed approach to code layout, and then applying that approach consistently across all your coding, is fundamental to best-practice programming. Good layout can improve the readability of a program, help detect errors within it, and make the structure of your code much easier to comprehend. Layout matters.

However, most coding styles--including the four mentioned earlier--confer those benefits almost equally well. While it's true that having a consistent code layout scheme matters very much indeed, the particular code layout scheme you ultimately decide upon does not matter at all! All that matters is that you adopt a single, coherent style; one that works for your entire programming team, and, having agreed upon that style, that you then apply it consistently across all your development.

In the long term, it's best to train yourself and your team to code in a consistent, rational, and readable style. However, the time and commitment necessary to accomplish that isn't always available. In such cases, a reasonable compromise is to prescribe a standard code-formatting tool that must be applied to all code before it's committed, reviewed, or otherwise displayed in public.

There is now an excellent code formatter available for Perl: [`perltidy`](http://perltidy.sourceforge.net/). It provides an extensive range of user-configurable options for indenting, block delimiter positioning, column-like alignment, and comment positioning.

Using `perltidy`, you can convert code like this:

    if($sigil eq '$'){
       if($subsigil eq '?'){
           $sym_table{substr($var_name,2)}=delete $sym_table{locate_orig_var($var)};
           $internal_count++;$has_internal{$var_name}++
       } else {
           ${$var_ref} =
               q{$sym_table{$var_name}}; $external_count++; $has_external{$var_name}++;
    }} elsif ($sigil eq '@'&&$subsigil eq '?') {
       @{$sym_table{$var_name}} = grep
           {defined $_} @{$sym_table{$var_name}};
    } elsif ($sigil eq '%' && $subsigil eq '?') {
    delete $sym_table{$var_name}{$EMPTY_STR}; } else
    {
    ${$var_ref}
    =
    q{$sym_table{$var_name}}
    }

into something readable:

    if ( $sigil eq '$' ) {
       if ( $subsigil eq '?' ) {
           $sym_table{ substr( $var_name, 2 ) }
               = delete $sym_table{ locate_orig_var($var) };
           $internal_count++;
           $has_internal{$var_name}++;
       }
       else {
           ${$var_ref} = q{$sym_table{$var_name}};
           $external_count++;
           $has_external{$var_name}++;
       }
    }
    elsif ( $sigil eq '@' && $subsigil eq '?' ) {
       @{ $sym_table{$var_name} }
           = grep {defined $_} @{ $sym_table{$var_name} };
    }
    elsif ( $sigil eq '%' && $subsigil eq '?' ) {
       delete $sym_table{$var_name}{$EMPTY_STR};
    }
    else {
       ${$var_ref} = q{$sym_table{$var_name}};
    }

Mandating that everyone use a common tool to format their code can also be a simple way of sidestepping the endless objections, acrimony, and dogma that always surround any discussion on code layout. If `perltidy` does all the work for them, then it will cost developers almost no effort to adopt the new guidelines. They can simply set up an editor macro that will "straighten" their code whenever they need to.

### 7. Code in Commented Paragraphs

A paragraph is a collection of statements that accomplish a single task: in literature, it's a series of sentences conveying a single idea; in programming, a series of instructions implementing a single step of an algorithm.

Break each piece of code into sequences that achieve a single task, placing a single empty line between each sequence. To further improve the maintainability of the code, place a one-line comment at the start of each such paragraph, describing what the sequence of statements does. Like so:

    # Process an array that has been recognized...
    sub addarray_internal {
       my ($var_name, $needs_quotemeta) = @_;

       # Cache the original...
       $raw .= $var_name;

       # Build meta-quoting code, if requested...
       my $quotemeta = $needs_quotemeta ?  q{map {quotemeta $_} } : $EMPTY_STR;

       # Expand elements of variable, conjoin with ORs...
       my $perl5pat = qq{(??{join q{|}, $quotemeta \@{$var_name}})};

       # Insert debugging code if requested...
       my $type = $quotemeta ? 'literal' : 'pattern';
       debug_now("Adding $var_name (as $type)");
       add_debug_mesg("Trying $var_name (as $type)");

       return $perl5pat;
    }

Paragraphs are useful because humans can focus on only a few pieces of information at once. Paragraphs are one way of aggregating small amounts of related information, so that the resulting "chunk" can fit into a single slot of the reader's limited short-term memory. Paragraphs enable the physical structure of a piece of writing to reflect and emphasize its logical structure.

Adding comments at the start of each paragraph further enhances the chunking by explicitly summarizing the purpose of each chunk (note: the purpose, not the behavior). Paragraph comments need to explain why the code is there and what it achieves, not merely paraphrase the precise computational steps it's performing.

Note, however, that the contents of paragraphs are only of secondary importance here. It is the vertical gaps separating each paragraph that are critical. Without them, the readability of the code declines dramatically, even if the comments are retained:

    sub addarray_internal {
       my ($var_name, $needs_quotemeta) = @_;
       # Cache the original...
       $raw .= $var_name;
       # Build meta-quoting code, if required...
       my $quotemeta = $needs_quotemeta ?  q{map {quotemeta $_} } : $EMPTY_STR;
       # Expand elements of variable, conjoin with ORs...
       my $perl5pat = qq{(??{join q{|}, $quotemeta \@{$var_name}})};
       # Insert debugging code if requested...
       my $type = $quotemeta ? 'literal' : 'pattern';
       debug_now("Adding $var_name (as $type)");
       add_debug_mesg("Trying $var_name (as $type)");
       return $perl5pat;
    }

### 8. Throw Exceptions Instead of Returning Special Values or Setting Flags

Returning a special error value on failure, or setting a special error flag, is a very common error-handling technique. Collectively, they're the basis for virtually all error notification from Perl's own built-in functions. For example, the built-ins `eval`, `exec`, `flock`, `open`, `print`, `stat`, and `system` all return special values on error. Unfortunately, they don't all use the same special value. Some of them also set a flag on failure. Sadly, it's not always the same flag. See the [perlfunc]({{</* perldoc "perlfunc" */>}}) manpage for the gory details.

Apart from the obvious consistency problems, error notification via flags and return values has another serious flaw: developers can silently ignore flags and return values, and ignoring them requires absolutely no effort on the part of the programmer. In fact, in a void context, ignoring return values is Perl's default behavior. Ignoring an error flag that has suddenly appeared in a special variable is just as easy: you simply don't bother to check the variable.

Moreover, because ignoring a return value is the void-context default, there's no syntactic marker for it. There's no way to look at a program and immediately see where a return value is deliberately being ignored, which means there's also no way to be sure that it's not being ignored accidentally.

The bottom line: regardless of the programmer's (lack of) intention, an error indicator is being ignored. That's not good programming.

Ignoring error indicators frequently causes programs to propagate errors in entirely the wrong direction. For example:

    # Find and open a file by name, returning the filehandle
    # or undef on failure...
    sub locate_and_open {
       my ($filename) = @_;

       # Check acceptable directories in order...
       for my $dir (@DATA_DIRS) {
           my $path = "$dir/$filename";

           # If file exists in an acceptable directory, open and return it...
           if (-r $path) {
               open my $fh, '<', $path;
               return $fh;
           }
       }

       # Fail if all possible locations tried without success...
       return;
    }

    # Load file contents up to the first <DATA/> marker...
    sub load_header_from {
       my ($fh) = @_;

       # Use DATA tag as end-of-"line"...
       local $/ = '<DATA/>';

       # Read to end-of-"line"...
       return <$fh>;
    }

    # and later...
    for my $filename (@source_files) {
       my $fh = locate_and_open($filename);
       my $head = load_header_from($fh);
       print $head;
    }

The `locate_and_open()` subroutine simply assumes that the call to `open` works, immediately returning the filehandle (`$fh`), whatever the actual outcome of the `open`. Presumably, the expectation is that whoever calls `locate_and_open()` will check whether the return value is a valid filehandle.

Except, of course, "whoever" doesn't check. Instead of testing for failure, the main `for` loop takes the failure value and immediately propagates it "across" the block, to the rest of the statements in the loop. That causes the call to `loader_header_from()` to propagate the error value "downwards." It's in that subroutine that the attempt to treat the failure value as a filehandle eventually kills the program:

    readline() on unopened filehandle at demo.pl line 28.

Code like that--where an error is reported in an entirely different part of the program from where it actually occurred--is particularly onerous to debug.

Of course, you could argue that the fault lies squarely with whoever wrote the loop, for using `locate_and_open()` without checking its return value. In the narrowest sense, that's entirely correct--but the deeper fault lies with whoever actually wrote `locate_and_open()` in the first place, or at least, whoever assumed that the caller would always check its return value.

Humans simply aren't like that. Rocks almost never fall out of the sky, so humans soon conclude that they never do, and stop looking up for them. Fires rarely break out in their homes, so humans soon forget that they might, and stop testing their smoke detectors every month. In the same way, programmers inevitably abbreviate "almost never fails" to "never fails," and then simply stop checking.

That's why so very few people bother to verify their `print` statements:

    if (!print 'Enter your name: ') {
       print {*STDLOG} warning => 'Terminal went missing!'
    }

It's human nature to "trust but not verify."

Human nature is why returning an error indicator is not best practice. Errors are (supposed to be) unusual occurrences, so error markers will almost never be returned. Those tedious and ungainly checks for them will almost never do anything useful, so eventually they'll be quietly omitted. After all, leaving the tests off almost always works just fine. It's so much easier not to bother. Especially when not bothering is the default!

Don't return special error values when something goes wrong; throw an exception instead. The great advantage of exceptions is that they reverse the usual default behaviors, bringing untrapped errors to immediate and urgent attention. On the other hand, ignoring an exception requires a deliberate and conspicuous effort: you have to provide an explicit `eval` block to neutralize it.

The `locate_and_open()` subroutine would be much cleaner and more robust if the errors within it threw exceptions:

    # Find and open a file by name, returning the filehandle
    # or throwing an exception on failure...
    sub locate_and_open {
       my ($filename) = @_;

       # Check acceptable directories in order...
       for my $dir (@DATA_DIRS) {
           my $path = "$dir/$filename";

           # If file exists in acceptable directory, open and return it...
           if (-r $path) {
               open my $fh, '<', $path
                   or croak( "Located $filename at $path, but could not open");
               return $fh;
           }
       }

       # Fail if all possible locations tried without success...
       croak( "Could not locate $filename" );
    }

    # and later...
    for my $filename (@source_files) {
       my $fh = locate_and_open($filename);
       my $head = load_header_from($fh);
       print $head;
    }

Notice that the main `for` loop didn't change at all. The developer using `locate_and_open()` still assumes that nothing can go wrong. Now there's some justification for that expectation, because if anything does go wrong, the thrown exception will automatically terminate the loop.

Exceptions are a better choice even if you are the careful type who religiously checks every return value for failure:

    SOURCE_FILE:
    for my $filename (@source_files) {
       my $fh = locate_and_open($filename);
       next SOURCE_FILE if !defined $fh;
       my $head = load_header_from($fh);
       next SOURCE_FILE if !defined $head;
       print $head;
    }

Constantly checking return values for failure clutters your code with validation statements, often greatly decreasing its readability. In contrast, exceptions allow an algorithm to be implemented without having to intersperse any error-handling infrastructure at all. You can factor the error-handling out of the code and either relegate it to after the surrounding `eval`, or else dispense with it entirely:

    for my $filename (@directory_path) {

       # Just ignore any source files that don't load...
       eval {
           my $fh = locate_and_open($filename);
           my $head = load_header_from($fh);
           print $head;
       }
    }

### 9. Add New Test Cases Before you Start Debugging

The first step in any debugging process is to isolate the incorrect behavior of the system, by producing the shortest demonstration of it that you reasonably can. If you're lucky, this may even have been done for you:

    To: DCONWAY@cpan.org
    From: sascha@perlmonks.org
    Subject: Bug in inflect module

    Zdravstvuite,

    I have been using your Lingua::EN::Inflect module to normalize terms in a
    data-mining application I am developing, but there seems to be a bug in it,
    as the following example demonstrates:

       use Lingua::EN::Inflect qw( PL_N );
       print PL_N('man'), "\n";       # Prints "men", as expected
       print PL_N('woman'), "\n";     # Incorrectly prints "womans"

Once you have distilled a short working example of the bug, convert it to a series of tests, such as:

    use Lingua::EN::Inflect qw( PL_N );
    use Test::More qw( no_plan );
    is(PL_N('man') ,  'men', 'man -> men'     );
    is(PL_N('woman'), 'women', 'woman -> women' );

Don't try to fix the problem straight away, though. Instead, immediately add those tests to your test suite. If that testing has been well set up, that can often be as simple as adding a couple of entries to a table:

    my %plural_of = (
       'mouse'         => 'mice',
       'house'         => 'houses',
       'ox'            => 'oxen',
       'box'           => 'boxes',
       'goose'         => 'geese',
       'mongoose'      => 'mongooses',
       'law'           => 'laws',
       'mother-in-law' => 'mothers-in-law',

       # Sascha's bug, reported 27 August 2004...
       'man'           => 'men',
       'woman'         => 'women',
    );

The point is: if the original test suite didn't report this bug, then that test suite was broken. It simply didn't do its job (finding bugs) adequately. Fix the test suite first by adding tests that cause it to fail:

    > perl inflections.t
    ok 1 - house -> houses
    ok 2 - law -> laws
    ok 3 - man -> men
    ok 4 - mongoose -> mongooses
    ok 5 - goose -> geese
    ok 6 - ox -> oxen
    not ok 7 - woman -> women
    #     Failed test (inflections.t at line 20)
    #          got: 'womans'
    #     expected: 'women'
    ok 8 - mother-in-law -> mothers-in-law
    ok 9 - mouse -> mice
    ok 10 - box -> boxes
    1..10
    # Looks like you failed 1 tests of 10.

Once the test suite is detecting the problem correctly, then you'll be able to tell when you've correctly fixed the actual bug, because the tests will once again fall silent.

This approach to debugging is most effective when the test suite covers the full range of manifestations of the problem. When adding test cases for a bug, don't just add a single test for the simplest case. Make sure you include the obvious variations as well:

    my %plural_of = (
       'mouse'         => 'mice',
       'house'         => 'houses',
       'ox'            => 'oxen',
       'box'           => 'boxes',
       'goose'         => 'geese',
       'mongoose'      => 'mongooses',
       'law'           => 'laws',
       'mother-in-law' => 'mothers-in-law',

       # Sascha's bug, reported 27 August 2004...
       'man'           => 'men',
       'woman'         => 'women',
       'human'         => 'humans',
       'man-at-arms'   => 'men-at-arms',
       'lan'           => 'lans',
       'mane'          => 'manes',
       'moan'          => 'moans',
    );

The more thoroughly you test the bug, the more completely you will fix it.

### 10. Don't Optimize Code--Benchmark It

If you need a function to remove duplicate elements of an array, it's natural to think that a "one-liner" like this:

    sub uniq { return keys %{ { map {$_=>1} @_ } } }

will be more efficient than two statements:

    sub uniq {
       my %seen;
       return grep {!$seen{$_}++} @_;
    }

Unless you are deeply familiar with the internals of the Perl interpreter (in which case you already have far more serious personal issues to deal with), intuitions about the relative performance of two constructs are exactly that: unconscious guesses.

The only way to know for sure which of two--or more--alternatives will perform better is to actually time each of them. The standard [Benchmark]({{<mcpan "Benchmark" >}}) module makes that easy:

    # A short list of not-quite-unique values...
    our @data = qw( do re me fa so la ti do );

    # Various candidates...
    sub unique_via_anon {
       return keys %{ { map {$_=>1} @_ } };
    }

    sub unique_via_grep {
       my %seen;
       return grep { !$seen{$_}++ } @_;
    }

    sub unique_via_slice {
       my %uniq;
       @uniq{@_} = ();
       return keys %uniq;
    }

    # Compare the current set of data in @data
    sub compare {
       my ($title) = @_;
       print "\n[$title]\n";

       # Create a comparison table of the various timings, making sure that
       # each test runs at least 10 CPU seconds...
       use Benchmark qw( cmpthese );
       cmpthese -10, {
           anon  => 'my @uniq = unique_via_anon(@data)',
           grep  => 'my @uniq = unique_via_grep(@data)',
           slice => 'my @uniq = unique_via_slice(@data)',
       };

       return;
    }

    compare('8 items, 10% repetition');

    # Two copies of the original data...
    @data = (@data) x 2;
    compare('16 items, 56% repetition');

    # One hundred copies of the original data...
    @data = (@data) x 50;
    compare('800 items, 99% repetition');

The `cmpthese()` subroutine takes a number, followed by a reference to a hash of tests. The number specifies either the exact number of times to run each test (if the number is positive), or the absolute number of CPU seconds to run the test for (if the number is negative). Typical values are around 10,000 repetitions or ten CPU seconds, but the module will warn you if the test is too short to produce an accurate benchmark.

The keys of the test hash are the names of your tests, and the corresponding values specify the code to be tested. Those values can be either strings (which are `eval`'d to produce executable code) or subroutine references (which are called directly).

The benchmarking code shown above would print out something like the following:

    [8 items, 10% repetitions]
            Rate anon  grep slice
    anon  28234/s --  -24%  -47%
    grep  37294/s   32% --  -30%
    slice 53013/s   88% 42%    --

    [16 items, 50% repetitions]
            Rate anon  grep slice
    anon  21283/s --  -28%  -51%
    grep  29500/s   39% --  -32%
    slice 43535/s  105% 48%    --

    [800 items, 99% repetitions]
           Rate  anon grep slice
    anon   536/s --  -65%  -89%
    grep  1516/s  183% --  -69%
    slice 4855/s  806%  220% --

Each of the tables printed has a separate row for each named test. The first column lists the absolute speed of each candidate in repetitions per second, while the remaining columns allow you to compare the relative performance of any two tests. For example, in the final test tracing across the `grep` row to the `anon` column reveals that the `grep`ped solution was 1.83 times (183 percent) faster than using an anonymous hash. Tracing further across the same row also indicates that `grep`ping was 69 percent slower (-69 percent faster) than slicing.

Overall, the indication from the three tests is that the slicing-based solution is consistently the fastest for this particular set of data on this particular machine. It also appears that as the data set increases in size, slicing also scales much better than either of the other two approaches.

However, those two conclusions are effectively drawn from only three data points (namely, the three benchmarking runs). To get a more definitive comparison of the three methods, you'd also need to test other possibilities, such as a long list of non-repeating items, or a short list with nothing but repetitions.

Better still, test on the real data that you'll actually be "unique-ing."

For example, if that data is a sorted list of a quarter of a million words, with only minimal repetitions, and which has to remain sorted, then test exactly that:

    our @data = slurp '/usr/share/biglongwordlist.txt';

    use Benchmark qw( cmpthese );

    cmpthese 10, {
        # Note: the non-grepped solutions need a post-uniqification re-sort
        anon  => 'my @uniq = sort(unique_via_anon(@data))',
        grep  => 'my @uniq = unique_via_grep(@data)',
        slice => 'my @uniq = sort(unique_via_slice(@data))',
    };

Not surprisingly, this benchmark indicates that the `grep`ped solution is markedly superior on a large sorted data set:

    s/iter anon slice  grep
    anon    4.28 --   -3%  -46%
    slice   4.15 3%    --  -44%
    grep    2.30 86%   80%    --

Perhaps more interestingly, the `grep`ped solution still benchmarks as being marginally faster when the two hash-based approaches aren't re-sorted. This suggests that the better scalability of the sliced solution as seen in the earlier benchmark is a localized phenomenon, and is eventually undermined by the growing costs of allocation, hashing, and bucket-overflows as the sliced hash grows very large.

Above all, that last example demonstrates that benchmarks only benchmark the cases you actually benchmark, and that you can only draw useful conclusions about performance from benchmarking real data.
