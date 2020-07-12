
  {
    "title"  : "Pretty Printing Perl 6",
    "authors": ["brian-d-foy"],
    "date"   : "2017-07-26T07:55:00",
    "tags"   : ["prettydump", "data-dumper", "pretty-printer"],
    "draft"  : false,
    "image"  : "",
    "description" : "When .Str is not good enough",
    "categories": "perl-6"
  }


As I was working on [Learning Perl 6](https://www.learningperl6.com/), I wanted a way to pretty print a hash to show the reader what happened. I didn't want to output from the builtin routines and a module I found was a good start but needed more work. So I created the [PrettyDump module](https://github.com/briandfoy/perl6-PrettyDump).

Before I get to my module, Perl 6 already has some nice ways to summarize objects. My first task was to dump a match object to see what it matched. Here's a bit of code that matches a string against a regex and saves the result in `$match`. That's a [Match](https://docs.perl6.org/type/Match) object:

```perl
my $rx = rx/ <[ a .. z ]> <[ 1 .. 9 ]> /;
my $string = ':::abc123::';
my $match = $string ~~ $rx;

put $match;
```

When I output that with [put](https://docs.perl6.org/routine/put), I get the part of the string that matched:

    c1

I could change the code slightly to use [say](https://docs.perl6.org/routine/say). That's like `put` but calls the [.gist](https://docs.perl6.org/routine/gist) method on the object first to provide a human-compatible version of the object. Each object can decide on it's own what that means.

```perl
say $match;  # put $match.gist
```

In this case, the output is almost the same. There are some fancy quotes around it:

    ｢c1｣

Instead of `.gist`, which `say` gives me for free, I could call the [perl](https://docs.perl6.org/routine/perl) method explicitly.

```perl
put $match.perl;
```

This produces a string that represents what Perl 6 thinks the data structure is:

    Match.new(list => (), made => Any, pos => 7, hash => Map.new(()), orig => ":::abc123::", from => 5)

I could also use [dd](https://docs.perl6.org/programs/01-debugging#Dumper_function_dd), a Rakudo-specific dumping feature:

```perl
dd $match;
```

The output is similar to the string for `.perl`, but also slightly different:

    Match $match = Match.new(list => (), made => Any, pos => 7, hash => Map.new(()), orig => ":::abc123::", from => 5)

I didn't particularly like any of formats because they are squished together and rather ugly to my eyes (but being pleasing to me personally shows up in exactly zero designs). I looked for a module, and even though the Perl 6 module ecosystem is fairly young, I found [Pretty::Printer](https://github.com/drforr/perl6-pp) from Jeff Goff:

```perl
use Pretty::Printer; # From Jeff Goff

my $rx = rx/ <[ a .. z ]> <[ 1 .. 9 ]> /;
my $string = ':::abc123::';
my $match = $string ~~ $rx;

Pretty::Printer.new.pp: $match;
```

When I tried this, I didn't get anything (or, more exactly, I got literally "anything"):

    Any

`Pretty::Printer` was nice for the few data types that it handled, but not a `Match` object. It had some builtin handlers that it selected with a `given-when`:

```perl
method _pp($ds,$depth)
  {
  my Str $str;
  given $ds.WHAT
    {
    when Hash    { $str ~= self.Hash($ds,$depth) }
    when Array   { $str ~= self.Array($ds,$depth) }
    when Pair    { $str ~= self.Pair($ds,$depth) }
    when Str     { $str ~= $ds.perl }
    when Numeric { $str ~= ~$ds }
    when Nil     { $str ~= q{Nil} }
    when Any     { $str ~= q{Any} }
    }
  return self.indent-string($str,$depth);
  }
```

I started to work on `Pretty::Printer` to add a `Match` handler, and then a few others, but I quickly realized I was getting far away from Jeff's original code. Not only that, but I didn't want to add more and more branches to the `given-when`:

```perl
method _pp($ds,$depth)
  {
  my Str $str;
  given $ds.WHAT
    {
    # Check more derived types first.
    when Match   { $str ~= self.Match($ds,$depth) }
    when Hash    { $str ~= self.Hash($ds,$depth)  }
    when Array   { $str ~= self.Array($ds,$depth) }
    when Map     { $str ~= self.Map($ds,$depth) }
    when List    { $str ~= self.List($ds,$depth) }
    when Pair    { $str ~= self.Pair($ds,$depth)  }
    when Str     { $str ~= $ds.perl }
    when Numeric { $str ~= ~$ds }
    when Nil     { $str ~= q{Nil} }
    when Any     { $str ~= q{Any} }
    }
  return self.indent-string($str,$depth);
  }
```

I changed my module name to [PrettyDump](https://github.com/briandfoy/perl6-PrettyDump) and ended up with this:

```perl
use PrettyDump;

my $rx = rx/ <[ a .. z ]> <[ 1 .. 9 ]> /;
my $string = ':::abc123::';
my $match = $string ~~ $rx;

put PrettyDump.new.dump: $match;
```

I was much more pleased with the output which allowed me easily pick out the part of the object I wanted to inspect:

    Match.new(
      :from(5),
      :hash(Map.new()),
      :list($()),
      :made(Mu),
      :orig(":::abc123::"),
      :pos(7),
      :to(7)
    )

That solves that problem. But what about all the other types? One of my first improvements was a way to dump a class that my module did not know about. I knew about the `TO_JSON` method that the Perl 5 [JSON]({{<mcpan "JSON" >}}) module. With that, a class could decide its own JSON representation. I could do that with `PrettyDump`. If a class or object has a `PrettyDump` method, my module will use that preferentially:

```perl
class SomeClass {
    …
    method PrettyDump ( $pretty, $ds, $depth ) {
        …
        }
    }

my $pretty = PrettyDump.new;

my $some-object = SomeClass.new;

put $pretty.dump: $some-object;
```

The class doesn't need to define that method. I could decorate an object with a `PrettyDump` method through a role. The [but](https://docs.perl6.org/language/operators#infix_but) operator can do that for me by creating a new object in a new class that includes that role mixed into the original class:

```perl
use PrettyDump;

my $pretty = PrettyDump.new;

my Int $a = 137;
put $pretty.dump: $a;

my $b = $a but role {
  method PrettyDump ( $pretty, $depth = 0 ) {
    "({self.^name}) {self}";
    }
  };
put $pretty.dump: $b;
```

My code looks different from Jeff's, but it's not that different. Instead of a `given-when`, I have an `if` structure. I collapsed Jeff's branches into `self.can: $ds.^name` to look for a matching method to the object type (and introduced a bug while doing it. See it?). The first branch looks for the `PrettyDump` method. The second does some special handling for numeric things. If none of those work, I `die`, which is another stupid thing I did at first.

```perl
method dump ( $ds, $depth = 0 ) {
  put "In dump. Got ", $ds.^name;
  my Str $str;

  if $ds.can: 'PrettyDump' {
    $str ~= $ds.PrettyDump: self;
    }
  elsif $ds ~~ Numeric {
    $str ~= self.Numeric: $ds, $depth;
    }
  elsif self.can: $ds.^name {
    my $what = $ds.^name;
    $str ~= self."$what"( $ds, $depth );
    }
  else {
    die "Could not handle " ~ $ds.perl;
    }

  return self.indent-string: $str, $depth;
  }
```

So, I kept going. I wanted a way to add (and remove) handlers to a `PrettyDump` object. I could add those as roles, but I thought about doing this repeatedly and often and didn't like the idea of the frankenclass that would create. I added a way to do it on my own (although I might change my mind later):

```perl
my $pretty = PrettyDump.new;

class SomeClass { … }

my $handler = sub ( $pretty, $ds, Int $depth = 0 ) {
  ...
  }

$pretty.add-handler: 'SomeClass', $handler;

put $pretty.dump: $SomeClass-object;
```

My code added a couple more branches (and some code comments to elucidate the process). First, I'd look for a handler. If I'd defined one of those, I'd use it. Otherwise, I went through the same process. I did add some more checks at the end. If nothing else worked, I try a `.Str` method. Instead of `die`-ing at the end, I add an "unhandled thingy" string for that object. That way I know that I didn't handle something and the rest of the program keeps going. That turned out to be more important than I thought. I use this to peek at a program as it executes. It's not part of the program flow and shouldn't interrupt it because my dumping code is incomplete:

```perl
method dump ( $ds, Int $depth = 0 --> Str ) {
  my Str $str = do {
    # If the PrettyDump object has a user-defined handler
    # for this type, prefer that one
    if self.handles: $ds.^name {
      self!handle: $ds, $depth;
      }
    # The object might have its own method to dump
    # its structure
    elsif $ds.can: 'PrettyDump' {
      $ds.PrettyDump: self;
      }
    # If it's any sort of Numeric, we'll handle it
    # and dispatch further
    elsif $ds ~~ Numeric {
      self!Numeric: $ds, $depth;
      }
    # If we have a method name that matches the class, we'll
    # use that.
    elsif self.can: $ds.^name {
      my $what = $ds.^name;
      self."$what"( $ds, $depth );
      }
    # If the class inherits from something that we know
    # about, use the most specific one that we know about
    elsif $ds.^parents.grep( { self.can: $_.^name } ).elems > 0 {
      my Str $str = '';
      for $ds.^parents -> $type {
        my $what = $type.^name;
        next unless self.can( $what );
        $str ~= self."$what"(
         $ds, $depth, "{$ds.^name}.new(", ')' );
        last;
        }
      $str;
      }
    # If we're this far and the object has a .Str method,
    # we'll use that:
    elsif $ds.can: 'Str' {
      "({$ds.^name}): " ~ $ds.Str;
      }
    # Finally, we'll put a placeholder method there
    else {
      "(Unhandled {$ds.^name})"
      }
    };

  return self!indent-string: $str, $depth;
  }
```

As I got further into this code, I looked at Perl 5's [Data::Dumper]({{<mcpan "Data::Dumper" >}}), but discovered that this isn't the same sort of thing. That module outputs Perl code that I could [eval]({{</* perlfunc "eval" */>}}) to get back the same data structure. I didn't want that [can of worms](https://www.masteringperl.org/2012/12/the-storable-security-problem/) in my module.

Beyond what I've shown here, I've been fiddling with formatting and other minor things as I run into problems. If there's something that you'd like to do with the code, you can contribute through the [PrettyDump GitHub repo](https://github.com/briandfoy/perl6-PrettyDump), or even fork my code as the basis for your own experiments.

(Part of this work was supported by a travel grant from [The Perl Foundation](http://www.perlfoundation.org). I presented talks about my work at [Amsterdam.pm](https://www.slideshare.net/brian_d_foy/pretty-dump-perl-6), [French Perl Workshop 2017](https://www.slideshare.net/brian_d_foy/dumping-perl-6-french-perl-workshop), and [London.pm](https://www.slideshare.net/brian_d_foy/prettydump-perl-6-londonpm).)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
