  {
    "title"       : "Perl / Unix One-liner Cage Match, Part 2",
    "authors"     : ["sundeep-agarwal"],
    "date"        : "2021-05-25T02:54:23",
    "tags"        : ["one-liners"],
    "draft"       : false,
    "image"       : "/images/perl-one-liners/on_the_mat.jpg",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "tutorials"
  }

In [Part 1](https://www.perl.com/article/perl-one-liners-part-1/), I compared Perl's regexp features with sed and Awk. In this concluding part, I'll cover examples that make use of Perl's extensive built-in features and third-party modules.

## Bigger library

Perl has a much bigger collection of built-in functions compared to Awk. For command-line usage, I often need `tr`, `join`, `map` and `grep`. I like that arrays and hashes are distinct in Perl and applying `sort` on these data types is much simpler compared to Awk.

### Append items to a list

[This problem](https://stackoverflow.com/q/49765879/4082052) wants to append columns to rows that have too few, like the `b`, `c` and `d` rows:

```bash
a,10,12,13
b,20,22
c,30
d,33
```

This appends zeros to list by using the `/e` again. This time, the Perl in the replacement counts the number of commas, and subtracts that from 3 to find out how many more columns it needs. The `x` is the string replication operator:

```bash
$ perl -pe 's|$|",0" x (3 - tr/,//)|e' ip.txt
a,10,12,13
b,20,22,0
c,30,0,0
d,33,0,0
```

### Reversing things

In [reverse complement DNA sequence for a specific field](https://stackoverflow.com/q/45571828/4082052), I need to select part of the string, complement it, and turn it around. I want to work on the third column:

```bash
ABC DEF GATTAG GHK
ABC DEF GGCGTC GHK
ABC DEF AATTCC GHK
```

I use the `tr` and `reverse` in the replacement side (with `/e` again):

```bash
$ perl -pe 's/^(\H+\h+){2}\K\H+/reverse $&=~tr|ATGC|TACG|r/e' test.txt
ABC DEF CTAATC GHK
ABC DEF GACGCC GHK
ABC DEF GGAATT GHK
```

Alternatively, I can use `-a`, which automatically splits on whitespace and puts the result in `@F`. I work on the third element then output `@F` again:

```bash
$ perl -lane '$F[2]=reverse $F[2]=~tr/ATGC/TACG/r; print "@F"' test.txt
ABC DEF CTAATC GHK
ABC DEF GACGCC GHK
ABC DEF GGAATT GHK
```

### Sort a CSV row

How about [sorting rows in csv file without header & first column](https://stackoverflow.com/q/48920626/4082052)? Here's some simple comma-separated values:

```bash
id,h1,h2,h3,h4,h5,h6,h7
101,zebra,1,papa,4,dog,3,apple
102,2,yahoo,5,kangaroo,7,ape
```

I use `-a` again, but also `-F,` to make comma as the field separator:

```bash
$ perl -F, -lane 'print join ",", $.==1 ? @F : (shift @F, sort @F)' ip.txt
id,h1,h2,h3,h4,h5,h6,h7
101,1,3,4,apple,dog,papa,zebra
102,2,5,7,ape,kangaroo,yahoo
```

The `$.` variable keeps track of the input line number. I use this to skip the first line (the header). In all other lines, I make a list of the first element of `@F` and the sorted list of the rest of the elements. Note that the numbers to be sorted in this example have the same number of digits, otherwise it wouldn't work.

### Insert incremental row and column labels

[Insert a row and a column in a matrix](https://stackoverflow.com/q/48985854/4082052) needs to add numerical labels with a fixed interval:

```bash
2 3 4 1 2 3
3 4 5 2 4 6
2 4 0 5 0 7
0 0 5 6 3 8
```

Here, I use `map` to generate the header:

```bash
$ perl -lane 'print join "\t", "", map {20.00+$_*0.33} 0..$#F if $.==1;
              print join "\t", 100+(0.33*$i++), @F' matrix.txt
        20      20.33   20.66   20.99   21.32   21.65
100     2       3       4       1       2       3
100.33  3       4       5       2       4       6
100.66  2       4       0       5       0       7
100.99  0       0       5       6       3       8

# with formatting and alternate way to join print arguments
$ perl -lane 'BEGIN{$,="\t"; $st=0.33}
              print "", map {sprintf "%.2f", 20+$_*$st} 0..$#F if $.==1;
              print sprintf("%.2f", 100+($st*$i++)), @F' matrix.txt
        20.00   20.33   20.66   20.99   21.32   21.65
100.00  2       3       4       1       2       3
100.33  3       4       5       2       4       6
100.66  2       4       0       5       0       7
100.99  0       0       5       6       3       8
```

## Using Perl modules

Apart from built-in functions, Standard or CPAN modules come in handy too. Load those with `-M` and put the import list after a `=`:

```bash
# randomize word list after filtering
$ s='floor bat to dubious four pact feed'
$ echo "$s" | perl -MList::Util=shuffle -lanE '
                    say join ":", shuffle grep {/[au]/} @F'
bat:four:pact:dubious

# remove duplicate elements while retaining input order
$ s='3,b,a,3,c,d,1,d,c,2,2,2,3,1,b'
$ echo "$s" | perl -MList::Util=uniq -F, -lanE 'say join ",", uniq @F'
3,b,a,c,d,1,2

# apply base64 decoding only for a portion of the string
$ s='123 aGVsbG8gd29ybGQK'
$ echo "$s" | perl -MMIME::Base64 -ane 'print decode_base64 $F[1]'
hello world
```

## CPAN

The Comprehensive Perl Archive Network ([CPAN](https://www.cpan.org)) has a huge collection of modules for various use cases.  Here are some examples.

### Extract IPv4 addresses

The [Regexp::Common](https://metacpan.org/pod/Regexp::Common) has recipes for common things you want to match. Here's some text with dotted-decimal IP addresses:

```bash
3.5.52.243 555.4.3.1 34242534.23.42.42
foo 234.233.54.123 baz 4.4.4.3123
```

It's easy to extract the IPv4 addresses:

```bash
$ perl -MRegexp::Common=net -nE 'say $& while /$RE{net}{IPv4}/g' ipv4.txt
3.5.52.243
55.4.3.1
34.23.42.42
234.233.54.123
4.4.4.31
```

I can match only if the IPv4 address isn't surrounded by digit characters, so I don't match in the middle of `34242534.23.42.42`:

```bash
$ perl -MRegexp::Common=net -nE '
        say $& while /(?<!\d)$RE{net}{IPv4}(?!\d)/g' ipv4.txt
3.5.52.243
234.233.54.123
```

### Real CSV processing

Earlier I did some simple CSV processing, but if I want to do it for real I can use [Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS) to make sure everything happens correctly. This one handles the quoted field `fox,42`:

```bash
$ s='eagle,"fox,42",bee,frog\n1,2,3,4'

# note that neither -n nor -p are used here
$ printf '%b' "$s" | perl -MText::CSV_XS -E 'say $row->[1]
                     while $row = Text::CSV_XS->new->getline(*ARGV)'
fox,42
2
```

### Processing XML

Processing XML files is another format that's easy to mess up. Many people try to do this with regexp, but that can easily go wrong. Here's an example file:

```bash
<doc>
    <greeting type="ask">Hi there. How are you?</greeting>
    <greeting type="reply">I am good.</greeting>
    <color>
        <blue>flower</blue>
        <blue>sand stone</blue>
        <light-blue>sky</light-blue>
        <light-blue>water</light-blue>
    </color>
</doc>
```

The `xpath` (a Perl program) and `xmllint` can be used for processing XML files:

```bash
$ xpath -e '//blue/text()' sample.xml
Found 2 nodes in sample.xml:
-- NODE --
flower
-- NODE --
sand stone
$ xpath -q -e '//blue/text()' sample.xml
flower
sand stone

$ xmllint --xpath '//blue/text()' sample.xml
flower
sand stone
```

Using the [XML::LibXML](https://metacpan.org/pod/XML::LibXML) module will help if you need Perl's power:

```bash
$ perl -MXML::LibXML -E '
    $ip = XML::LibXML->load_xml(location => $ARGV[0]);
    say $_->to_literal() for $ip->findnodes("//blue")' sample.xml
flower
sand stone

$ perl -MXML::LibXML -E '
    $ip = XML::LibXML->load_xml(location => $ARGV[0]);
    say uc $_->to_literal() for $ip->findnodes("//blue")' sample.xml
FLOWER
SAND STONE
```

### Processing JSON

JSON files have the same issue. You don't want to do regexes on this:

```bash
$ s='{"greeting":"hi","marks":[78,62,93],"fruit":"apple"}'
```

Various JSON modules, such as [Cpanel::JSON::XS](http://metacpan.org/pod/Cpanel::JSON::XS) can handle this. For example, pretty printing:

```bash
$ echo "$s" | cpanel_json_xs
{
   "fruit" : "apple",
   "greeting" : "hi",
   "marks" : [
      78,
      62,
      93
   ]
}
```

And here's a particular selection:

```bash
$ echo "$s" | perl -MCpanel::JSON::XS -0777 -E '$ip=decode_json <>;
              say join ":", @{$ip->{marks}}'
78:62:93
```

Sometimes it's easier to put that in a script (although that's not really a one-liner anymore). I use a Bash function as a shortcut:

```bash
$ pj() { perl -MCpanel::JSON::XS -0777 -E '$ip=decode_json <>;'"$@" ; }

$ echo "$s" | pj 'say $ip->{fruit}'
apple
$ echo "$s" | pj 'say join ":", @{$ip->{marks}}'
78:62:93
```

A non-Perl example of the same thing is [jq](https://stedolan.github.io/jq/), but that's something you have to install separately and might not be available:

```bash
$ echo "$s" | jq '.fruit'
"apple"
$ echo "$s" | jq '.marks | join(":")'
"78:62:93"
```

## Speed

Perl is usually slower compared to specialized tools, but the regexp engine performs better for certain cases of backreferences and quantifiers.

```bash
$ time LC_ALL=C grep -xE '([a-z]..)\1' /usr/share/dict/words > f1
real    0m0.074s

$ time perl -ne 'print if /^([a-z]..)\1$/' /usr/share/dict/words > f2
real    0m0.024s

$ time LC_ALL=C grep -xP '([a-z]..)\1' /usr/share/dict/words > f3
real    0m0.010s
```

Perl's hash implementation performs better compared to Awk's associative arrays for large number of keys. The `SCOWL-wl.txt` file used below was created using [app.aspell.net](http://app.aspell.net/create). `words.txt` is from `/usr/share/dict/words`. Mawk is usually faster, but GNU Awk does better in this particular case.

```bash
$ wc -l words.txt SCOWL-wl.txt
  99171 words.txt
 662349 SCOWL-wl.txt
 761520 total

# finding common lines between two files
# Case 1: shorter file passed as the first argument
$ time mawk 'NR==FNR{a[$0]; next} $0 in a' words.txt SCOWL-wl.txt > t1
real    0m0.296s
$ time gawk 'NR==FNR{a[$0]; next} $0 in a' words.txt SCOWL-wl.txt > t2
real    0m0.210s
$ time perl -ne 'if(!$#ARGV){$h{$_}=1; next}
                 print if exists $h{$_}' words.txt SCOWL-wl.txt > t3
real    0m0.189s

# Case 2: longer file passed as the first argument
$ time mawk 'NR==FNR{a[$0]; next} $0 in a' SCOWL-wl.txt words.txt > f1
real    0m0.539s
$ time gawk 'NR==FNR{a[$0]; next} $0 in a' SCOWL-wl.txt words.txt > f2
real    0m0.380s
$ time perl -ne 'if(!$#ARGV){$h{$_}=1; next}
                 print if exists $h{$_}' SCOWL-wl.txt words.txt > f3
real    0m0.351s
```

## Other things to read

* My ebook on [Perl one-liners](https://learnbyexample.github.io/learn_perl_oneliners/)

* [Awesome Perl](https://github.com/hachiojipm/awesome-perl) has a curated list of awesome Perl5 frameworks, libraries and software

* [Perl XML::LibXML by example](https://grantm.github.io/perl-libxml-by-example/) for a detailed book on `XML::LibXML` module

<hr/>

*[image from <a href="https://www.flickr.com/photos/ljsilver71/14139619905/in/photolist-nxtfo6-xDEB2-2hdZdFv-XPjLeQ-6nGeoM-29v1fwo-puR1K-2kNaM6P-nxtgeK-a2nLuc-qvDmkw-nfYDTu-6R6FQB-2i1Psj2-74Nwsu-2kNam6c-c2EsqS-2i1PsgB-nvqjK1-2i1RTpS-2i1T2RR-2i1S2Wr-2i1Psik-2gcee9c-2i1PHci-23p4pKV-2i4eukR-urRBFS-nzf35k-6R6Fmp-nvqicm-pvqAaK-6RaKuU-2i1S8S9-2i1Tbr1-2i1Psd5-2i1S9WP-2i1T2LL-nfYwEo-2i1RTnx-2i1RTbW-2i1PsbB-2i1S2VE-2i1S8Tg-2tFtHH-2i1Psku-2i1TbFV-614Rh8-2i1S8Va-27YK5Fj">Riccardo Maria Mantero</a> on Flickr, (CC BY-NC-ND 2.0)]*
