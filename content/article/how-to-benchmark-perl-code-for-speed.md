{
   "date" : "2013-09-29T19:12:54",
   "slug" : "40/2013/9/29/How-to-benchmark-Perl-code-for-speed",
   "authors" : [
      "david-farrell"
   ],
   "description" : "Benchmarking is easy with the Benchmark module",
   "image" : null,
   "tags" : [
      "benchmarking",
      "module",
      "core"
   ],
   "draft" : false,
   "categories" : "development",
   "title" : "How to benchmark Perl code for speed"
}


Benchmarking Perl code speed is easy with the [Benchmark](https://metacpan.org/module/Benchmark) module. This article discusses benchmarking in general and how to use the [Benchmark](https://metacpan.org/module/Benchmark) module.

### What is a benchmark?

In programming a benchmark is a point-in-time measurement of the performance of a some code. Any aspect of the code performance can be benchmarked: speed, memory use and IO frequency are some common metrics.

### Benchmark limitations

One thing to keep in mind with benchmarks is that they are affected by the environment: the operating system, hardware, software and current machine state can all affect the benchmark. For Perl code the current Perl version and the compile options that Perl was installed with can have significant affects on code performance. For example if Perl was compiled with iThreads enabled, this increases the overhead of all Perl programs. Therefore benchmark comparisons are only meaningful when the benchmark environments are the same.

### Perl's Benchmark Module

[Benchmark](https://metacpan.org/module/Benchmark) comes installed in Perl core so if you have Perl installed you should already have Benchmark installed as well. If you are on a UNIX-like system then consider installing [Benchmark::Forking](https://metacpan.org/module/Benchmark::Forking) as it can improve the accuracy of benchmarks. [Benchmark::Forking](https://metacpan.org/module/Benchmark::Forking) is a drop-in replacement for [Benchmark](https://metacpan.org/module/Benchmark) and all of the following code examples will work with either module.

### Timing Perl Code

Benchmarks are most interesting when comparing performance of code - so we're going to focus on methods that do that. Benchmark provides a `timethese` subroutine which continuously executes sets of Perl code for a number of CPU seconds and then prints out the results. Let's compare the speed difference of two common Perl operations: array assignment using the shift built in function and direct array assignment using equals:

```perl
use strict;
use warnings;
use Benchmark qw/cmpthese timethese/;

timethese(-10, {
        shiftAssign => sub {    my @alphabet = ('A'..'Z');
                                for (my $i = 0; $i < 26; $i++){
                                    my $letter = shift @alphabet;
                                }
                           },
        equalsAssign => sub {   my @alphabet = ('A'..'Z');
                                for (my $i = 0; $i < 26; $i++){
                                    my $letter = $alphabet[$i];
                                }
                            },
});
```

Running the code above yielded the following results:

```perl
Benchmark: running equalsAssign, shiftAssign for at least 10 CPU seconds...
equalsAssign: 10 wallclock secs (10.32 usr +  0.00 sys = 10.32 CPU) @ 150112.98/s (n=1549166)
shiftAssign: 11 wallclock secs (10.43 usr +  0.00 sys = 10.43 CPU) @ 148529.82/s (n=1549166)
```

The key metric to focus on is the rate per CPU second. This shows that the shiftAssign code block was executed 148,529.82/s and the equalsAssign block was slightly faster, executing 150,112.98/s. Note that the testing of each block ran for different amounts of time - so the other numbers in the output are not directly comparable.

### Comparing Perl Code

The `cmpthese` subroutine provided the Benchmark module accepts the same arguments and `timethese` shown above, but prints out a useful comparison grid of the results to show which code block was faster by %. Helpfully it also includes the rate per CPU second.

```perl
use strict;
use warnings;
use Benchmark qw/cmpthese timethese/;

cmpthese(-10, {
        shiftAssign => sub {    my @alphabet = ('A'..'Z');
                                for (my $i = 0; $i < 26; $i++){
                                    my $letter = shift @alphabet;
                                }
                           },
        equalsAssign => sub {   my @alphabet = ('A'..'Z');
                                for (my $i = 0; $i < 26; $i++){
                                    my $letter = $alphabet[$i];
                                }
                            },
});
```

Executing this code returned the following results:

```perl
                 Rate  shiftAssign equalsAssign
shiftAssign  142529/s           --          -4%
equalsAssign 148159/s           4%           --
```

The results above are ordered from slowest to fastest (as seen by the rate/s measurement). This benchmark shows that the equalsAssign code block was 4% faster than the shiftAssign code block.

### Additional Tips

-   Try to use the minimum set of code required for the behavior required - this will increase the accuracy of the benchmark pertaining to operations being benchmarked.
-   Use a negative number as the CPU seconds count for `timethese` or `cmpthese`. This specifies the minimum number of CPU seconds to run. [Some sources](http://www.perlmonks.org/?node_id=8745) recommend at least -5 seconds to avoid inaccurate benchmarks.
-   Sanity check your results: if you're not sure try comparing two code blocks with one obviously slower than the other to check that Benchmark is returning sensible results.
-   Compare code examples rather than time individual ones: the actual execution time of a block of code is usually not that important; knowing which set of code is faster than the other however is useful as this will generally be a repeatable occurrence.
-   If you require more in depth benchmarking consider using [Devel::NYTProf](https://metacpan.org/module/Devel::NYTProf).

### Sources

This article drew on information from a few sources in particular: brian d foy's [Benchmarking Perl](http://www252.pair.com/comdog/Talks/benchmarking_perl.pdf) talk notes and David Golden's [Adventures in Benchmarking](http://www.dagolden.com/index.php/1849/adventures-in-benchmarking-part-1/) post.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
