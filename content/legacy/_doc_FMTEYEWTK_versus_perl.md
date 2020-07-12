{
   "tags" : ["perl-4"],
   "thumbnail" : null,
   "date" : "1996-01-01T00:00:00-08:00",
   "categories" : "programming-languages",
   "image" : null,
   "title" : "The Seven Deadly Sins of Perl",
   "slug" : "/doc/FMTEYEWTK/versus/perl.html",
   "description" : "advocatus diaboli",
   "authors" : [
      "tom-christiansen"
   ],
   "draft" : null
}

Back in the Perl4 days I made a list of the greatest 'gotchas' in Perl. Almost all of those have been subsequently fixed in current incarnations of Perl, some to my deep and abiding amazement. In that same spirit, here's of my current list of what's--um... let's be charitable and just say 'suboptimal' in Perl from a reasonably serious programming languages design point of view. I believe these are real gotchas, and not always obvious. A few of these are fixable through programming rigor; a few of them are rumored to be fixed in Larry's own copy of 5.002 :-); but a few are simply inherent design decisions that quite possibly cannot be solved without breaking what the language is, much as csh's design flaws cannot be solved.

Of course, for many many kinds of apps, there's also so very much more that's *right* with Perl to make it not only a reasonable but often even the best choice from what's in the field today. I'm just trying to provide perspective here; think of it as eventual updates for the [perltrap]({{</* perldoc "perltrap" */>}}).

### 1. Implicit Behaviours and Hidden Context Dependencies

Functions overload only on return type rather than parameter type, which is always implicit and while inferrible by the language. This is often a shocking and terrible surprise to the programmer who doesn't have their fingers in Perl code all day every day. Type conversions (of non-reference types) are silent and deadly, especially between aggregates and scalars. They are hard for many to predict. The presence of subobvious default behaviours of various functions, and the inability to turn this off is too surprising, and more than somewhat dangerous.

### 2. To Paren || !To Paren?

That adding or not adding parens should have the strong potential for semantic changes instead of merely grouping is hard to fathom. Sometimes you're damned if you do, damned if you don't. By allowing but not requiring parens in almost all situations, people are confused by whether they should put them in, and deeply disturbed when doing or not can radically alter their program's behaviour. This is especially annoying in trying to figure out how to get regexps to return what they match.

### 3. Global Variables

There's no mandatory enforcement of declaration or detection of fully global variables, this can cause very difficult to detect program errors. Implicit use `$\_` is one of the classics, causing functions way up the stack to mysterious fail. There's no `use strict globals` or some such to force declaration even of exportable module-level globals. There's no way to have lexically-scoped pre-defined file-handles or built-in variables (like `$_`, `$?`, etc), and the dynamically-scoped versions are confusing to programmers of traditional languages.

### 4. References vs Non-References

Although introducing references in v5 was a critical step, by keeping backwards compatibility with older v4 code, the legacy code and basic system still uses too many types and ensuing confusions. That means people are still confused about `$` vs. `@` vs. `%`. In particular, they expect things that work on arrays or hashes to transparently work on references to the same, or vice versa. This shows up when folks try to work out complex data structures.

### 5. No Prototypes

Not having prototypes (function signatures) makes it impossible to create one's own functions that exactly duplicate builtins, as well as making static analysis of errors difficult. Even if you introduce prototypes for normal functions, how does this extend to user-defined object classes and methods? How do you prototype return values?

### 6. No Compiler Support for I/O or Regexp Objects

The I/O system's use of barewords is unclean and unpleasant, as there isn't really good compiler-aware support for i/o handles. The `open()` interface and friends must be entirely redone, preferably into an o-o paradigm, but without breaking old code. The regexp system is likewise archaic: since there's no real compiler support for compiled regexps, you either get very poor performance or else opaque hacks to work around it.

### 7. Haphazard Exception Model

There's no standard model or guidelines for exception handling in libraries, modules, or classes, which means you don't know what to trap and what not to trap. Does a library throw an exception or does it just return false? Even if it does, there is no standard nomenclature for exceptions, so it's hard to know how, for example, to catch all numeric exceptions, all i/o exceptions, etc. People mistakenly use `eval $str` for both code-generation and exception handling, thus not only delaying errors until run-time but also standing a good chance of losing them.
