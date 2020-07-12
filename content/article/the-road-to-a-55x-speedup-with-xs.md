{
   "thumbnail" : "/images/61/thumb_EC20EEA0-FF2E-11E3-9D6C-5C05A68B9E16.png",
   "description" : "The power of C with the pleasure of Perl",
   "draft" : false,
   "image" : "/images/61/EC20EEA0-FF2E-11E3-9D6C-5C05A68B9E16.png",
   "categories" : "development",
   "date" : "2016-06-14T20:54:51",
   "title" : "The road to a 55x speedup with XS",
   "tags" : [
      "xs",
      "c",
      "uri_encode_xs",
      "uri_escape",
      "percent_encoding",
      "optimization",
      "benchmark"
   ],
   "authors" : [
      "david-farrell"
   ]
}

Lately my client has been concerned with improving their application speed, so naturally I started to think about XS, Perl's C macro language. With XS you can write C code and call it from Perl.

To test the waters I wrote a simple URI encoder/decoder in C and with some trial-and-error managed to make [URI::Encode::XS]({{<mcpan "URI::Encode::XS" >}}), a module that used it. "This is easy!" I thought and excitedly typed out a benchmarking [script](https://github.com/dnmfarrell/URI-Encode-XS/blob/master/bench). I benchmarked my module against [URI::Escape]({{<mcpan "URI::Escape" >}}) a venerable but rather slow *pure-Perl* URI encoder/decoder. You can imagine how crestfallen I was when I read the benchmark results to find that all of my effort only netted a 20% speedup. I wondered if Perl's string routines are so fast they're hard to improve upon.

### Renewed hope

Enter [URI::XSEscape](https://metacpan.org), a "quick and dirty" (the authors' words) XS implementation of URI::Escape. It was uploaded to CPAN last month. You can see the authors' [benchmarks]({{<mcpan "URI::XSEscape#BENCHMARKS" >}}) for yourself, but in my testing it appeared to be about 18.5 times faster than URI::Escape. That's not a misprint - on my laptop it encoded 2.75m strings per second, compared to 138k for URI::Escape. So how did they do it?

First let's look at my naive C encode implementation:

```perl
void *uri_encode (char *uri, const char *special_chars, char *buffer)
{
  int i = 0;
  /* \0 is null, end of the string */
  while (uri[i] != '\0')
  {
    int encode_char = 1;
    int j = 0;
    while (special_chars[j] != '\0')
    {
      if (uri[i] == special_chars[j])
      {
        /* do not encode char as it is in the special_chars set */
        encode_char = 0;
        break;
      }
      j++;
    }
    if (encode_char == 1)
    {
      char code[4];
      sprintf(code, "%%%02X", uri[i]);
      strcat(buffer, code);
    }
    else
    {
      char code[2];
      code[0] = uri[i];
      code[1] = '\0';
      strcat(buffer, code);
    }
    i++;
  }
}
```

Basically what this does is loop through the `uri` string, looking characters that are in the `special_chars` string, and if it finds a match, it percent encodes the character with `sprintf` and appends the result to `buffer` which is the encoded string. Compare this with the encode function from `URI::XSEscape` (I've simplified it slightly):

```perl
Buffer* uri_encode(Buffer* src, int length,
                   Buffer* tgt)
{
    int s = src->pos;
    int t = tgt->pos;

    while (s < (src->pos + length)) {
        unsigned char u = (unsigned char) src->data[s];
        char* v = uri_encode_tbl[(int)u];

        /* if current source character doesn't need to be encoded,
           just copy it to target*/
        if (!v) {
            tgt->data[t++] = src->data[s++];
            continue;
        }

        /* copy encoded character from our table */
        tgt->data[t+0] = '%';
        tgt->data[t+1] = v[0];
        tgt->data[t+2] = v[1];

        /* we used up 3 characters (%XY) in target
         * and 1 character from source */
        t += 3;
        ++s;
    }
    /* null-terminate target and return src as was left */
    src->pos = s;
    tgt->pos = t;
    buffer_terminate(tgt);
    return src;
}
```

This code loops through the input string but instead of comparing the current character to another string of special characters, it does a table lookup. This is much faster than looping through another string. Note how it doesn't use `sprintf` either - all the hex codes are pre-computed in `uri_encode_tbl`. Finally, instead of creating a new string and concatenating it to the output string, this code simply copies the output directly to the output string's memory location.

This code also avoid a subtle bug with my implementation: Perl strings can contain null characters, but in C null is used to terminate strings. Because URI::XSEscape's encode function accepts a length argument, it can encode strings will nulls and my version can't.

### Going faster

At this point I updated the encode/decode functions in URI::Encode::XS to be table based like URI::XSEscape and saw huge gains in performance, making URI::Encode::XS about 25 times faster than URI::Escape (URI::Encode::XS doesn't support user-defined escape values, so it's simpler than URI::XSEscape). I thought a 25x improvement was as good as it got, and was about done with the module, when I was contacted by [Christian Hansen](https://metacpan.org/author/CHANSEN) (author of [Time::Moment](https://metacpan.org/release/Time-Moment)). Christian overhauled my simple XS code to make it safer and faster. This is what became of the `uri_encode` C function:

```perl
size_t uri_encode (const char *src, const size_t len, char *dst)
{
  size_t i = 0, j = 0;
  while (i < len
  {
    const char * code = uri_encode_tbl[ (unsigned char)src[i] ];
    if (code)
    {
      memcpy(&dst[j], code, 3);
      j += 3;
    }
    else
    {
      dst[j] = src[i];
      j++;
    }
    i++;
  }
  dst[j] = '\0';
  return j;
}
```

This version looks up the character value in a pre-computed table and then uses `memcpy` to append it to the output string (avoiding 3 separate assignments). It also returns the length of encoded string, which is useful. After Christian's optimizations, my benchmarking [script](https://github.com/dnmfarrell/URI-Encode-XS/blob/master/bench) showed URI::Encode::XS's encoding function to be 55 times faster than URI::Escape (about 8m encoded strings per second). Much of the gains came from optimizing the [xsub](https://github.com/dnmfarrell/URI-Encode-XS/blob/df8009e9d7af4cf243fa29ca8aaa23982feeba58/XS.xs#L143).

### The power of C, the pleasure of Perl

To me the most magical thing about XS code is you call it from Perl:

```perl
use URI::Encode::XS 'uri_encode';

my $encoding = uri_encode($some_string); # super fast
```

So the user has the convenience of writing Perl code, but the benefit of the faster implementation. Perl is already pretty fast, but there are certain operations that are expensive. If you work on a Perl application, how much faster would it be if you could make all of the bottlenecks 55 times faster?

### Learning XS

If you'd like to learn more about XS, I'd strongly recommend this [series](http://world.std.com/~swmcd/steven/perl/pm/xs/intro/index.html) by Steven W McDougall. It's the best introduction I know of.

[XS is Fun](https://github.com/xsawyerx/xs-fun) is a more modern introduction to XS programming that takes you through the steps of writing an XS module and importing a C library.

Chapter 18 "Extending Perl: A First Course" in [Advanced Perl Programming](http://shop.oreilly.com/product/9781565922204.do) first edition has a good introduction to XS. It covers the most common macros for scalars, arrays and hashes which is useful (the second edition doesn't cover XS). [Extending and Embedding Perl](https://www.manning.com/books/extending-and-embedding-perl) goes further, with several tutorials on the different ways to call and receive data from XS. Both books are a bit dated but I found them valuable and an easier read than the official docs.

The official Perl documentation has useful reference sources: [perlxs]({{< perldoc "perlxs" >}}), [perlapi]({{< perldoc "perlapi" >}}) and [perlguts]({{< perldoc "perlxs" >}}). There is also [perlxstut]({{< perldoc "perlxs" >}}) but I would skip that in favor of the above resources.

Several times I've found XS macros used in Perl code that are not explained in any documentation (e.g. `dXSTARG`). In those cases it pays to have a copy of the Perl [source code](https://www.perl.org/get.html) - just grep the source and you'll find its definition with a comment (typically in `pp.h`).

### A note on the benchmarks

The benchmarks in this article were all run on my laptop, a Dell XPS 13 with 8GB RAM running Fedora 23. Different hardware will yield different results (Christian's benchmark showed URI::Encode::XS to be 90x (!) faster than URI::Escape).

The [script](https://github.com/dnmfarrell/URI-Encode-XS/blob/master/bench) counts how many times each module can encode a string per second. But a string of a different length, or with a different number of reserved characters will yield a different benchmark. For example benchmarking an empty string shows URI::Encode::XS to be just 9x times faster on my laptop.

The module versions were URI::Encode::XS v0.08 and URI::Escape v3.31. The Perl version was 5.22.

### Thanks

A big thank you to Christian Hansen and Jesse DuMond for your help with URI::Encode::XS. The module would not be half of what it is without your contributions.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
