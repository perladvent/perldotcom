{
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "debugging",
      "module"
   ],
   "categories" : "development",
   "slug" : "89/2014/5/15/Debunk-Perl-s-magic-with-B--Deparse",
   "date" : "2014-05-15T12:19:51",
   "title" : "Debunk Perl's magic with B::Deparse",
   "image" : "/images/89/ECED30D2-FF2E-11E3-9A57-5C05A68B9E16.jpeg",
   "description" : "We show you how to peak behind the curtain and inspect Perl code"
}


*The [B::Deparse](https://metacpan.org/pod/B::Deparse) module compiles a Perl program and then deparses it, producing the internally generated source code. What's the point of that you say? Well it let's you look behind the curtain and inspect how Perl is structuring the program code which can help you debug it, among other things.*

### Example

Consider the slurpy parameter optimization from this week's subroutine signatures [article](http://perltricks.com/article/88/2014/5/12/Benchmarking-subroutine-signatures). We know from speed benchmarks that the signature becomes ~30% faster with a slurpy parameter, and we can reason about why that is the case, but B::Deparse can *show* us why. Here is the code for two signatures, one normal and one using the slurpy parameter:

``` prettyprint
use feature 'signatures';

sub normal_signature ($foo) {}

sub slurpy_signature ($foo, @) {}
```

Now if we save the code as signatures.pl, we can use B::Deparse to inspect it at the command line:

``` prettyprint
$ perl -MO=Deparse signatures.pl
```

This generates the following output:

``` prettyprint
sub normal_signature {
    use feature 'signatures';
    die 'Too many arguments for subroutine' unless @_ <= 1;
    die 'Too few arguments for subroutine' unless @_ >= 1;
    my $foo = $_[0];
    ();
}
sub slurpy_signature {
    use feature 'signatures';
    die 'Too few arguments for subroutine' unless @_ >= 1;
    my $foo = $_[0];
    ();
}
signatures.pl syntax OK
```

The generated code shows how Perl structured the signatures.pl code internally. You can see how "slurpy\_signature" has one fewer die statement. This explains the improved performance as the subroutine has less to do. Magic debunked!

### More on B::Deparse

B::Deparse comes with extensive [documentation](https://metacpan.org/pod/B::Deparse) and has some useful options for altering the output.

One of the many gems in brian d foy's [Mastering Perl](http://www.amazon.com/gp/product/144939311X/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=144939311X&linkCode=as2&tag=perltrickscom-20) book is the B::Deparse entry in the "Cleaning up Perl" chapter (affiliate link). In the book brian shows several uses for B::Deparse including debugging one-liners and decoding obfuscated code. You can read a draft version of the chapter online [here](http://chimera.labs.oreilly.com/books/1234000001527/ch07.html).

PerlMonks has an [interesting](http://www.perlmonks.org/?node_id=804232) entry for those curious as to why the command line use of B::Deparse is "-MO=Deparse" and not "-MB::Deparse".

### Thanks

Thanks again to Perl Pumpking and [teflon](http://www.youtube.com/watch?v=Sp102BECq8s) man Ricardo Signes who put me on to using B::Deparse on subroutine signatures.

*Cover image [©](https://creativecommons.org/licenses/by/2.0/) [bark](https://www.flickr.com/photos/barkbud/4165385634) image has been digitaly altered*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
