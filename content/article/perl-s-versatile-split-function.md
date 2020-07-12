{
   "image" : null,
   "description" : "Write elegant, simple code with split",
   "categories" : "development",
   "slug" : "121/2014/10/24/Perl-s-versatile-split-function",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "array",
      "split",
      "builtin",
      "function",
      "whitespace",
      "trim",
      "char",
      "join"
   ],
   "date" : "2014-10-24T12:42:52",
   "title" : "Perl's versatile split function"
}


I love Perl's [split]({{</* perlfunc "split" */>}}) function. Far more powerful than its feeble cousin [join]({{</* perlfunc "join" */>}}), split has some wonderful features that should make it a regular feature of any Perl programmer's toolbox. Let's look at some examples.

### Split a sentence into words

To split a sentence into words, you might think about using a whitespace regex pattern like `/\s+/` which splits on contiguous whitespace. Split will ignore trailing whitespace, but what if the input string has *leading* whitespace? A better option is to use a single space string: `' '`. This is a special case where Perl emulates awk and will split on all contiguous whitespace, trimming any leading or trailing whitespace as well.

```perl
my @words = split ' ', $sentence;
```

Or loop through each word and do something:

```perl
use 5.010;
say for (split ' ', ' 12 Angry Men ');
# 12
# Angry
# Men
```

The single-space pattern is also the default pattern for `split`, which by default operates on `$_`. This can lead to some seriously minimalist code. For example if I needed to split every name in a list of full names and do something with them:

```perl
for (@full_names)
{
    for (split)
    {
        # do something
    }
}
```

And who says Perl looks like line noise?

### Create a char array

To split a word into separate letters, just pass an empty regex `//` to split:

```perl
my @letters = split //, $word;
```

### Parse a URL or filepath

It's tempting to reach for a regex when parsing strings, but for URLs or filepaths `split` usually works better. For example if you wanted to get the parent directory from a filepath:

```perl
my @directories = split '/', '/home/user/documents/business_plan.ods';
my $parent_directory = $directories[-2];
```

Here I split the filepath on slash and use the negative index `-2` to get the parent directory. The challenge with filepaths is that they can have n depth, but the parent directory of a file will always be the last but one element of a filepath, so `split` works well.

### Extract only the first few columns from a separated file

How many times have you parsed a comma separated file, but didn't want all of the columns in the file? Let's say you wanted the first 3 columns from a file, you might do it like this:

```perl
while <$read_file>
{
    my @columns = split /,/;
    my $name    = $columns[0];
    my $email   = $columns[1];
    my $account = $columns[2];
    ...
}
```

This is all well and good, but `split` can return a limited number of results if you want:

```perl
while <$read_file>
{
    my ($name, $email, $account) = split /,/;
    ...
}
```

Or to revisit an earlier example, splitting on whitespace:

```perl
for (@full_names)
{
    my ($firstname, $lastname) = split;
    ...
}
```

### Conclusion

These are just a few examples of Perl's versatile `split` function. Check out the official documentation [online]({{</* perlfunc "split" */>}}) or via the terminal with `$ perldoc -f split`.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
