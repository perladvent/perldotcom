
  {
    "title"  : "Identify slow code with Devel::Timer",
    "authors": ["david-farrell"],
    "date"   : "2016-08-17T08:38:50",
    "tags"   : ["devel-timer", "benchmark", "refactor", "optimize", "speed"],
    "draft"  : false,
    "image"  : "/images/identify-slow-code-with-devel--timer/stopwatch.png",
    "description" : "How timing statements can help you pinpoint bottlenecks",
    "categories": "development"
  }

Program speed is an important factor in programming. No one wants their program to execute more slowly. As a general purpose programming language, Perl is usually fast enough for most things, and when it isn't, we have some great tools to help us make it faster. We can use the [Benchmark](https://metacpan.org/pod/Benchmark) module to compare code and [Devel::NYTProf](https://metacpan.org/pod/Devel::NYTProf) to produce detailed analyses of our programs.

This article is about [Devel::Timer](https://metacpan.org/pod/Devel::Timer), another module I like to use when I want to optimize an existing subroutine, and I'm not sure how long each statement within the subroutine takes to execute. It's very easy to setup, so if you haven't used it before, once you've read this article you'll have another tool in your toolbox for optimizing code.


### Use Devel::Timer to get a timing report

Let's say I have a subroutine which is far too slow, but I'm not sure what's slowing it down. The (fictional) subroutine looks like this:

``` prettyprint
sub foo {
  my $args = shift;

  die 'foo() requires an hashref of args'
    unless $args && ref $args eq 'HASH';

  my %parsed_args = validate_args($args);

  my $user        = find_user($parsed_args{username});

  my $location    = get_location($parsed_args{req_address});

  my $bar         = register_request($user, $location);

  return $bar;
}
```

I can use Devel::Timer to time each statement in the subroutine, and tell me how long each one took:

``` prettyprint
use Devel::Timer;

sub foo {
  my $args = shift;
  my $timer = Devel::Timer->new();

  die 'foo() requires an hashref of args'
    unless $args && ref $args eq 'HASH';
  $timer->mark('check $args is hashref');

  my %parsed_args = validate_args($args);
  $timer->mark('validate_args()');

  my $user        = find_user($parsed_args{username});
  $timer->mark('find_user()');

  my $location    = get_location($parsed_args{req_address});
  $timer->mark('get_location()');

  my $bar         = register_request($user, $location);
  $timer->mark('register_request()');

  $timer->report();
  return $bar;
}
```

I've updated the code to import Devel::Timer and construct a new `$timer` object. After every statement I want to time, I call the `mark` method which adds an entry to the timer, like recording split times on a stopwatch. Finally I call `report` which prints out a table listing the time spent between every `mark` call.

    Devel::Timer Report -- Total time: 0.0515 secs
    Interval  Time    Percent
    ----------------------------------------------
    02 -> 03  0.0328  63.68%  validate_args() -> find_user()
    04 -> 05  0.0095  18.44%  get_location() -> register_request()
    03 -> 04  0.0081  15.72%  find_user() -> get_location()
    06 -> 07  0.0010   0.19%  register_request() -> END
    01 -> 02  0.0001   0.00%  check $args is hashref -> validate_args()
    00 -> 01  0.0000   0.00%  INIT -> check $args is hashref

By default the table is printed in descending order of duration. The output shows that the subroutine took 515ms to execute, and the time between the `validate_args()` mark and the `find_user()` mark took a whopping 63.68% of the runtime. So if I was going to refactor this subroutine, I would start with the `find_user()` function.

In my experience, this is a typical distribution of timings. It's rare to find every statement in a subroutine takes the same amount of time. Usually there just are one or two culprits, and if you can refactor those, the subroutine runtime can improve by an order of magnitude or more.


### A common pitfall

One thing to watch out for with Devel::Timer is lazy evaluation. This is when code is written to only execute when it's required. Sometimes the first call to a subroutine may be slow, as objects are created, caches initialized or whatever. But subsequent calls are much faster. An easy way to check for this is to call the subroutine multiple times in the same process, and check the Devel::Timer reports to confirm the timings.


### References

- This article is about [Devel::Timer](https://metacpan.org/pod/Devel::Timer)
- [Benchmark::Stopwatch](https://metacpan.org/pod/Benchmark::Stopwatch) is another timer module, similar to Devel::Timer
- [Devel::NYTProf](https://metacpan.org/pod/Devel::NYTProf) is a code profiler for Perl. Tim Bunce regularly gives [talks](https://www.youtube.com/watch?v=SDWoCQf53Ck) about it
- The [Benchmark](https://metacpan.org/pod/Benchmark) module comes with Perl

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
