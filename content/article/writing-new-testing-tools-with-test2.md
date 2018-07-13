{
   "image" : "/images/writing-new-test-tools-with-test2/bugs.jpg",
   "description" : "Extending Perl's powerful new test framework",
   "authors" : [
      "david-farrell"
   ],
   "draft" : false,
   "title" : "Writing new testing tools with Test2",
   "tags" : [
      "test2", "test2-tools-skipuntil"
   ],
   "categories" : "testing",
   "thumbnail" : "/images/writing-new-test-tools-with-test2/thumb_bugs.jpg",
   "date" : "2018-06-12T15:26:40"
}

Perl has had great testing tools for a long time, but {{< mcpan "Test2" >}} is the single biggest improvement to Perl testing in years. One of my favorite Test2 features is how easy it is to extend it with new tools, and today I'll show you how I wrote my first tool.

### Dealing with known test failures

Ideally when your tests fail, it means that something needs to be fixed, and that thing is fixable. However in the Real World™ things aren't always that simple. For example you might investigate a failure, figure out the root cause, but the person to fix it is on vacation. Or perhaps there's a datetime bug in the code, and it will resolve itself in a few days. The key here is that the failure is understood and not serious but also impractical to fix in the short term.

I found myself in exactly this situation a few months ago. I didn't want to skip the failing test, as I thought it might be forgotten, but I also wanted the build to complete in the meantime. In large distributed development teams, you want successful builds to be "the norm", so when a build fails, developers take notice.

I decided what I needed was a `skip_until` function that would skip the test until a date was reached, at which point it would start failing again. Not finding anything on CPAN, I figured it was time for a new testing tool.

### Test2 terminology: plugins vs tools

In Test2, a "plugin" is a package which overrides the behavior of existing Test2 features, whereas a "tool" is a package which provides new functions. In this case I was creating a new testing function which didn't already exist, so I needed to write a {{< mcpan "Test2::Tools" "tool" >}}.

### Test2::API context

{{< mcpan "Test2::API" >}} provides the `context` function to access the test context during runtime. The context object provides common test methods like `pass`, `fail` and `skip` etc, which let's you add custom test behavior. Here's how I use it to skip tests:

```perl
package Test2::Tools::SkipUntil;
use Test2::API 'context';
use Exporter 'import';
our @EXPORT_OK = ('skip_until');

sub skip_until {
  my ($reason, $count, $date) = @_;

  ...

  if ($should_skip) {
    my $ctx = context();
    $ctx->skip('skipped test', "$reason skip until $date") for (1..$count);
    $ctx->release;
    no warnings 'exiting';
    last SKIP;
  }
}
1;
```
I declare a new function called `skip_until` which accepts a text reason to skip, a count of tests to skip and a date. This signature is the same as [skip](Test2::Tools::Basic::skip), with the extra date parameter (I don't love the parameter order but I figure it's better to remain similar to prior art).

For the sake of brevity I've omitted the argument checking code and the date time logic to decide whether `$should_skip` is true or not. If it is, the main `if` block obtains the test context, and calls `skip` for the count of tests to skip. Next it calls `release` to free the test context ([important!]({{<mcpan "Test2::API::Context#CRITICAL-DETAILS" >}})). Finally it calls `last` to exit the SKIP block that `skip_until` would be called from.

Careful readers might notice that the use of `SKIP` means `$count` can be 1, and all tests within the skip block will still be skipped. This is the same as the Test2 behavior, in fact that code is almost identical to the Test2::Tools::Basic [source](https://metacpan.org/source/EXODIST/Test2-Suite-0.000114/lib/Test2/Tools/Basic.pm#L67).

### Using the new tool

Now if I import `Test2::Tools::SkipUntil` in my tests I  can use it like any other module:

```perl
#!/usr/bin/perl
use Test2::Tools::Basic;
use Test2::Tools::SkipUntil 'skip_until';

SKIP:{
  skip_until 'This should be fixed next month, see ticket #529', 1, '2018-06-30';

  ok foo();
  ...
}

done_testing;
```

And the tests will be skipped until the date is reached. Test2 makes writing new testing tools easy, if you have a good idea for a new testing function, consider using Test2.

### References

* {{< mcpan "Test2::Tools" >}} is the Test2 documentation for Test2 tools
* For plugins see {{< mcpan "Test2::Plugin" >}}
* {{< mcpan "Test2::API" >}} is used to get the test context object, see the context [cardinal rules]({{<mcpan "Test2::API::Context#CRITICAL-DETAILS" >}})
* {{< mcpan "Test2::Tools::SkipUntil" >}}

\
Cover image via [pixabay](https://pixabay.com/p-762486/).
