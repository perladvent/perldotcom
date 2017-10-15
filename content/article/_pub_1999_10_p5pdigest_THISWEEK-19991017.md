{
   "tags" : [],
   "thumbnail" : null,
   "date" : "1999-10-17T00:00:00-08:00",
   "categories" : "community",
   "image" : null,
   "title" : "This Week on p5p 1999/10/17",
   "description" : "(11-17 October 1999) -> Introduction New Development Release 5.005_62 Unicode Character Classes Module Bundling and the proposed import pragma use fields allows overlapping member names PREPARE functions and my Class $foo declarations goto Out of Conditional Bug Regex Range Bug...",
   "slug" : "/pub/1999/10/p5pdigest/THISWEEK-19991017.html",
   "draft" : null,
   "authors" : [
      "mark-jason-dominus"
   ]
}



-   [Introduction](#introduction)
-   [New Development Release 5.005\_62](#devel500506)
-   [Unicode Character Classes](#charclasses)
-   [Module Bundling and the proposed `import` pragma](#bundling)
-   [`use fields` allows overlapping member names](#fields)
-   [`PREPARE` functions and `my Class $foo` declarations](#prepare)
-   [`goto` Out of Conditional Bug](#goto)
-   [Regex Range Bug](#range)
-   [`use lib` change](#lib)
-   [More discussion about documentation for `pack`](#pack)
-   [MicroPerl](#microperl)
-   [Various](#various)

------------------------------------------------------------------------

### <span id="introduction">Introduction</span>

This is intended to be a short summary of the major and important threads of discussion on the perl5-porters mailing list this week.

I am trying to add value to the summary by omitting threads that I perceive as uninteresting. For example, you often see threads of this type:

**Person A**  
Here is a problem with Perl when you try to do X. I propose solution S.

**Person B**  
Solution S is unnecessary because you can do Y instead.

**Person A**  
No, that does not work, because of Z.

**Person B**  
Oh, I totally misunderstood what you were doing.

**Person C**  
But solution S will break existing code.

**Person A**  
No, it won't.

**Person C**  
Oh, you're right. I thought you meant something else.

**Person A**  
Here is a patch to implement solution S.

I am going to try to omit these blind alleys. I will also try to omit some other types of messages:

**Person D**  
Why are submitting a patch for S when we know it will break old code and anyway you could be doing Y instead?

**Person E**  
Fortran has adopted solution S. Perl is not Fortran; therefore solution S is no good. If you want Fortran, you know where to find it.

**Person F**  
You shut up.

**Person G**  
No, you shut up.

**Person H**  
Your formatting style offends me profoundly. Can't you get a real mailer?

**Person I**  
How can I develop CGI scripts offline on my W98 machine?

**Person J**  
P5P is not a help desk.

**Person K**  
I am writing to report a bug in the `localtime` function. It returns the wrong month.

**Person L**  
WORK FROM HOME!!!!

A lot of the stuff I omitted is on topic and has real value, but isn't particularly interesting. For example I have omitted a bunch of cases where someone submitted a minor patch that was accepted with no discsusion. I omitted some discussions that did not seem to be of general interest. For example, this week, Brad Appleton and Ilya Zakharevich had an exchange about the pod-formatting features of cperl-mode.

It is hard to keep track of everything, and I may occasionally omit something you think is important, or I might misunderstand some important issue. Your additions and emendations are welcome. Please send any corrections, suggestions, additions, or embellishments to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month. For a more complete view of perl5-porters, either subscribe to the mailing list or [check the archive](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/).

I wanted to include hot links to the relevant messages in the archive, but the archive was down and I could not get the URLs. This will be corrected in a future issue, even if we have to start our own archive.

### <span id="devel500506">New Development Release 5.005\_62</span>

Sarathy announced the release of development version 5.005\_62. It is available from [CPAN](http://www.cpan.org/src/5.0/perl-5.6.2.tar.gz).

Changes since 5.005\_61 include:

-   more 64-bit enhancements: 64-bit `vec()`, lfs fixes (Jarkko Hietaniemi)
-   `our` declarations (Larry Wall)
-   `sub foo : attrs`, `use attrs` deprecated (Spider Boardman)
-   Configure: new flag `-Accflags=stuff` (Jarkko Hietaniemi)
-   lvalue subroutines breaks `\(Foo->bar())` (Ilya Zakharevich and Tuomas Lukka)
-   added `File::Glob` (was `File::BSDGlob` from Greg Bacon)
-   building perl with `-DPERL_INTERNAL_GLOB` will do implicit `use File::Glob 'globally'`
-   `use strict` generates true errors, not fatal warnings
-   new `-DPERL_Y2KWARN` option for `"19$yr"` and `sprintf "19%d", $yr` (Ulrich Pfeifer)
-   `exists()` works better on pseudo-hashes (Michael Schwern)
-   warnings on invalid escapes in char ranges (Jarkko Hietaniemi)
-   comments in `pack` templates allowed (Ilya Zakharevich)
-   subroutine context could be popped too soon, leading to Tk coredumps (Russel O'Connor)
-   64bit-safe macros for `int->ptr` and `ptr->int` typecasts (Robin Barker)
-   fix for `POPSTACK` panics
-   fixes for memory leaks when is `@_` modified
-   `%@` "leaks", gone
-   `END` blocks not run under `-c` switch
-   `die`/`warn` go to `STDERR`, not `PerlIO_stderr()`
-   `\C{foo}` has been renamed to `\N{foo}`
-   `pack` template `Z` always packs a null byte
-   `POSIX::strftime()` bugs (Spider Boardman and Jan Dubois)
-   `xsubpp` understands function pointers, undocumented (Ilya Zakharevich)
-   `h2xs` more selective, and works with opaque types (Ilya Zakharevich)
-   `use lib` doesn't keep dups
-   `MakeMaker` support for uninstalled perl, undocumented (Ilya Zakharevich)
-   `Benchmark` enhancements (Barrie Slaymaker)
-   warning on `join(/foo/,...)` (Mark-Jason Dominus)
-   `perlcc` supports other backends (Tom Hughes)
-   more descriptive diagnostics about opcodes (Michael Schwern)
-   Unicode database updated to 3.0-ish (unicode.org)
-   EPOC updates (Olaf Flebbe)
-   DOS updates (Laszlo Molnar)
-   VMS updates (Charles Bailey and others)
-   Win32 updates: Windows 95 support, faster `opendir()`, `use Shell` support (Benjamin Stuhl, Jochen Wiedmann, Jenda Krynicky and others)
-   cygwin updates (Eric Fifer and others)
-   JPL updates (Brian Jepson)
-   Compiler updates (Vishal Bhatia)
-   `DB_File` update to 1.71 (Paul Marquess)
-   `PodParser` update to 1.085 (Brad Appleton)
-   `pod2text`, `pod2man` replaced by `podlators-0.08` (Russ Allbery)
-   `Getopt::Long` 2.20 (Johan Vromans)
-   `perlcompile.pod`, `perlhack.pod` (Nathan Torkington)
-   lots of pod adjustments
-   lots of other bug fixes

Sarathy also said that he was moving into beta mode for the upcoming version 5.6.

### <span id="charclasses">Unicode Character Classes</span>

Jarkko realized that since Perl was moving into beta mode for 5.6, this was his last chance to propose a new feature. He wants Perl regexes to support the \`equivalence class' feature of POSIX 1003.2. What this means is that certain characters in the character set may be deemed \`equivalent', and the notation `[=c=]` denotes a character class containing all the characters equivalent to `c`.

How do you decide which characters are considered \`equivalent'? Unicode provides a definition that allows you to understand a character like `é`; as an `e` with an acute accent; we could have Perl understand this to be equivalent to a plain `e`. Then the notation `[=e=]` would match any of `e`, `é`, `è`, `ë`, or `ê`. This might be useful.

Jarkko also wants people to be able to define their own equivalence relations, and he wants the `m//` and `s///` operators to support a new option, analogous to `/i`, which would say to ignore all diacritical marks, again using the Unicode tables to decide what a diacritical mark is.

People brought up a number of potential problems; for example, in Danish, the character `å` (U00E5) is considered to be an entirely different letter from `a` and not equivalent to it at all. But according to Unicode, `å` is indeed an `a` with a diacritical mark. (Jarkko: \`\`Ha! I am just expecting some Danes . . . to jump up here and wave frantically their hands. . . '' )

Discussion continues; I will deliver an update next week if there is anything to report. By the way, the [Unicode code charts](http://charts.unicode.org/) are great browsing. [The databases that say which characters are composed from which others](ftp://ftp.unicode.org/Public/UNIDATA/) are interesting too.

### <span id="bundling">Module Bundling and the proposed import pragma</span>

Tim Bunce forwarded a message that Michael King had sent to the `modules@perl.com` mailing list. Michael had written a new module, which he named `import`. The idea of `import` is this: Suppose you have a bunch of modules that are for internal use at your company only. You are worried about namespace collisions with CPAN modules. You can name your internal-use modules with names that all begin with `com::yourcompany` and then use

     use import 'com::yourcompany';

This does two things. First, it locates *all* modules in the `com::yourcompany` space on the local machine and imports them all. But second, it imports each `com::yourcompany::Foo` module with the `com::yourcompany` part stripped off. This means that if, for example, you have a `com::yourcompany::Template` module, you can now call `Template->new()` instead of `com::yourcompany::Template->new()`.

Michael says that this is like the `import` keyword in Java.

This touched off a number of interesting discussions:

1.  Andreas König suggested that Perl should support a

         package "www.foo.org";

    directive which would be equivalent to `package       org::foo::www;`. But Chip Salzenberg said that this was usually understood to have been a bad idea, because organizations often change URLs for various reasons. For example, `foo.com` and `bar.com` might merge to become `foobar.com`. Says Chip: *One of the best things about CPAN is that it is the de facto root namespace for all shared Perl modules. Let's not throw that away!*

2.  This led to a general discussion about how entire module namespaces might be reserved.

    Damian Conway pointed out that we could simply establish the convention that if you have a PAUSE id, that module space is reserved for you. For example, Damian's PAUSE id is DCONWAY; under this convention, all modules beginning with `DCONWAY::*` would belong to him.

    Problems with this scheme: Uri Guttman would now own the `URI::*` space, including the `URI::URL` module. Nick Ing-Simmons's PAUSE id is `NI-S`, which is not a valid package identifier.

3.  John Redford suggested a module that lets you bundle many modules into one. He says:

    > Then you could write a bundling module, like this:
    >
    >                     package MyCompany::CGIBundle;
    >                     use MyCompany::CGI::BobsCode::Foo;
    >                     use MyCompany::CGI::Test::Bar;
    >                     use MyCompany::CGI::BobsBetterCode::Foo2;
    >                     ....
    >                     use NameSpace::Transitive;
    >
    > And then people could just write:
    >
    >                     use MyCompany::CGIBundle;
    >
    > to get all the symbols that were exported into `MyCompany::CGIBundle` re-exported into their own namespace.

    I had written a module something like this back in February, so I decided that put it on CPAN. It is now available as ModuleBundle. Nick Ing-Simmons also pointed out that his `Tk::widgets` module does something similar: `use TK::widgets qw(Text       Entry Canvas)` is equivalent to:

         use Tk::Text ();
         use Tk::Entry ();
         use Tk::Canvas();

4.  A couple of people wanted the two functions of this module to be separated. They liked the idea of being able to alias namespaces, so that the objects in `com::yourcompany::Template` could be referred to as if they were in `Template`, but they were worried about the other function, which is to locate and import a whole lot of stuff indiscriminately. There was some discussion of a namespace aliasing pragma, or of adding this functionality to the existing `Alias` module.

There were also a number of uninteresting discussions: Someone wanted to know what would happen if you said `use import 'CGI'`. Michael's answer to that was that that was not what `import` was for and that whoever did that would get the bizarre behavior that they deserved. That did not stop a lot of people from making a big fuss about it, however. One person even said \`\`If you want that functionality, why don't you write a module to do that?'' apparently having forgotten that the way the discussion started was that Michael had written a module to do that, notified the modules list, and then Tim Bunce forwarded his note to P5P.

It appears that Michael is now pursuing a name in the `Import` namespace, and may make some changes to the module's calling interface to better seprate the two functions of his module.

### <span id="fields">use fields allows overlapping member names</span>

Tuomas Lukka discovered a gotcha in `field.pm`. The gotcha is this: Suppose you have a base and a derived class, and both contain a field with the same name, say `f`. Suppose the method `m` is defined in the base class and inherited by the derived class. Now create an object of the derived class, and call `m` on the object. Suppose `m` contains code to modify field `f`. There are two fields named `f`. Which one will be modified?

You would expect that, because `m` is defined in the base class, it should modify the base class's `f`. And so it does, if `m` is written correctly:

     package Base;

     sub m {
       my Base $self = shift;
       $self->{f} = 'newvalue';   # Modifies base class field f
     }

But if you accidentally write `my $self` instead of `my Base $self`, it modifies the wrong member:

     package Base;

     sub m {
       my $self = shift;
       $self->{f} = 'newvalue';   # Modifies DERIVED class field f
     }

Tuomas points out that the declaration and use of `$self` might be very far apart, and that a mistake in a far-away declaration could introduce a bug in the program that was difficult to find. Worse, suppose the object was stored inside some other object, so that instead of `$self->{f}` you had `$object->{subobject}->{f}`; in this case no declaration at all applies and you get the same problem.

Tuomas' solution is to simply forbid conflicting field names. `fields.pm` and `base.pm` will detect this and throw a fatal exception if they detect that a derived class is using a member with the same name as one of its parent classes.

Tuomas's rationale: It is very dangerous at present, and is \`action at a distance', which means that two apparently unrelated declarations far away, even in entirely different files, might drastially alter the behavior of a subroutine in a third location. The prohibition can be lifted later if a way is found to make it safer, and nobody appears to be using it now. (Someone thought they were, but realized they were mistaken.)

Sarathy appeared to be persuaded that the situation required at least a warning. Tuomas is pushing for a fatal compile-time error.

### <span id="prepare">PREPARE functions and my Class $foo</span> declarations

Ilya had submitted a patch which would have made `my Class $foo;` behave as if you had also written `Class->PREPARE($foo)`, if there was such a method. If you had `my Class $foo = 'bar'` instead, the assignment would occur after the `PREPARE` call.

Sarathy did not like the implementation, for reasons I did not completely understand. Sarathy did not like that an `AUTOLOAD` call would be made at compile time if `PREPARE` was not found where it was supposed to be. Ilya did this by analogy with `DESTROY`, but the compile-time call to `AUTOLOAD` is peculiar. (Sarathy: \`\`Yikes!'') Sarathy also objected to the way that the check for `PREPARE` was done at compile time, rather than at run time; Ilya said he did it that way for efficiency so that the check would not have to be done every time the declaration was executed.

Sarathy also complained that even though most uses of `my Class $foo` would not involve `PREPARE`, the compiler would have to make an `AUTOLOAD` call for each one of them. Ilya appeared to agree that this was a problem. Sarathy suggested a pragma that declares the `PREPARE` method for a class. Ilya pointed out that if the autloading part was removed from his patch, then the definition of the `PREPARE` subroutine itself would serve as exactly such a pragma.

An interesting sidetrack developed: Chip said it would be simpler in Topaz if the argument to `PREPARE` were `\$foo` rather than just `$foo`. Ilya said he did not want to do that because constructing a reference costs as much as 21 \`simple' operations. What this means is: Perl takes a certain amount of time to dispatch each operation. For some \`simple' operations, such as performing a scalar assignment, the time to actually perform the operation is dominated by the opcode dispatch time, so they all take about the same amount of time. Constructing a scalar reference, according to Ilya, takes 21 times as long as one of these \`simple' operations, and constructing an array reference takes 50 times as long. Chip was surprised, and so am I.

### <span id="goto">goto Out of Conditional Bug</span>

Damien Neil reported a bug in 5.005\_03 that is triggered when you use `goto` out of a conditional block. He also supplied a patch. Watch out for Damien&\#151newcomers who provide core patches are people to pay attention to.

Sarathy said that this was already fixed in the development version. His solution is a little different. Damien's patch wraps up each branch of the `if` as a separate block; Sarathy's wraps up the entire `if` as one block. Sarathy wants to keep his patch because it makes the op tree smaller and so the code is faster at run time. But he notes that Damien's approach might be better if the peephole optimizer could be instructed to remove the extra instructions for blocks that do not contain `goto`.

### <span id="range">Regex Range Bug</span>

Faisal Nasim had trouble with a regex that included `[\w-]` and `[\w-.]`. Different versions of Perl behaved differently for this, depending on whether the `-` was seen as indicating a range or not. 5.005\_03 interpreted it as if you had written `[\w\-.]`; 5.005\_62 generated a syntax error. (\`\`Invalid range''.) This was Jarkko's doing. Opinions varied about what behavior was best, especially since the documentation seemed to support the latter view&\#151but the changed behavior broke old code, as Faisal pointed out.

Larry suggested making it a warning. Jarkko thought this was peachy and put in the patch. While on the subject, he put in a warning for use of `\A` etc. in character classes.

### <span id="lib">use lib change</span>

Tod Irwin wants `use lib 'foo'` to append `foo` to the front of `@INC` (which it does already) and to also remove any *other* appearances of `foo` that happen to be in `@INC` already. His motivation: `mod_perl` scripts that have `use lib` have `@INC` lists that get longer and longer and longer.

There were some objections, but the change is in.

> **Nick Ing-Simmons:** Modules which inject things into `@INC` are highly suspect beasts - its like lacing the fruit juice with vodka.

### <span id="pack">More discussion about documentation for pack</span>

A discussion about the documentation for `pack` finished up. I wouldn't have mentioned this, except:

> **Sarathy:** What would you suggest \[the format specifier\] `@*` should mean?
>
> **Ilya:** Call the cops.

### <span id="microperl">MicroPerl</span>

This almost slipped by me, but I wrote to ask Ilya what it was about. Here's what he said:

> Build Perl without Configure support. First you build a bastardized version (nanoperl), use it to build a correctly working version with some functionality missing (microperl), then use this to run `Configure.PL` which will make an analogue of `config.sh`, then you continue with miniperl and perl as before.
>
> The supplied target crazyperl is *very* close to become nanoperl of the above classification. Minor changes to supplied `micro0/config.sh` should (when bugs are ironed out) produce a microperl.
>
> Currently crazyperl passes a lot of tests. This should be improved yet more (apparently the code *is* there to support the situation when no non-portable services are found, but it has some bugs).

Aren't you glad I asked? I sure am.

### <span id="various">Various</span>

Also a large collection of bug reports, bug fixes, questions, answers, and a small amount of flamage and spam.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-199910+@plover.com)
