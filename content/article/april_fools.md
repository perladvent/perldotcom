{
   "title" : "Perl Jam VI: April Trolls",
   "date" : "2016-05-04T20:37:57",
   "image" : "",
   "description" : "Perl's ignored security problems, j/k but srsly this time",
   "authors" : [
      "brian-d-foy"
   ],
   "draft" : false,
   "categories" : "community",
   "tags" : [
      "perl",
      "core",
      "random",
      "modulus",
      "libc",
      "security"
   ]
}

For an April Fool's joke, I wanted to parody the [Perl Jam circus](http://perltricks.com/article/netanel-rubins-perljam-circus/) where the author has an idea that something is wrong but gets the explanation half-wrong. I wrote [Perl Jam VI: The Return of the Camel](http://perltricks.com/article/perl-jam-iv-return-of-the-camel/).

I thought I'd catch some people out if I was clever enough with the first example and increasingly lazy. I might have been too clever, but I also think that April Fool's is probably over. Not only that, I still felt guilty about not doing the work to explain things properly or giving you proper pointers where to look for good solutions.

#### Perl's rounding problem

Rounding is a problem for people who really care about numbers and where slight biases in numeric functions can skew results. Most people will probably never care about this because they don't have to care. However, I used to work with scads of data from nuclear physics experiments where it could have mattered.

Perl's particular issue is its reliance on someone else making the decision. When I first starting teaching Perl, many of my students had experience with C. They knew the issues with their libc. `perl` defers many decisions on to that libc. This means that you can get different results with a different `perl`s. Perl may run virtually everywhere, but it doesn't guarantee you'll get the same answer everywhere.

There is plenty of literature out there on different methods, and there are more than several methods. Just that fact shows that people don't agree on how it should work. If rounding might impact your results, you should be aware that you have many ways to deal with it. The [Math::Round]({{<mcpan "Math::Round" >}}) handles most of them.

#### The modulus of negative numbers

The modulus operator was a bit more interesting since it actually has some problems and undefined behavior. I presented the table of operand combinations and noted which ones are defined in Perl. Some of the situations don't have defined behavior.

I didn't think that many people would take this section seriously since the modulus operator isn't that popular. The [integer pragma ]({{< perldoc "integer" >}}) may fix the problem:

> Internally, native integer arithmetic (as provided by your C compiler) is used. This means that Perl's own semantics for arithmetic operations may not be preserved. One common source of trouble is the modulus of negative numbers, which Perl does one way, but your hardware may do another.

The StackOverflow question [Perl: understanding modulo operation on negative numbers](https://stackoverflow.com/a/32090446/2766176) goes into more detail about Perl's behavior.

If this matters for your application, you can implement your own modulo operation (perhaps in [Inline::C]({{<mcpan "Inline::C" >}})?) to do it exactly how you like to get the results you expect no matter where you run your program.

#### Fake random numbers

When we say "random numbers", experienced programmers generally understand that they aren't actually using numbers that are random. They are [pseudo-random](https://www.random.org/randomness/), although that's too much to say over and over again. We shorten it to "random" to keep the sentences short. If you are seeding a random number generator, you're using the fake kind.

For the odd homework assignment or selecting a unique value you haven't used yet, Perl's [rand]({{< perlfunc "rand" >}}) may be fine. If you are doing something where you want real randomness, you don't want something deterministic. You want "true" random numbers.

Several modules provide an interface to better sources:

* [Net::Random]({{<mcpan "Net::Random" >}}) can connect to internet services that send back random numbers. You have to trust the internet though.

* [Crypt::Random]({{<mcpan "Crypt::Random" >}}) connects to the local [/dev/random](http://man7.org/linux/man-pages/man4/random.4.html). That uses environmental noise to generate bytes. The /dev/urandom device might drop down to pseudo-randomness though. Neither is a good source for long sequences of numbers.

* An [Entropy Key](http://www.entropykey.co.uk) is a small USB device that helps the _/dev/random_ device fill up its entropy sink. This allows you to read from the device more frequently without dropping into pseudorandomness.

* [Random.org](https://www.random.org/integers/) provides data based on atmospheric noise. In the StackOverflow question [How to generate an array with random values, without using a loop?](http://stackoverflow.com/a/4093822/2766176), I presented a way to override Perl's [rand]({{< perlfunc "rand" >}}) to use this source. Some other answers are illuminating as well.

As with most everything else, there's no answer that covers every use. That you discover other sources is a rite of passage for a programmer.

#### Perl lets anyone program

I joked that Perl's real problem was that it existed, essentially, and that people could use it. It's a variation on the joke about the world's most secure computer is one that's turned off, encased in concrete, and dropped to the bottom of the ocean. And, we're not even sure even then.

But, I had a more interesting point in mind. Despite any technical limitations or gotchas, documented or not, it's people who make programs and the decisions about what programs will do. Knowing the syntax of a language is a start, but the biggest failures come from human decisions while programming. For entertaining illustrations of this idea, you might like Paul Fenwick's [An Illustrated History of Failure](https://www.youtube.com/watch?v=73vQglu-4H4).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
