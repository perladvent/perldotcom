
  {
    "title"  : "Untangling subroutine attributes",
    "authors": ["david-farrell"],
    "date"   : "2016-06-29T08:37:20",
    "tags"   : ["attributes", "symbol_table", "typeglob", "lvalue"],
    "draft"  : false,
    "image"  : "",
    "description" : "How they work and how to implement your own custom versions",
    "categories": "development"
  }

Subroutine attributes are optional labels that can be included in a subroutine declaration. They're a curious feature with a clunky interface and minimal documentation. They seem underused, but it's hard to think of legitimate uses for them. In my opinion the coolest thing about subroutine attributes is that they run at compile time. This means you can execute custom code before the main program is run, and seeing as Perl gives you access to the symbol table, you can basically do wizardy things.

### The lvalue trick

Perl has several subroutine attributes built-in. A useful one is `lvalue` which tells Perl that the subroutine refers to a variable that persists beyond individual calls. A common case is using them as method getter/setters:

```perl
package Foo;

sub new { bless {}, shift }

sub bar :lvalue {
  my $self = shift;

  # must return the variable for lvalue-ness
  $self->{bar};
}

package main;

my $foo = Foo->new();

$foo->bar = "dogma"; # not $foo->bar("dogma");
print $foo->bar;
```

By adding the attribute `:lvalue` to the `bar` subroutine, I can use it like a variable, getting, setting and substituting and so on.

### Custom attributes

To use custom attributes in a package, you must provide a subroutine called `MODIFY_CODE_ATTRIBUTES`. Perl will call this subroutine during compilation if it find any custom subroutine attributes. It's called once for every subroutine with custom attributes. `MODIFY_CODE_ATTRIBUTES` receives the package name, a coderef to the subroutine and a list of the attributes it declared:


```perl
package Sub::Attributes;

sub MODIFY_CODE_ATTRIBUTES {
  my ($package, $coderef, @attributes) = @_;
  return ();
}

sub _internal_function :Private {
  ...
}
1;
```

I've created a new package with the required subroutine - all it does is return an empty list. I've then declared an empty subroutine called `_internal_function` which has a custom attribute, `Private`. I want to do the impossible and create truly private subroutines in Perl by making any subroutine with the `Private` attribute only callable by its own package. But what if I misspell `Private`?  If we received any attributes we didn't recognize, `MODIFY_CODE_ATTRIBUTES` can add them to a list and Perl will throw a compile time error:

```perl
package Sub::Attributes;

sub MODIFY_CODE_ATTRIBUTES {
  my ($package, $coderef, @attributes, @disallowed) = @_;

  push @disallowed, grep { $_ ne 'Private' } @attributes;

  return @disallowed;
}

sub _internal_function :Private {
  ...
}
1;
```

I've updated to code to declare and return `@disallowed` - an array of any unrecognized subroutine attributes. Even though it's declared in the first line of the subroutine, it will always be empty because `@attributes` gobbles up all remaining arguments passed to the subroutine. Next I grep through the list of attributes received and if any don't match "Private", I add them to the disallowed array.

### Adding compile time behavior

Now any subroutine in the package can use the attribute `Private` but it doesn't do anything. I need to add some behavior!

```perl
package Sub::Attributes;
use B 'svref_2object';

sub MODIFY_CODE_ATTRIBUTES {
  my ($package, $coderef, @attributes, @disallowed) = @_;

  my $subroutine_name = svref_2object($coderef)->GV->NAME;

  my %allowed = (
    Private => sub {
        my ($coderef, @args) = @_;
        my ($calling_package, $filename, $line, $sub) = caller(2);
        croak 'Only the object may call this sub' unless $sub && $sub =~ /^Sub\:\:Attributes\:\:/;
        $coderef->(@args);
      },
  );

  for my $attribute (@attributes) {
    # parse the attribute into name and value

    # attribute not known, compile error
    push(@disallowed, $attribute) && next unless exists $allowed{$attribute};

    # override subroutine with attribute coderef
    my $overrider = $allowed{$attribute};
    my $old_coderef = $coderef;
    $coderef = sub { $overrider->($old_coderef, @_) };
    *{"Sub:\:Attributes:\:$subroutine_name"} = $coderef;
  }
  return @disallowed;
}

sub _internal_function :Private {
  ...
}

sub call_internal_function {
  _internal_function();
}
1;
```

This code imports the `svref_2object` function from the [B]({{<mcpan "B" >}}) module. This handy function takes a reference and returns an object with the data from Perl's internals. In this case, passing a coderef returns a [B::CV]({{<mcpan "B#B::CV-Methods" >}}) object. I use this to get the subroutine name and overrride the subroutine later.

I've created a hash called `%allowed` which is where I can declare any permitted custom attributes and their associated code. For `Private` I made a coderef that checks the caller is in the same package and croaks if it's not, else it will call it.

Next I loop through any attributes received, and check they exist in `%attributes`. If they don't, I push them into `@disallowed` and skip to the next attribute. If the attribute does exist, I assign the coderef to `$overrider` and declare a new coderef which will call `$overrider` passing the old coderef to be called.

Finally I override the `Private` subroutine with the new coderef:

    *{"Sub:\:Attributes:\:$subroutine_name"} = $coderef;

This is how you override subroutines using a [typeglob]({{< perldoc "perldata" "Typeglobs-and-Filehandles" >}}) ([Mastering Perl](https://www.amazon.com/Mastering-Perl-brian-d-foy/dp/144939311X/) has a whole chapter dedicated to features like these, highly recommended). But what about that backslash in the middle of the colons `:\:`?. That escape is necessary for the code to run on Perl versions 5.16 through 5.18 (thanks to Andreas König for debugging this).

If you're wondering why I bothered to create `$old_coderef` at all, it's so that a subroutine can have multiple attributes with new behaviors nested inside each other.

Now any calls to `_internal_function` will croak unless they come from within Sub::Attributes:

```perl
use Sub::Attributes;

Sub::Attributes::call_internal_function(); # ok
Sub::Attributes::_internal_function(); # croak!
```

### Making it re-useable

If it seems dumb to create custom attributes and then elsewhere in the same code, validate those attributes, join the club. To get the most out of this system, you have to make your custom attributes re-usable. Fortunately, just a few changes are needed:

```perl
package Sub::Attributes;
use B 'svref_2object';

sub MODIFY_CODE_ATTRIBUTES {
  my ($package, $coderef, @attributes, @disallowed) = @_;

  my $subroutine_name = svref_2object($coderef)->GV->NAME;

  my %allowed = (
    Private =>
      sub {
        my $package = shift;
        return sub {
          my ($coderef, @args) = @_;
          my ($calling_package, $filename, $line, $sub) = caller(2);
          croak 'Only the object may call this sub' unless $sub && $sub =~ /^$package\:\:/;
          $coderef->(@args);
        }
      },
  );

  for my $attribute (@attributes) {
    # parse the attribute into name and value

    # attribute not known, compile error
    push(@disallowed, $attribute) && next unless exists $allowed{$attribute};

    # execute compile time code
    my $overrider = $allowed{$attribute}->($package);
    next unless $overrider;

    # override the subroutine if necessary
    my $old_coderef = $coderef;
    $coderef = sub { $overrider->($old_coderef, @_) };
    *{"$package:\:$subroutine_name"} = $coderef;
  }

  $Sub::Attributes::attributes{$package}{$subroutine_name} = \@attributes;
  return @disallowed;
};
1;
```

Rather than hardcoding the package name, I've made it dynamic. The key change here is that the coderef for `Private` has been changed to a coderef that returns another coderef. Now I can execute some arbitrary code at compile time and optionally manufacture a new coderef that uses compile time information. In the case of `Private`, I want to pass the package name of the private subroutine, so I can check later that the caller is from within the same package.

Why optionally return a coderef? Imagine if I created an attribute called `After` which behaved like the `after` function in [Class::Method::Modifiers]({{<mcpan "Class::Method::Modifiers" >}}). In this case the subroutine with the private attribute would be reference a _different_ subroutine. That might look like this:

```perl
sub foo { }

sub logger :After(foo) {
  print "foo() was called!\n";
}
```

Here `logger` should be executed after `foo`. So logger itself never changes, and doesn't need to be overridden.

I store the attributes for a subroutine under the package name in the symbol table for `Sub::Attributes`. I could add them to the package's symbol table, but I might inadvertently overwrite something else, so I keep the data within the `Sub::Attributes` namespace.

  $Sub::Attributes::attributes{$package}{$subroutine_name} = \@attributes;


### Why no FETCH_CODE_ATTRIBUTES?

The `attribute` [docs]({{< perldoc "attributes" >}}) mention another subroutine, called `FETCH_CODE_ATTRIBUTES` that given a coderef, should return the attributes for the referenced subroutine. When `attributes::get` is called, it passes the class of the declaring package, which is `Sub::Attributes`:

```perl
# $class == "Sub::Attributes"
sub FETCH_CODE_ATTRIBUTES {
  my ($class, $coderef) = @_;
  my $cv = svref_2object($coderef);
  # $class should be subclass name, not Sub::Attributes
  return @{$Sub::Attributes::attributes{$class}{ $cv->GV->NAME }};
}
```

I don't see a way to find out the package name of the original subroutine. `FETCH_CODE_ATTRIBUTTES` is not required and if it's not there Perl won't throw an exception if `attributes::get` is called. Instead I provided the `sub_attributes` method which does work:

```perl
sub sub_attributes {
  my ($package) = @_;
  my $class_name = ref $package || $package;
  return $Sub::Attributes::attributes{ $class_name };
}
```

This returns the attributes stored for a package. This might be useful if other packages want to inspect the attributes for a package's subroutine. it can be called as an object method or class method:

```perl
package Foo;
use base 'Sub::Attributes';

...

Foo->sub_attributes(); # works
$foo->sub_attributes(); # works also
```

### Squashing warnings

It's generally good practice to use the `strict` and `warnings` pragmas to help detect issues with our code. However the code so far will emit some warnings and an exception if we add those pragmas as-is. This code will add the pragmas but make Perl ignore the violations:

```perl
use strict;
no strict 'refs';
use warnings;
no warnings qw(reserved redefine);
```

The `reserved` warning is of particular interest here. This would be caused by using custom subroutine attributes, so no matter what, you'd want to turn that off. Redefine is a warning emitted whenever a subroutine is over-written, strict references means no interpolating of variable names in symbol table lookups; we need these features so we can dynamically patch subroutines like this:

    *{"$class:\:$subroutine"} = $coderef

### Making it extensible

If you've gone to the hard work of setting up the code for inheritable custom attributes, why not make it extensible? That way consuming packages can add their own custom attributes.

```perl
package Sub::Attributes;
use strict;
no strict 'refs';
use warnings;
no warnings qw(reserved redefine);

use B 'svref_2object';

BEGIN {
  our %allowed = (
    Private =>
      sub {
        my $package = shift;
        return sub {
          my ($coderef, @args) = @_;
          my ($calling_package, $filename, $line, $sub) = caller(2);
          croak 'Only the object may call this sub' unless $sub && $sub =~ /^$package\:\:/;
          $coderef->(@args);
        }
      },
    # compile time override, run a coderef after running the subroutine
    After => sub {
      my ($package, $value, $coderef) = @_;

      # full name of the sub to override
      my $fq_sub = "$package:\:$value";

      my $target_coderef = \&{$fq_sub};
      *{$fq_sub} = sub {
        my @rv = $target_coderef->(@_);
        $coderef->(@_);
        return wantarray ? @rv : $rv[0];
      };

      # we didn't change the method with the attribute
      # so we return undef as we have no runtime changes
      return undef;
    },
  );
}

sub MODIFY_CODE_ATTRIBUTES {
  my ($package, $coderef, @attributes, @disallowed) = @_;

  my $subroutine_name = svref_2object($coderef)->GV->NAME;

  for my $attribute (@attributes) {
    # parse the attribute into name and value
    my ($name, $value) = $attribute =~ qr/^ (\w+) (?:\((\S+?)\))? $/x;

    # attribute not known, compile error
    push(@disallowed, $name) && next unless exists $Sub::Attributes::allowed{$name};

    # execute compile time code
    my $overrider = $Sub::Attributes::allowed{$name}->($package, $value, $coderef);
    next unless $overrider;

    # override the subroutine if necessary
    my $old_coderef = $coderef;
    $coderef = sub { $overrider->($old_coderef, @_) };
    *{"$package:\:$subroutine_name"} = $coderef;
  }

  $Sub::Attributes::attributes{$package}{$subroutine_name} = \@attributes;
  return @disallowed;
};

sub sub_attributes {
  my ($package) = @_;
  my $class_name = ref $package || $package;
  return $Sub::Attributes::attributes{ $class_name };
}
1;
```

I've moved the `%allowed` hash into a `BEGIN` block - this has to be declared at compile time so it's available for `MODIFY_CODE_ATTRIBUTES`. Now new custom attributes can be added by modifying `%Sub::Attributes::attributes`. I also added a new custom attribute `After` which implements causes the subroutine to be called after another one, like this:

```perl
sub foo { }

sub bar :After(foo) {
  print "foo() was called!\n";
}
```

I added a regex which captures the attribute name and value when passing attributes (so for `After(foo)` "After" is the name and "foo" is the value). The `$value` and `$coderef` are now passed to the custom attribute's subroutine to allow compile-time overrides of other subroutines.

### Resources

* [attributes]({{< perldoc "attributes" >}}) is the official documentation on attributes.
* [Sub::Attributes]({{<mcpan "Sub::Attributes" >}}) is my module which implements the above code, and adds a few more custom attributes.
* [perldata]({{< perldoc "perldata" "Typeglobs-and-Filehandles" >}}) has an entry on typeglobs and the symbol table.
* Chapters 7 & 8 of [Mastering Perl](https://www.amazon.com/Mastering-Perl-brian-d-foy/dp/144939311X/) second edition cover the symbol table and overrriding subroutines in detail.
* [perlsub]({{< perldoc "perlsub" >}}) has information on lvalue subroutines.
* Two useful blog posts by mascip on [possible uses](http://blogs.perl.org/users/mascip/2014/02/subroutine-attributes-how-to-use-them-and-what-for.html) and [when to use](http://blogs.perl.org/users/mascip/2014/02/three-ways-to-introduce-othogonal-behavior-aspects-method-modifiers-and-subroutine-attributes.html) subroutine attributes.
* [Attribute::Handlers]({{<mcpan "Attribute::Handlers" >}}) provides a mechanism for calling subroutines via attributes.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
