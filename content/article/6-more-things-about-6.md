{
   "description" : "Perl 6 features worth spreading",
   "image" : "",
   "authors" : [
      "brian-d-foy"
   ],
   "categories" : "perl6",
   "tags" : [
     "rat", "return-value","perl-shop","failure","fmt"
   ],
   "date" : "2017-02-07T08:26:00",
   "title" : "Six more things I like about 6",
   "draft" : false
}

[The Perl Shop](http://www.theperlshop.com) recently sponsored me to speak about Perl 6 at a meeting of the [Boston Perl mongers](http://boston.pm.org). They had backed the Kickstarter project for [Learning Perl 6](https://www.learningperl6.com). As part of that, I'm giving talks to Perl mongers groups about what I like about the language. These aren't necessarily the most exciting or advanced features or the newest computer science features. They are merely things that I like.

Many of these features are scattered across the languages landscape, and I've long said that I'd gladly abandon Perl when I found a language I liked better. Now I'm getting some of the features I may have coveted in languages that are missing some of the stuff I still enjoy about Perl.

### Rats

Perl 6 can maintain precision as long as possible by keeping rational numbers as ratios instead of making them native floating points (although you can still do that too). This means that we don't have to deal with the variety of problems that come with relying on the underlying storage.

	$ perl5 -le 'print 0.3 - 0.2 - 0.1'
	-2.77555756156289e-17

That's a little off, but we've come to accept that (for example, multiplying all money amounts so you only deal in integers). Perl 6 however, stores them exactly as long as it can:

	$ perl6
	To exit type 'exit' or '^D'
	> my $rat = 0.3
	0.3
	> $rat.numerator
	3
	> $rat.denominator
	10
	> 0.3 - 0.2 - 0.1
	0

A repeating decimal is still a rational number, although Perl 6 doesn't yet have a feature to put the overbar on the repeating part:

	> <1/3>
	0.333333

### Soft Failures

Perl 6 has [Failure](https://docs.perl6.org/type/Failure) objects, which wrap an exception. Many things may return such an object when something goes wrong. A [Failure](https://docs.perl6.org/type/Failure) is always `False` in Boolean context, but Perl 6 also marks it as handled when it's checked like that. Otherwise, if I try to use that object as if everything succeeded, it immediately throws its exception:

``` prettyprint
my $file = 'not-there';

unless my $fh = open $file {
	put "In unless: exception is {$fh.exception.^name}"
	}

CATCH {
	put "Caught {.^name}: {.message}";
	}
```

The output shows that I handled the problem in the `unless`:

	In unless: exception is X::AdHoc

Compare this with code that doesn't check the result of the `open` and keep going as if the filehandle is good:

``` prettyprint
my $file = 'not-there';

my $fh = open $file;

$fh.lines;

CATCH {
	put "Caught {.^name}: {.message}";
	}
```

Now the exception takes over and the `CATCH` block handles it. There's a strack trace that comes with that:

	Caught X::AdHoc: Failed to open file not-there: no such file or directory
	Failed to open file not-there: no such file or directory
	  in any  at ... CORE.setting.moarvm line 1
	  in block <unit> at ...

	Actually thrown at:
	  in block <unit> at ...

I love that this lets me decide how to check the error. I've always thought that the various syntaxes for `try` (in any language) bullied their ways into the language and took over the source code.

And, I'm sufficiently besotted with this idea of object-oriented programming that I have a Perl 5 module that does a similar thing: [ReturnValue](https://metacpan.org/pod/release/BDFOY/ReturnValue-0.10_01/lib/ReturnValue.pm). I use that to return values where the caller can determine what happened by calling methods on the result.

### Resumable Exceptions

So let's talk about exceptions. I haven't liked the fake ones people tried to push on me in Perl 5. If I can't actually handle it and continue the program, I don't think it's a proper exception. It's just a different way to return a value.

``` prettyprint
CATCH {
	default {
		put "Problem with file: {.^name} --> {.message}";
		.resume
		}
	}

my $line = read-a-line( 'not-there' );

sub read-a-line ( $file ) {
	X::AdHoc.new( :payload<Oh no Mr Bill!> ).throw;
	say "Hey, I can keep going!"
	}
```

I see that `CATCH` handled the exception, but then let the code in the subroutine continue:

	Problem with file: X::AdHoc --> Oh no Mr Bill!
	Hey, I can keep going!

Not every exception can resume, but I see a lot of promise in this ability.

### Easier Interpolation

My estimation of a language is mostly based on how easy I can create new strings. Perl 5 was pretty good about that, but Perl 6 is even better.

Scalars, arrays, and hashes (yes, hashes!) can interpolate directly, although you need to add the subscript characters for the latter two:

``` prettyprint
say "This one has a $scalar";
say "The array needs braces: @array[]";
say "The hash needs curlies: %hash{}";
```

Better than that, though, is that I can interpolate anything by enclosing it in braces within the string. Perl 6 evaluates the code in the braces and replaces the block with the last evaluated expression:

``` prettyprint
say "There are { $scalar.elems } elements";
say "The object's name is { $object.^name }";
say "The sum is { 2 + 2 }";
say "The lowest is { @array.sort.[1] }";
say "The lowest is { @array.min }";
```

I could do this with `sprintf`, and sometimes I think that's more appropriate. But I've often played reference-dereference games in strings to do what I can now do by design. I really like this (and so will Ruby programmers, I think).

### fmt

Have something in a scalar that you want to format in a different way? There's a method for that. This isn't one of the exciting new features because `printf` has been around forever. Similar to the interpolation, this might seem like a small thing, put in the times I've used it I've been quite pleased despite the voice at the back of my head that says "It's just `sprintf` you idiot!"

```prettyprint
my @buffer = Buf.new( ... );
@buffer.map( { .fmt: "%02x" } ).join( ' ' ).put;
```

I forego the parens there and give the arguments to `.fmt` by putting a colon after the method name. Since I didn't specify an object this uses the topic (what you call `$_`).

For some reason I really like this more than what everyone reading this article is thinking:

```prettyprint
$buffer.map( { sprintf "%02x", $_ } ).join( ' ' )
```

### Lists of lists

Perl 6 has lists of lists (ever since the [Great List Refactor](https://perl6advent.wordpress.com/2015/12/14/day-15-2015-the-year-of-the-great-list-refactor/)). This will be a bit disconcerting to those use to the "always flat" lists of Perl 5, but I think you'll get used to them. This is quite handy for keeping related values together.

And, a list is an object, and as a single thingy you can store it in a scalar variable. It knows that it is a list:

```prettyprint
my $scalar = ( 1, 2, 3 );
# my $scalar = 1, 2, 3;  # Nope!

put "scalar: $scalar";
put "scalar: { $scalar.^name }";

scalar: 1 2 3
scalar: List
```

You can have literal lists of lists:

```prettyprint
my @array = ( ( 1, 2 ), qw/a b/ );

put "elems: { @array.elems }";
put "@array[]";  # the whole thing
put "@array[0]"; # the first thing
put "{ @array[0].^name }";

2
1 2 a b
1 2
List
```

But here's something even better. You can go the other way. I go from the flat list of this buffer (list of numbers representing octets in this case) to two-element lists that I can iterate over. This is quite handy for dealing with binary formats:

```prettyprint
my Buf $buf =
	Buf.new( 0xDE, 0xAD, 0xBE, 0xEF );

for $buf.rotor(2) -> $c {
	put "c is $c";
	put "word is ",
	( $c[0] +< 8 + $c[1] )
		.fmt( '%02X' );
	}

c is 222 173
word is DEAD
c is 190 239
word is BEEF
```

There's much more that I can write about lists of lists, but this article is long enough already. I'll save some of that for later articles. You can see more of my Perl 6 stuff at [https://www.learningperl6.com](https://www.learningperl6.com/).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
