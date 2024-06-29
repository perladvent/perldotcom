{
   "authors" : [
      "chromatic"
   ],
   "draft" : null,
   "slug" : "/pub/2011/06/new-features-of-perl-514-unicode-strings.html",
   "description" : "Perl 5.14 provides a new feature called unicode_strings to improve Unicode string handling.",
   "categories" : "development",
   "title" : "New Features of Perl 5.14: unicode_strings",
   "image" : null,
   "date" : "2011-06-08T11:12:39-08:00",
   "tags" : [],
   "thumbnail" : null
}



Perl 5.14 is now available. While this latest major release of Perl 5 brings with it many bugfixes, updates to the core libraries, and the usual performance improvements, it also includes a few nice new features.

One such feature is the new `unicode_strings` feature, enabled with `use feature 'unicode_strings';` or `use feature ':5.14';`. (Perl 5.12 first introduced this feature, though it remained incomplete until the development of 5.14. Fortunately, you can write `use feature ':5.12';` while running with 5.14 and still get all of the benefits of the improved form in Perl 5.14.)

`unicode_strings` tells the Perl 5 compiler to assume Unicode semantics for all string operations within the enclosing lexical scope. In other words, Perl will treat all strings as if they contain Unicode characters and not merely bytes. This fixes an issue when your code handles text outside of the strict ASCII range.

For example, what should Perl assume if you read a character with a code point between 128 and 255? It's obviously not ASCII text. Is it Latin-1? Is it a raw byte? What should happen?

If you intend it as a Latin-1 character (Ö, for example), then the regular expression metacharacter `\w` should match it, because an O even with a diaresis is still a letter. The Perl 5 documentation refers to this as "character semantics".

If you intend it as the byte value 214, then `\w` should *not* match it (though why are you using a regular expression against it?). The Perl 5 documentation refers to this as "byte semantics".

Now assume you have several strings from several places and you don't know the exact encodings of all of those sources and you want to concatenate two strings or interpolate them into a third string. What happens?

With `unicode_strings` in effect, Perl 5 prefers to use character semantics for all string operations. You can override this lexically with `no feature 'unicode_strings';` or `use locale;`.

For more information, see  [feature]({{< perldoc "feature" "the-%27unicode_strings%27-feature" >}}) and especially [The Unicode Bug" in perlunicode]({{< perldoc "perlunicode" "The-%22Unicode-Bug%22" >}}).
