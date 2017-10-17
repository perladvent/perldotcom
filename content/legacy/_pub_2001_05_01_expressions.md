{
   "date" : "2001-05-01T00:00:00-08:00",
   "image" : null,
   "title" : "Reversing Regular Expressions",
   "categories" : "development",
   "authors" : [
      "pete-sergeant"
   ],
   "thumbnail" : null,
   "description" : " Regular Expressions are arguably one of Perl's most useful and powerful tools. The ability to match complex strings is one of the things that makes Perl the effective \"Practical Extraction and Reporting Language\" that it is. The regular expression...",
   "slug" : "/pub/2001/05/01/expressions.html",
   "draft" : null,
   "tags" : []
}



Regular Expressions are arguably one of Perl's most useful and powerful tools. The ability to match complex strings is one of the things that makes Perl the effective "Practical Extraction and Reporting Language" that it is. The regular expression engine is highly optimised and thus very fast, although in some situations people fail to use it in the most effective manner.

For example, imagine a case where you have a collection of very long lines from a log file, that each have a four digit year (starting with 19) somewhere near the end.

One would normally say something like:

    # Match any occurrence of 19xx that's not followed by another one
    if ($string =~ /(19\d\d)(?!.*19\d\d)/) {$date = $1}

    or, better:

    if ($string =~ /.*(19\d\d)/) {$date = $1}

However, in this situation, the regular expression engine has to go through all the string, remembering any matches it finds and discarding them any time it finds a new match, until it reaches the end of the string. If you have long log lines, this can be highly inefficient, and comparatively slow. But is there another way to do it? (Hint: With Perl, There's Always More Than One Way To Do It)

Unless you're a regular on IRC or [perlmonks.com](http://www.perlmonks.com), or attended [YAPC::Europe](http://yapc.org/Europe/), it's quite possible that you've never heard of (a) Jeff Pinyan (aka Japhy) and (b) his simple and elegant solution to getting around this problem. He dubbed these solutions reversed regular expressions, or sexeger.

Instead of going through the whole string looking for the last match, wouldn't it be a better idea to work from the back of the string and take the first match that is found? At the moment, Perl doesn't provide a built in method for doing this, but it's surprisingly easy to emulate one. To quote the lightning talk Mr Pinyan wrote for me to give at YAPC::E "Reverse the input! Reverse the regex! Reverse the match!".

And so that's exactly what we'll do:

    sub get_date {
        $_ = scalar reverse($_[0]); # Reverse whatever string we were passed
        /(\d\d91)/;                 # Look for the first occurrence of a xx91 (19xx reversed)
        return scalar reverse $1;   # Reverse back whatever we found and return it
    }

Obviously, we're performing two more functions in this example, two calls of reverse. Reverse however appears to be very efficient, and in benchmarks that were run (details below), this seemed not to be a problem. To test if this really would be significantly faster, I used a 10,000 character string, and ran the regex 10000 times on it. Here's the code used to test it:

    $la = [our 10000 character string]
    ...
    use Benchmark;
    $t = timeit("10000",  sub { $_ = $la; /.*(19\d\d)/; });
    print "Greedy took:",timestr($t), "\n";
    $t = timeit("10000",  sub { $_ = $la; /(19\d\d)(?!.*19\d\d)/;});
    print "Lookahead took:",timestr($t), "\n";
    $t = timeit("10000",  sub { $_ = reverse($la); /(\d\d91)/;  });
    print "Sexeger took:",timestr($t), "\n";

The first example, with its look ahead assertion, took four hundred seconds, as the look ahead assertion is a major time sink. The second example took 1.5 seconds. The reversed method managed however to shave three quarters of a second off that, and become 0.75 seconds. To summarise:

| Method                   | Time |
|--------------------------|------|
| `/(19\d\d)(?!.*19\d\d)/` | 400  |
| `/.*(19\d\d)/`           | 1.5  |
| sexeger                  | 0.75 |

However, performance gains are not the only good use for reversed regular expression, as one can also use them to solve a few other common problems that Perl doesn't handle easily. If you've all read the Frequently Asked Questions included with Perl, which I'm **sure** you have, then you'll have seen a particularly good example in Section 5 (perldoc perlfaq5) by Andrew Johnson - "How can I output my numbers with commas added?".

    sub commify {
    my $input = shift;
    $input = reverse $input;
    $input =~ s<(\d\d\d)(?=\d)(?!\d*\.)><$1,>g;
    return scalar reverse $input;
    }

One of my personal favourite regex tools is zero-width look ahead assertions, as in the very first example (it's worth noting that that's a **negative** zero-width look ahead assertion). For people who haven't scoured *perldoc perlre*, this allows you to state that a pattern has to exist in front of your position, without actually matching it. Perhaps an example would help illustrate: ` /ab(?=.+e)cd/ ` will match `"abcde"` but not `"abecd"` or `"abcd"`. Sadly, it's not possible to do variable length zero-width look behind assertions with the current Regular Expression Engine. However, if we apply sexeger principles to it, as suggested by Anthony Guselnikov, it suddenly becomes easy. If we want to match the string `"def"`, as long as it was preceded by the letter 'a', we can say:

    sub nlba {
    $_ = scalar reverse $_[0];
    print "Success\n" if /fed(?=.*a)/;
    }

Reversing Regular Expressions is a powerful and effective tool in any programmers arsenal. I hope that I've managed to illustrate the utility that this simple and elegant solution offers. Some overhead in programmer time, and in processing time is required to use them, and so I'd suggest that you evaluate using them on a case by case basis.

For more information, visit the homepage at [http://www.pobox.com/~japhy/sexeg er](http://www.pobox.com/~japhy/sexeger)
