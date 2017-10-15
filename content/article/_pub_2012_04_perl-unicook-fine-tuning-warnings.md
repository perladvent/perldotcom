{
   "description" : "℞ 2: Fine-tuning Unicode warnings It's easy to get Unicode wrong, especially when handling user input and dealing with multiple encodings. Perl is happy to help you detect unexpected conditions of your data. Perl is also happy to let you...",
   "draft" : null,
   "tags" : [],
   "slug" : "/pub/2012/04/perl-unicook-fine-tuning-warnings.html",
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Fine-Tuning Unicode Warnings",
   "authors" : [
      "tom-christiansen"
   ],
   "image" : null,
   "thumbnail" : null,
   "date" : "2012-04-05T06:00:01-08:00"
}



℞ 2: Fine-tuning Unicode warnings
---------------------------------

It's easy to get Unicode wrong, especially when handling user input and dealing with multiple encodings. Perl is happy to help you detect unexpected conditions of your data. Perl is also happy to let you decide if these unexpected conditions are worth warning about.

As of v5.14, Perl distinguishes three subclasses of UTF‑8 warnings. While the `utf8` lexical warning category existed prior to 5.14, you may now handle these warnings individually:

     use v5.14;                  # subwarnings unavailable any earlier
     no warnings "nonchar";      # the 66 forbidden non-characters
     no warnings "surrogate";    # UTF-16/CESU-8 nonsense
     no warnings "non_unicode";  # for codepoints over 0x10_FFFF

Previous: [℞ 1: Always Decompose and Recompose](/pub/2012/04/perl-unicode-cookbook-always-decompose-and-recompose.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 3: Enable UTF-8 Literals](/pub/2012/04/perlunicook-enable-utf-8-literals.html)
