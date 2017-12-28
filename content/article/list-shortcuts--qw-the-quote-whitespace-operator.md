{
   "tags" : [
      "operator",
      "string",
      "array",
      "syntax"
   ],
   "slug" : "15/2013/4/9/List-shortcuts--qw-the-quote-whitespace-operator",
   "title" : "List shortcuts: qw the quote whitespace operator",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "description" : "A popular way to build a list of literal quotes in Perl is to use the quote whitespace operator (qw). It's terse, versatile and elegant. To see why, let's look at a typical statement using a list of strings:",
   "categories" : "development",
   "date" : "2013-04-09T00:02:11",
   "image" : null
}


A popular way to build a list of literal quotes in Perl is to use the quote whitespace operator (qw). It's terse, versatile and elegant. To see why, let's look at a typical statement using a list of strings:

```perl
# import the Encode module and three subroutines
use Encode ('decode', 'encode', 'find_encoding');
```

To define the list of strings in Perl we had to encase every string with apostrophes, separated by commas and surrounded by parentheses. That's a lot of fluff, and opens the door to easy mistakes such as using speechmarks (") when you needed an apostrophe. Instead of doing that, we could have used the quote whitespace operator:

```perl
use Encode qw/decode encode find_encoding/;
```

The quote whitespace operator takes a list delimiter followed by a list of plain strings separated by whitespace and returns list of literal quoted strings. The delimiter can be an ASCII symbol (slash / is a popular choice), brackets or parentheses. Let's review some more examples:

```perl
# assign a list of an array
my @ny_boroughs = qw{Bronx Brooklyn Manhattan Queens Staten_Island};

# Quote some tricky symbols using tilde as the list delimiter
my @ascii_symbols = qw~! @ $ % ^ & * ( ) - _ = + { } [ ] \ | / ? ~;

# Use qw an input to a loop
foreach my $firm (qw/Deloitte ErnstAndYoung KPMG PWC/){
    print $firm; 
}

# It will ignore spaces, even double or triple spaces
my @colours = qw(red  blue   yellow    pink   green   ); 
foreach (@colours) {
    print $_;
}
# red
# blue
# yellow
# pink
# green
```

Using the quote whitespace operator often results in a cleaner, simpler syntax that reduces the risk of error when working with lists.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
