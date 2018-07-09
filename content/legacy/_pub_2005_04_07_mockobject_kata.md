{
   "date" : "2005-04-07T00:00:00-08:00",
   "categories" : "testing",
   "image" : null,
   "title" : "Perl Code Kata: Mocking Objects",
   "tags" : [
      "mock-objects",
      "perl-code-kata",
      "perl-exercises",
      "perl-test-kata",
      "perl-testing",
      "test-mockobject"
   ],
   "thumbnail" : null,
   "slug" : "/pub/2005/04/07/mockobject_kata.html",
   "description" : " The last Perl Code Kata was on DBD::Mock, a mock DBI driver which is useful for testing Perl DBI applications. This Kata delves once again into the world of mock objects, this time using the more general Test::MockObject module....",
   "draft" : null,
   "authors" : [
      "stevan-little"
   ]
}



The last Perl Code Kata was on [DBD::Mock](https://metacpan.org/pod/DBD::Mock), a mock DBI driver which is useful for [testing Perl DBI applications](/pub/2005/02/10/database_kata.html). This Kata delves once again into the world of mock objects, this time using the more general [Test::MockObject](https://metacpan.org/pod/Test::MockObject) module.

### What are Mock Objects?

Mock objects are exactly what they sound like: "mocked" or "fake" objects. Through the power of polymorphism, it's easy to swap one object for another object which implements the same interface. Mock objects take advantage of this fact, allowing you to substitute the *most minimally mocked implementation of an object possible* for the real one during testing. This allows a greater degree of isolation within your tests, which is just an all around good thing.

### What are Mock Objects Good For?

Mock objects are primarily useful when writing unit tests. They share a certain similarity with the Null Object pattern in that they are purposefully *not* meant to work. Mock objects take things one step further and allow you to mock certain actions or reactions that your mock object should have, so they are especially useful in scenarios usually considered *hard to test*. Here is a short list of some scenarios in which mock objects make hard things easy.

-   *Tests which depend on outside resources such as networks, databases, etc.*

    If your code properly encapsulates any outside resources, then it should be possible to substitute a mocked object in its place during testing. This is especially useful when you have little control over the execution environment of your module. The previous Test Code Kata illustrated this by mocking the database itself. You need not stop with databases; you can mock any sufficiently encapsulated resource such as network connections, files, or miscellaneous external devices.

-   *Tests for which dependencies require a lot of setup.*

    Sometimes your object will have a dependency which requires a large amount of set-up code. The more non-test code in your tests, the higher the possibility that it will contain a bug which can then corrupt your test results. Many times your code uses only a small portion of this hard-to-setup dependency as well. Mock objects can help simplify things by allowing you to create the most minimally mocked implementation of an object and its dependencies possible, thus removing the burden of the set-up code and reducing the possibility of bugs in your non-test code.

-   *Tests for failures; in particular, failure edge cases.*

    Testing for failures can sometimes be very difficult to do, especially when the failure is not immediate, but triggered by a more subtle set of interactions. Using mock objects, it is possible to achieve exacting control over when, where, and why your object will fail. Mock objects often make this kind of testing trivial.

-   *Tests with optional dependencies.*

    Good code should be flexible code. Many times this means that your code needs to adapt to many different situations and many different environments based on the resources available at runtime. Requiring the presence of these situations and/or environments in order to test your code can be very difficult to set up or to tear down. Just as with testing failures, it is possible to use mock objects to achieve a high degree of control over your environment and mock the situations you need to test.

### The Problem

The example code for this kata illustrates as many points as possible about which mock objects are good at testing. Here is the code:

    package Site::Member;

    use strict;
    our $VERSION = '0.01';

    sub new { bless { ip_address => '' }, shift }

    sub ip_address { 
        my ($self, $ip_address) = @_;
        $self->{ip_address} = $ip_address if $ip_address;
        return $self->{ip_address};
    }

    # ...

    sub city {
        my ($self) = @_;
        eval "use Geo::IP";
        if ($@) {
            warn "You must have Geo::IP installed for this feature";
            return;
        }
        my $geo = Geo::IP->open(
                    "/usr/local/share/GeoIP/GeoIPCity.dat", 
                    Geo::IP->GEOIP_STANDARD
                ) || die "Could not create a Geo::IP object with City data";
        my $record = $geo->record_by_addr($self->ip_address());
        return $record->city();
    }

This example code comes from a fictional online community software package. Many such sites offer user homepages which can display all sorts of user information. As an optional feature, the software can use the member's IP address along with the [Geo::IP](https://metacpan.org/pod/Geo::IP) module to determine the user's city. The reason this feature is optional is that while `Geo::IP` and the C library it uses are both free, the city data is not.

The use cases suggest testing for the following scenarios:

-   User does not have `Geo::IP` installed.
-   User has `Geo::IP` installed but does not have the city data.
-   User has `Geo::IP` and city data installed correctly.

Using `Test::MockObject`, take thirty to forty minutes and see if you can write tests which cover all these use cases.

### Tips, Tricks, and Suggestions

Some of the real strengths of `Test::MockObject` lie in its adaptability and how simply it adapts. All `Test::MockObject` sessions begin with creating an instance.

    my $mock = Test::MockObject->new();

Even just this much can be useful because a `Test::MockObject` instance warns about all un-mocked methods called on it. I have used this "feature" to help trace calls while writing complex tests.

The next step is to mock some methods. The simplest approach is to use the `mock` method. It takes a method name and a subroutine reference. Every time something calls that method on the object, your `$mock` instance will run that sub.

    $mock->mock('greetings' => sub {
        my ($mock, $name) = @_;
        return "Hello $name";
    });

How much simpler could it be?

`Test::MockObject` also offers several pre-built mock method builders, such as `set_true`, `set_false`, and `set_always`. These methods pretty much DWIM.

    $mock->set_true('foo'); # the foo() method will return true
    $mock->set_false('bar'); # the bar() method will return false
    $mock->set_always('baz' => 100); # the bar() method will always return 100

It's even possible for the object to mock not only the methods, but its class as well. The simplest approach is to use the `set_isa` method to tell the `$mock` object to pretend that it belongs to another class.

    $mock->set_isa('Foo::Bar');

Now, any code that calls this mock object's `isa()` method will believe that the `$mock` is a `Foo::Bar` object.

In many cases, it is enough to substitute a `$mock` instance for a real one and let polymorphism do the rest. Other times it is necessary to inject control into the code much earlier than this. This is where the `fake_module` method comes in.

With the `fake_module` method, `Test::MockObject` can subvert control of an entire package such that it will intercept any calls to that package. The following code:

    my $mock = Test::MockObject->new();
    $mock->fake_module('Foo::Bar' => (
        'import' => sub { die "Foo::Bar could not be loaded" }
    ));
    use_ok('Foo::Bar');

...actually gives the illusion that the `Foo::Bar` module failed to load regardless of whether the user has it installed. These kinds of edge cases can be very difficult to test, but `Test::MockObject` simplifies them greatly.

But wait, that's not all.

After your tests have run using your mock objects, it is possible to inspect the methods called on them and query the order of their calls. You can even inspect the arguments passed into these methods. There several methods for this, so I refer you to the POD documentation of `Test::MockObject` for details.

### The Solution

I designed each use case to illustrate a different capability of `Test::MockObject`.

-   User does not have Geo::IP installed.

        use Test::More tests => 4;
        use Test::MockObject;

        my $mock = Test::MockObject->new();
        $mock->fake_module('Geo::IP' => (
            'import' => sub { die "Could not load Geo::IP" },
        ));

        use_ok('Site::Member');

        my $u = Site::Member->new();
        isa_ok($u, 'Site::Member');

        my $warning;
        local $SIG{__WARN__} = sub { $warning = shift };

        ok(!defined($u->city()), '... this should return undef');
        like($warning, 
                qr/^You must have Geo\:\:IP installed for this feature/, 
                '... and we should have our warning');

    This use case illustrates the use of `Test::MockObject` to mock the failure of the loading of an optional resource, which in this case is the `Geo::IP` module.

    The sample code attempts to load `Geo::IP` by calling `eval "use Geo::IP"`. Because `use` always calls a module's `import` method, it is possible to exploit this and mock a `Geo::IP` load failure. This is easy to accomplish by using the `fake_module` method and making the `import` method die. This then triggers the warning code in the `city` method, which the `$SIG{__WARN__}` handler captures into `$warning` for a later test.

    This is an example of a failure edge case which would be difficult to test without `Test::MockObject` because it requires control of the Perl libraries installed. Testing this without `Test::MockObject` would require altering the `@INC` in subtle ways or mocking a `Geo::IP` package of your own. `Test::MockObject` does that for you, so why bother to re-invent a wheel if you don't need to?

-   User has `Geo::IP` installed but does not have the city data.

        use Test::More tests => 3;
        use Test::Exception;
        use Test::MockObject;

        my $mock = Test::MockObject->new();
        $mock->fake_module('Geo::IP' => (
            'open'           => sub { undef },
            'GEOIP_STANDARD' => sub { 0 }
        ));

        use_ok('Site::Member');

        my $u = Site::Member->new();
        isa_ok($u, 'Site::Member');

        $u->ip_address('64.40.146.219');

        throws_ok {
            $u->city()
        } qr/Could not create a Geo\:\:IP object/, '... got the error we expected';

    This next use case illustrates the use of `Test::MockObject` to mock a dependency relationship, in particular the failure case where `Geo::IP` cannot find the specified database file.

    `Geo::IP` follows the common Perl idiom of returning `undef` if the object constructor fails. The example code tests for this case and throws an exception if it comes up. Testing for this failure uses the `fake_module` method again to hijack `Geo::IP` and install a mocked version of its `open` method (the code also fakes the `GEOIP_STANDARD` constant here). The mocked `open` simply returns `undef` which will create the proper conditions to trigger the exception in the example code. The exception is then caught using the `throws_ok` method of the [Test::Exception](https://metacpan.org/pod/Test::Exception) module.

    This example illustrates that it is still possible to mock objects even if your code is not in the position to pass in a mocked instance itself. Again, to test this without using `Test::MockObject` would require control of the outside environment (the `Geo::IP database` file), or in some way having control over where `Geo::IP` looks for the database file. While well-written and well-architected code would probably allow you to alter the database file path and therefore test this without using mock objects, the mock object version makes no such assumptions and therefore works the same in either case.

-   User has `Geo::IP` and the Geo-IP city data installed correctly.

        use Test::More tests => 7;
        use Test::MockObject;

        my $mock = Test::MockObject->new();
        $mock->fake_module('Geo::IP' => (
            'open'           => sub { $mock },
            'GEOIP_STANDARD' => sub { 0 }
        ));

        my $mock_record = Test::MockObject->new();
        $mock_record->set_always('city', 'New York City');

        $mock->set_always('record_by_addr', $mock_record);

        use_ok('Site::Member');

        my $u = Site::Member->new();
        isa_ok($u, 'Site::Member');

        $u->ip_address('64.40.146.219');

        is($u->city(), 'New York City', '... got the right city');

        cmp_ok($mock->call_pos('record_by_addr'), '==', 0,
                '... our mock object was called');
        is_deeply(
                [ $mock->call_args(0) ],
                [ $mock, '64.40.146.219' ],
                '... our mock was called with the right args');
                
        cmp_ok($mock_record->call_pos('city'), '==', 0,
                '... our mock record object was called');
        is_deeply(
                [ $mock_record->call_args(0) ],
                [ $mock_record ],
                '... our mock record was called with the right args');

    This next case illustrates a success case, where `Geo::IP` finds the database file it wants and returns the expected results.

    Once again, the `fake_module` method of `Test::MockObject` mocks `Geo::IP`'s `open` method, this time returning the `$mock` instance itself. The code creates another mock object, this time for the `Geo::IP::Record` instance which `Geo::IP`'s `record_by_addr` returns. `Test::MockObject`'s `set_always` method mocks the `city` method for the `$mock_record` instance. After this, `Geo::IP`'s `record_by_addr` is mocked to return the `$mock_record` instance. With all of these mocks in place, the tests then run. After that, inspecting the mock objects ensures that the code called the correct methods on the mocked objects in the correct order and with the correct arguments.

    This example illustrates testing success without needing to worry about the existence of an outside dependency. `Test::MockObject` supports taking this test one step further and providing methods for inspecting the details of the interaction between the example code and that of the mocked `Geo::IP` module. Accomplishing this test without `Test::MockObject` would be almost impossible given the lack of control over the `Geo::IP` module and its internals.

### Conclusion

Mock objects can seem complex and overly abstract at first, but once grasped they can be a simple, clean way to make hard things easy. I hope to have shown how creating simple and minimal mock object with `Test::MockObject` can help in testing cases which might be difficult using more traditional means.
