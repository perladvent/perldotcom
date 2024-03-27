
  {
    "title"  : "The History of the Schwartzian Transform",
    "authors": ["brian-d-foy"],
    "date"   : "2016-09-02T11:18:55",
    "tags"   : ["perl","lisp", "randal-schwartz","schwartzian-transform", "alpine-perl-workshop"],
    "draft"  : false,
    "image"  : null,
    "description" : "A complex sort with a complex history",
    "categories": "community"
  }


The history of the Schwartzian Transform is fascinating, full of intrigue, competing philosophies, and cross-language reluctant cooperation. The Schwartzian Transform is the name applied to a particular implementation of a cached-key sorting algorithm.

The first public appearance is probably Randal Schwartz's Usenet [post](https://groups.google.com/d/msg/comp.unix.shell/MdqXDOuzDG0/gcmc1IG9GckJ) on December 16, 1994 in response to Ken Brown's request for help:

> I'm having trouble sorting on the \*last\* word of the last field in a record
>
> *Ken Brown*

Randal included the following code in his reply:

```perl
#!/usr/bin/perl
require 5; # new features, new bugs!
print
  map { $_->[0] }
  sort { $a->[1] cmp $b->[1] }
  map { [$_, /(\S+)$/] }
  <>;
```

Randal didn't name it. He wrote the code and essentially dropped the mic. He says that he was on a break from teaching a Perl class, so his response was brief and unexplicated - typical for an experienced Usenet denizen (he said that he was there when you could read all of Usenet in a half hour). I don't think he expected it to be as troublesome as it turned out to be.

His code isn't that complex. It's a big statement, but when I teach it in Perl classes, I tell people to read it from the end toward the beginning (a handy technique for any list pipeline):

1. The first step computes the key to sort on. It combines that with the original value in a tuple.
1. The middle step sorts of the computed element in the tuple.
1. The last step extracts the original value from the tuple.

You probably can't imagine how shocking this could be back then. Perl 5 was officially released in October 1994, but the first development versions had been around since the middle of 1993. Randal was surely playing with Perl 5 as soon as it came out. This means that most Perl programmers had not yet seen new features like the [map]({{< perlfunc "map" >}}) function or references. They certainly weren't comfortable with those ideas.

Randal, however, knew the _decorate-sort-undecorate_ technique from LISP, especially since he's solidly in the emacs camp in the editor wars. Renzo on [Code Review](http://codereview.stackexchange.com/a/138436/13050) fixed up my attempt at a LISP version:

```perl
(defun schwartzian-transform (list costly-function predicate)
"sort a list of objects over the value of a function applied to them,
by applying the Schwartzian Transform (https://en.wikipedia.org/wiki/Schwartzian_transform)
the parameters are the list, the function, and the predicate for the sort."
  (mapcar #'cdr
      (stable-sort (mapcar (lambda (x)
                 (cons (funcall costly-function x) x))
                 list)
             predicate
             :key #'car)))

(require :sb-posix)
(schwartzian-transform
 (directory "/etc/*")
 (lambda (x) (sb-posix:stat-mtime (sb-posix:stat x)))
 #'<=)
```

Even with a little LISP knowledge you can tease out the same algorithm. You see the `mapcar`, `stable-sort`, and `mapcar`. (I used [SBCL](http://www.sbcl.org) for this).

In 1995 Tom Christiansen wrote [Far More Than Everything You've Ever Wanted to Know About Sorting](/doc/FMTEYEWTK/sort.html) and extensively covered Randal's code even though he hadn't labeled yet. He didn't like it that much, but, to be fair, he says at the end:

> I'm not ragging on Randal, merely teasing a bit. He's just trying to be clever, and that's what he does. I'm just submitting a sample chapter for his perusal for inclusion the mythical Alpaca Book :-)
>
> *Tom Christiansen*

Tom refers to _Learning Perl Objects, References, Objects, and Modules_, which wouldn't show up until 2003 (it's now called [Intermediate Perl](http://www.intermediateperl.com)). Curiously, in that same year [Text Processing in Python](https://books.google.com/books?id=GxKWdn7u4w8C&pg=PA113&dq=schwartzian+transform&hl=en&sa=X&ved=0ahUKEwir89e-krvNAhXMdz4KHW4uAqQQ6AEILjAC#v=onepage&q=schwartzian%20transform&f=false) (Google Books) mentioned it.

A month after his Usenet posting, Randal wrote about his decorate-sort-undecorate idiom in his [Unix Review column](http://www.stonehenge.com/merlyn/UnixReview/col06.html) for January 1996, but he hadn't labeled the technique by then either.

### Getting the name

In August 1995, [Bennett Todd answers a sorting question](https://groups.google.com/forum/?hl=en#!topic/comp.lang.perl.misc/fLo0RNV8oW8) with a "Schwartz transformation":

> Or for possibly more efficiency, ensure that the calls only happen once per
> record, rather than approximately NlogN times, with the Schwartz
> transformation:-)
>
> *Bennett Todd*

    @keys = map { $_->[0] }
        sort { $a->[1] <=> $b->[1] or $a cmp $b }
        map { [ $_, datexform($foo{$_}) ] } keys %foo;

This is the first instance I could find where Randal's last name was attached to the technique. People have seen and understood the technique and it has the start of a name, but it's not quite an idiom yet. It also hasn't settled on a name.

Tom Christiansen's April 1996 post in _comp.lang.perl.misc_ for [Read directory in timestamp order?](https://groups.google.com/d/msg/comp.lang.perl.misc/pw-Hl4byLnc/yzejRnku3RoJ) showed some benchmarks for sorting methods. He labeled one the "Schwartzian Transform".

In July, Colin Howarth started the thread ["Schwartzian transform of %$self ... help?"](https://groups.google.com/d/msg/comp.lang.perl.misc/6NEeX4XJx54/nmpMmReMIbcJ).

In October, Tom posted [an expanded draft of perllol](https://groups.google.com/d/msg/comp.lang.perl.misc/VIKNMCeNFAM/18UApg1hWy8J) as part of his [Perl Data Structures Cookbook](http://www.perl.com/doc/FMTEYEWTK/pdsc/), which turned into [perldsc]({{< perldoc "perldsc" >}}) and [perllol]({{< perldoc "perllol" >}}). He uses the full term "Schwartzian Transform". The term was catching on.

### Gaining notoriety

> [I'm still pissed at Randal for having posted it](https://groups.google.com/d/msg/comp.lang.perl.misc/fPx42DB2jd8/cC_6osV70mMJ)
>
> *Tom Christiansen*

Tom wrote that in December and he didn't mince words. It might look catty now, but at the time, Tom was on a mission to make people fall in love with Perl. He evangelized the language and didn't want to scare people off with weird looking code. He was everywhere that people were talking about Perl, and that was good for us. That meant he was effectively supporting code he didn't write, he didn't like, and people didn't understand. In his role of Perl's apostle, he was besieged with people asking about something he wouldn't have written himself.

Later, in that same thread, he'd give it another name, the [Black Transform](https://groups.google.com/d/msg/comp.lang.perl.misc/fPx42DB2jd8/cC_6osV70mMJ). He played on the translation of Randal's [Germanic surname](https://en.wikipedia.org/wiki/Schwartz_(surname)) that reflected his own opinion. That name didn't stick.

As with most long Usenet threads, it's not entirely clear what people specifically didn't like about the code, or even that there's a consensus complaint. Some complaints spiral around Randal's lack of comments. Some people want Perl to be accessible at first glance to someone who doesn't know the language. Others who were comfortable with advanced programming skills weren't bothered at all. That's a tension even today.

Remember, references and method notation were new syntax. People skilled with Perl 4 were still learning Perl 5. Perl hadn't developed idioms for list processing (LISP, natch), so people apparently weren't that comfortable with stacked list operations. Some people merely hated functional programming and LISP.

There's also a segment of people who would rather have programming languages that are easy to learn over more powerful but more opaque.

Around that time, Joseph Hall wrote [More about the Schwartzian Transform (Internet Archive)](http://web.archive.org/web/19961228210914/http://www.5sigma.com/perl/schwtr.html). It's tough to tell exactly when he wrote this, but the earliest copy in the Internet archive notes it was last modified in January 1997. Joseph used his PeGS (Perl Graphical Structures) to show them in action. This might be the first mention outside of Usenet. It's also the basis for the item that appears in his 1998 book [Effective Perl Programming](http://www.effectiveperlprogramming.com).

Also, around that time, Joseph was working with Randal at Stonehenge Consulting Services to develop the Perl courses. I'm fuzzy on that timeline, but his coursework turned into the book _Learning Perl Objects, References, and Modules_ (later renamed [Intermediate Perl](https://www.intermediateperl.com)). He's the one who came up with the Gilligan's Island as examples, but his handiwork with PeGS and the Schwartzian Transform show up in that book and in the class.

[Effective Perl Programming](http://www.effectiveperlprogramming.com) might be the first book to mention the transform, using what he'd already written. Even though I worked on the second edition of that book, I think [Joseph's original is still worth the $4 on Amazon.com](https://www.amazon.com/gp/product/0201419750/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&tag=hashbang09-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=0201419750&linkId=b8a4558fd65ec4c4bb17add6e194e5e4). It's some of the best Perl writing in the history of Perl.

In 1998 the transform also showed up in the first edition of [The Perl Cookbook](https://books.google.com/books?id=7q5QAAAAMAAJ&q=schwartzian+transform+%22programming+perl%22&dq=schwartzian+transform+%22programming+perl%22&hl=en&sa=X&ved=0ahUKEwjplePak7vNAhWSZj4KHYK9AtUQ6AEINDAD), where Tom called it the Schwartzian Transform. I don't know who first typed it into a manuscript, so perhaps it's a tie. Tom and Joseph might have to figure that out between them.

[Mastering Perl Algorithms (Google Books)](https://books.google.com/books?id=4ju67sMPwEkC&pg=PA111&dq=schwartzian+transform&hl=en&sa=X&ved=0ahUKEwir89e-krvNAhXMdz4KHW4uAqQQ6AEIOjAE#v=onepage&q=schwartzian%20transform&f=false) covered the transform in 1999 and [CGI Programming in Perl (Google Books)](https://books.google.com/books?id=gGNQ-O1WWQAC&pg=PA310&dq=schwartzian+transform&hl=en&sa=X&ved=0ahUKEwjo79KEk7vNAhWBMj4KHcBFDEY4ChDoAQhNMAg#v=onepage&q=schwartzian%20transform&f=false) mentioned it in 2000. After that, the term "Schwartzian Transform" turns up quite a bit, even in some Ruby, Python, the Jython books.

Some other interesting quotes from that long thread, which seem quaint twenty years later. My favorite was prophetic:

> [I wonder if this chunk of code will haunt us forever.](https://groups.google.com/d/msg/comp.lang.perl.misc/fPx42DB2jd8/CTRmyWyJW6MJ)
>
> *Eric Arnold*

Indeed it has haunted us since then, but that's not the end of the story.

### Variations

Randal's use of the anonymous array is interesting, but it's not the only way to decorate the original value. You could compute the values and store them in a hash. Joseph Hall came up with something called the Orcish Maneuver - a clever pun on [Orc](http://lotr.wikia.com/wiki/Orcs) (perhaps) and "OR Cache". This doesn't use the [map]({{< perlfunc "map" >}}) function  or references:

```perl
my @sorted = sort {
  ( $times{$a} ||= -M $a ) <=>
  ( $times{$b} ||= -M $b )
} @old_array;
```

Joseph uses a hash to store the potentially expensive sort value. If that key does not yet exist, he calculates and stores it for next time. This idiom relies on the feature that a Perl assignment returns the value assigned.

Thanks to the [Alpine Perl Workshop 2016](http://act.yapc.eu/alpineperl2016/) in Innsbruck for sponsoring the accompanying talk on this history. You can find [the slides for that talk on Slideshare](http://bit.ly/2bHNNx4).

For what it's worth, you'll find plenty more Lord of the Rings references in the perl source.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
