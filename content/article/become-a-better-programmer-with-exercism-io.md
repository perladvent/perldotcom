{
   "draft" : false,
   "tags" : [
      "community",
      "windows",
      "app",
      "open_source"
   ],
   "title" : "Become a better programmer with exercism.io",
   "thumbnail" : "/images/90/thumb_ECF71624-FF2E-11E3-A119-5C05A68B9E16.png",
   "description" : "The open source programming puzzler that will level-up your Perl programming",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "90/2014/5/19/Become-a-better-programmer-with-exercism-io",
   "image" : "/images/90/ECF71624-FF2E-11E3-A119-5C05A68B9E16.png",
   "date" : "2014-05-19T01:15:07",
   "categories" : "community"
}


*For the past week I've been trying out [exercism.io](http://exercism.io/) the programming exercises app. I heard about it back in December when Gabor [blogged](http://blogs.perl.org/users/gabor_szabo/2013/12/perl-exercism.html) about it, but didn't try it until now. I wish I hadn't waited so long, as exercism is a lot of fun.*

### How exercism works

exercism comes with a command line app that downloads programming exercises and submits your coded answers to the exercism website. Every programming exercise comes with a readme and a test file. To complete the exercise you need to write a Perl module that passes all of the tests.

When you are done and have submitted your Perl module via the command line app, you and other programmers can "nitpick" your code and comment on it. Once you feel you have gotten enough comments, you can finalize your submission and view other programmer's solutions for the same exercise. The kicker is that you only receive one programming exercise at a time, and cannot access another exercise until you complete the current one.

Perl's TIMTOWTDI nature means that there are several correct solutions for the exercises and you can often learn something from viewing other programmers' solutions. For example in one exercise I used a regular expression only to find that the simpler [transliteration]({{< perldoc "perlop" "Quote-and-Quote-like-Operators" >}}) operator worked just as well. The exercise difficulty varies from easy to hard, but the real challenge is finding a clean, generalized solution for the spec.

### Try it out

Grab the [latest binary](https://github.com/exercism/cli/releases/latest) for your platform and extract it. Fire up the command line and type:

```perl
$ exercism demo
```

This will fetch the first exercise ("Bob" at the time of writing). You can find the test file and readme at "perl5/bob/". Opening the readme you'll see:

```perl
# Bob

Bob is a lackadaisical teenager. In conversation, his responses are very limited.

Bob answers 'Sure.' if you ask him a question.

He answers 'Woah, chill out!' if you yell at him.

He says 'Fine. Be that way!' if you address him without actually saying anything.

He answers 'Whatever.' to anything else.

## Instructions

Run the test file, and fix each of the errors in turn. When you get the first test to pass, go to the first pending or skipped test, and make that pass as well. When all of the tests are passing, feel free to submit. 

Remember that passing code is just the first step. The goal is to work towards a solution that is as readable and expressive as you can make it. 

Please make your solution as general as possible. Good code doesn't just pass the test suite, it works with any input that fits the specification.

Have fun!

## Source

Inspired by the 'Deaf Grandma' exercise in Chris Pine's Learn to Program tutorial. [view source](http://pine.fm/LearnToProgram/?Chapter=06)
```

To run the test file change into the exercise directory and use prove:

```perl
$ cd perl5/bob
$ prove bob.t
```

That will get this output:

```perl
bob.t .. 1/22 Bailout called.  Further testing stopped:  You need to create a module called Bob.pm with a function called hey() that gets one parameter: The text Bob hears.

#   Failed test 'missing Bob.pm'
#   at bob.t line 37.
FAILED--Further testing stopped: You need to create a module called Bob.pm with a function called hey() that gets one parameter: The text Bob hears.
```

Let's create a basic Bob.pm module:

```perl
package Bob;
use warnings;
use strict;

sub hey {
    my $input = shift;
}

1;
```

This is a shell of the solution. Our "hey" subroutine returns the first input it receives. Re-running prove, we get this output:

```perl
$ prove bob.t
bob.t .. 1/22 
#   Failed test 'stating something: Tom-ay-to, tom-aaaah-to.'
#   at bob.t line 52.
#          got: 'Tom-ay-to, tom-aaaah-to.'
#     expected: 'Whatever.'

...

# Looks like you failed 19 tests of 22.
bob.t .. Dubious, test returned 19 (wstat 4864, 0x1300)
Failed 19/22 subtests 

Test Summary Report
-------------------
bob.t (Wstat: 4864 Tests: 22 Failed: 19)
  Failed tests:  4-22
  Non-zero exit status: 19
Files=1, Tests=22,  1 wallclock secs ( 0.02 usr  0.00 sys +  0.04 cusr  0.00 csys =  0.06 CPU)
Result: FAIL
```

You can see that Bailout is no longer being called, so our basic module passed the first few tests, but failed 19 of 22. I've abbreviated the output to show only the first failing test. The output tells us everything we need to know: our "hey" subroutine did not return the content required by the spec. I'll leave the exercise here - if you're feeling suitably inspired see if you can complete it.

### Help represent Perl

One of the exercism's strengths is it has the same programming exercises in different programming languages, so you can develop your polyglot skills. Looking at the [source](https://github.com/exercism), it appears that JavaScript, Python, Ruby and Haskell are leading the pack with about 55 exercises available each. Perl is well-represented with 36 exercises and the other languages have about 20 or fewer.

This week I ported a couple of the missing exercises to the Perl [repo](https://github.com/exercism/xperl5). To port a missing exercise you have to provide the test file and module solution. This is easier than it sounds as you can just translate the exercise code from another language into Perl. Across all the languages there are about 80 different exercises. I've created a [quest](https://questhub.io/realm/perl/quest/53795a10bbd0be180400014f) which lists the missing exercises.

It only take about 30 minutes to port one exercise: if 2% of the readers of this article port one exercise each today, Perl will immediately have more exercises than any other language. There is also an empty Perl 6 [repo](https://github.com/exercism/xperl6); porting the Perl 5 exercises to Perl 6 could make for a juicy hackathon target.

### Conclusion

Playing with exercism has been loads of fun and I've learned a few Perl tricks (hah!) along the way. The source is MIT licensed and the committers are friendly. It would be great to see more Perlers participating or porting an exercise or too. Feel free to clone or or stencil the [quest](https://questhub.io/realm/perl/quest/53795a10bbd0be180400014f). Let's show people what our language can do!

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F90%2F2014%2F5%2F18%2FBecome-a-better-programmer-with-exercism-io&text=Become+a+better+programmer+with+exercism.io&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F90%2F2014%2F5%2F18%2FBecome-a-better-programmer-with-exercism-io&via=perltricks) about it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
