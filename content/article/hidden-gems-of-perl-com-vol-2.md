{
   "description" : "Classic articles from Perl.com's archive",
   "title" : "Hidden Gems of Perl.com Vol.2",
   "image" : "/images/hidden-gems-of-perl-com/treasure-in-cave.jpg",
   "authors" : [
      "david-farrell"
   ],
   "thumbnail" : "/images/hidden-gems-of-perl-com/thumb_treasure-in-cave.png",
   "date" : "2018-03-12T09:24:06",
   "categories" : "perldotcom",
   "tags" : ["hidden-gems","style"],
   "draft" : false
}

Today's hidden gem is Tom Christiansen's Perl [style guide]({{< relref "_doc_FMTEYEWTK_style_slide-index.md" >}}). It's a collection of 44 slides of Tom's advice regarding Perl style, from specific rules ("Uncuddled elses") to general philosphy:

> Strive always to create code that is functional, minimal, flexible, and understandable – not necessarily in that order
>

Dating from 1998, the guide is twenty years old and at times, shows its age. For example, the recommendation to use `#!/usr/bin/perl -w` instead of the warnings pragma. I wonder what Tom would change if he had the opportunity to review it.

Much of the advice however, is timeless. It's peppered with quotes from various programming luminaries such as Kernighan and Pike. Being a style guide, it's *opinionated* which makes for a thought provoking read, whether you agree with all of it or not. Several entries made me laugh out loud, such as this advice on variable names:

> Length of identifiers is not a virtue
>

I also encountered several ideas I wasn't previously aware of ("Name hashes for their values, not their keys"). Given the guide's age, perhaps these concepts are assumed knowledge, or maybe they fell out of fashion. Give Tom's [style guide]({{< relref "_doc_FMTEYEWTK_style_slide-index.md" >}}) a read, and judge for yourself.

\
N.B. Two other popular sources of Perl style are Damian Conway's [Perl Best Practices](http://shop.oreilly.com/product/9780596001735.do) and [perlstyle]({{< perldoc "perlstyle" >}}).

