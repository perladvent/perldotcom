{
   "authors" : [
      "david-farrell"
   ],
   "categories" : "development",
   "date" : "2013-11-25T03:28:00",
   "image" : null,
   "tags" : [
      "class",
      "object",
      "attribute",
      "method",
      "typeglob"
   ],
   "draft" : false,
   "title" : "Add Moose-style attribute accessors to your Perl classes",
   "description" : "Writing accessors in vanilla object oriented Perl doesn't have to lead to verbose boilerplate code",
   "slug" : "49/2013/11/25/Add-Moose-style-attribute-accessors-to-your-Perl-classes"
}


*Let's face it, writing attribute accessors for out-of-the-box Perl classes is repetitive and not much fun. Of course you could use [Moose]({{<mcpan "Moose" >}}) or even [Class::Accessor]({{<mcpan "Class::Accessor" >}}) to ease the burden but sometimes you want to roll your own solution, *sans* dependencies.*

### A typical class

The Point class below has two attributes (x, y) and get/set methods for each attribute written in the vanilla Perl object oriented style.

```perl
package Point;

sub new {
    my ($class, $x, $y) = @_;
    my $self = {
        x => $x,
        y => $y,
    };
    return bless $self, $class;
}

sub get_x {
    return $_[0]->{x};
}

sub set_x {
    return $_[0]->{x} = $_[1];
}

sub get_y {
    return $_[0]->{y};
}

sub set_y {
    return $_[0]->{y} = $_[1];
}

1;
```

### The alternative

Last week Rob Hoelz wrote a [fascinating post](http://hoelz.ro/blog/oh-my-glob) on Perl typeglobs, and we can use the a typeglob to help with our Point class attribute accessors. This is the updated class:

```perl
package Point;

my @attributes;
BEGIN {
    @attributes = qw/x y/;
    no strict 'refs';
    for my $accessor ( @attributes ) {
        *{$accessor} = sub {
            @_ > 1 ? $_[0]->{$accessor} = $_[1] : $_[0]->{$accessor} };
    }
}

sub new {
    my ($class, $args) = @_;
    my $self = bless {}, $class;
    for my $key ( @attributes ) {
        $self->{$key} = $args->{$key} if exists $args->{$key}
    }
    return $self;
}

1;
```

Gone are the individual get/set accessors and in their place is a BEGIN block. The block turns off strict references (for the block only) and for every attribute creates a typeglob reference to an anonymous get/set subroutine. The constructor has been updated to take a hashref of arguments ($args) and sets the values of any attribute that is found in $args.

What's nice about this approach is that adding additional attributes can be done simply by adding the attribute names to @attributes, whereas in the original Point class we would have needed to add two new methods and update the constructor method every time a new attribute was added. Additionally this approach supports the Moose-style syntax: when an argument is provided it sets the attribute value, else it gets it. E.g.

```perl
$point->x; #get x
$point->x(5); #set x to 5
```

Whilst this approach does offer faster extensibility and a nicer syntax than vanilla object oriented Perl, it's also restrictive. For example it would be difficult to add attribute-specific behavior without adding some ugly if-else code. Therefore it probably works best for scenarios involving simple classes with many attributes.

### Sources

Thanks to David Golden whose awesome [HTTP::Tiny]({{<mcpan "HTTP::Tiny" >}}) source code inspired this article.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
