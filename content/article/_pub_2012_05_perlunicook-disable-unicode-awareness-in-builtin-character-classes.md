{
   "slug" : "/pub/2012/05/perlunicook-disable-unicode-awareness-in-builtin-character-classes",
   "tags" : [],
   "date" : "2012-05-14T06:00:01-08:00",
   "draft" : null,
   "image" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "thumbnail" : null,
   "categories" : "unicode",
   "description" : "â 24: Disabling Unicode-awareness in builtin charclasses Many regex tutorials gloss over the fact that builtin character classes include far more than ASCII characters. In particular, classes such as \"word character\" (\\w), \"word boundary\" (\\b), \"whitespace\" (\\s), and \"digit\" (\\d)...",
   "title" : "Perl Unicode Cookbook: Disable Unicode-awareness in Builtin Character Classes"
}





â 24: Disabling Unicode-awareness in builtin charclasses {#Disabling-Unicode-awareness-in-builtin-charclasses}
--------------------------------------------------------

Many regex tutorials gloss over the fact that builtin character classes
include far more than ASCII characters. In particular, classes such as
"word character" (`\w`), "word boundary" (`\b`), "whitespace" (`\s`),
and "digit" (`\d`) respect Unicode.

Perl 5.14 added the `/a` regex modifier to disable `\w`, `\b`, `\s`,
`\d`, and the POSIX classes from working correctly on Unicode. This
restricts these classes to mach only ASCII characters. Use the
[re](http://perldoc.perl.org/re.html) pragma to restrict these claracter
classes in a lexical scope:

     use v5.14;
     use re "/a";

... or use the `/a` modifier to affect a single regex:

     my($num) = $str =~ /(\d+)/a;

You may always use speciï¬c un-Unicode properties, such `\p{ahex}` and
`\p{POSIX_Digit}`. Properties still work normally no matter what charset
modiï¬ers (`/d /u /l /a /aa`) are in eï¬ect.

Previous: [â 23: Get Character
Categories](/media/_pub_2012_05_perlunicook-disable-unicode-awareness-in-builtin-character-classes/perlunicook-get-character-categories.html)

Series Index: [The Standard
Preamble](/media/_pub_2012_05_perlunicook-disable-unicode-awareness-in-builtin-character-classes/perlunicook-standard-preamble.html)

Next: [â 25: Match Unicode Properties in
Regex](/media/_pub_2012_05_perlunicook-disable-unicode-awareness-in-builtin-character-classes/perlunicook-match-unicode-properties-in-regex.html)


