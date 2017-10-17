{
   "description" : "Perl's flexible syntax accepts all kinds of shenanigans and hackery. This article describes one such trick to call object methods without including the referent object (sort of).",
   "draft" : false,
   "date" : "2013-08-03T17:56:03",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "development",
   "title" : "Call object methods without an object reference",
   "slug" : "35/2013/8/3/Call-object-methods-without-an-object-reference",
   "tags" : [
      "object_oriented",
      "object",
      "method",
      "wizardry",
      "old_site"
   ],
   "image" : null
}


Perl's flexible syntax accepts all kinds of shenanigans and hackery. This article describes one such trick to call object methods without including the referent object (sort of).

### Preamble

Imagine we have a class call Boomerang with a single method, throw. The code looks like this:

``` prettyprint
package Boomerang;
use strict;
use warnings;
use feature qw/say/;

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub throw {
    my ($self, $url) = @_;
    say 'I flew ' . int(rand(500)) . ' feet!';
    return $self;
}

1;
```

To use the Boomerang class and throw method, we have a script called throw.pl:

``` prettyprint
use Boomerang;
use strict;
use warnings;

my $stick = Boomerang->new;
$stick->throw;
$stick->throw; 
$stick->throw;
```

The code in throw.pl shown above creates a new Boomerang object called $stick. It then calls the throw method on $stick three times. All throw does is print a statement declaring how many feet (a random integer) the Boomerang was thrown. Running throw.pl gives us this output:

``` prettyprint
perl throw.pl
I flew 230 feet!
I flew 17 feet!
I flew 31 feet!
```

### Removing the object reference (sort of)

Let's update throw.pl to remove the object reference altogether:

``` prettyprint
use Boomerang;
use strict;
use warnings;

Boomerang->new
    ->throw
    ->throw
    ->throw;
```

Running throw.pl gives the same output as previously:

``` prettyprint
perl throw.pl
I flew 36 feet!
I flew 25 feet!
I flew 372 feet!
```

So **why** does this code work? It works because of several conditions:

-   Boomerang's new and throw methods return the object $self - just like a Boomerang :).
-   Perl allows multi-line statements.
-   Perl's precedence runs from left to right on method calls.

If you're still not clear why this code works, consider that another way to write the same code in throw.pl would be like this:

``` prettyprint
use Boomerang;
use strict;
use warnings;

Boomerang->new->throw->throw->throw;
```

### What is this good for?

Admittedly this style of writing method calls can lead to reduced readability and will only work on method calls that return $self. However one use of this technique was shown by Eric Johnson at YAPC::EU 2012. He developed a Selenium test class which allowed non-Perl programmers to write test cases using this method. His talk is on [youtube](http://www.youtube.com/watch?v=9eQJnyocMuQ).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
