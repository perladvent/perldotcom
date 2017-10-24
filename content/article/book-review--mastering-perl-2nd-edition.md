{
   "title" : "Book review: Mastering Perl 2nd edition",
   "image" : "/images/67/EC46C580-FF2E-11E3-A987-5C05A68B9E16.png",
   "description" : "Learn how to bend Perl to your will with brian d foy's Mastering Perl",
   "slug" : "67/2014/2/10/Book-review--Mastering-Perl-2nd-edition",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "book-review"
   ],
   "date" : "2014-02-10T05:24:44",
   "categories" : "community"
}


*The second edition of Mastering Perl by brian d foy has just been published by O'Reilly. We took a look at the new version to see what's changed and to find out what it really means to become a Perl master.*

### The road to mastery

Perl is a deceptively deep language: a novice can be productive in Perl within minutes, yet it takes years of practice to understand all of Perl's features and shortcomings. brian d foy knows this, and he prefaces Mastering Perl with the explanation that the journey to mastery will involve self-study and experimentation, and working with and learning from many different Perl programmers. What follows in the book is a tour-de-force of advanced Perl programming subjects intended to set the reader on the road to mastery and equip them with the knowledge they need to advance their own skills further.

### What's in Mastering Perl

Mastering Perl covers a lot of ground and you can find a complete listing of chapters [here](http://www.masteringperl.org/new-in-2e/). In every chapter I learned something useful, amazing or just plain cool about Perl. There were too many to mention them all, but a few highlights for me were:

-   The advanced regular expressions coverage, which culminates in writing a regex grammar (chapter 1)
-   In-depth coverage of taint, including how to circumvent it (chapter 2)
-   Writing your own Perl debugger (chapter 3)
-   Fixing other people's subroutines by wrapping them (chapter 9)
-   Writing/reading external data with Sereal (chapter 13)
-   Extending the modulino concept to work for testing (chapter 17)

Mastering Perl is also a pleasure to read: brian d foy's writing style is light hearted but professional, opinionated but reasoned. There is a good balance between code and words: concepts are introduced and explained without verbose prose and often the code examples do the talking.

Every chapter is self-contained: you won't find yourself thumbing back through previous chapters to understand concepts discussed later in the book. And because of it's modular structure, you can dive into the topics that interest you most and return to the remainder later on.

### Content changes

The content of the new edition has been refreshed and beefed-up; it's about 50 pages longer than the first time around. Every chapter has been updated and several have been extensively revised. A complete list of changes is [available](http://www.masteringperl.org/new-in-2e/) however the chapters with the most changes are:

-   The Advanced Regular Expressions chapter now covers recursion, grammars and other advanced regex features, culminating in [Randal Scwartz' JSON parser](http://www.perlmonks.org/?node_id=995856).
-   Secure Programming Techniques has new sections on symbolic references and preventing SQL injection with DBI. The [Safe](https://metacpan.org/pod/Safe) module is also covered.
-   The Detecting and Reporting Errors chapter updates the Fatal content with [autodie](https://metacpan.org/pod/autodie), and introduces [TryCatch](https://metacpan.org/pod/TryCatch).
-   The data formats of the Data Persistence chapter have been reorganized into Perl specific data storage and Perl agnostic data storage. New material has been added on JSON, Storable's [security issue](http://www.masteringperl.org/2012/12/the-storable-security-problem/), and Booking.com's [Sereal](https://metacpan.org/pod/Sereal).

### Style changes

![](/images/67/mastering_perl_first_second_cover.png)

The covers for the first and second editions are shown above. Style-wise O'Reilly has given Mastering Perl a spring clean. The cover title lettering has changed from Garamond to URW Typewriter, and the family of vicuñas has undergone a North Korean-style airbrushing, with the (presumably) troublesome second fawn removed entirely. I like the new cover, it feels cleaner and more modern but stays faithful to the Perl tradition with the blue background and camel-related animal on the cover. Beyond the cover, the book's pages have not changed in style at all, with the same fonts and spacing used throughout.

### Conclusion

Mastering Perl is enjoyable, informative and a worthy successor to Intermediate Perl. It equips the reader with a whole host of advanced tools and approaches for doing more with Perl now, whilst opening the doorway towards true language mastery.

The second edition of Mastering Perl is available to buy now from [O'Reilly](http://shop.oreilly.com/product/0636920012702.do?intcmp=il-prog-books-videos-cat-intsrch_perl_ct) and [Amazon](http://www.amazon.com/gp/product/144939311X/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=144939311X&linkCode=as2&tag=perltrickscom-20) (affiliate link).

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F67%2F2014%2F2%2F10%2FBook-review-Mastering-Perl-2nd-edition&text=Book%20review%3A%20Mastering%20Perl%202nd%20edition&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F67%2F2014%2F2%2F10%2FBook-review-Mastering-Perl-2nd-edition&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
