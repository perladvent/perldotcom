{
   "title" : "perl5i Makes More Simple Things Simple",
   "image" : null,
   "categories" : "development",
   "date" : "2010-03-23T06:00:01-08:00",
   "thumbnail" : null,
   "tags" : [
      "perl",
      "perl-5",
      "perl-programming",
      "perl5i"
   ],
   "authors" : [
      "michael-schwern"
   ],
   "draft" : null,
   "description" : "Suppose that you want to load a module dynamically (you have the name in a scalar), then alias a function from that module to a new name in another class. In other words, you want a renaming import. How do...",
   "slug" : "/pub/2010/03/perl5i-makes-more-simple-things-simple.html"
}



Suppose that you want to load a module dynamically (you have the name in a scalar), then alias a function from that module to a new name in another class. In other words, you want a renaming import. How do you do that in Perl 5?

    {
        no strict 'refs';
        eval qq{require $class} or die $@;
        *{$other_class."::".$alias} = $class->can($func);
    }

There's a lot of magic going on there. Aliasing requires using symbolic refs which means turning off `strict`. Because you want `strict` off in as small a hunk of code as possible you have to enclose it in braces. Then, `require Class` and `require $class` work differently, so you have to trick `require` into seeing a bareword by `eval`ing it. Don't forget to catch and rethrow the error! Finally, to do the aliasing you need to get a code ref with `can()` and assign it to the symbol table via the magic of typeglobs.

Guh. There's an idea in interface design called [The Gulf of Execution](http://www.usabilityfirst.com/glossary/gulf-of-execution/) which measures the distance between the user's goal and the actions she must take to achieve that goal. The goals here are to:

1.  Load a class from a variable.
2.  Alias a function in that class.

The actions are:

1.  Enclose the code in a block.
2.  Turn off `strict`.
3.  `require $class` in an `eval` block to turn it into a bareword.
4.  Catch and rethrow any error which might result.
5.  Use `can()` to get a reference to the function.
6.  Construct a fully qualified name for the alias.
7.  Turn that into a typeglob.
8.  Assign the code ref to the typeglob.
9.  Drink.

Try explaining that to a non-Perl guru.

Now consider the [perl5i]({{<mcpan "perl5i" >}}) (specifically perl5i::2) way:

    $class->require
          ->can($func)
          ->alias($other_class, $alias);

Release the breath you've been holding in for the last 15 years of Perl 5.

Through the magic of [autoboxing]({{<mcpan "autobox" >}}), perl5i lets you call methods on unblessed scalars, hashes, arrays, regexes, references... anything. It also implements some handy methods. Some, like `require()`, are core functions redone as methods. Others, like `alias()`, should be core functions never made it in for whatever reason. autoboxing gives perl5i the freedom to add handy features without polluting the global function/method namespace with new keywords.

Recall the goals:

1.  Load a class from a variable.
2.  Alias a function in that class.

... and consider perl5i's actions:

1.  Call `require()` to load the class.
2.  Call `can()` to get a reference to the function.
3.  Call `alias()` on that reference to alias it to the other class.

The gulf has narrowed to a stream you can hop over while hardly getting your feet wet.

The goal of perl5i is to bring modern conveniences back to Perl 5. In the 15 years since the release of Perl 5, we've learned a lot. Our views of good practices have changed. 15 years ago, aliasing a function was black magic available only to the wildest of gurus. Now it's a technique many module authors take advantage of. Why should it remain complicated and error prone?

Autoboxing is a big part of perl5i, allowing it to add convenience methods without having to add new keywords. Adding new keywords--which contracts the function names available to programmers--is a big thing holding Perl 5 back! Every potential new keyword is a debate over compatibility. Autoboxing eliminates that debate. It takes off the brakes.

Some other examples: [How do I check if a scalar contains a number, an integer, or a float?]({{< perldoc "perlfaq4" "How-do-I-determine-whether-a-scalar-is-a-number/whole/integer/float?" >}}) The Perl FAQ entry on the subject is two pages long offering five different possibilities, two of which require pasting code. Code in FAQs tends to rot, and perlfaq is no exception; without testing nobody noticed that those venerable regexes fail to catch "+1.23". How does perl5i do it?

    say "It's a number"   if $thing->is_number;
    say "It's an integer" if $thing->is_integer;
    say "It's a decimal"  if $thing->is_decimal;

It's clear, simple, fast, and tested. TMTOWTDI is great and all, but FAQs are about getting things done, not about writing dissertations on the subject. perl5i picks one way that's pretty good and makes it available with no fuss.

The bar for what is "simple" has moved since Perl 5 first came out. perl5i takes the goal of "simple things should be simple" and helps us all catch up.
