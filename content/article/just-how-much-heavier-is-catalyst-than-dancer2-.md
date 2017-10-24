{
   "date" : "2014-05-05T12:29:09",
   "slug" : "85/2014/5/5/Just-how-much-heavier-is-Catalyst-than-Dancer2-",
   "tags" : [
      "catalyst",
      "dancer",
      "mvc"
   ],
   "categories" : "web",
   "image" : "/images/85/ECCE3D08-FF2E-11E3-8D5F-5C05A68B9E16.png",
   "title" : "Just how much heavier is Catalyst than Dancer2?",
   "draft" : false,
   "description" : "We compare the two web frameworks dependencies and test suites",
   "authors" : [
      "david-farrell"
   ]
}


*Within the Perl community it is received wisdom that Catalyst is a heavyweight web framework with many dependencies and that Dancer2 is a micro web framework that's more agile than a Cirque du Soleil acrobat. But is it true?*

### Tech Specs

The comparison was between [Catalyst 5.90062](https://metacpan.org/pod/release/JJNAPIORK/Catalyst-Runtime-5.90062/lib/Catalyst/Runtime.pm) and [Dancer2 0.14](https://metacpan.org/release/XSAWYERX/Dancer2-0.140000). For local tests the machine used was a 2011 MacBook Air running Fedora 19 and Perl 5.16.3.

### Number of Dependencies

The greatest perceived difference between Catalyst and Dancer2 is the number of dependencies each has, with Catalyst being thought to have "too many". For example at the recent German Perl workshop, Dancer2 development lead Sawyer X [joked](http://www.youtube.com/watch?v=91xDp_Eus5c&t=12m09s):

> We're not pulling off half of CPAN like maybe a different web framework [Catalyst]

To compare the two frameworks, we need to compare all of their dependencies; not just those first-order dependencies used by the framework, but also those used by the modules used by the framework and so on. Fortunately this is an easy comparison to make using [Stratopan](https://stratopan.com/).

I created two stacks, one for [Catalyst](https://stratopan.com/sillymoose/WebStuff/Catalyst/graphs) and one for [Dancer2](https://stratopan.com/sillymoose/WebStuff/Dancer2/graphs). Their respective dependency graphs are shown below:

![Catalyst framework](/images/85/catalyst%20dependencies.png)
![Dancer2 framework](/images/85/dancer2%20dependencies.png)

Tabulating the Stratopan data for the two stacks we get:

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Framework</th>
<th align="left">Direct Dependencies</th>
<th align="left">Recursive Dependencies</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Catalyst</td>
<td align="left">44</td>
<td align="left">114</td>
</tr>
<tr class="even">
<td align="left">Dancer2</td>
<td align="left">29</td>
<td align="left">96</td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left">+15</td>
<td align="left">+18</td>
</tr>
</tbody>
</table>

Stratopan reveals that while Catalyst required 15 more modules than Dancer2 (+52%), when considering recursive dependencies, the Catalyst stack is only 19% larger than the Dancer2 stack. Interestingly, over 61% of the 96 distributions Dancer2 uses are used by Catalyst.

### Testing

When installing a CPAN module, the module tests usually take the longest time of the installation process and can contribute to the perceived "size" of the module. As the maturer framework, perhaps Catalyst simply has more tests than Dancer2, and therefore it's installation process takes longer?

To check for this, I tested both frameworks installation tests:

``` prettyprint
$ perl Makefile.PL
$ make
$ make test
```

Catalyst's test results:

``` prettyprint
Files=166, Tests=3374, 179 wallclock secs ( 0.85 usr  0.16 sys + 172.95 cusr  4.56 csys = 178.52 CPU)
```

Dancer2's results:

``` prettyprint
Files=78, Tests=1112, 21 wallclock secs ( 0.38 usr  0.07 sys + 19.68 cusr  1.46 csys = 21.59 CPU)
```

These results show that Catalyst ran 3,374 tests over 3 minutes compared to Dancer2's 1,112 tests over 21 seconds. So while Catalyst did run more tests, it was also slower in executing them; Dancer2 executed 53 tests per second and Catalyst managed 19 tests per second.

What would explain this discrepancy? Perhaps Dancer2 has more trivial tests that run quicker than Catalyst's tests. As a control I checked the code coverage of each framework's test suite using [Devel::Cover](https://metacpan.org/pod/Devel::Cover). Dancer2's total test coverage was 84.7% whilst Catalyst's was 85.5% - a negligible difference.

### Conclusion

So is Catalyst's "heavyweight" reputation deserved? Whilst it does not have a significantly greater number of dependencies than Dancer2, during installation Dancer2's test suite runs far faster than Catalyst's and with a similar code coverage. This doesn't mean Dancer2's test suite is better than Catalyst's (Catalyst's test suite could have higher cyclomatic complexity). But it does show that Dancer2's simpler micro-framework approach offers benefits beyond fast startups and application development time. As a Catalyst user, I've found Catalyst to be plenty fast for my needs (like PerlTricks.com), however its startup time is noticeably slow and during installation tests the Catalyst test application is started and stopped multiple times. I expect that contributes more to discrepancy in installation times between Dancer2 and Catalyst than anything else.

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F85%2F2014%2F5%2F5%2FJust-how-much-heavier-is-Catalyst-than-Dancer2-&text=Just+how+much+heavier+is+Catalyst+than+Dancer2%3F&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F85%2F2014%2F5%2F5%2FJust-how-much-heavier-is-Catalyst-than-Dancer2-&via=perltricks) about it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
