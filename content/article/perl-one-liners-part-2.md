  {
    "title"       : "Perl / Unix One-liner Cage Match, Part 2",
    "authors"     : ["sundeep-agarwal"],
    "date"        : "2021-05-25T02:54:23",
    "tags"        : ["one-liners"],
    "draft"       : true,
    "image"       : "/images/perl-one-liners/on_the_mat.jpg",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "tutorials"
  }

## Bigger library

Perl has a much bigger collection of built-in functions compared to Awk. For command-line usage, I often need `tr`, `join`, `map` and `grep`. Also, `sort` is much simpler to use in Perl compared to Awk, along with array/hash distinction. Here are some examples.

### Append items to a list

This problem wants to append columns to rows that have too few, like this where the `c` and `d` rows don't have as many columns:

```bash
a,10,12,13
b,20,22
c,30
d,33
```

[This appends zeros to list](https://stackoverflow.com/questions/49765879/append-zeros-to-list) by using the `/e` again. This time, the Perl in the replacement counts the number of commas, and subtracts that from 3 to find out how many more columns it needs. The `x` is the string replication operator:

```
$ perl -pe 's|$|",0" x (3 - tr/,//)|e' ip.txt
a,10,12,13
b,20,22,0
c,30,0,0
d,33,0,0
```

### Reversing things

In [reverse complement DNA sequence for a specific field](https://stackoverflow.com/questions/45571828/execute-bash-command-inside-awk-and-print-command-output), I need to select part of the string, complement it, and turn it around:

```bash
ABC DEF GATTAG GHK
ABC DEF GGCGTC GHK
ABC DEF AATTCC GHK
```

Use the `tr` and `reverse` in the replacement side (with `/e` again):

```bash
$ perl -pe 's/^(\H+\h+){2}\K\H+/reverse $&=~tr|ATGC|TACG|r/e' test.txt
ABC DEF CTAATC GHK
ABC DEF GACGCC GHK
ABC DEF GGAATT GHK
```

With `-a`, it automatically splits on whitespace and puts the result in `@F`. Do the work on the right element then output `@F` again:

```bash
$ perl -lane '$F[2]=reverse $F[2]=~tr/ATGC/TACG/r; print "@F"'
ABC DEF CTAATC GHK
ABC DEF GACGCC GHK
ABC DEF GGAATT GHK
```

### Sort a CSV row

How about [sorting rows in csv file without header & first column](https://stackoverflow.com/questions/48920626/sort-rows-in-csv-file-without-header-first-column)? Assuming this is simple CSV like this:

```bash
id,h1,h2,h3,h4,h5,h6,h7
101,zebra,1,papa,4,dog,3,apple
102,2,yahoo,5,kangaroo,7,ape
```

This uses `-a` again, but also `-F` to make the record separator the comma:

```
$ perl -F, -lane 'print join ",", $.==1 ? @F : (shift @F, sort @F)' ip.txt
id,h1,h2,h3,h4,h5,h6,h7
101,1,3,4,apple,dog,papa,zebra
102,2,5,7,ape,kangaroo,yahoo
```

I use the `$.`, the input line number, to skip the first line (the header). In all other lines, I make a list of the first element of `@F` and the sorted list of the rest of the elements.

## Using Perl modules

Apart from built-in functions, Standard or CPAN modules come in handy too. Load those with `-M` and put the import list after a `=`:

```bash
$ s='floor bat to dubious four'
$ echo "$s" | perl -MList::Util=shuffle -lanE 'say join ":", shuffle @F'
bat:four:dubious:floor:to

$ s='3,b,a,3,c,d,1,d,c,2,2,2,3,1,b'
$ echo "$s" | perl -MList::Util=uniq -F, -lanE 'say join ",", uniq @F'
3,b,a,c,d,1,2

$ s='123 aGVsbG8gd29ybGQK'
$ echo "$s" | perl -MMIME::Base64 -ane 'print decode_base64 $F[1]'
hello world
```

## CPAN

The Comprehensive Perl Archive Network ([CPAN](https://www.cpan.org)) has a huge collection of modules for various use cases.  Here are some examples.

### Extract IPv4 addresses

The [Regexp::Common](https://metacpan.org/pod/Regexp::Common) has shortcuts for common things you want to match. Here's some text with dotted-decimal IP addresses:

```bash
3.5.52.243 5.4.3 34242534.23.42.42
foo 234.233.54.123 baz 4.4.4.3
```

It's easy to extract the IPv4 addresses:

```
$ perl -MRegexp::Common=net -nE 'say $& while /$RE{net}{IPv4}/g' ipv4.txt
3.5.52.243
34.23.42.42
234.233.54.123
4.4.4.3
```

### Real CSV processing

Earlier I did some simple CSV procesing, but if I want to do it for real I can use [Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS) to make sure everything happens correctly. This one handles the quoted field `fox,42`:

```bash
$ s='eagle,"fox,42",bee,frog\n1,2,3,4'

# note that neither -n nor -p are used here
$ printf '%b' "$s" | perl -MText::CSV_XS -E 'say $row->[1]
                     while $row = Text::CSV_XS->new->getline(*ARGV)'
fox,42
2
```

### Processing XML

Processing XML files is another format that's easy to mess up. Many people try to do this with regex, but that can easily go wrong. Here's an example file:

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

The `xpath` (a Perl program) and `xmllint` but their output is annoying and hard to change:

```bash
$ xmllint --xpath '//blue/text()' test.xml
flowersand stone
brian@otter Desktop [3570]
$ xpath test.xml '//blue/text()'
Found 2 nodes:
-- NODE --
flower-- NODE --
sand stone
```

The [XML::LibXML](https://metacpan.org/pod/XML::LibXML) module can handle this easily because I'm in control:

```bash
$ perl -MXML::LibXML -E '
	$ip = XML::LibXML->load_xml(location => $ARGV[0]);
    say $_->to_literal() for $ip->findnodes("//blue")' sample.xml
flower
sand stone
```


### Processing JSON

JSON files have the same issue. You don't want to do regexes on this:

```bash
$ s='{"greeting":"hi","marks":[78,62,93],"fruit":"apple"}'
```

Various JSON modules, such as [Cpanel::JSON::XS](http://metacpan.org/pod/Cpanel::JSON::XS) can handle this:

```
$ echo "$s" | perl -MCpanel::JSON::XS -0777 -E '$ip=decode_json <>;
              say join ":", @{$ip->{marks}}'
78:62:93
```

Sometimes it's easier to put that in a script (although that's not really a one-liner anymore):

```
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

A non-Perl example of the same thing is [jq](https://stedolan.github.io/jq/), but that's something you have to install separately and might not be available:

```bash
$ echo $s | jq '.marks | join(":")'
"78:62:93"
```

## Speed

Perl is usually slower, but performs better for certain cases of backreferences and quantifiers.

```bash
$ time LC_ALL=C grep -xE '([a-z]..)\1' /usr/share/dict/words > f1
real    0m0.135s

$ time perl -ne 'print if /^([a-z]..)\1$/' /usr/share/dict/words > f2
real    0m0.039s

$ time LC_ALL=C grep -xP '([a-z]..)\1' /usr/share/dict/words > f3
real    0m0.012s
```

Perl's hash implementation performs better compared to Awk's associative arrays. The `SCOWL-wl.txt` file used below was created using [app.aspell.net](http://app.aspell.net/create). `words.txt` is from `/usr/share/dict/words`.

```bash
$ wc -l words.txt SCOWL-wl.txt
  99171 words.txt
 662349 SCOWL-wl.txt
 761520 total

# finding common lines between two files
# shorter file passed as first argument here
$ time awk 'NR==FNR{a[$0]; next} $0 in a' words.txt SCOWL-wl.txt > t1
real    0m0.376s
$ time perl -ne 'if(!$#ARGV){$h{$_}=1; next}
                 print if exists $h{$_}' words.txt SCOWL-wl.txt > t2
real    0m0.284s

# longer file passed as first argument here
$ time awk 'NR==FNR{a[$0]; next} $0 in a' SCOWL-wl.txt words.txt > f1
real    0m0.603s
$ time perl -ne 'if(!$#ARGV){$h{$_}=1; next}
                 print if exists $h{$_}' SCOWL-wl.txt words.txt > f2
real    0m0.536s
```

## Other things to read

* [Pitfalls of reading file into shell variable](https://stackoverflow.com/questions/7427262/how-to-read-a-file-into-a-variable-in-shell/22607352#22607352)

* Dave Cross's [Perl Command-Line Options](https://www.perl.com/pub/2004/08/09/commandline.html/)

* Known bugs in the [GNU grep manual](https://www.gnu.org/software/grep/manual/grep.html#Known-Bugs)

* [Awesome Perl](https://github.com/hachiojipm/awesome-perl) has a curated list of awesome Perl5 frameworks, libraries and software

* [Perl XML::LibXML by example](https://grantm.github.io/perl-libxml-by-example/) for a detailed book on `XML::LibXML` module

<hr/>

*[image from <a href="https://www.flickr.com/photos/ljsilver71/14139619905/in/photolist-nxtfo6-xDEB2-2hdZdFv-XPjLeQ-6nGeoM-29v1fwo-puR1K-2kNaM6P-nxtgeK-a2nLuc-qvDmkw-nfYDTu-6R6FQB-2i1Psj2-74Nwsu-2kNam6c-c2EsqS-2i1PsgB-nvqjK1-2i1RTpS-2i1T2RR-2i1S2Wr-2i1Psik-2gcee9c-2i1PHci-23p4pKV-2i4eukR-urRBFS-nzf35k-6R6Fmp-nvqicm-pvqAaK-6RaKuU-2i1S8S9-2i1Tbr1-2i1Psd5-2i1S9WP-2i1T2LL-nfYwEo-2i1RTnx-2i1RTbW-2i1PsbB-2i1S2VE-2i1S8Tg-2tFtHH-2i1Psku-2i1TbFV-614Rh8-2i1S8Va-27YK5Fj">Riccardo Maria Mantero</a> on Flickr, (CC BY-NC-ND 2.0)]*
