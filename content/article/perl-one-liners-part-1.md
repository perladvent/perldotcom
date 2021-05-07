  {
    "title"       : "Perl / Unix One-liner Cage Match, Part 1",
    "authors"     : ["sundeep-agarwal"],
    "date"        : "2021-05-11T02:54:23",
    "tags"        : ["one-liners"],
    "draft"       : true,
    "image"       : "/images/perl-one-liners/cage_match.jpg",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "tutorials"
  }

<br/>

A shell (like Bash) provides built-in commands and scripting features to easily solve and automate various tasks. External commands like grep, sed, Awk, sort, find, or parallel can be combined to work with each other. Sometimes you can use Perl either as a single replacement or a complement to them for specific use cases.

Perl is the most robust portable option for text processing needs. Perl has a feature rich regular expression engine, built-in functions, an extensive ecosystem, and is quite portable. However, Perl may have slower performance compared to specialized tools and can be more verbose.

## One-liners or scripts?

For assembly-level testing of a digital signal processing (DSP) chip, I had to replicate the same scenario for multiple address ranges. My working knowledge of Linux command line was limited at that time and I didn't know how to use sed or Awk. I used Vim and Perl for all sorts of text processing needs.

I didn't know about Perl's options for one-liners, so I used to modify a script whenever I had to do substitutions for multiple files. Once, I even opened the files as Vim buffers and applied a `bufdo` command to see if that would make my workflow simpler. If I had known about Perl one-liners, I could have easily utilized find and Bash globs to make my life easier, for example:

```bash
$ perl -i -pe 's/0xABCD;/0x1234;/; s/0xDEAD;/0xBEEF;/' *.tests
```

The `-i` option will write back the changes to the source files. If needed, I can pass an argument to create a backup of the original files. For example, `-i.bkp` will create *ip.txt.bkp* as the backup for *ip.txt* passed as the input file. I can also put the backups in another existing directory. The `*` gets expanded to original filename:

```bash
$ mkdir backups
$ perl -i'backups/*' -pe 's/SEARCH/REPLACE/g' *.txt
```

## Powerful regexp features

Perl regexps are much more powerful than either basic or extended regular expressions used by utilities. The common features I often use are non-greedy and possessive quantifiers, lookarounds, the `e` flag, subexpression calls, and `(*SKIP)(*FAIL)`. Here are some examples from StackOverflow threads that I have answered over the years.

### Skip some matches

This question needed [to convert avr-asm to arm-gnu comments](https://stackoverflow.com/q/64368280/4082052). The starting file looks like this:

```bash
ABC r1,';'
ABC r1,";" ; comment
  ;;;
```

I need to change `;` to `@`, but `;` within single or double quotes shouldn't be affected. I can match quoted `;` in the first branch of the alternation and use `(*SKIP)(*F)` to not replace those:

```bash
$ perl -pe 's/(?:\x27;\x27|";")(*SKIP)(*F)|;/@/' ip.txt
ABC r1,';'
ABC r1,";" @ comment
  @;;
```

I use `(*SKIP)(*F)` so often that I wish it had a shorter syntax, `(*SF)` for example.

### Replace a string with an incrementing value

I can [replace strings with incrementing value](https://stackoverflow.com/q/42554684/4082052). The `/e` on a substitution allows me to treat the replacement side as Perl code. Whatever that code evaluates to is the replacement. That can be a variable that I increment:

```bash
$ echo 'a | a | a | a | a | a | a | a' | perl -pe 's/ *\| */$i++/ge'
a0a1a2a3a4a5a6a
```

### Reverse a substring

I also used the `/e` trick [to reverse the text matched by a pattern](https://stackoverflow.com/q/63681983/4082052):

```bash
$ echo 'romarana789:qwerty12543' | perl -pe 's/\d+$/reverse $&/e'
romarana789:qwerty34521
```

### Do some arithmetic

Adding another `/e` to get `/ee` means there are two rounds of Perl code. I evaluate the replacement side to get the string that I'll evaluate as Perl code. In [Arithmetic replacement in a text file](https://stackoverflow.com/q/62241101/4082052), I need to find simple arithmetic, like `25100+10`, and replace that with its arithmetic result:

```bash
id=25100+10
xyz=1+
abc=123456
conf_string=LMN,J,IP,25100+1,0,3,1
```

I can do that with one `/e` by matching the numbers and doing some Perl on the replacement side:

```bash
$ perl -pe 's/(\d+)\+(\d+)/$1+$2/ge' ip.txt
id=25110
xyz=1+
abc=123456
conf_string=LMN,J,IP,25101,0,3,1
```

But instead of matching the numbers separately, I can match the whole expression. The match is in `$&`, so the first `/e` interpolates that to `25100+10`. The second round runs that as Perl, which is addition:

```bash
$ perl -pe 's/\d+\+\d+/$&/gee' ip.txt
id=25110
xyz=1+
abc=123456
conf_string=LMN,J,IP,25101,0,3,1
```

That would also make it easier to handle a set of operators:

```bash
$ echo '2+3 10-3 8*8 11/5' | perl -pe 's|\d+[+/*-]\d+|$&|gee'
5 7 64 2.2
```

## Handling the newline

I want to un-hypenate this text:

```bash
Hello there.
It will rain to-
day. Have a safe
and pleasant jou-
rney.
```

Unlike sed and Awk, you can choose to preserve the record separator in Perl. That makes it easier to solve this problem:

```bash
$ perl -pe 's/-\n//' msg.txt
Hello there.
It will rain today. Have a safe
and pleasant journey.
```

See [remove dashes and replace newlines with spaces](https://unix.stackexchange.com/q/647648/109046) for a similar problem and to compare the Perl solution with sed/Awk.

## Multiline fixed-string substitution

Escaping regexp metacharacters is simpler with built-in features in Perl. Combined with slurping entire input file as a single string, I can easily perform multiline fixed-string substitutions. Consider this sample input:

```bash
This is a multiline
sample input with lots
of special characters
like . () * [] $ {}
^ + ? \ and ' and so on.
```

Say you have a file containing the lines you wish to match:

```bash
like . () * [] $ {}
^ + ? \ and ' and so on.
```

And a file containing the replacement string:

```bash
---------------------
$& = $1 + $2 / 3 \ 4
=====================
```

Here's one way to do it with Perl:

```bash
$ perl -0777 -ne '$#ARGV==1 ? $s=$_ : $#ARGV==0 ? $r=$_ :
                  print s/\Q$s/$r/gr' search.txt replace.txt ip.txt
This is a multiline
sample input with lots
of special characters
---------------------
$& = $1 + $2 / 3 \ 4
=====================
```

Note that in the above solution, contents of `search.txt` and `replace.txt` are also processed by the Perl command. Avoid using shell variables to save their contents, since trailing newlines and ASCII NUL characters will require special attention.

Awk and sed do not have an equivalent option to slurp the entire input file content. Sed is Turing complete and Awk is a programming language, so you can write code for it if you wish, in addition to the code you'd need for escaping the metacharacters.

## Better regexp support

Some other regexp libraries have problems tied to whatever they use to implement them. GNU versions, for example, may have some bugs that other implementations may not have. Which version you use can give different results. Perl, however, has the same bugs everywhere.

### Back references

There's a [problem with backreferences in glibc](https://sourceware.org/bugzilla/show_bug.cgi?id=25322) that I found and [reported for grep](https://debbugs.gnu.org/cgi/bugreport.cgi?bug=26864). This bug is seen in at least GNU implementations of grep and sed. As far as I know, no implementation of Awk supports backreferences within regexp definition.

I wanted to get words having two occurrences of consecutive repeated characters. This example takes some time and results in no output:

```bash
$ grep -xiE '([a-z]*([a-z])\2[a-z]*){2}' /usr/share/dict/words
```

It does work when the nesting is unrolled or PCRE is used:

```bash
$ grep -xiE '[a-z]*([a-z])\1[a-z]*([a-z])\2[a-z]*' /usr/share/dict/words
Abbott
Annabelle
...

$ grep -xiP '([a-z]*([a-z])\2[a-z]*){2}' /usr/share/dict/words
Abbott
Annabelle
...
```

Here's the Perl, which is the original regexp:

```bash
$ perl -ne 'print if /^([a-z]*([a-z])\2[a-z]*){2}$/i' /usr/share/dict/words
Abbott
Annabelle
...
```

### Word boundaries

[Why doesn't this sed command replace the 3rd-to-last "and"?](https://unix.stackexchange.com/q/579889/109046) shows another interesting bug when word boundaries and group repetition are involved. This bug is seen in anything using the regexp stuff from glibc (as you would on Linux):

This incorrectly matches because there is no word boundary in the middle of "cocoa":

```bash
$ sed --version
sed (GNU sed) 4.8
$ echo 'cocoa' | sed -nE '/(\bco){2}/p'
cocoa
```

Without the quantifier, there's no problem and no matches:

```bash
$ echo 'cocoa' | sed -nE '/\bco\bco/p'
$ echo 'cocoa' | perl -ne 'print if /(\bco){2}/'
```

Here's another example from GNU sed. This modifies the line because it thinks it finds "it" as a separate word two times after "with", but the second is really in the middle of "sit":

```bash
$ echo 'it line with it here sit too' | sed -E 's/with(.*\bit\b){2}/XYZ/'
it line XYZ too
```

Change the pattern to get rid of the quantifier and it works correctly:

```bash
$ echo 'it line with it here sit too' | sed -E 's/with.*\bit\b.*\bit\b/XYZ/'
it line with it here sit too
$ echo 'it line with it here sit too it a' | sed -E 's/with.*\bit\b.*\bit\b/XYZ/'
it line XYZ a

# Perl doesn't need such workarounds
$ echo 'it line with it here sit too' | perl -pe 's/with(.*\bit\b){2}/XYZ/'
it line with it here sit too
$ echo 'it line with it here sit too it a' | perl -pe 's/with(.*\bit\b){2}/XYZ/'
it line XYZ a
```

## Stay tuned

I'll have more in Part 2, where I'll delve into XML, JSON, and CSV.

## Other things to read

* [When to use grep, sed, Awk, Perl, etc](https://unix.stackexchange.com/q/303044/109046)

* Dave Cross's [Perl Command-Line Options](https://www.perl.com/pub/2004/08/09/commandline.html/)

* [Pitfalls of reading file into shell variable](https://stackoverflow.com/q/7427262/4082052) and my blog post on [multiline fixed-string search and replace with cli tools](https://learnbyexample.github.io/multiline-search-and-replace/)

* Known bugs section in the [GNU grep manual](https://www.gnu.org/software/grep/manual/grep.html#Known-Bugs)

* [BSD/macOS sed vs GNU sed vs the POSIX sed specification](https://stackoverflow.com/q/24275070/4082052)

* [Differences between sed on Mac OSX and other standard sed](https://unix.stackexchange.com/q/13711/109046)

<hr/>

*[image from <a href="https://www.flickr.com/photos/ppetrovic72/3981925030/in/photolist-74SpzQ-bU41RP-2kNaLcQ-nxdaVA-bKtznV-bwyLmq-beJniM-58jr5R-2kNakh3-6fxhGR-nxtfo6-xDEB2-2hdZdFv-XPjLeQ-6nGeoM-29v1fwo-puR1K-2kNaM6P-nxtgeK-a2nLuc-qvDmkw-nfYDTu-6R6FQB-2i1Psj2-74Nwsu-2kNam6c-c2EsqS-2i1PsgB-nvqjK1-2i1RTpS-2i1T2RR-2i1S2Wr-2i1Psik-2gcee9c-2i1PHci-23p4pKV-2i4eukR-urRBFS-nzf35k-6R6Fmp-nvqicm-pvqAaK-6RaKuU-2i1S8S9-2i1Tbr1-2i1Psd5-2i1S9WP-2i1T2LL-nfYwEo-2i1RTnx">Dim Sum!</a> on Flickr, (CC BY-NC-ND 2.0)]*
