{
   "date" : "2013-05-20T00:11:41",
   "slug" : "25/2013/5/20/Old-School-Object-Oriented-Perl",
   "draft" : false,
   "title" : "Old School Object Oriented Perl",
   "image" : null,
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "object_oriented",
      "old_school_perl",
      "class",
      "object",
      "attribute",
      "inheritance"
   ],
   "description" : "If you need to write object oriented Perl code with no dependencies, then you need to use the old school Perl syntax. This article describes the main features of old school object oriented Perl including class declaration, constructors, destructors, methods, attributes, accessors and inheritance.",
   "categories" : "development"
}


If you need to write object oriented Perl code with no dependencies, then you need to use the old school Perl syntax. This article describes the main features of old school object oriented Perl including class declaration, constructors, destructors, methods, attributes, accessors and inheritance.

If you want to write object oriented Perl code using modern Perl tools, consider using [Moose]({{<mcpan "Moose" >}}) for a feature rich implementation including type checking, roles and accessor methods. An alternative is [Moo]({{<mcpan "Moo" >}}) which provides a speedy, minimalist implementation of the Moose syntax, without the sugar (or the overhead) of Moose.

### Classes

A Perl class is defined in a Perl module file (\*.pm) with a package declaration. At a minimum the class must contain a constructor method and optionally can contain additional class methods and attributes. As with all Perl packages, it must return a true value (normally 1, this is placed at the end of the file). A minimal example Perl class would look like this:

```perl
# This is the package declaration
package Shape;

# This is the constructor method
sub new {
    return bless {}, shift;
}

1;
```

The example Shape class must be saved in a file called 'Shape.pm'.

### The constructor method

The constructor method is a Perl subroutine that returns an object which is an instance of the class. It is convention to name the constructor method 'new', but it can be any valid subroutine name. The constructor method works by using the [bless]({{</* perlfunc "bless" */>}}) function on a hash reference and the class name (the package name). When new is called, the package name 'Shape' is in the default array @\_ and [shift]({{</* perlfunc "shift" */>}}) is used to take the package name from @\_ and pass it to the bless function. Let's modify the constructor method to convey this behaviour more clearly:

```perl
package Shape;

sub new {
    my $class = shift;
    my $self = {};
    return bless $self, $class;
}

1;
```

This style of coding the constructor is a common pattern seen frequently in Perl code. Not only does it convey the behaviour of the code more clearly, it also allows for easy extension to $self, such as adding default attributes and / or accepting initialization arguments.

### Attributes

Essentially a Perl object is a blessed reference to a hash reference. This hash reference stores the key value pairs of data which are the object's attributes. Let's add some useful attributes to our Shape class:

```perl
package Shape;

sub new {
    my $class = shift;
    my $self = {
        color  => 'black',
        length => 1,
        width  => 1,
    };
    return bless $self, $class;
}

1;
```

The Shape class has been given color, length and width attributes. We can access these attributes by using our Shape class in a Perl program, let's call it 'Draw.pl' (it should be saved in the same directory as Shape.pm):

```perl
use strict;
use warnings;
use feature qw/say/;
use Shape;

# create a new Shape object
my $shape = Shape->new;

# print the shape object attributes
say $shape->{color};
say $shape->{length};
say $shape->{width};
```

Let's review the key lines: 'use feature qw/say/;' enables the say function which prints and appends a newline. 'use Shape;' imports the Shape class and my $shape = Shape-\>new; creates a new Shape object. Using $shape we can then access the attributes with a dereferencing arrow -\> using the attribute name encased in curly brackets and print the attributes using the say function.

### Setting attribute values using constructor arguments

At the moment Shape.pm is quite rigid; every Shape object we use will have the same color, length and width values. We can increase the flexibility of the Shape class by accepting arguments that set the values of color, length and width attributes. Let's modify the Shape.pm constructor accordingly:

```perl
package Shape;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color  => $args->{color},
        length => $args->{length},
        width  => $args->{width},
    };
    return bless $self, $class;
}

1;
```

When calling any subroutine in Perl the arguments are contained in the default array variable @\_. The Shape.pm constructor now expects a hash reference containing the attribute values in its arguments, and assigns this to $args. We can update Draw.pl to pass those arguments:

```perl
use strict;
use warnings;
use feature qw/say/;
use Shape;

# pass color, length and width arguments to the constructor
my $shape = Shape->new({
                color => 'red',
                length=> 2,
                width => 2,
            });

# print the shape object attributes
say $shape->{color};
say $shape->{length};
say $shape->{width};
```

### Creating default attribute values

Now we can create Shape objects of different colors, lengths and widths. But what if we don't pass all the arguments in our Perl program? In this case the object will initialize with those attributes as null. To avoid that, we can set default values that are overridden if the argument is present when the object is constructed. We can use the logical or operator || to achieve this effect in Shape.pm:

```perl
package Shape;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color  => $args->{color} || 'black',
        length => $args->{length} || 1,
        width  => $args->{width} || 1,
    };
    return bless $self, $class;
}

1;
```

Now we have the best of both worlds: when using Shape.pm you can optionally pass the attribute values or the Shape will be constructed with the default values. We can prove this by updating and running Draw.pl:

```perl
use strict;
use warnings;
use feature qw/say/;
use Shape;

# pass color, length and width arguments to the constructor
my $red_shape = Shape->new({
                    color => 'red',
                });
# use the default attribute values
my $black_shape = Shape->new;

say $red_shape->{color};
say $black_shape->{color};
```

In Draw.pl we initialized $red\_shape with an argument pair (color =\> red), but for $black\_shape we provided no arguments, so the color attribute defaults to black.

### Dynamically adding attributes

It is possible to insert new attributes into an object's hash reference, for example we could calculated the area of a shape using it's length and width attributes:

```perl
use strict;
use warnings;
use feature qw/say/;
use Shape;

# pass color, length and width arguments to the constructor
my $red_shape = Shape->new({
                    color => 'red',
                    length=> 2,
                    width => 2,
                });
# calculate the area of $red_shape
my $area = $red_shape->{length} * $red_shape->{width};

# insert the area attribute and value into $red_shape
$red_shape->{area} = $area;

say $red_shape->{area};
```

Now $red\_shape has the attributes: color, length, width and area.

### Methods

Methods are simply Perl subroutines that belong to a class. The Shape class already has one method, the constructor called new. Let's add a new method to Shape.pm to calculate and return the area:

```perl
package Shape;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color  => $args->{color} || 'black',
        length => $args->{length} || 1,
        width  => $args->{width} || 1,
    };
    return bless $self, $class;
}

sub get_area {
    my $self = shift;
    my $area = $self->{length} * $self->{width};
    return $area;
}

1;
```

We've added the get\_area method (it's good practice to be descriptive when naming your methods by using the verb-noun style). When an object method is called the first element of the default array @\_ will contain the package name and a reference to the object. In the get\_area method we store this argument in $self. We then dereference the length and width attributes to calculate and return $area. We can update Draw.pl to use the new area method:

```perl
use strict;
use warnings;
use feature qw/say/;
use Shape;

# pass color, length and width arguments to the constructor
my $red_shape = Shape->new({
                color => 'red',
                length=> 2,
                width => 2,
            });
# call the area method and print the value
say $red_shape->get_area;
```

### Accessor methods

Accessor methods are subroutines which access object attributes.This is better than directly dereferencing the attributes in the object's hash reference, as it leads to more readable and maintainable code (particularly if you follow the verb-noun style of naming methods). We can update Shape.pm with get and set methods for its color attribute:

```perl
package Shape;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color  => $args->{color} || 'black',
        length => $args->{length} || 1,
        width  => $args->{width} || 1,
    };
    return bless $self, $class;
}

sub get_area {
    my $self = shift;
    return $self->{length} * $self->{width};
}

sub get_color {
    my $self = shift;
    return $self->{color};
}

sub set_color {
    my ($self, $color) = @_;
    $self->{color} = $color;
}

1;
```

Let's update Draw.pl to use the new methods:

```perl
use strict;
use warnings;
use feature qw/say/;
use Shape;

# pass color argument to the constructor
my $shape = Shape->new({
                color => 'red',
            });

# print the shape color using get_color method
say $shape->get_color;

# set the shape color to blue
$shape->set_color('blue');

# print the shape color using get_color method
say $shape->get_color;
```

Using the example methods of get\_color and set\_color, it should be obvious how to write additional get and set methods for the length and width attributes.

### Builder methods

A builder method is an internal subroutine that is used to set the value of an object attribute at construction. A convention used by Perl programmers is to denote internal methods by prepending an underscore to their name. Let's add a builder method to Shape.pm that sets the creation datetime, using the [Time::Piece]({{< mcpan "Time::Piece" }}) core module:

```perl
package Shape;
use Time::Piece;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color    => $args->{color} || 'black',
        length   => $args->{length} || 1,
        width    => $args->{width} || 1,
    };
    my $object = bless $self, $class;
    $object->_set_datetime;
    return $object;
}

sub get_area {
    my $self = shift;
    return $self->{length} * $self->{width};
}

sub get_color {
    my $self = shift;
    return $self->{color};
}

sub set_color {
    my ($self, $color) = @_;
    $self->{color} = $color;
}

sub _set_datetime {
    my $self = shift;
    my $t = localtime;
    $self->{datetime} = $t->datetime;
}

sub get_datetime {
    my $self = shift;
    return $self->{datetime};
}

1;
```

The \_set\_datetime builder method is called at construction within the new method. A corresponding accessor to get the datetime has also been added. We can test this by updating Draw.pl to use it:

```perl
use strict;
use warnings;
use feature qw/say/;
use Shape;

my $shape = Shape->new;

# get datetime
say $shape->get_datetime;
```

### The destructor method

A destructor method is automatically called by Perl when all references to an object go out of scope - it is never called directly. Destructor methods are useful if the class creates temporary files or threads that must be cleaned up if the object is destroyed. They can also be useful for event logging. Perl provides a special destructor method name, 'DESTROY' that must be used when declaring a destructor.

```perl
package Shape;
use Time::Piece;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color    => $args->{color} || 'black',
        length   => $args->{length} || 1,
        width    => $args->{width} || 1,
    };
    my $object = bless $self, $class;
    $object->_set_datetime;
    return $object;
}

# The new destructor method, called automatically by Perl
sub DESTROY {
    my $self = shift;
    print "I have been garbage-collected!\n";
}

sub get_area {
    my $self = shift;
    return $self->{length} * $self->{width};
}

sub get_color {
    my $self = shift;
    return $self->{color};
}

sub set_color {
    my ($self, $color) = @_;
    $self->{color} = $color;
}

sub _set_datetime {
    my $self = shift;
    my $t = localtime;
    $self->{datetime} = $t->datetime;
}

sub get_datetime {
    my $self = shift;
    return $self->{datetime};
}

1;
```

### Inheritance

A key concept of object oriented programming is the ability to create sub-classes of existing classes. These sub-classes will inherit the methods and attributes of their parent class, which allows programmers to stay [DRY](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself) by separating re-usable generic code from specialist code.

Let's say we wanted to implement circle shape. Currently Shape.pm has length and width attributes - these work for rectangular shapes but not for circles as they require radius, diameter and circumference attributes instead. We can subclass Shape.pm to create a new Circle class that inherits the methods of Shape and implements new circle-specific functionality:

```perl
package Shape::Circle;
use parent Shape;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color    => $args->{color} || 'black',
        diameter => $args->{diameter} || 1,
    };
    my $object = bless $self, $class;
    $object->_set_datetime;
    return $object;
}

sub get_radius {
    my $self = shift;
    return $self->{diameter} * 0.5;
}

sub get_circumference {
    my $self = shift;
    return $self->{diameter} * 3.14;
}

sub get_area {
    my $self = shift;
    my $area = $self->get_radius ** 2 * 3.14;
}
1;
```

The Circle.pm file should be saved in Shape/Circle.pm. The line 'use parent Shape;' informs Perl that Circle.pm inherits from the Shape class. The Circle class has now inherited the datetime and color methods from Shape, but also provides new circle-specific methods. Note that Circle.pm also inherited the 'new' and 'get\_area' methods from Shape.pm, however it has overridden them by re-defining them in Circle.pm. Let's test Circle.pm out using Draw.pl:

```perl
use strict;
use warnings;
use feature qw/say/;
use Shape::Circle;

my $circle = Shape::Circle->new;

# get datetime - inherited method
say $circle->get_datetime;

# try new Circle methods
say $circle->get_radius;
say $circle->get_circumference;
say $circle->get_area;
```

### Wrap up

This article has explored some of the core object-oriented Perl functionality. For more information the official Perl documentation has a [OO tutorial]({{< perldoc "perlootut" >}}) and a [more detailed reference]({{< perldoc "perlobj" >}}). The definitive text on old school object oriented Perl is Damian Conway's [Object Oriented Perl](http://www.manning.com/conway/) (Manning, 1999).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
