{
   "title" : "Benchmarking subroutine signatures",
   "tags" : [
      "subroutine",
      "method",
      "optimization",
      "old_site"
   ],
   "date" : "2014-05-12T13:19:16",
   "image" : null,
   "draft" : false,
   "categories" : "development",
   "description" : "We review native subroutine signatures speed and show you how to make them faster",
   "slug" : "88/2014/5/12/Benchmarking-subroutine-signatures",
   "authors" : [
      "david-farrell"
   ]
}


*Subroutine signatures will be released to the Perl core in just a few days. But how do they performance compared with traditional methods like direct variable assignment and the [Method::Signatures](https://metacpan.org/pod/Method::Signatures) module? I benchmarked all three with interesting results.*

### Background

I [covered](http://perltricks.com/article/72/2014/2/24/Perl-levels-up-with-native-subroutine-signatures) the new subroutine signatures features when they first appeared in the Perl development release 5.19.9. For these benchmarks I used the latest Perl development release (5.19.11).

### Method

All of the benchmarks came from variations of this code:

``` prettyprint
use strict;
use warnings;
use Benchmark::Forking 'cmpthese';
use feature 'signatures';
no warnings 'experimental::signatures';
use Method::Signatures;

sub native_assignment { 
    die "Too few arguments for subroutine $!" unless @_ == 1; 
    my ($var) = @_;
}

sub native_signature ($var) {}

func method_signature ($var) {}

cmpthese(-5, {
    native_assignment=> sub { native_assignment(1)},
    native_signature => sub { native_signature(1) },
    method_signature => sub { method_signature(1) },
});
```

The code begins by importing the necessary libraries. The line "no warnings 'experimental::signatures' stops Perl from warning about the use of subroutine signatures. The code then declares the three subroutines we want to test: one is the normal variable assignment, one native subroutine signature and one for Method::Signatures ("func").

Because the benchmark module executes tests in alphabetical order, every benchmark was run three times with the tests renamed each time to change the test order (every test was run first, second and third across the three benchmarks).

### Results

Running this benchmark returned the following results:

<table>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"></th>
<th align="left">native_signature</th>
<th align="left">method_signature</th>
<th align="left">native_assignment</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">native_signature</td>
<td align="left">--</td>
<td align="left">-10%</td>
<td align="left">-27%</td>
</tr>
<tr class="even">
<td align="left">method_signature</td>
<td align="left">12%</td>
<td align="left">--</td>
<td align="left">-19%</td>
</tr>
<tr class="odd">
<td align="left">native_assignment</td>
<td align="left">38%</td>
<td align="left">23%</td>
<td align="left">--</td>
</tr>
</tbody>
</table>

The results showed native subroutine signatures to be about 12% slower than the Method::Signatures function and 38% slower than the native assignment subroutine. So is this the price of the cleaner syntax? Actually it's not the whole story.

### Changing the number of variables

Would changing the number of variables assigned in the subroutine affect the relative performance of the three subroutine types? I re-ran the benchmarks, only this time incrementing the number of variables being assigned and plotted the results:

![Comparison of signatures speed with increasing number of variables](/images/88/signatures%20comparison.png)

The results showed that increasing the number of variables improved the relative speed of native subroutine signatures against Method::Signatures. With two variable assignments their speed is about par. With three or more variables, native subroutine signatures outperforms, up to 18% faster. When I discussed these results with Ricardo Signes, he confirmed that the native subroutine signatures code had been optimized for multiple variable assignments, which correlates with the results shown above.

### Faster subroutine signatures

It could be argued that the native subroutine signatures are plenty fast as they are and offer several benefits over both variable assignments and Method::Signatures. However, Ricardo did share a trick with me to make subroutine signatures run even faster, which I can't resist sharing.

Adding a nameless slurpy parameter ("@") to the subroutine signature removes the upper limit on how many arguments can be passed to the subroutine. Let's add the slurpy parameter to the subroutine signature in our benchmark code. I've also updated the code to take two parameters - the level where previously Method::Signatures and subroutine signatures exhibited similar performance:

``` prettyprint
use strict;
use warnings;
use Benchmark::Forking 'cmpthese';
use feature 'signatures';
no warnings 'experimental::signatures';
use Method::Signatures;

sub native_assignment { 
    die "Too few arguments for subroutine $!" unless @_ == 2; 
    my ($var1, $var2) = @_;
}

sub native_signature ($var1, $var2, @) {}

func method_signature ($var1, $var2) {}

cmpthese(-5, {
    native_assignment=> sub { native_assignment(1, 2)},
    native_signature => sub { native_signature(1, 2) },
    method_signature => sub { method_signature(1, 2) },
});
```

And here are the results:

<table>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th align="left"></th>
<th align="left">method_signature</th>
<th align="left">native_signature</th>
<th align="left">native_assignment</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">method_signature</td>
<td align="left">--</td>
<td align="left">-23%</td>
<td align="left">-37%</td>
</tr>
<tr class="even">
<td align="left">native_signature</td>
<td align="left">30%</td>
<td align="left">--</td>
<td align="left">-18%</td>
</tr>
<tr class="odd">
<td align="left">native_assignment</td>
<td align="left">60%</td>
<td align="left">23%</td>
<td align="left">--</td>
</tr>
</tbody>
</table>

By adding the slurpy parameter, native subroutine signatures performance improved by 30%! This is because the subroutine no longer has to run a variable count check against the upper limit of variables accepted by the signature. It's up to you if you want to remove this check for the performance gain or not - I can't think of a use case where this would be worth it, but you never know.

### Conclusion

Subroutine variable assignment is a relatively inexpensive operation and unlikely to be a bottleneck in your code running time. However the speed benchmarks show that by switching to subroutine signatures is unlikely to regress and in some cases will improve run time speed. So use them with confidence!

### Thanks

Thanks to Perl pumpking Ricardo Signes for providing detail on the subroutine signatures implementation and slury parameter optimization.

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F88%2F2014%2F5%2F12%2FBenchmarking-subroutine-signatures&text=Benchmarking+subroutine+signatures&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F88%2F2014%2F5%2F12%2FBenchmarking-subroutine-signatures&via=perltricks) about it!

***Edit:** article code and benchmarks corrected for single variable assignment on 2014/05/12*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
