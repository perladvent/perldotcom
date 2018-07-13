{
   "description" : "Don't waste time writing test classes, test the role directly",
   "slug" : "120/2014/10/16/How-to-test-Perl-roles-without-creating-test-classes",
   "date" : "2014-10-16T13:16:03",
   "title" : "How to test Perl roles without creating test classes",
   "categories" : "development",
   "image" : null,
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "object",
      "test_more",
      "role_tiny",
      "unit",
      "mock",
      "fake",
      "role_basic",
      "bless",
      "sub"
   ]
}


Recently I've been working on a [game engine](https://github.com/sillymoose/March) which uses a composition pattern for its actors. I'm using [Role::Tiny]({{<mcpan "Role::Tiny" >}}) to create the roles. Role::Tiny is really convenient as it lets you use roles with native OO Perl, without committing to a whole object system like Moose. A typical role looks like this:

```perl
package March::Attribute::Id;
use 5.020;
use Role::Tiny;
use feature 'signatures';
no warnings 'experimental';

sub id ($self)
{
    $self->{id};
}

1;
```

All this role does is return the id attribute of the consuming class (yes I'm using [signatures](http://perltricks.com/article/72/2014/2/24/Perl-levels-up-with-native-subroutine-signatures) throughout). I wanted to write unit tests for this role, but I didn't want to a create test class to test the role. So how do you construct an object from a package that has no constructor? The answer is by using `bless` in your test file:

```perl
use strict;
use warnings;
use Test::More;

my $self = bless { id => 5 }, 'March::Attribute::Id';

BEGIN { use_ok 'March::Attribute::Id' }

is $self->id, 5, 'id()';

done_testing();
```

This code creates an object called `$self` by blessing a hashref with the package name of the role that I want to test. It adds a key value pair for the id attribute, and then tests that the role's id method returns the correct id value. I can execute the tests using `prove`:

```perl
$ prove -vl t/Attribute/Id.t 
t/Attribute/Id.t .. 
ok 1 - use March::Attribute::Id;
ok 2 - id()
1..2
ok
All tests successful.
Files=1, Tests=2,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.02 cusr  0.00 csys =  0.04 CPU)
Result: PASS
```

This is another role I want to test:

```perl
package March::Attribute::Direction;
use 5.020;
use Role::Tiny;
use feature 'signatures';
no warnings 'experimental';
use March::Game;
use March::Msg;

requires 'id';

sub direction ($self, $new_direction = 0)
{
    if ($new_direction && $new_direction->isa('Math::Shape::Vector'))
    {
        $self->{direction} = $new_direction;

        # publish direction to game queue
        March::Game->publish(
            March::Msg->new(__PACKAGE__, $self->id, $new_direction)
        );
    }
    $self->{direction};
}

1;
```

This role gets and sets the direction vector for the consuming class. The challenge with testing this role is that it requires the consuming class to implement an `id` method. Role::Tiny's `requires` function is a great way to ensure that the consuming class meets the requirements of the role. But how do we test it without creating a real class with an `id` sub? What I do is declare the required sub in the test file:

```perl
use strict;
use warnings;
use Test::More;
use Math::Shape::Vector;

# create an object
my $self = bless { direction => Math::Shape::Vector->new(1, 2) 
                  }, 'March::Attribute::Direction';

# add required sub
sub March::Attribute::Direction::id { 107 };

BEGIN { use_ok 'March::Attribute::Direction' }

is $self->direction->{x}, 1, 'Check direction x is 1';
is $self->direction->{y}, 2, 'Check direction y is 2';
ok $self->direction( Math::Shape::Vector->new(1, 0) ),
    'Update direction to new vector';
is $self->direction->{x}, 1, 'Check direction x is still 1';
is $self->direction->{y}, 0, 'Check direction y is now 0';

done_testing();
```

The magic line is `sub March::Attribute::Direction::id { 107 };` which adds the sub to the role I'm testing (it just returns the value 107). Now I can test the `direction` method, again using `prove`:

```perl
$ prove -lv t/Attribute/Direction.t 
t/Attribute/Direction.t .. 
ok 1 - use March::Attribute::Direction;
ok 2 - Check direction
ok 3 - Check direction
ok 4 - Update direction to new vector
ok 5 - Check direction
ok 6 - Check direction
1..6
ok
All tests successful.
Files=1, Tests=6,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.08 cusr  0.00 csys =  0.10 CPU)
Result: PASS
```

### It's not all gravy

One drawback I've encountered with this approach can be seen with the following role and test file:

```perl
package Data::Inspector;
use Role::Tiny;

sub inspect_data
{
    my ($self, $data);
    Data::Dumper->Dump(['Inspecting:', $data]);
}

1;
```

This role has a method called `inspect_data` which simply returns a dump of any data reference pass to it. This is the test file:

```perl
use Test::More;
use Data::Dumper;

my $self = bless {}, 'Data::Inspector';

BEGIN { use_ok 'Data::Inspector' } 

ok $self->inspect_data({ test => 'data' });

done_testing();
```

As before I bless the role in the test file and then proceed to test the `inspect_data` method. This test file runs and all the tests pass. Can you spot this issue here? Notice that the Data::Inspector role uses [Data::Dumper's]({{<mcpan "Data::Dumper" >}}) `Dump` method, but it doesn't load the Data::Dumper module, the test file does! This is a problem as when the Data::Inspector role is used elsewhere in real code, it will crash and burn when it doesn't find Data::Dumper loaded in memory.

### Conclusion

With this project I intend to create a lot of simple roles, so this approach provides a lightweight way for me to test roles within the test file without creating test classes for every role.

I really like [Role::Tiny]({{<mcpan "Role::Tiny" >}}). It's flexible: you can create minimalist trait-like behavior or go further and create mixins (roles which modify state). It has nice features like auto-enabling strict and warnings, method modifiers and good [documentation]({{<mcpan "Role::Tiny" >}}). [Role::Basic]({{<mcpan "Role::Basic" >}}) is another lightweight roles module that supports traits only (by [design]({{<mcpan "Role::Basic#DESIGN-GOALS-AND-LIMITATIONS" >}})). I wonder if I'll come to regret using a mixin approach as I get further into development of the game engine.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
