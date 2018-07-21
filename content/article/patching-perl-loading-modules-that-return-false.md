
  {
    "title"       : "Patching Perl: loading modules that return false",
    "authors"     : ["david-farrell"],
    "date"        : "2018-06-25T20:27:37",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Removing of one of require's most annoying behaviors",
    "categories"  : "perl-internals"
  }

What's the minimum amount of code a module needs to have to be loaded by Perl? How about:

```perl
package Foo;

1;
```

This includes a package declaration and ends with `1;` so when it's loaded Perl doesn't error with: `Foo.pm did not return a true value`. This is a peculiar quirk of `require`: modules *must* return a true value else Perl interprets it as a failure:

> The file must return true as the last statement to indicate
> successful execution of any initialization code, so it's customary
> to end such a file with "1;" unless you're sure it'll return true
> otherwise. But it's better just to put the "1;", in case you add
> more statements.
> \
> perlfunc, require

But modules don't have to contain a package declaration. In fact all you need is to return a true value, so:

```perl
1;
```

Is valid module code (the code is scoped within the `main` package, like a script). Some folks are surprised to learn this, but it makes sense when you consider that module names are file names, not package names, despite them both sharing the `::` namespace separator.

I don't find this feature useful: if a module fails to initialize, it could `die` with a meaningful error message, instead of returning false and Perl croaking with a generic message. I would wager that the majority of the time this exception is encountered, it's because the programmer _forgot_ to append a true value to their module code. If one ethos of Perl is optimizing for the common case, croaking on require returning false doesn't seem to fit.

Many other features of Perl have been adopted by other languages, from its regular expression syntax, to `use strict` (JavaScript). But I don't know of any language that has copied this feature - perhaps because it's not very useful?

### Allowing require to return false

So what could I do about this? In order to allow modules to be loaded that don't return a true value, the Perl source code would need to be changed. I've dumpster-dived into the source occasionally to help better understand the Perl interpreter API, but I've never changed the source code before ... until now!

The first thing I did was fork the Perl [source code](https://github.com/Perl/perl5). I started grepping the code for the exception message "did not return a true value" and sure enough, I found the function `S_pop_eval_context_maybe_croak` in `pp_ctl.c`. This function is called when an eval completes (`require` evals the code it's trying to load) in order to clean up the stack and optionally, croak if an exception was encountered. It accepts a number between 0 and 2: 0 means "don't croak", 1 means "croak: require did not return a true value", and 2 means "croak: require triggered a compilation error".

Next I searched for callers to `S_pop_eval_context_maybe_croak` and found just one caller that passed a 1 to the function, this was the "leave eval" op code declaration, that included this logic:

```c
failed =    CxOLD_OP_TYPE(cx) == OP_REQUIRE
             && !(gimme == G_SCALAR
                    ? SvTRUE_NN(*PL_stack_sp)
                    : PL_stack_sp > oldsp);

...

/* pop the CXt_EVAL, and if a require failed, croak */
S_pop_eval_context_maybe_croak(aTHX_ cx, NULL, failed);
```

So I [deleted](https://github.com/dnmfarrell/perl5/commit/a27d5730eca477a85b81f3226c13ba87f52b5857) the `failed` code block, and changed the call to `S_pop_eval_context_maybe_croak` to always pass 0 instead.

Then I compiled the source:

```bash
$ ./Configure -des -Dusedevel -Dprefix=$HOME/blead-perl
$ make -j4
```

Finally I created a module called "Foo.pm" that only contained: `0;`. Then I tried to load it with the newly compiled Perl:

```bash
$ ./perl -I. -e 'require "Foo.pm"'
```

And I didn't see a "Foo.pm did not return a true value" error, yay!

### Making it a "feature"

I don't think P5P (the group that maintains the Perl source code) would accept my change as-is. For one thing, any code that _does_ rely on the require returning false feature would be broken by the next Perl release. The preferred way to introduce new behavior these days is to use the [feature](https://metacpan.org/pod/feature) pragma. So I removed my previous changes as tried to implement allowing require to return false as a feature.

The Perl source code has a handy utility called [regen/feature.pl](https://github.com/dnmfarrell/perl5/blob/66f43943f438f5bc7970dab0b7940e46c84909f5/regen/feature.pl) which takes care of generating the necessary C and Perl code to implement the feature flag. All you have to do is add the new feature's name to `regen/feature.pl`, and then run the script to add it to the Perl source.

I added the "require_false" feature to `regen/feature.pl` and ran the script, resulting in these [changes](https://github.com/dnmfarrell/perl5/commit/66f43943f438f5bc7970dab0b7940e46c84909f5#diff-731afc105e527b56f99b7fa4c365e82c). This added the macro `FEATURE_REQUIRE_FALSE_IS_ENABLED` to `header.h`, which I'll use later to check if the feature is enabled or not. Also note because `require_false` was the longest feature name in the set, the script also updated the `MAX_FEATURE_LEN` macro value so that the Perl's interpreter would compare the right number of bytes when checking feature names.

### Adding tests

At this stage I've created a new feature, but don't use it anywhere. This felt like a good time to update the source code tests to check if the feature works: at first it won't, but whilst I'm working on the feature I can quickly recompile and run the tests to check.

Searching through the battery of tests that ship with Perl, I found [t/comp/require.t](https://github.com/dnmfarrell/perl5/blob/b0fac096ef960f40700283537617bc27ee109cd4/t/comp/require.t) which tests require does the right thing when loading modules. One interesting thing about the Perl source test suite is they can't use common tools we use for testing like `Test::More`, instead they just print TAP output and let the test runner figure it out.

I updated [t/comp/require.t](https://github.com/dnmfarrell/perl5/commit/b0fac096ef960f40700283537617bc27ee109cd4#diff-fe89da3b778d57130351808d331b3731) to enable the new feature, and test loading a module returning a false value. I also test that compilation errors are not ignored when the feature is enabled. Because pragma's are scoped, I had to write the tests within a block, but also I couldn't use the test function `do_require` to handle everything for me, as it would be executed in a different scope.

I then recompiled Perl via `make` and ran the test with:

```bash
$ ./perl -I. -MTestInit t/comp/require.t
1..61
ok 1 - require 5.005 try 1
...
# use feature 'require_false';
not ok 59 - require loads module returning 0
ok 60 - require throws compile error
```

And as expected, the module wasn't loaded. By the way, `TestInit` is a useful module to load to avoid running the entire Perl source test suite which can take a long timewhen you only want to test certain behavior (I ran `make -j4 && ./perl -I. -MTestInit t/comp/require.t` countless times).

### Using the feature

In my previous change I updated the [leave eval op declaration](https://github.com/dnmfarrell/perl5/blob/521634c9fb488f9e3a1310d7eec7ab9a94dc2188/pp_ctl.c#L4506) in `pp_ctl.c` and that would seem like a logical place to add a check that the feature was enabled or not, and tell `S_pop_eval_context_maybe_croak` to croak or not. However, I found that this didn't work, and even when the feature was enabled, `FEATURE_REQUIRE_FALSE_IS_ENABLED` was always false.

I think this is because the line beginning `PP(pp_leaveval)` is declaring a new op via the `PP` macro - it's not a C function declaration. Instead of that, I tried adding the logic to `S_pop_eval_context_maybe_croak` [itself](https://github.com/dnmfarrell/perl5/commit/521634c9fb488f9e3a1310d7eec7ab9a94dc2188) and it worked. The change was very simple:

```c
+#include "feature.h"
 
 static void
 S_pop_eval_context_maybe_croak(pTHX_ PERL_CONTEXT *cx, SV *errsv, int action)
@@ -1630,7 +1631,9 @@ S_pop_eval_context_maybe_croak(pTHX_ PERL_CONTEXT *cx, SV *errsv, int action)
     bool do_croak;
 
     CX_LEAVE_SCOPE(cx);
-    do_croak = action && (CxOLD_OP_TYPE(cx) == OP_REQUIRE);
+    do_croak = action && (CxOLD_OP_TYPE(cx) == OP_REQUIRE) &&
+        (!FEATURE_REQUIRE_FALSE_IS_ENABLED || action == 2);
```

I imported `feature.h` and then added a logical condition to the `do_croak` assignment which checks if `FEATURE_REQUIRE_FALSE_IS_ENABLED` is enabled or not. I explained the `action` variable earlier: if it has a value of 2 that means there was compilation error, which we still want to allow to croak.

All that was left was to re-compile and run the tests again:

```bash
$ ./perl -I. -MTestInit t/comp/require.t
1..60
ok 1 - require 5.005 try 1
...
# use feature 'require_false';
ok 59 - require loads module returning 0
ok 60 - require throws compile error
```

All the `require` tests pass, woohoo!

### Wrap-up

I'm planning on getting feedback from P5P on this change: implementation-wise, I'm not sure if I've violated an unwritten rule by importing `feature.h` into `pp_ctl.c`. If I have, another way to achieve the same thing would be to declare a new a private flag for the require op, and set it in `perly.y` in the sections of the grammar which create a new require op (whenever it encounters `require` in Perl code). The flag could then be checked in `pp_ctl.c` instead of the feature macro.

Philosophically I think this is a good change to make, for the reasons I explained earlier, but also because it's relatively safe: modules are free to continue to return a true value if they want to. It eliminates an annoying feature and makes Perl developers lives a *little* bit easier - what's not to like about that?

Working with the Perl source can be intimidating: it's a large collection of advanced C code, which leans heavily on macros. The source's conventions can be opaque too: function, macro and variable names often follow a logical, but unintuitive naming format. Previously I've found myself unpacking a macro declaration to find it contains ... another macro, and another macro inside that one and so on. It's easy to forget the context and get lost in the code.

Sometimes I've had to literally write out call chains on paper to keep track. But it is incredibly satisfying to change Perl's behavior to suit your tastes. Imagine with that power, what would *you* change? It might not be an easy road, but things of value rarely come easy, and if nothing else you might learn a more about how Perl works internally, and pick up some new C programming tricks along the way.

