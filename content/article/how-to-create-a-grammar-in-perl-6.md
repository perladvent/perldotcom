{
   "categories" : "perl-6",
   "title" : "How to create a grammar in Perl 6",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "date" : "2015-01-13T15:45:36",
   "tags" : [
      "perl_6",
      "grammar",
      "pegex"
   ],
   "image" : null,
   "description" : "They're powerful and easy to whip up",
   "slug" : "144/2015/1/13/How-to-create-a-grammar-in-Perl-6"
}


In programming, a grammar is a set of rules for parsing text. They're incredibly useful, for instance you can use a grammar to check if a text string conforms to a specific standard or not. Perl 6 has native support for grammars - they're so easy to write that once you start using them, you'll find yourself using them everywhere.

Recently I've been working on Module::Minter, a simple app to create a base skeleton structure for a new Perl 6 module. I needed a way to check that the proposed module name would conform to Perl 6's naming conventions.

Module names can be described as identifiers separated by 2 colons, [File::Compare](https://github.com/labster/perl6-File-Compare/) for example\*. An identifier must begin with an alpha character (a-z) or an underscore, followed by zero or more alphanumeric characters. So far so good, but it's not that simple; some module names only have a single identifier and no colons like [Bailador](https://github.com/tadzik/Bailador/) whilst other modules are more of a mouthful like [HTTP::Server::Async::Plugins::Router::Simple](https://github.com/tony-o/perl6-http-server-async-plugins-router-simple/). This sounds like a job for a grammar!

### Defining the grammar

Perl 6 Grammars are built from regexes. I need two regexes: one for matching identifiers and one for matching the double colon separators. For the identifier regex, I'll use:

``` prettyprint
<[A..Za..z_]> # begins with letter or underscore
<[A..Za..z0..9]> ** 0..* # zero or more alpanumeric
```

Remember we're using Perl 6 regexes, so things might look a little different if you're used to Perl 5 style regexes. A character class is defined by `<[ ... ]>` and ranges are defined using the range operator `..` instead of a hyphen. This regex matches any leading letter or underscore followed by zero or more alphanumeric characters. Matching two colons is easy:

``` prettyprint
\:\: # colon pairs
```

Grammars are defined using the `grammar` keyword, followed by the name of the grammar. I'm going to call this grammar `Legal::Module::Name`

``` prettyprint
grammar Legal::Module::Name
{
  ...
}
```

Now I can add the regexes as tokens to the grammar:

``` prettyprint
grammar Legal::Module::Name
{
  token identifier
  {
    # leading alpha or _ only
    <[A..Za..z_]>
    <[A..Za..z0..9]> ** 0..*
  } 
  token separator
  {
    \:\: # colon pairs
  }
}
```

Every Grammar needs a token called `TOP`, which is the starting point for the grammar:

``` prettyprint
grammar Legal::Module::Name
{
  token TOP
  { # identifier followed by zero or more separator identifier pairs
    ^ <identifier> [<separator><identifier>] ** 0..* $
  }
  token identifier
  {
    # leading alpha or _ only
    <[A..Za..z_]>
    <[A..Za..z0..9]> ** 0..*
  } 
  token separator
  {
    \:\: # colon pairs
  }
}
```

The `TOP` token defines a valid module name as one that begins with an identifier token, followed by zero or more separator and identifier token pairs. This is nice to write and maintain - let's say I wanted to change the rules for separators to include hyphens ('-'), I could just update the separator token regex and the effect would bubble up to the `TOP` token definition.

### Using the grammar

Now I've got the grammar, it's time to put it into action. The `parse` method runs the grammar on a string and if successful, returns a match object. This code parses the `$proposed_module_name` string, and either prints out the match object or an error message if the propose module name is invalid.

``` prettyprint
my $proposed_module_name = 'Super::New::Module';
my $match_obj = Legal::Module::Name.parse($proposed_module_name);

if $match_obj
{
    say $match_obj;
}
else
{
    say 'Invalid module name!';
}
```

This code prints:

``` prettyprint
｢Super::New::Module｣
 identifier => ｢Super｣
 separator => ｢::｣
 identifier => ｢New｣
 separator => ｢::｣
 identifier => ｢Module｣
```

### Extracting content from the match object

Rather than dumping the contents of the match object to the command line, we can extract matched tokens from the match object. This uses the same quoting syntax often used elsewhere in Perl 6 (e.g. named regexes and hash keys):

``` prettyprint
say $match_obj[0].Str; # Super
say $match_obj[1].Str; # New
say $match_obj[2].Str; # Module

say $match_obj; # all 3 captures
```

### Action Classes

So far the grammar can detect if a proposed module name is legal or not, and produces a match object from which it's easy to extract the components of the module name. Perl 6 also let's you add an action class which defines extra behaviour for matched tokens. I'd like to add a warning when a module name has too many identifiers, in other words, it's a legal module name, but the user might want to shorten it. First I define the action class itself:

``` prettyprint
class Module::Name::Actions
{
  method TOP($/)
  {
    if $<identifier>.elems > 5
    {
      warn 'Module name has a lot of identifiers, consider simplifying the name';
    }
  }
}
```

As you can see this is an ordinary Perl 6 class definition. I've added one method called `TOP` which matches the first token in the grammar. I use the named regex syntax to count all identifier matches, and if there are more than 5, fire a warning. This won't stop the code from running, but it might cause the user to reconsider their choice of module name.

I then initialize the action class and pass it as an argument in to `parse`:

``` prettyprint
my $actions = Module::Name::Actions.new; 
my $match_obj = Legal-Module-Name.parse($proposed_module_name, :actions($actions));
```

The grammar will call the matching action class method every time the token is encountered during parsing. In this case that's once per parse, but we could add an additional length length on identifier tokens for example. Check out the [Module::Minter](https://github.com/sillymoose/Module-Minter/blob/master/lib/Module/Minter.pm6) source to see how to incorporate a grammar into a module.

### Grammars in Perl 5

You can also write grammars in Perl 5. For a solution similar to the Perl 6 implementation, have a look at [Regexp::Grammars](https://metacpan.org/pod/Regexp::Grammars) or Ingy Döt Net's [Pegex](https://metacpan.org/pod/Pegex) distribution. For a different approach, check out chapter 1 of [Mastering Perl](http://www.masteringperl.org/) by brian d foy, which contains an example JSON grammar.

\* This isn't strictly correct - the entire name (colons included) is the identifier.

**Update:** *added link to Regexp::Grammars. 2015-01-13*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
