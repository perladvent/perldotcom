{
   "date" : "2013-04-02T22:14:45",
   "image" : null,
   "title" : "Repeat strings with the repetition operator Repeat strings with the repetition operator",
   "slug" : "10/2013/4/2/Repeat-strings-with-the-repetition-operator-Repeat-strings-with-the-repetition-operator",
   "draft" : false,
   "categories" : "development",
   "tags" : [
      "operator",
      "string"
   ],
   "authors" : [
      "david-farrell"
   ],
   "description" : "You get the idea - Perl has a repetition operator (x) that repeats the scalar or list on its left by the number on it's right (like multiplication)."
}


You get the idea - Perl has a repetition operator (x) that repeats the scalar or list on its left by the number on it's right (like multiplication).

```perl
my $string = 'I like chocolate';
print $string x 10;
#results

I like chocolateI like chocolateI like chocolateI like chocolateI like chocolateI like chocolateI like chocolateI like chocolateI like chocolateI like chocolate
```

You may be able to think of more useful employment for this operator, like this:

```perl
perl -CS -e 'print qq!\N{U+2661} \N{U+2665}! x 1000;'
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
