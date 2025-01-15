{
   "tags" : [
      "modernperl",
      "subroutine",
      "method"
   ],
   "image" : null,
   "date" : "2014-02-24T03:55:52",
   "title" : "Perl levels up with native subroutine signatures",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "72/2014/2/24/Perl-levels-up-with-native-subroutine-signatures",
   "categories" : "development",
   "description" : "The syntax, the benefits and what's coming next",
   "draft" : false
}


*It's been a long time coming, but subroutine signatures have just been added to Perl. Although Perl version 5.20 is not due until the Spring, you can use subroutine signatures with the latest Perl development release now.*

### Requirements

You'll need to install a copy of the latest Perl development release (v5.19.9). You can get this with Perlbrew:

```perl
$ perlbrew install perl-5.19.9
$ perlbrew switch perl-5.19.9
```

Or you can download and build Perl v5.19.9 from [cpan.org](http://www.cpan.org/src/README.html).

Once 5.19.9 is installed, you'll need the [experimental]({{<mcpan "experimental" >}}) distribution. Install it via cpan at the command line:

```perl
$ cpan experimental
```

### Subroutine signatures explained

A subroutine signature is a formal list of parameters for a subroutine. You can declare a subroutine signature like this:

```perl
use experimental 'signatures';

sub echo ($message) {
    print "$message\n";
}
```

In this example "($message)" is the subroutine signature. That indicates that all calls to the echo subroutine must pass one parameter. When the subroutine is called, the parameter is assigned to $message and available for use within the scope of the subroutine.

### Default values

A signature can also declare default values for its parameters. Let's add a default message to the echo subroutine:

```perl
use experimental 'signatures';

sub echo ($message = 'Hello World!') {
    print "$message\n";
}
```

Now the value of $message will default to "Hello World!" when the subroutine is called without arguments.

Subroutine signatures can also declare optional and slurpy parameters. If you'd like to see examples, check out the new subroutine signatures entry in Perl's [official documentation.]({{< perldoc "perlsub" "Signatures" >}})

### Argument checking

Adding a signature to a subroutine enables argument checking for all calls to that subroutine. For example this code generates an error when run:

```perl
use experimental 'signatures';

sub echo ($message) {
    print "$message\n";
}

echo(); # missing argument
```

```perl
$ perl echo.pl
Too few arguments for subroutine at echo.pl line 3.
```

Perl will also raise an error if too many arguments are passed:

```perl
use experimental 'signatures';

sub echo ($message) {
    print "$message\n";
}

echo('hello', 'world'); # too many arguments
```

```perl
$ perl echo.pl
Too many arguments for subroutine at echo.pl line 3.
```

This is helpful- it avoids the need to write boilerplate argument checking code inside subroutines. Beware though; as there is no value check, the following will not raise an arguments error:

```perl
use experimental 'signatures';

sub echo ($message) {
    print "$message\n";
}

echo(undef); #undef is an argument
```

### Less ugly code

You can banish those unsightly variable assignments from your subroutines. Say goodbye (and good riddance) to this:

```perl
sub ugly_code {
    my ($arg1, $arg2, arg3) = @_;
    ...
}
```

And say hello to this:

```perl
sub fine_code ($arg1, $arg2, arg3){
    ...
}
```

### Further enhancements are coming

The native subroutine signatures implementation is a minimalist one compared to the feature-full [Method::Signatures]({{<mcpan "Method::Signatures" >}}) module. Peter Martini the main sponsor of Perl's native subroutine signatures, has confirmed plans to add type checking, aliases, read-only copies, and named parameters in the future. He expects each of these features to bring speed improvements too.

### Revisiting an old Python and Perl comparison

On page 5 of [The Quick Python Book, Second Edition](http://www.amazon.com/gp/product/193518220X/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=193518220X&linkCode=as2&tag=perltrickscom-20) (affiliate link), the author compares equivalent Perl and Python functions for readability. In the author's view, the Python code is more readable than the Perl code. It's a straw man argument as the Perl example is written in "baby Perl", but let's revisit the example using Perl's native subroutine signatures feature. This is the Python example, unmodified:

```perl
def pairwise_sum(list1, list2):
    result = []
    for i in range(len(list1)):
        result.append(list1[i] + list2[i])
    return result
```

And this is the original Perl code example:

```perl
sub pairwise_sum {
    my($arg1, $arg2) = @_;
    my(@result) = ();
    @list1 = @$arg1;
    @list2 = @$arg2;
    for($i=0; $i < length(@list1); $i++) {
        push(@result, $list1[$i] + $list2[$i]);
    }
    return(\@result);
}
```

Here is a refactored Perl version:

```perl
sub pairwise_sum {
    my ($arg1, $arg2) = @_;
    return map { $arg1->[$_] + $arg2->[$_] } 0 .. $#$arg1;
}
```

This code is cleaner and shorter than the original Perl code. It's also shorter than the Python example. But is it cleaner? Using subroutine signatures, we can do better:

```perl
sub pairwise_sum ($arg1, $arg2) {
    return map { $arg1->[$_] + $arg2->[$_] } 0 .. $#$arg1;
}
```

You can see that using subroutine signatures has saved us a line of code for parameter assignment. Now there can be no argument: the Perl code is shorter and cleaner than the Python example. Nice!

### Conclusion

Subroutine signatures is a leap-forward for Perl technically and a boost for the Perl community. It's motivating to see significant language advancements and there are more on the way. With [postfix dereferencing](http://perltricks.com/article/68/2014/2/13/Cool-new-Perl-feature-postfix-dereferencing), new [performance enhancements](http://blogs.perl.org/users/matthew_horsfall/2014/02/perl-519x-performance-improvements.html) and now subroutine signatures, Perl version 5.20 is going to be the most significant release since 5.10. Roll on Spring 2014!

*2014-02-24: article updated to correct the error checking implementation, Perl code example and clarify Peter Martini's role in the Perl core signatures development.*

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F72%2F2014%2F2%2F24%2FPerl-levels-up-with-native-subroutine-signatures&text=Perl+levels+up+with+native+subroutine+signatures&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F72%2F2014%2F2%2F24%2FPerl-levels-up-with-native-subroutine-signatures&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
