{
   "title" : "Quoting strings in Perl - even ones containing apostrophes and quote or speech marks",
   "description" : "Broadly speaking Perl has two types of strings: quotes that are interpolated at runtime and literal quotes that are not interpolated. Let's review each of these in turn.",
   "draft" : false,
   "tags" : [
      "operator",
      "string",
      "variable",
      "old_site"
   ],
   "categories" : "development",
   "date" : "2013-03-30T18:49:41",
   "authors" : [
      "david-farrell"
   ],
   "image" : null,
   "slug" : "7/2013/3/30/Quoting-strings-in-Perl---even-ones-containing-apostrophes-and-quote-or-speech-marks"
}


Broadly speaking Perl has two types of strings: quotes that are interpolated at runtime and literal quotes that are not interpolated. Let's review each of these in turn.

### Interpolated Strings

These strings are declared by encapsulating the quote in speech marks ("). If the encapsulated quote contains variables or escape-sequences, these will be processed at runtime.

``` prettyprint
my $integer = 10;
#Declare an interpolated string
my $sentence = "I will count to $integer.\nThen I am coming for you!";
print $sentence;
```

This will print:

``` prettyprint
I will count to 10. 
Then I am coming for you!
```

Notice how the $integer variable was interpolated to print it's value, and how the newline escape sequence (\\n) was applied too.

### Literal strings (not interpolated)

Literal strings need to be encapsulated by apostrophes ('). The content of these strings will be preserved as quoted, and not interpolated at runtime. Using literal strings is also more efficient as the Perl parser does not have to examine the the string for variables and escape sequences for interpolation.

``` prettyprint
my $integer = 10;
#Declare a literal string
my $sentence = 'I will count to $integer.\nThen I am coming for you!';
print $sentence;
```

This will print:

``` prettyprint
I will count to $integer.\nThen I am coming for you!
```

### Strings that contain quote / speech marks

To quote a string that contains speech marks or apostrophes, Perl provides two quote operators: **q** for literal quotes and **qq** for interpolated quotes. The quote operators let the programmer define the encapsulating characters for the string - simply choose characters that are not contained in your string:

``` prettyprint
my $user = "sillymoose";
my $difficult_string_interpolated = qq{Welcome $user\n. Whilst you are are here, you can "do as they do in Rome" and enjoy yourself};
print $difficult_string_interpolated;
```

This will print:

``` prettyprint
Welcome sillymoose
Whilst you are are here, you can "do as they do in Rome" and enjoy yourself
```

Although the example above used curly braces ({,}) to encapsulate the string, Perl will accept most symbol characters such as those on the top of your keyboard(!@£$%^&\*-+). Contrary to popular belief, Perl **will not accept any character** as the delimiter - the letters of the alphabet (a-z) do not work for example.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
