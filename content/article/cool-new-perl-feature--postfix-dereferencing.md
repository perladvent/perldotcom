{
   "image" : null,
   "authors" : [
      "david-farrell"
   ],
   "title" : "Cool new Perl feature: postfix dereferencing",
   "date" : "2014-02-13T05:00:02",
   "draft" : false,
   "slug" : "68/2014/2/13/Cool-new-Perl-feature--postfix-dereferencing",
   "description" : "A sneak peak at Perl v5.20's most interesting change",
   "tags" : [
      "modernperl",
      "reference",
      "news",
      "postfix"
   ],
   "categories" : "development"
}


*Postfix dereferencing is a cool new feature coming in the next major Perl release. Although Perl version 5.20 is not due until the Spring, you can use the postfix dereferencing feature with the Perl developer release now.*

### Requirements

You'll need to install a copy of the latest Perl developer release (v5.19.8). You can get this with Perlbrew:

```perl
$ perlbrew install perl-5.19.8
$ perlbrew switch perl-5.19.8
```

Or you can download and build Perl v5.19.8 from [cpan.org](http://www.cpan.org/src/README.html).

Once 5.19.8 is installed, you'll need the [experimental](https://metacpan.org/pod/experimental) distribution. Install it via cpan at the command line:

```perl
$ cpan experimental
```

### Circumfix dereferencing primer

In Perl we're used to using the circumfix operation to dereference variables. The circumfix operation involves wrapping our reference in curly braces and prepending the appropriate variable sigil. For example, to dereference an array:

```perl
my $array_ref = [1, 2, 3];
push @{$array_ref}, 4;
```

Here we declare an array reference, then use the circumfix operation ("@{}") to dereference the array, enabling us to push the scalar onto the array. Stylistically the circumfix operation is ugly. Perl syntax is already awash with sigils and curly braces and we don't need any more. Circumfix dereferences can also be hard to read in the case of deeply nested references, as the dereferencing sigil is on the left, whilst the chain of dereferencing arrows grow to the right:

```perl
my $deep_array_ref = [[[[[1,2,3]]]]];
push @{$deep_array_ref->[0][0][0][0]}, 4;
```

### Enter postfix dereferencing

Postfix dereferencing is a new feature and a drop-in replacement for circumfix dereferencing. Instead of wrapping the reference with a circumfix operation, we append a dereferencing sigil to the end of the reference. Let's revisit the previous two examples using postfix dereferencing:

```perl
use experimental 'postderef';

my $array_ref = [1, 2, 3];
push $array_ref->@*, 4;

my $deep_array_ref = [[[[[1,2,3]]]]];
push $deep_array_ref->[0][0][0][0]->@*, 4;
```

Here we dereferenced the arrays using the postfix operation ("-\>@\*"). You can even get the array's last element index:

```perl
use experimental 'postderef';

my $array_ref = [1, 2, 3];
my $last_element_index = $array_ref->$#*;
```

This is cleaner than circumfix as there are no extra curly braces, it's more intuitive as it follows left-to-right precedence and nested references are easier to read as we don't have to track back to the beginning of the reference to locate the sigil. We have a winner!

### Postfix dereference works anywhere circumfix does

Arrays aren't the only beneficiary of this new feature. Postfix dereferencing works with scalars, hashes, coderefs and globs too:

```perl
use experimental 'postderef';
use feature 'say';

my $scalar   = 'hello world!';
my %hash     = ( hello => 'world!' );
my $code     = sub { say 'hello world!' };

my $sundry_ref = [  \$scalar,
                    \%hash,
                     $code ];

# scalar
say $sundry_ref->[0]->$*;

# hash
for (keys $sundry_ref->[1]->%*) { say "$_ $sundry_ref->[1]{$_}" }

# coderef
$sundry_ref->[2]->&*;
```

### Conclusion

Postfix dereferencing syntax is cleaner and easier to follow than circumfix. If you haven't seen it already, check out Perl pumpking, Ricardo Signes [presenting](http://www.youtube.com/watch?v=Sp102BECq8s&t=63m11s) postfix dereferencing at NYC.pm (the rest of the talk is great too).

For more postfix dereferencing examples, take a look at the Perl [source test file](https://github.com/Perl/perl5/blob/blead/t/op/postfixderef.t) and the new [perlref](http://search.cpan.org/~shay/perl-5.19.5/pod/perlref.pod#Postfix_Dereference_Syntax).

Enjoyed this article? Help us out and [retweet it!](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F68%2F2014%2F2%2F13%2FCool-new-Perl-feature-postfix-dereferencing&text=Cool%20new%20Perl%20feature%3A%20postfix%20dereferencing&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F68%2F2014%2F2%2F13%2FCool-new-Perl-feature-postfix-dereferencing&via=perltricks)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
