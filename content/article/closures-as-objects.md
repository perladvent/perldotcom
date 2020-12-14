
  {
    "title"       : "Closures as objects",
    "authors"     : ["david-farrell"],
    "date"        : "2020-12-13T12:57:03",
    "tags"        : ["closure", "lisp", "moose", "metaobject-protocol","object-oriented"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "How lexical scope and anonymous functions can create powerful object systems",
    "categories"  : "programming-languages"
  }

Perl's object system is not one of its most admired qualities. Included in the 1993 Perl 5.0 release, objects were a bolt-on. A big improvement at the time, in today's context the Perl 5 object system requires too much boilerplate and is under-powered compared to other language offerings (no private state, no type checking, no traits, no multimethods). Perl programmers have been trying to upgrade it for years ([Cor](https://gist.github.com/Ovid/68b33259cb81c01f9a51612c7a294ede) is a recent example).

Combining a few concepts can lead to great power; 60 years ago in the [LISP Programmer's Manual](https://mitpress.mit.edu/books/lisp-15-programmers-manual) John McCarthy showed how a Lisp interpreter could be created from simple parsing rules, a few types and just five (!) elementary functions.

Two things Perl 5 got right was its lexical scoping rules and support for anonymous functions ("lambdas"). Combine those features and you can make closures. And just what are closures good for? Well it turns out they're pretty damn powerful; powerful enough, in fact to make a better object system than Perl's built-in offering.

Private state
-------------
Perl objects are "blessed" data structures, which means data plus its package subroutines. Here's a `Point` class:

```perl
package Point;

sub new {
  my ($class, $x, $y) = @_;
  return bless { x => $x, y => $y }, $class;
}

sub x { $_[0]->{x} }

sub y { $_[0]->{y} }

sub to_string {
  my $self = shift;
  return sprintf 'x: %d, y: %d', $self->x, $self->y;
}
```

The `new` subroutine is (by convention) the object constructor method. It accepts x y coordinates, and blesses a hashref of that data into a Point object. This associates all the subroutines in the package `Point` with the object (`x`, `y`, `to_string` and oops! it gets `new` as well). As a Point object is just a hashref, any consuming code is able to modify the object data directly, even if no setter method was provided:

```perl
my $p = Point->new(3, 10);
$p->{x} = 5; # methods schmethods
```
Score one for convenience, strike one for (lack of) encapsulation. Here's the same Point class, implemented using a closure:

```perl
package Point;

sub new {
  my ($class, $x, $y) = @_;
  my %methods = (
    to_string => sub { "x: $x, y: $y" },
    x         => sub { $x },
    y         => sub { $y },
  );
  sub {
    my $method_name = shift;
    $methods{$method_name}->(__SUB__, @_);
  };
}
```

In this case `new` returns an anonymous function which performs the method resolution itself. Because the x and y coordinates are copied into the scope of the anonymous function, it has "closed over" the lexical environment and calling code has no way of altering those variables without using its public interface:

```perl
my $p = Point->new(1, 5);
say $p->('x'); # 1
say $p->('y'); # 5
say $p->('to_string'); # x: 1, y: 5
```
As its constructor does not provide any setter methods, its x y coordinates cannot change. It is immutable. The object also does not get its package subroutines, i.e. it has no `new` method, which stays where it belongs, in the Point package.

Making it re-usable
--------------------
So far so good. But what if I wanted to make other classes which work in the same way? If I have to copy-and-paste this pattern around, it's not buying me much. Instead I'm going to introduce a new package which builds classes:

```perl
package Class::Lambda;

sub new_class {
  my ($class_name, $properties, $methods) = @_;

  my $class_methods = {
    properties => sub { %$properties },
    methods    => sub { %$methods },
    name       => sub { $class_name },
    new        => sub {
      my $class = $_[0];
      my %self;
      %self = (%$properties,
               %{$_[1]},
               self => sub {
                         my $method_name = shift;
                         $methods->{$method_name}->(\%self, @_);
                       });
      $self{self};
    },
  };
  my $class = sub {
    my ($method_name) = shift;
    $class_methods->{$method_name}->(__SUB__, @_);
  };
  $methods->{class} = sub { $class };
  $class;
}
```

The `new_class` subroutine takes a class name, a hashref of properties for object state (name and default value), and a hashref of methods (method name and anonymous subroutine). It returns a function object class, which uses the same method dispatch mechanism as before. I've omitted error checks for brevity.

The class objects have some useful methods for inspecting them: `properties` returns the object properties and their default values, `methods` returns the object methods, `name` returns the class name, and `new` creates a new instance of the class. It also injects a `class` method into every object which returns itself (e.g. given a function object, you can call its `class` method to get its class object). With these methods, our class objects have no need for Perl's built-in object toolset of packages, [bless]({{< perlfunc "bless" >}}), and [UNIVERSAL]({{< perldoc "UNIVERSAL" >}}).

The Point class compresses nicely:

```perl
my $class_point = Class::Lambda::new_class(
  'Point',
  {
    x => undef,
    y => undef,
  },
  {
    x => sub { $_[0]->{x} },
    y => sub { $_[0]->{y} >}});
```

One wrinkle here is the naive copying of constructor args into the object state. If the args themselves contain references, the caller could change the state of the references without using the object's interface (assuming they retained a reference to the data). To prevent that the code could be updated to deep-copy any references that have a refcount greater than 1.

Inheritance
-----------
This wouldn't be much of an object system if it didn't support inheritance. I've extended the `new_class` subroutine:

```perl
sub new_class {
  my ($class_name, $properties, $methods, $superclass) = @_;

  my $class_methods = {
    superclass => sub { $superclass },
    properties => sub { %$properties },
    subclass   => sub {
      my ($superclass, $class_name, $properties, $methods) = @_;
      $properties   = { $superclass->('properties'), %$properties };
      $methods      = {
      # prevent changes to subclass method changing the super
      (map { ref $_ ? _clone_method($_) : $_ } $superclass->('methods')),
      %$methods };
      new_class($class_name, $properties, $methods, $superclass);
    },
    methods      => sub { %$methods },
    name         => sub { $class_name },
    new          => sub {
      my $class = $_[0];
      my %self;
      %self = (%$properties,
               %{$_[1]},
               self => sub {
                         my $method_name = shift;
                         $methods->{$method_name}->(\%self, @_);
                       });
      $self{self};
    },
  };
  my $class = sub {
    my ($method_name) = shift;
    $class_methods->{$method_name}->(__SUB__, @_);
  };
  $methods->{class} = sub { $class };
  $class;
}

sub _clone_method {
  my $sub = shift;
  sub { goto $sub };
}
```

It now accepts an optional superclass argument. I've also added two new methods to call on the class object: `superclass` returns the superclass object and `subclass` accepts similar arguments to `new_class` and creates a new class built with the current class properties and methods and its arguments. Because it uses list-flattening to combine the key/value pairs of properties and methods, and because the superclass data is listed first, the subclass specification always override the superclass.

Superclass methods are copied using `_clone_method` to prevent method re-definition also redefining the superclass method. For now I've accomplished this with [goto]({{< perlfunc "goto" >}}); every subclass adds a new layer of indirection. This could be implemented in XS to avoid the indirection cost; [Sub::Clone]({{< mcpan "Sub::Clone" >}}) does this, but it doesn't work on [v5.18 or higher](http://matrix.cpantesters.org/?dist=Sub-Clone+0.03) (I guess the Perl interpreter internals changed and it needs an update).

Here's a subclass of Point which in addition to storing x y coordinates, accepts a "z" value, to store a point in 3d coordinates. It overrides `to_string` to include the new value:

```perl
my $class_point3d = $class_point->('subclass',
  'Point3D',
  { z => undef },
  {
    to_string => sub { "x: $_[0]->{x}, y: $_[0]->{y}, z: $_[0]->{z}" },
    z         => sub { shift->{z} },
  });
```

Traits
------
Single inheritance is quite limited; I could add support for multiple inheritance by accepting an arrayref of superclasses, and making method resolution more sophisticated. Instead I'm going to support traits which avoid the complexity of multiple inheritance and allow class behavior to be extended in a more flexible way:

First I'll add support for creating new traits:

```perl
sub new_trait {
  my ($trait_name, $methods, $requires) = @_;
  my $trait_methods = {
    requires => sub { @$requires },
    methods  => sub { %$methods },
    name     => sub { $trait_name },
  };
  sub {
    my $method_name = shift;
    $trait_methods->{$method_name}->();
  };
}
```

This is implemented as the (what should be familiar by now) function object pattern. Every trait object has 3 methods: `requires` returns a list of required method names, `methods` key/value pairs of method names and anonymous subroutines, and `name` to return the trait's name.

Classes can be composed with traits using the `compose` method, which looks like this:

```perl
sub new_class {
  my ($class_name, $properties, $methods, $superclass) = @_;
  my $traits = [];

  my $class_methods = {
    ...
    compose    => sub {
      my ($class, @traits) = @_;
      for my $t (@traits) {
        next if $class->('does', $t->('name'));
        my @missing = grep { !$methods->{$_} } $t->('requires');
        die sprintf('Cannot compose %s as %s is missing: %s',
          $t->('name'), $class_name, join ',', @missing) if @missing;
        my %trait_methods = $t->('methods');
        for my $m (keys %trait_methods) {
          next if exists $methods->{$m}; # clashing methods are excluded
          # prevent changes to composed class method changing the trait
          $methods->{$m} = _clone_method($trait_methods{$m});
        }
        push @$traits, $t;
      }
    },
    traits     => sub { @$traits },
    does       => sub {
                    my ($class, $trait_name) = @_;
                    grep { $trait_name eq $_->('name') } @$traits;
                  },
    ...
```

This isn't a precise implementation of traits; in the original [paper](http://web.cecs.pdx.edu/~black/publications/TR_CSE_02-012.pdf) traits are not given access to the state of the object (except via its methods). That would require storing trait methods in a separate hashref, not passing the object state as an argument when the methods are called, and updating method dispatch to include searching the object's trait methods hashref.

Metamethods
-----------
Whereas methods are concerned with object state, metamethods deal with object *structure*. Because function objects control their method dispatch, it's trivial to modify dispatch to support metamethods like `before` and `after` which run code before or after a method is called:

```perl
sub new_class {
  my ($class_name, $properties, $methods, $superclass) = @_;
  my $traits = [];

  my $class_methods = {
    ...
    before       => sub {
                      my ($class, $method_name, $sub) = @_;
                      my $original_method = $methods->{$method_name};
                      $methods->{$method_name} = sub {
                        my $self = shift;
                        my @args = $sub->($self, @_);
                        $original_method->($self, @args);
                      >}},
    after        => sub {
                      my ($class, $method_name, $sub) = @_;
                      my $original_method = $methods->{$method_name};
                      $methods->{$method_name} = sub {
                        my @results = $original_method->(@_);
                        $sub->($_[0], @results);
                      >}},
    ...
```

Whilst this works, it feels like the code is starting to get unwieldy. What I really need is a [Metaobject Protocol](https://en.wikipedia.org/wiki/Metaobject#Metaobject_protocol). Instead of defining methods in a hashref of anonymous functions, I could have a "make_method" metamethod, which registers a new method in a class. Method registration would provide the opportunity to do things like multiple-dispatch; that is, a class could have several methods with the same name, dispatched to based on the arguments received at runtime (aka [multimethods](https://en.wikipedia.org/wiki/Multiple_dispatch)). This is one way of solving the [Expression Problem](https://craftinginterpreters.com/representing-code.html#the-expression-problem).

Speed
-----
By this point you might be wondering how fast function objects are; I ran some [benchmarks](https://github.com/dnmfarrell/Class-Lambda/blob/master/bench/run.pl) to compare built-in OO, Moose and Class::Lambda objects. These show that function objects are at least _in the ballpark_ of acceptable performance for construction, get and set methods. Once you add type constraints, error checking and deep-copies of arguments (Moose deep-copies its args), I don't think these differences would matter in most cases. For example if I add `isa => 'Int'` to the Moose Point class's x property, its setter benchmark is ~4x slower.

                     Rate   moose-new  lambda-new builtin-new
    moose-new    714757/s          --        -13%        -64%
    lambda-new   817247/s         14%          --        -59%
    builtin-new 2012803/s        182%        146%          --
                      Rate  lambda-get   moose-get builtin-get
    lambda-get   5804047/s          --        -46%        -61%
    moose-get   10789651/s         86%          --        -27%
    builtin-get 14813317/s        155%         37%          --
                     Rate  lambda-set builtin-set   moose-set
    lambda-set  4272114/s          --        -46%        -46%
    builtin-set 7855213/s         84%          --         -0%
    moose-set   7886981/s         85%          0%          --

Point function objects did use about 3x more memory than their built-in and Moose style equivalents on my computer: 812 bytes compared to 266 bytes (I was surprised to find simple Moose objects are as memory efficient as built-in ones). This is because function objects carry around more data, but also because closures require more Perl internal data structures. I could save memory by not copying every class instance method as a key/value pair into every object, and resolve method calls with a recursive search of the object's class hierarchy instead. This trades memory for speed though.

Future
------
I've uploaded this proof-of-concept to [GitHub](https://github.com/dnmfarrell/Class-Lambda). If you're interested in learning more about metaobjects, [The Art of the Metaobject Protocol](https://mitpress.mit.edu/books/art-metaobject-protocol) is the definitive reference. For what it's worth, [Moose]({{< mcpan "Moose" >}}) is Metaobject Protocol aware, battle-tested and remains the classiest (har) object system available for Perl today.

Perl's evolution into a kitchen-sink of capabilities provides many tools: some powerful, some mediocre. The question is, where do we go from here? I'm not convinced "more OO" is the right direction for Perl; the language is already huge, the interpreter a byzantine labyrinth of C macros, and Ruby cornered the market for expressive, object-oriented dynamic languages long-ago.

One way to fight the bloat would be to distill the role of the Perl interpreter down to fewer, more powerful ideas. Objects are more powerful than subroutines, and a Metaobject Protocol more profound still. Yet beneath that, lexical scoping and a thoughtful type system could power them all<sup>†</sup>.

\

---

<sup>†</sup> Doug Hoyte writes in [Let Over Lambda](https://letoverlambda.com/index.cl/guest/chap2.html#sec_7): "Let and lambda are fundamental; objects and classes are derivatives."

