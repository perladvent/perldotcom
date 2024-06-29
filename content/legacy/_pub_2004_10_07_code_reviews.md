{
   "description" : "Richard Gabriel of Sun Microsystems suggests that beginning programmers should study the source code for great works of software as part of a Master of Fine Arts course in software. Prominent Extreme Programmers talk about finding the Quality Without a...",
   "slug" : "/pub/2004/10/07/code_reviews.html",
   "draft" : null,
   "authors" : [
      "luke-schubert"
   ],
   "tags" : [
      "code-reviews",
      "good-perl-code",
      "luck-schubert",
      "math-complex",
      "reading-code"
   ],
   "thumbnail" : "/images/_pub_2004_10_07_code_reviews/111-good_code.gif",
   "date" : "2004-10-07T00:00:00-08:00",
   "categories" : "development",
   "title" : "Why Review Code?",
   "image" : null
}



Richard Gabriel of Sun Microsystems suggests that [beginning programmers should study the source code for great works of software](http://java.sun.com/features/2002/11/gabriel_qa.html) as part of a [Master of Fine Arts course in software](http://www.dreamsongs.com/MFASoftware.html). Prominent Extreme Programmers talk about finding the [Quality Without a Name](http://c2.com/cgi/wiki?QualityWithoutaName) in software, listening to your code, and reworking your code when it "smells."

With this in mind, this article contains a review of one of the "base" Perl modules, available from CPAN but also included as part of any distribution of Perl. It's a module that I particularly like (with algorithms that I can more or less understand); I aim to show why I like it and what you can learn from it.

### Code and Communication

Reviewing (even reading) source code is not always easy. Most software doesn't have human readability as a primary goal — just compilers or interpreters. The exception is software written as examples or to help others learn. This code is primarily of interest in itself and not for what it does. As far as a computer cares, software would have the same behavior if it had no comments and all variables named as `a1, a2, ...` -- as the obfuscated programming contests prove. They also prove that we humans then find it difficult to read. Most literature (including poems, essays, short stories, novels), on the other hand, has the primary purpose of communicating with other people, and so is often easier to understand.

Nonetheless, code reviews are still useful. Projects that perform them usually do so to find bugs or to suggest improvements; they exist for the benefit of the code writer or tester. Here, we seek to learn from the code, to take away from it lessons that we can apply to our own code. These are lessons, or patterns, but not design patterns; the patterns discussed here appear at a lower level and are more of the order of tips and tricks.

As mentioned above, there are parts of software programs that do exist to communicate: comments as well as variable and function (or method) names are all about communicating (with other people). The challenge for the considerate [\[1\]](#codemaintainer) software developer (who thinks beyond the short term) is to use comments and names to tell the story of the software: what it is, what it should do, and why the developers made certain choices. Ideally, the form of software should match its function [\[2\]](#camel): comments and names should explain and clarify the rest of the code, rather than disagreeing with it, repeating what it says, or being irrelevant. Source code reviews are part of this process. They further explain the code to a wider audience, telling its story in a broader and hopefully deeper way.

### The Review Itself

[Math::Complex]({{< mcpan "Math::Complex" >}}) is an open source Perl package that is part of the core Perl distribution. It provides methods for complex arithmetic (and overloading of operators).

[Raphael Manfredi](http://c2.com/cgi/wiki?RaphaelManfredi) created the module in 1996. Since then, first [Jarkko Hietaniemi](http://www.hut.fi/~jhi/) and, currently, [Daniel S. Lewart](http://www.prairienet.org/~dslewart/) have maintained it (according to its own comments). My comments below relate to version 1.34.

I should explain that while I've been using Perl for maybe three years, it's mostly been for test automation and text processing; my day-to-day programming is primarily in C. I tend to notice the things about Perl that are difficult (at times verging on impossible) to do in C.

Early on in the [Math::Complex]({{< mcpan "Math::Complex" >}}) package, a huge (and often reused) regular expression `$gre` appears:

    # Regular expression for floating point numbers.
    my $gre =
    qr'\s*([\+\-]?(?:(?:(?:\d+(?:_\d+)*(?:\.\d*(?:_\d+)*)?|\.\d+(?:_\d+)*)(?:[eE][\+\-]?\d+(?:_\d+)*)?)))';

This regular expression captures floating-point numbers (which may include isolated underscores) in a single reference. It thus provides flexibility and robustness (key motivations for using regular expressions) without repetition. It also uses `?:` within the brackets to cluster parts of the regular expression without providing back references; this means that the whole regular expression provides one back reference rather than five or six.

This regular expression may be easier to understand when refactored into smaller chunks. The test I used when refactoring was quite simple:

    my @testexpressions = ('100', '100.12', '100.12e-13', '100_000.545_123',
        '1e-3', '.1', '-100_000.545_123e+11_12');
    foreach my $expr (@testexpressions)
    {
       if ($expr =~ m/$gre/)
       {
          print "$expr matches gre\n";
       }
    }

The same test code can run against the refactored regular expression to make sure that it still matches the same strings. Here, working from the inside out, I extracted some common expressions. For each expression extracted and captured by the quote-like operator `qr`, I also removed the `?:` clustering. `$gre` above is equivalent to `$newgre` below:

    my $underscoredigits = qr/_\d+/;
    my $digitstring      = qr/\d+$underscoredigits*/;
    my $fractional       = qr/\.\d*$underscoredigits*/;
    my $mantissa         = qr/$digitstring$fractional?|\.$digitstring/;
    my $exponent         = qr/[eE][\+\-]?$digitstring/;
    my $newgre           = qr/\s*([\+\-]?$mantissa$exponent?)/;

For example, `$underscoredigits` matches `_123`; `$digitstring` matches `545_123`; `$fractional` matches `.545_123`; `$mantissa` matches either `100_000.545_123` or `.1`; `$exponent` matches `e+11_12`; and finally `$newgre` matches the whole string `-100_000.545_123e+11_12`.

The construction method `make` is, again, flexible and robust. The author has extracted part of its complexity to different methods to avoid repetition. For example, the module uses the `_cannot_make` function internally to report errors, calling it from several places in `make`. It looks like:

    # Die on bad *make() arguments.

    sub _cannot_make {
        die "@{[(caller(1))[3]]}: Cannot take $_[0] of $_[1].\n";
    }

In turn, it calls the built-in `caller` function to refer back to the original code (similar to an `assert` in C, or a lightweight version of the `cluck` or `confess` functions in the [Carp]({{< perldoc "Carp" >}}) package).

`make` also calls the the `remake` function, if `make` receives only one argument (for example, a string such as `"1 + 2i"`) and must deduce the real and/or imaginary parts:

    sub _remake {
        my $arg = shift;
        my ($made, $p, $q);

        if ($arg =~ /^(?:$gre)?$gre\s*i\s*$/) {
            ($p, $q) = ($1 || 0, $2);
            $made = 'cart';
        } elsif ($arg =~ /^\s*\[\s*$gre\s*(?:,\s*$gre\s*)?\]\s*$/) {
            ($p, $q) = ($1, $2 || 0);
            $made = 'exp';
        }

        if ($made) {
            $p =~ s/^\+//;
            $q =~ s/^\+//;
        }

        return ($made, $p, $q);
    }

The regular expression `$gre` appears here as part of a larger regular expression, to interpret not only `"1 + 2i"` but also `"2i"` by itself. The expression `$1 || 0`, used here and elsewhere, replaces the `undef` value of Perl (treated as 0 in a Boolean context) with 0, while leaving other values unchanged.

The `plus` function, one of the several binary operators provided in the package, also has some interesting features:

    #
    # (plus)
    #
    # Computes z1+z2.
    #
    sub plus {
            my ($z1, $z2, $regular) = @_;
            my ($re1, $im1) = @{$z1->cartesian};
            $z2 = cplx($z2) unless ref $z2;
            my ($re2, $im2) = ref $z2 ? @{$z2->cartesian} : ($z2, 0);
            unless (defined $regular) {
                    $z1->set_cartesian([$re1 + $re2, $im1 + $im2]);
                    return $z1;
            }
            return (ref $z1)->make($re1 + $re2, $im1 + $im2);
    }

It uses the trinary conditional operator `* = * ? * : *`, which is also present in C. In Perl, this can return not just scalars but also lists. Thus the code to calculate the values of `$re2` and `$im2` is much more compact than the equivalent code in C could be. This code uses the Cartesian coordinates of `$z2` if it's already a complex number. Otherwise, it turns a real number into a complex number.

The `plus` function later uses `ref $z1`, the package name of `$z1`, to create the sum of `$z1` and `$z2`; this allows subclasses of Math::Complex to reuse exactly the same function.

Finally, the `Cartesian` function mentioned above can either return existing values for the real and imaginary part, if these are "clean" (valid), or recalculate them from the polar form. Each complex number object stores the "cleanliness" (validity) of its Cartesian values, as follows:

    sub cartesian {$_[0]->{c_dirty} ?
            $_[0]->update_cartesian : $_[0]->{'cartesian'}}

This is a neat trick to avoid recalculating Cartesian coordinates when it's not necessary.

### Summary

The `Math::Complex` package is not only useful, but efficient, robust, and flexible. It does use brief variable names, but this is traditional in mathematics; given that it uses complicated (or at least long) expressions, this means that the full expression is easy to understand (or read aloud). The functions themselves tend also to be brief and easy to understand.

We see here the benefits of reuse and refactoring. Over 8 years and 34 versions of this code, it has no doubt seen heavy rewriting, to the point of perhaps each line being different from the corresponding line in version 1.1 (or 0.1!). This extended refactoring has removed unnecessary and repeated code, clarified comments and usage, and led to clear and clean code. It provides an example not only of how to write a mathematical package in Perl, using regular expressions and references as described above, but also of what code can look like. That is perhaps its best lesson.

### Endnotes

<span id="codemaintainer">\[1\]</span> "Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live." (Martin Golding)

<span id="camel">\[2\]</span> Though perhaps not always to [this](http://www.perlmonks.org/index.pl?node_id=45213) extent.
