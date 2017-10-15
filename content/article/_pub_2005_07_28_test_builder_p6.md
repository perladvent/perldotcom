{
   "tags" : [
      "parrot",
      "perl-6",
      "perl-6-modules",
      "porting-to-perl-6",
      "pugs",
      "refactoring",
      "test-driven-design-of-perl-6",
      "test-builder"
   ],
   "slug" : "/pub/2005/07/28/test_builder_p6.html",
   "description" : "Pugs let real people write real Perl 6 code. This article presents a case study of porting Perl's venerable Test::Builder to Perl 6.",
   "draft" : null,
   "thumbnail" : "/images/_pub_2005_07_28_test_builder_p6/111-testbuilder.gif",
   "image" : null,
   "date" : "2005-07-28T00:00:00-08:00",
   "categories" : "perl-6",
   "title" : "Porting Test::Builder to Perl 6",
   "authors" : [
      "chromatic"
   ]
}



Perl 6 development now proceeds in two directions. The first is from the bottom up, with the creation and evolution of [Parrot](http://www.parrotcode.org/) and underlying code, including the Parrot Grammar Engine. The goal there is to build the structure Perl 6 will need. The second direction is from the top down, with the [Pugs](http://www.pugscode.org/) project implementing Perl 6 initially separate from Parrot, though recent additions allow an embedded Parrot to run the parsed code and to emit valid Parrot PIR code.

Both projects are important and both help the design of Perl 6 and its implementation. Parrot is valuable in that it demonstrates a solid foundation for Perl 6 (and other similar languages); a far better foundation than the internals of Perl 5 have become. Pugs is important because it allows people to use Perl 6 productively now, with more features every day.

### Motivation and Design

Perl culture values testing very highly. Several years ago, at the suggestion of Michael Schwern, I extracted the code that would become [Test::Builder](http://search.cpan.org/perldoc/Test::Builder) from [Test::More](http://search.cpan.org/perldoc/Test::More) and unified [Test::Simple](http://search.cpan.org/perldoc/Test::Simple) and Test::More to share that back end. Now dozens of other testing modules, built upon Test::Builder, work together seamlessly.

Pugs culture also values testing. However, there was no corresponding Test::Builder for Perl 6 yet--there was only a single [*Test.pm*](http://svn.openfoundry.org/pugs/ext/Test/lib/Test.pm) module that did most of what the early version of Test::More did in Perl 5.

Schwern and I have discussed updates and refactorings of Test::Builder for the past couple of years. We made some mistakes in the initial design. As Perl 6 offers the chance to clean up Perl 5, so does a port of Test::Builder to Perl 6 offer the chance to clean up some of the design decisions we would make differently now.

Internally, Test::Builder provides a few testing and reporting functions and keeps track of some test information. Most importantly, it contains a plan consisting of the number of tests expected to run. It also holds a list of details of every test it has seen. The testing and reporting functions add information to this list of test details. Finally, the module contains functions to report the test details in the standard [TAP](http://search.cpan.org/dist/Test-Harness/lib/Test/Harness/TAP.pod) format, so that tools such as [Test::Harness](http://search.cpan.org/perldoc/Test::Harness) can interpret the results correctly.

Test::Builder needs to do all of these things, but there are several ways to design the module's internals. Some ways are better than others.

The original Perl 5 version mashed all of this behavior together into one object-oriented module. To allow the use of multiple testing modules without confusing the count or the test details, `Test::Builder::new()` always returns a singleton. All test modules call the constructor to receive the singleton object and call the test reporting methods to add details of the tests they handle.

This works, but it's a little inelegant. In particular, modules that test test modules have to go to a lot of trouble to work around the design. A more flexible design would make things like [Test::Builder::Tester](http://search.cpan.org/perldoc/Test::Builder::Tester) much easier to write.

The biggest change that Schwern and I have discussed is to separate the varying responsibilities into separate modules. The [new Test::Builder object in Perl 6](http://svn.openfoundry.org/pugs/ext/Test-Builder/lib/Test/Builder.pm) itself contains a [Test::Builder::TestPlan](http://svn.openfoundry.org/pugs/ext/Test-Builder/lib/Test/Builder/TestPlan.pm) object that represents the plan (the number of tests to run), a [Test::Builder::Output](http://svn.openfoundry.org/pugs/ext/Test-Builder/lib/Test/Builder/Output.pm) object that contains the filehandles to which to write TAP and diagnostic output, and an array of tests' results (all [Test::Builder::Test](http://svn.openfoundry.org/pugs/ext/Test-Builder/lib/Test/Builder/Test.pm) instances).

The default constructor, `new()`, still returns a singleton by default. However, modules that use Test::Builder can create their own objects, which perform the Test::Builder::TestPlan or Test::Builder::Output roles and pass them to the constructor to override the default objects created internally for the singleton. If a test module really needs a separate Test::Builder object, the alternate `create()` method creates a new object that no other module will share.

This strategy allows the Perl 6 version of [Test::Builder::Tester](http://svn.openfoundry.org/pugs/ext/Test-Builder/lib/Test/Builder/Tester.pm) to create its own Test::Builder object that reports tests as normal and then creates the shared singleton with output going to filehandles it can read instead of `STDOUT` and `STDERR`. The design appears to be sound; it took less than two hours to go from the idea of T::B::T to a fully working implementation--counting a break to eat ice cream.

### First Attempts

Translating Perl 5 OO code into Perl 6 OO code was mostly straightforward, despite my never having written any runnable Perl 6 OO code. (Also, Pugs was not far enough along that objects worked.)

#### What Went Right

One nice revelation is that opaque objects are actually easier to work with than blessed references. Even better, Perl 6's improved function signatures reduce the necessity to write lots of boring boilerplate code.

Breaking Test::Builder into separate pieces gave the opportunity for several other refactorings. One of my favorite is "Replace Condititional with Polymorphism". There are four different types of tests that have different reporting styles: `pass`, `fail`, `SKIP`, and `TODO`. It made sense to create separate classes for each of those, giving each the responsibility and knowledge to produce the correct TAP output. Thus I wrote Test::Builder::Test, a façade factory class with a very smart constructor that creates and returns the correct test object based on the given arguments. When Test::Builder receives one of these test objects, it asks it to return the TAP string, passes that message to its contained Test::Builder::TestOutput object, and stores the test object in the list of run tests.

[<img src="http://conferences.oreillynet.com/images/os2005/banners/468x60.gif" alt="O&#39;Reilly Open Source Convention 2005." width="468" height="60" />](http://conferences.oreillynet.com/os2005/)

#### What Went Wrong

Writing the base for all (or at least many) possible test modules is tricky. In this case, it was trebly so. Not only was this the first bit of practical OO Perl 6 code I'd written, but I had no way to test it, either by hand (how I tested the Perl 5 version, before Schwern and I worked out a way to write automated tests for it), or with automated tests. Pugs didn't even have object support when I wrote this, though checking in this code pushed OO support higher on the schedule.

##### Infinite Loops in Construction

Originally, I thought all test classes would inherit from Test::Builder::Test. As Damian Conway pointed out, my technique created an infinite loop. (He suggested that "Don't make a façade factory class an ancestor of the instantiable classes" is a design mistake akin to "Don't get involved in a land war in Asia" and mumbled something else about battles of wits and Sicilians.) The code looked something like:

      class Test::Builder::Test
      {
          my Test::Builder::Test $:singleton is rw;

          has Bool $.passed;
          has Int  $.number;
          has Str  $.diagnostic;
          has Str  $.description;

          method new (Test::Builder::Test $class, *@args)
          {
              return $:singleton if $:singleton;
              $:singleton = $class.create( @args );
              return $:singleton;
          }

          method create(
              $number, 
              $passed       =  1,
              ?$skip        =  0,
              ?$todo        =  0,
              ?$reason      = '',
              ?$description = '',
          )
          {
              return Test::Builder::Test::TODO.new(
                  description => $description, reason => $reason, passed => $passed,
              ) if $todo;

              return Test::Builder::Test::Skip.new(
                  description => $description, reason => $reason, passed => 1,
              ) if $skip;

              return Test::Builder::Test::Pass.new(
                  description => $description, passed => 1,
              ) if $passed;

              return Test::Builder::Test::TODO.new(
                  description => $description, passed => 0,
              ) if $todo;
          }
      }

      class Test::Builder::Test::Pass is Test::Builder::Test {}
      class Test::Builder::Test::Fail is Test::Builder::Test {}
      class Test::Builder::Test::Skip is Test::Builder::Test { ... }
      class Test::Builder::Test::TODO is Test::Builder::Test { ... }

      # ...

Why is this a singleton? I have no idea; I typed that code into the *wrong* module and continued writing code a few minutes later, thinking that I knew what I was doing. The infinite loop stands out in my mind very clearly now. Because all of the concrete test classes inherit from Test::Builder::Test, they inherit its `new()` method; none of them override it. Thus, they'll all call `create()` again (and none of them override *that* either).

##### Confusing Initialization

I also struggled with the various bits and pieces of creating and building objects in Perl 6. There are a lot of hooks and overrides available, making the object system very flexible. However, without any experience or examples or guidance, choosing between `new()`, `BUILD()`, and `BUILDALL()` is difficult.

I realized I had no idea how to handle the singleton in Test::Builder. At least, when I realized that (for now) Test::Builder could remain a singleton, I didn't know how or where to create it.

I finally settled on putting it in `new()`, with code much like that in the broken version of Test::Builder::Test previously. `new()` eventually allocates space for, creates, and returns an opaque object. `BUILD()` initializes it. This led me to write code something like:

      class Test::Builder;

      # ...

      has Test::Builder::Output   $.output;
      has Test::Builder::TestPlan $.plan;

      has @:results;

      submethod BUILD ( Test::Builder::Output ?$output, ?$TestPlan )
      {
          $.plan   = $TestPlan if $TestPlan;
          $.output = $output ?? $output :: Test::Builder::Output.new();
      }

There's a difference here because most uses of Test::Builder set the test plan explicitly later, after receiving the Test::Builder object. I added a `plan()` method, too:

      method plan ( $self:, Str ?$explanation, Int ?$num )
      {
          die "Plan already set!" if $self.plan;

          if ($num)
          {
              $self.plan = Test::Builder::TestPlan.new( expect => $num );
          }
          elsif $explanation ~~ 'no_plan'
          {
              $self.plan = Test::Builder::NullPlan.new();
          }
          else
          {
              die "Unknown plan";
          }

          $self.output.write( $self.plan.header() );
      }

There are some stylistic errors in the previous code. First, when declaring an invocant, there's a colon but no comma. Second, `fail` is much better than `die` (an assertion Damian made that I take on faith, having researched more serious issues instead). Third, the parenthesization of the cases in the `if` statement is inconsistent.

### Final (Ha!) Version

Shortly after I checked in the example code, Stevan Little began work on a test suite (using *Test.pm*). I knew that Pugs didn't support many of the necessary language constructs, but this allowed Pugs hackers to identify necessary features and me to identify legitimate bugs and mistakes in the code. (It's tricky to bootstrap test-driven development.)

After filling out the test suite, fixing all of the known bugs in my code, talking other Pugs hackers into adding features I needed, and implementing those I couldn't pawn off on others, Test::Builder works completely in Pugs right now. There is one remaining nice feature: splatty args in method calls. But I'm ready to port *Test.pm* to the new back end and then write many, many more useful testing modules--starting with a port of Mark Fowler's Test::Builder::Tester written the night before this article went public!

The singleton creation in `Test::Builder` now looks like:

      class Test::Builder-0.2.0;
      
      use Test::Builder::Test;
      use Test::Builder::Output;
      use Test::Builder::TestPlan;
      
      my  Test::Builder           $:singleton;
      has Test::Builder::Output   $.output handles 'diag';
      has Test::Builder::TestPlan $.testplan;
      has                         @:results;
      
      method new ( Test::Builder $Class: ?$plan, ?$output )
      {
          return $:singleton //= $Class.SUPER::new(
              testplan => $plan, output => $output
          );
      }
      
      method create ( Test::Builder $Class: ?$plan, ?$output )
      {
          return $Class.new( testplan => $plan, output => $output );
      }
      
      submethod BUILD
      (
          Test::Builder::TestPlan ?$.testplan,
          Test::Builder::Output   ?$.output = Test::Builder::Output.new()
      )
      {}

Those test modules that want to use the default `$Test` object directly can call `Test::Builder::new()` to return the singleton, creating it if necessary. Test modules that need different output or plan objects should call `Test::Builder::create()`. (The test suite actually does this.)

Having removed the `Test::Builder` code from `Test::Builder::Test`, I revised the latter, as well:

      class Test::Builder::Test-0.2.0
      {
          method new (
              $number,     
              ?$passed      = 1,
              ?$skip        = 0,
              ?$todo        = 0,
              ?$reason      = '', 
              ?$description = '',
          )
          {
              return ::Test::Builder::Test::TODO.new(
                  description => $description, passed => $passed, reason => $reason
              ) if $todo;

              return ::Test::Builder::Test::Skip.new(
                  description => $description, passed =>       1, reason => $reason
              ) if $skip;

              return ::Test::Builder::Test::Pass.new(
                  description => $description, passed =>       1,
              ) if $passed;

              return ::Test::Builder::Test::Fail.new(
                  description => $description, passed =>       0,
              );
          }
      }

That's it. I moved the object attributes into roles. `Test::Builder::Test::Base` is the basis for all tests, encapsulating all of the attributes that tests share and providing the important methods:

      role Test::Builder::Test::Base
      {
          has Bool $.passed;
          has Int  $.number;
          has Str  $.diagnostic;
          has Str  $.description;

          submethod BUILD (
              $.description,
              $.passed,
              ?$.number     =     0,
              ?$.diagnostic = '???',
          ) {}

          method status returns Hash
          {
              return
              {
                  passed      => $.passed,
                  description => $.description,
              };
          }

          method report returns Str
          {
              my $ok          = $.passed ?? 'ok' :: 'not ok';
              my $description = "- $.description";
              return join( ' ', $ok, $.number, $description );
          }

      }

      class Test::Builder::Test::Pass does Test::Builder::Test::Base {}
      class Test::Builder::Test::Fail does Test::Builder::Test::Base {}

`Test::Builder::Test::WithReason` forms the basis for `TODO` and `SKIP` tests, adding the reason why the developer marked the test as either:

      role Test::Builder::Test::WithReason does Test::Builder::Test::Base
      {
          has Str $.reason;

          submethod BUILD ( $.reason ) {}

          method status returns Hash ( $self: )
          {
              my $status        = $self.SUPER::status();
              $status{"reason"} = $.reason;
              return $status;
          }
      }

      class Test::Builder::Test::Skip does Test::Builder::Test::WithReason { ... }
      class Test::Builder::Test::TODO does Test::Builder::Test::WithReason { ... }

#### What's Hard

The two greatest difficulties I encountered in this porting effort were in mapping my design to the new Perl 6 way of thinking and in working around Pugs bugs and unsupported features. The former is interesting; it may suggest places where other people will run into difficulties.

One of the trickiest parts of Perl 6's OO model to understand is the interaction of the `new()`, `BUILD()`, and `BUILDALL()` methods. Perl 5 provides very little in the way of object support beyond `bless`. Though having finer-grained control over object creation, initialization, and initializer dispatch will be very useful, remembering the purposes of each method is very important, lest you override the wrong one and end up with an infinite loop or partially initialized object.

From rereading the design documents, experimenting, picking the brains of other @Larry members, and thinking hard, my rules are:

-   Leave `new()` alone.

    This method creates the opaque object. Override it when you don't want to return a new object of this class every time. Don't do initialization here. Don't forget to call `SUPER::new()` if you actually want an object.

-   Override `BUILD()` to add initialize attributes for objects of *this* class.

    Think of this as an initializer, not a constructor.

-   Override `BUILDALL()` when you want to change the order of initialization.

    I haven't needed this yet and don't expect to.

Pugs-wise, find a good Haskell tutorial, find a really fast machine that can run GHC 6.4, and look for lambdacamel mentors on *\#pugs*. (My productivity increased when Autrijus told me about Haskell's `trace` function. He called it a refreshing desert in the oasis of referential transparency.)

#### What's Easy

Was this exercise valuable? Absolutely! It reinforced my belief that Perl 6 is not only Perlish, but that it's a fantastic revolution of Perl 5 in several ways:

-   The object system is much better. Attributes and accessors require almost no syntax, and that only in their declarations. Using attributes feels Perlish, even if it's not manipulating hash keys.
-   Function signatures eliminate a lot of code. My initializers do a lot of work, but they don't take much code. Some even have empty method bodies. This is a big win, except for the poor souls who had to implement the underlying binding code in Pugs. (That took a while.)
-   Roles are fantastic. Sure, I believed in them already, but being able to use them without the hacks required in Perl 5 was even better.

#### Final Thoughts

Schwern and I did put a lot of thought into the Perl 5 redesign we never really did, and my code here really benefits from the lessons I learned from the previous version. Still, even though I wrote code to a moving project that didn't yet support all of the features I wanted, it was a great exercise. `Test::Builder` is simpler, shorter, cleaner, and more flexible; it's ready for everything the Perl 6 QA group can throw at it.

`Test::Builder` isn't the only Perl 5 module being ported to Perl 6. Other modules include ports of HTTP::Server::Simple, Net::IRC, LWP, and `CGI`. There are even ports underway for Catalyst and Maypole.

Perl 6 isn't ready yet, but it's closer every day. Now's a great time to port some of your code to see how Perl 6 is still Perlish, but a revolutionary step in refreshing new directions.

*chromatic is the author of [Modern Perl](http://onyxneon.com/books/modern_perl/). In his spare time, he has been working on [helping novices understand stocks and investing](http://trendshare.org/how-to-invest/).*
