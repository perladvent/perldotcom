{
   "title" : "How to read a string into an array of characters using split",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "string",
      "array",
      "split"
   ],
   "draft" : false,
   "categories" : "development",
   "slug" : "42/2013/10/3/How-to-read-a-string-into-an-array-of-characters-using-split",
   "date" : "2013-10-03T00:42:18",
   "description" : "Perl's split function has a useful feature that will split a string into characters. This works by supplying an empty regex pattern (\"//\") to the split function. This can be used to easily split a word into an array of letters, for example:",
   "image" : null
}


Perl's split function has a useful feature that will split a string into characters. This works by supplying an empty regex pattern ("//") to the split function. This can be used to easily split a word into an array of letters, for example:

```perl
my $word = 'camel';
my @letters = split(//, $word);
```

Perl's official documentation has more on the split function. You can read it [online]({{</* perlfunc "split" */>}}) or by running the following command at the terminal:

```perl
perldoc -f split
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
