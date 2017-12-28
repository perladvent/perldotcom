{
   "categories" : "development",
   "tags" : [
      "module",
      "object_oriented",
      "object",
      "role"
   ],
   "title" : "Use roles in object oriented Perl with Role::Tiny",
   "date" : "2013-11-11T04:48:50",
   "description" : "Get roles / traits with minimal overhead",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "slug" : "47/2013/11/11/Use-roles-in-object-oriented-Perl-with-Role--Tiny",
   "image" : null
}


Roles are a label for a set of methods that a class provides. Similar to traits in Smalltalk or an interface in Java, adding a Perl role to a class is like adding a guarantee that the class will implement that role's API. Roles are an alternative to inheritance; instead of extending a class hierarchy through subclassing, a programmer composes a class using roles for what the class does. This article describes how by using the [Role::Tiny](https://metacpan.org/pod/Role::Tiny) module you can imbue native Perl object oriented code with roles.

### Install Role::Tiny

In order to use the code examples in this article you'll need to install [Role::Tiny](https://metacpan.org/pod/Role::Tiny). You can install it via CPAN from the command line:

```perl
cpan Role::Tiny
```

### Creating a role

A role is a declared in a module file (\*.pm). Let's create a role called "Shape", which we would expect all Shape classes to implement:

```perl
package Shape;

use Role::Tiny;

requires 'getArea';

1;
```

The code starts with the usual package declaration. By importing [Role::Tiny](https://metacpan.org/pod/Role::Tiny) with the use statement, we can automatically treat this module as a role by using its package name. The "requires" function adds a requirement that any class using this role must implement a 'getArea' method.

### Using a role

Let's develop a Point class that will implement the Shape role. A point is a simple 2d shape located using an x and y value for Cartesian coordinates.

```perl
package Point;

use Role::Tiny::With;

with 'Shape';

sub new {
    my ($class, $x, $y) = @_;
    return bless {  
                  x => $x,
                  y => $y,
                 }, $class;
}

1;
```

As before the file begins with a package declaration. To be able to add roles to a class, we use "Role::Tiny::With". This imports the "with" function which is use to import roles. We've also declared a constructor method that takes an x and y coordinate as parameters to store the point's location. At this stage we have not added the "getArea" method required by the Shape role - so what would happen if we tried to create a Point object? We can test this at the command line:

```perl
perl -MPoint -we 'my $p = Point->new(5,5)'
Can't apply Shape to Point - missing getArea at /home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/lib/site_perl/5.16.3/Role/Tiny.pm line 306.
Compilation failed in require.
BEGIN failed--compilation aborted.
```

As shown above, Perl will raise an exception if a class uses a role but doesn't implement its required methods. Let's add a "getArea" method to the Point class:

```perl
package Point;

use Role::Tiny::With;

with 'Shape';

sub new {
    my ($class, $x, $y) = @_;
    return bless {
                  x => $x,
                  y => $y,
                 }, $class;
}

sub getArea { return 1 }

1;
```

The "getArea" sub returns the area of the point object (1). For other shapes such as a rectangle, "getArea" would have to calculate the area before returning it. Now that the Point class has the "getArea" method, we can create Point objects without Perl raising an exception.

### Roles can define methods

A can be more than just a list of required methods - roles can define methods which the consuming class can use, just like a subclass inherits methods from its parent class. To see this in action let's add get and set color methods to the Shape role.

```perl
package Shape;

use Role::Tiny;

requires 'getArea';

sub getColor {
    my $self = shift;
    return $self->{color} ? $self->{color} : 'none';
}

sub setColor {
    my ($self, $color) = @_;
    $self->{color} = $color;
}

1;
```

Now we can get and set the color of any Point object. We can test this at the command line:

```perl
perl -MPoint -we 'my $p = Point->new(5,5); $p->setColor("blue"); print $p->getColor'
```

### How to check if an object does a role

When a class uses a role, it also gets a boolean "does" method. This can be used to check if the class implements a specific role. For example we can quickly check for the presence of our "Shape" role in our Point class at the command line:

```perl
perl -MPoint -we 'my $p = Point->new(5,5); print $p->does("Shape")'
```

### Conclusion

Roles are a useful alternative to inheritance - they focus on what a class does rather than what it is. Using [Role::Tiny](https://metacpan.org/pod/Role::Tiny) is a nimble way to add roles to the existing Perl object oriented syntax without using an entire object system such as Moose.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
