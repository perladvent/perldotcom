
  {
    "title"       : "How to become CPAN contributor - part 2",
    "authors"     : ["mohammad-anwar"],
    "date"        : "2018-05-25T09:58:25",
    "tags"        : ["cpan","github","kwalitee"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Explain the practical real world issues.",
    "categories"  : "community"
  }

I assume you have read the previous [article]({{< relref "how-to-become-cpan-contributor.md" >}}) before coming here. In this article, we will go through the nitty-gritty of different types of issue with regard to the suggested area of PR as mentioned in the previous article.

### Missing license meta name

You would assume what could go wrong with this, just add the meta name to the build script. However there is a catch and I have been bitten by it as well. For example, if the distribution document says the license is "Artistic 2". Then meta name would depend what build script is available. So in case of *Makefile.PL* the meta name would be **artistic_2** whereas in case of *dzil* then it would be **Artistic_2_0**.

As in *Makefile.PL* from [Map::Tube](https://metacpan.org/release/Map-Tube)

```perl
   ...
   ...
   VERSION_FROM       => 'lib/Map/Tube.pm',
   ABSTRACT_FROM      => 'lib/Map/Tube.pm',
   LICENSE            => 'artistic_2',
   EXE_FILES          => [ 'script/map-data-converter' ],
   ...
   ...
```

As in *dist.ini* from [Map::Tube::Delhi](https://metacpan.org/release/Map-Tube-Delhi)

```perl
   ...
   ...
   author  = Mohammad S Anwar <mohammad.anwar@yahoo.com>
   license = Artistic_2_0
   copyright_holder = Mohammad S Anwar
   ...
   ...
```

For all the different types of license, please read the [Software::License](https://metacpan.org/pod/Software::License).

I would like one more classic situation where distribution missing license name and repository includes *META.yml* with license as unknown. In such cases, you would simply add the license meta to the build script and try to build the dist. Surprise surprise, build is complaining with warning message *"Invalid LICENSE value ..."*. Although there is nothing wrong with the given license name.

I have been in such situation in the past. It turned out that it compares newly added license meta against the license meta in the *META.yml*. which doesn't match and hence the error. So what shall we do in such cases? Delete old *META.yml* and build the dist. Then copy the newly generated *META.yml* back to the repositoryn.

You might be thinking, why would you keep *META.yml* in source repository as it can be easily generated? I agree with you completely but keep in mind your intent is to add the license meta and nothing else. You never know what made the author to have it. It would be better to discuss with the author if it is good idea to drop it completely.

### Missing strict/warnings pragma

This is the easiest of all. Adding strict pragma requires adding line **use strict;** at the top.

```perl
   package package_name;
   use strict;
```

Is it that simple? **Yes** and **No**.

**Yes**, if package doesn't import latest module e.g. *Moose*, *Moo*. Some of the latest modules gives you strict/warnings pragmas for *free*.

**No**, if it is *Moose* or *Moo* or something similar based package then it becomes redundant.

For more information about which modules give you *strict* pragma for free, please have a look [Test::Strict](https://metacpan.org/pod/Test::Strict). I must say that I adopted this wonderful module *4 years* ago, thanks to **Gabor Szabo**.

You could do something like below:

```perl
   package package_name;
   use strict;
   use warnings;
```

However be carefull when adding *warnings* pragma.

Why? Why can't we just add line *use warnings;* just like above.

Before I answer this question, I would like to share a memorable moment with you. I was giving talk at the **German Perl Workshop 2018**, during the talk I spoke about one of my pull request being rejected by the author for adding warnings pragma. I didn't have the courage to question the author, so I apologized and moved on. Surprisingly, the very same author was sitting in the front row attending my talk. And he was none other than **Reini Urban** himself. At the end of the talk, he explained to me why he rejected the pull request.

Until that point, I didn't know that in some cases, adding *warnings pragma* can affect the *performance*. He is such a genious and humble person. It was my honour that he was in the audience.

So the moral of the story is, be carefull when adding *use warnings;* line. To be honest with you all, I avoid dealing with missing warnings issue unless I know the author personally.

I will go through other issues in detail in the next article till then keep contributing. If you need any help then feel free to *[email me](mailto:mohammad.anwar@yahoo.com)* and if necessary, we can remote pair program to get you going.