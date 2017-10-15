{
   "image" : null,
   "thumbnail" : null,
   "date" : "1999-11-30T00:00:00-08:00",
   "categories" : "development",
   "title" : "Sins of Perl Revisited",
   "authors" : [
      "mark-jason-dominus"
   ],
   "tags" : [],
   "slug" : "/pub/1999/11/sins.html",
   "description" : "Sins of Perl Revisited -> Sins of Perl Revisited Implicit Behaviors and Hidden Context Dependencies To Paren || ! To Paren? Global Variables References vs. Non-references No Prototypes No Compiler Support for I/O or Regex Objects Haphazard Exception Model New...",
   "draft" : null
}



-   [Sins of Perl Revisited](#Sins_of_Perl_Revisited)
    -   [Implicit Behaviors and Hidden Context Dependencies](#1)
    -   [To Paren `||` `!` To Paren?](#2)
    -   [Global Variables](#3)
    -   [References vs. Non-references](#4)
    -   [No Prototypes](#5)
    -   [No Compiler Support for I/O or Regex Objects](#6)
    -   [Haphazard Exception Model](#7)
-   [New Problems](#New_Problems)
    -   [The Documentation is Too Big](#8)
    -   [The API is Too Complicated](#9)

------------------------------------------------------------------------

Long ago, back in the Perl 4 days, Tom Christiansen wrote an article called [The Seven Deadly Sins of Perl](/pub/language/versus/perl.html), describing the biggest problems in the Perl language at the time. A few years later, he went over the list again to see how well the problems had been addressed by Perl 5. That was in 1996; I think it's time for another update. Where are we now?

Tom's original Seven Sins:

### <span id="1">1. Implicit Behaviors and Hidden Context Dependencies</span>

Every week or so someone shows up in `comp.lang.perl.misc` asking why this didn't work:

            while (<FILE>) {
              my $line = <FILE>
              # ...
            }

\`\`It seems to be skipping every second line,'' they say. Hmmm. Of course, it is skipping every second line, because when a `<...>` operator is the condition of a `while` loop, it magically turns into `defined($_ = <...>)`. But then a lot of people get confused in the other direction:

            if (something) {
              <FILE>
              print "The next line is ``$_''.\n";
            }

`<...>` *only* changes `$_` when it is the condition of the `while` loop. I wonder if it would have been better to have `<...>` *always* read into `$_` unless assigned somewhere? Oh well, it's much too late anyway.

I do see a trend away from these. Here is an example, which is somewhat obscure, because of the trend. In a regex, `^` and `$` normally match at the beginning and end of the string, respectively. The regex `/^Hello/` looks for `Hello` at the beginning of the string. If your string contains many lines, separated by `\n` characters, you might like to have a regex that looks for `Hello` at the beginning of any line. The way you did this in Perl 4 (and also Perl 3, 2, and 1) was to set the variable `$*` to a true value. This changed the meaning of `^` and `$` for every regex in the entire program. If you set it and forgot to set it back, you could get a nasty surprise when other regexes matched when they shouldn't have. If you were writing a library to be used by other programs, you'd have to put

            { local $* = 0;
              $target =~ /^regex/;
            }

around every one of your regexes that used `^` or `$`; otherwise you could get taken by surprise by an unexpected setting of `$*`. Of course, most libraries didn't do this. Here's another example: Array indices normally begin at 0 because the value of `$[` is normally 0; if you set `$[` to 1, then arrays start at 1, which makes Fortran programmers happy, and so we see examples like this in the `perl3` man page:

            foreach $num ($[ .. $#entry) {
              print "  $num\t'",$entry[$num],"'\n";
            }

And of course you could set `$[` to 17 to have arrays start at 17 instead of at 0 or 1. This was a great way to sabotage module authors.

Fortunately, sanity prevailed. These features are now recognized to have been mistakes. The perl5-porters mailing list now has a catchphrase for such features: they're called \`action at a distance'. The principle is that a declaration in one part of the program shouldn't drastically and invisibly alter the behavior of some other part of the program. Some of the old action-at-a-distance features have been reworked into safer versions. For example, In Perl 5, you are not supposed to use `$*`. Instead, you put `/m` on the end of the match operator to say that the meanings of `^` and `$` should be changed just for that one regex. The expected flood of ex-Fortran programmers never materialized, so `$[` is highly deprecated, and only affects code in the current file; it can't be used to sabotage modules.

Unfortunately, not enough sanity prevailed, since the ubiquitous `$/` variable (input record separator string) is still with us and can cause plenty of sabotage all by itself.

This may change soon. A hot topic on the perl5-porters mailing list is \`line disciplines', which means that each filehandle would have its own private notion of the line terminator, as well as its own notion of other properties of the input such as the character representation. This would allow it to translate EBCDIC data into ASCII transparently, or (more to the point) Latin-1 to Unicode. Still the problem is not likely to go away for good; variables like `$/`, `$\`, `$"`, and `$,` will be with us for a long time.

Prognosis: Action at a distance is now recognized as a bad thing, and the old action at a distance features are being converted to safer versions. But the problem will probably continue for a long time, and very few modules presently take precautions against seeing a weird `$"` or whatever.

### <span id="2">2. To Paren `||` `!`To Paren?</span>

By this Tom meant weird context traps having to do with the way parentheses (or lack of parentheses) can drastically alter the meaning of an expression. Hardly any beginning programmers understand context. Here's a nice example: This works:

            $n = sprintf("%d %d", 32, 49);

So does this:

            @n = (32, 49);
            $n = sprintf("%d %d", @n);

But if you try this you get a surprise:

            @args = ("%d %d", 32, 49);
            $n = sprintf(@args);

(If you replace `sprintf` with `printf`, the surprise goes away. Ugh.)

People have problems with `my $x = ...` when they should have written `my($x) = ...`. They have the opposite problem, where they write `my ($line) = <FILE>` when they should have written `my $line = <FILE>`. And of course, they wonder how to find the number of elements in an array.

People also want to think that `(...)` in an expression constructs a list, and they go putting parentheses around things to make them into lists, which never works, because it's what's on the left side of the equals sign that determines whether the right side is a list or not. That's a pretty good rule of thumb, in fact, as long as you're willing to overlook the `x` operator: `'foo' x 3` constructs the string `'foofoofoo'`, but `('foo') x 3` constructs the list `('foo', 'foo', 'foo')`, equls signs or no equals signs.

Prognosis: You don't have to love it, but you have to learn to live with it.

### <span id="3">3. Global Variables</span>

The prototypical example of this problem is this code:

            while (<FILE>) {
              print if some_function();
            }

That looks harmless, doesn't it? But it's deceptive, because `some_function()` calls `other_function()`, and `other_function()` calls `joes_function()` in the module `Joe::Database`, and `joes_function()` calls `load_database()`, and `load_database()` is 484 lines long and in the middle it says

            while (<DATABASE>) {
              push @records, <DATABASE> if /pattern/;
            }

That `while` clobbers the value of `$_`, which would be OK, except that it clobbers the value of `$_` way up in the main program, which was going to print out the value of `$_` when `some_function` finally returned. Instead, it prints out the empty string. The program fails and the power plant explodes, poisoning the earth and the sea. Famine and disease sweep the world. All die. Oh, the embarrassment.

Today perl5-porters got mail asking why this code destroys the array:

            my @array=(1,2,3);
            foreach (@array) {
              open FILE, "<test";
              while (<FILE>) {
                ...
              }
              close FILE;
            }

That is a good question. Another good question would be why this code does *not* output a bunch of `3`s:

            my @array=(1,2,3);
            open FILE, "<test";
            while (<FILE>) {
              foreach (@array) {
              ...
              }
              print;
            }
            close FILE;

Answer: Because `foreach` automatically saves the old value of its index variable and then restores the original value when the loop is over.

This problem has gotten somewhat better in recent years. Auto-localization in `foreach` loops was the first step. Encouraging people to use the new `for my $x (...)` and `while (my $x = ...)` syntax will help with this problem also; anything that gets people to stop using `$_` is a step in the right direction.

Prognosis: Things have gotten better, but have also probably reached the limit of improvement. Module authors must be educated to localize `$_` before changing it, and any advance that depends on the education of module authors is probably doomed.

### <span id="4">4. References vs. Non-references</span>

Tom's complaint seems to be that reference syntax is too complicated. I don't think anyone can argue with that. Reference syntax is awful. It isn't going to get any better, either.

Prognosis: Doom and gloom.

### <span id="5">5. No Prototypes</span>

A common complaint with Perl 4 was that you couldn't write a function like `push`:

            my_push(@array, 1, 2, 3);

`@array` would be expanded into a list of elements, and `my_push` would never have a chance to operate on the original array. This was fixed with the prototype feature; now you can write `my_push` like this:

            sub my_push(\@@) {
              my $aref = shift;
              push @$aref, @_;
            }

Prototypes still have some minor but annoying holes. You can't write a function that behaves like `printf` with its optional filehandle argument, or like `sort` with its optional code block argument, or like `tied` with its any-kind-of-variable argument. You can write a function like `lc` that takes a single optional argument, but it won't be parsed the same way that `lc` is:

            $fred = 'Flooney';
            sub my_lc (;$) {
              if (@_) { lc $_[0] } else { lc $_ }
            }

            print lc $fred, "\n";
            print my_lc $fred, "\n";
            
    Too many arguments for main::my_lc at /tmp/lc line 7, near ""\n";"
    Execution of /tmp/lc aborted due to compilation errors.

Probably the worst thing about prototypes is the name. When ANSI standardized the C language in 1989, the big change was to add \`prototypes' to enable compile-time type checking of function arguments. C programmers learned that you should prototype all your functions to enable these checks so that you didn't end up passing a pointer to a function that wanted an integer, or whatever. People have the idea that Perl prototypes are for the same thing, and in fact they're not. They do something totally different, and they don't protect you against this:

            sub foo ($);

            foo(@x);   # whoops, should have been foo($x) instead.

The C programmers would like to think that this will deliver a compile-time error that says \`Hey, dummy! You used an array when you meant to use a scalar!' which would make it easier to debug. No, Perl takes the prototype as an indication that you would like the array automatically converted to a scalar, and passes the number of elements in the array to `foo()`. This will make it harder to debug, not easier.

Prognosis: The remaining technical problems with prototypes are pretty small and may get smoothed out eventually. Better type checking of function arguments may arrive eventually also; there's been talk for a long time about function declarations of the form

            sub foo (Dog, Cat) { ... }

which would make sure you were passing objects of the appropriate classes, and support for this has been going in a bit at a time. See `perldoc fields` for example. This, however, will compound the problems of people trying to get C programmers to stop using prototypes for compile-time type checking. Expect more confusion here, not less.

### <span id="6">6. No Compiler Support for I/O or Regex objects</span>

This got a lot better between Tom's first and second reports, so much so that he regarded it as fixed. I think the credit for this on the regex side mostly goes to Ilya Zakharevich; I don't know who gets the credit on the I/O side; probably Larry Wall and Graham Barr. Since Tom's last report, it's been fixed even better: You can say

            open my $fh, $filename;

and `$fh` will be autovivified to be a filehandle open to the specified file; when `$fh` goes out of scope, the file will be closed automatically. This means that you don't have to worry about using global filehandle names any more. Another useful use of C&lt;local&gt; down the drain, and good riddance.

Prognosis: Essentially fixed, despite a few lingering problems.

### <span id="7">7. Haphazard Exception Model</span>

Tom says: \`\`There's no standard model or guidelines for exception handling in libraries, modules, or classes, which means you don't know what to trap and what not to trap. Does a library throw an exception or does it just return false?''

This problem persists. Every module does something different. C programmers used to complain that having to explicitly check every system call for an error return made their code four times as big; in Perl the problem is worse because every check looks a little different.

Modules persist in issuing warning messages with no way to get them to shut up. Modules call `die` and take you by surprise when you thought you were going to get a simple error return. The standard modules have been substantially cleaned up in this regard since 1996, thank goodness.

Here's another problem: Exceptions and `die` are the same thing in Perl, which sometimes surprises people. Someone wrote into perl5-porters recently about a library function that was going to run a subprocess. The `fork()` succeeded but the `exec()` failed, so the child process called `die`. That was usually the right thing to do. In this case, however, the library function had been called inside of an `eval` block, which trapped the child's `die`. The original process was still waiting for the child to complete, but the child was going ahead, thinking it was the parent!

Groundwork for rationalization has been laid here; recent versions of Perl let you throw any sort of object with `die`, not just a string. Using these objects you could propagate complex kinds of exceptions in your programs. But as far as I know these features are little-used. There are several modules that provide `try`-`catch`-`cleanup` syntax, but as far as I know they're also little-used. And there are no widely accepted guidelines for the behavior of modules.

Prognosis: This is a social problem, not a technical one. The only answer is education, possibly headed by a crusader, or many crusaders.

------------------------------------------------------------------------

To replace the two problems that have been solved (lack of prototypes and compiler support for IO and Regex objects) I'd like to add two new problems to this list:

### <span id="8">8. The Documentation is Too Big</span>

The Perl 1 documentation was 2,000 lines long, which is already pretty big. The documentation for the current development release is 72,000 lines long, not counting developer-only documentation like the `Changes` files. It is difficult for beginners to know where to start, and it's difficult for anyone to know where to find any particular piece of information. The existing documentation includes a bunch of stuff like `perlhist` and `perlapio` that should have been buried in a subdirectory somewhere instead of alongside `perlfunc`.

The manual keeps getting bigger and bigger, because while it's easy to see and appreciate the value of any particular addition, it's much harder to appreciate the negative value of having an 0.01% larger documentation set. So you have a situation where someone will come along and say that they were confused by X, and that the manual should have a more detailed explanation of X, and it will only take a few lines. Nobody is willing to argue against the addition of just a few lines, because there's no obvious harm, but then after you've done that 14,000 times, the manual's usefulness is severly impaired.

Similarly, it's hard to seriously suggest that the manual be made shorter. Making manuals shorter is at least as hard as making programs shorter. You can't just cut stuff out; you have to reorganize and rewrite.

Short of throwing the whole thing away and starting over, some things that might help: The trend over the past few years seems to be toward a separation of reference material from tutorial material. It might be good for this to continue. The existing documentation needs reorganization; it's not clear what is \`Syntax' rather than \`Operators' or \`Functions'. (If I knew how to do this, I would say so.) Right now the overall structure is flat; I think it might be a step forward if the documentation were simply divided into a few subdirectories called \`Tutorials', \`Internals', \`Reference', \`Social', and so on. Perl needs to come with better documentation browsing tools, and maybe more important, there needs to be a better search interface on the web. Better indexing of the exiting documentation would help to enable this.

Prognosis: Poor. Very little work is being done on the documentation except more of the same. Everyone wants to write; nobody wants to index.

### <span id="9">9. The API is Too Complicated.</span>

Writing Perl extensions is too hard. You have to understand XS. Existing documentation of XS is very sketchy.

If what you want to do is just to glue existing C functions into Perl, packages like SWIG and `h2xs` are a big help here. If you want to do anything the slightest bit offbeat, you're on your own.

What would help here? Better documentation. The example discussed in the existing `perlxs` manual is an interface to the `rpcb_gettime` function, whatever the heck that is. If you don't have it on your system, and you probably don't, you can't try out the example. There's too much dependency between the `XS` man pages and the `perlguts` man page; someone needs to go over these and reorganize them into a series of documents that can be read in order.

I once asked Larry why XS is so complicated, and he said that it was like that to make it efficient. It would be nice if there were a kind of extension glue that was simpler to write even if it were less efficient.

Prognosis: Mixed. Glue makers like SWIG and Ken Fox's C++ kit seem to be maturing nicely. But the documentation problem is not being addressed, and the real underlying problem, which is that Perl's internals are too complicated and irrational, is probably insoluble. The Topaz (Perl 6) project might fix this.
