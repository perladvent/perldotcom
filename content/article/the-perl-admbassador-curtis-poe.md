{
   "authors" : [
      "mohammad-anwar"
   ],
   "draft" : true,
   "categories" : "community",
   "title" : "The Perl Ambassador: Curtis 'Ovid' Poe",
   "thumbnail" : "",
   "tags" : [
   ],
   "image" : "/images/the-perl-ambassador-curtis-poe/curtis-poe.jpg",
   "description" : "The person behind the news of Perl",
   "date" : "2020-07-15T07:30:00"
}

As a part of monthly series of interview, today we are talking to none
other than **Curtis 'Ovid' Poe** himself. He is one of the tallest
leader of Perl community.

If you'd like me to interview you, or know someone you'd like me to
interview, let me know. Take the same set of questions and send me your
answers!

**Curtis** has been building software for decades. He specialize in
building database-driven Websites. He joined The Perl Foundation
[boards of directors](https://news.perlfoundation.org/post/new_board_member)
in 2009. He also runs the global global development and consulting firm,
[All Around The World](https://allaroundtheworld.fr/).

He wrote some of the very popular books on Perl like
[Beginning Perl](https://www.amazon.com/Beginning-Perl-Curtis-Poe/dp/1118013840/)
and [Perl Hacks](https://www.amazon.com/Perl-Hacks-Programming-Debugging-Surviving/dp/0596526741/).

He is also the man behind [Tau Station](https://taustation.space/),
text-based Massive Multiplayer Online Browser Game (MMOBG) set in a
vibrant far future universe.

You can find him blogging [here](https://ovid.github.io/blog.html). If
are interested in the technical blog then you please check out his
[collections](https://ovid.github.io/articles.html). How about his
[public speaking video](https://ovid.github.io/publicspeaking.html) as well.

\
\

#### How did you first start using Perl?

I first started using Perl about 20 years ago, when I was doing mainframe programming. I was trying to fix a problem with a COBOL program that was converting a CSV file from an NT system to the fixed-width format that COBOL prefers. COBOL has many weaknesses and working with text is one of them. The code was 150 lines long, but that’s because the author didn’t understand how the COBOL’s unstring function worked. I got it down to 80 lines of COBOL. Out of curiosity, I tried it in Perl and got it down to 10 lines of code. Everything I touched in Perl was shorter and easier to read, so I jumped ship.

\
\

#### What do you think about Perl 7? Do you see the Perl is on the path of recovery?

I am 100% on board with the project and yes, it's the path for Perl's recovery. I've seen widespread support for the change, which was heartening, and with the amount of press, even TIOBE moved Perl from 19 to 14th place, though I suspect it will drop back after the press dies down.

However, there's a difference between having a goal and having a plan. There's widespread agreement on the goal, but there's less agreement about the plan. That's great so long as people can use this to find the best path. It's less great if it devolves into acrimony. Fortunately, Sawyer's been great at projecting a positive message.

So long as we manage to protect businesses currently using Perl (and that means convincing Linux distros that we're not going to break them), having a plan to better support active and new developers is awesome. And the version number change is a key first step.

\
\

#### What inspired you to start the project "Cor"? When are you planning to release it?

First, for those who are not familiar with Cor, you can read about it at https://github.com/Ovid/Cor/wiki. In short, Cor is a plan to add modern OO to the Perl core. But the motto is "'Good enough' is not good enough." We have to stop settling for what we can have and start dreaming about what we want. For a trivial example, here's a naïve LRU cache implementation in Cor:

```perl
class Cache::LRU {
    use Hash::Ordered;

    has $max_size :new(optional) :reader :isa(PositiveInt) = 20;
    has $created  :reader = time;
    has $cache    :handles(get)  :builder;
    method _build_cache () { Hash::Ordered->new }

    method set ( $key, $value ) {
        if ( $cache->exists($key) ) {
            $cache->delete($key);
        }
        elsif ( $cache->keys > $max_size ) {
            $cache->shift;
        }
        $cache->set( $key, $value );  # new values in front
    }
}
```

As for my motivation, like many developers, I was waiting for Stevan Little to finish his work to get a better OO system for the Perl core. But he was working mostly alone, for a long time, and that's hard to do. So when I decided I wanted something, I was able to take a look at his work and realize it was solid. But I needed a better syntax.

I tried to refine some of the syntax from Moo/se, but honestly, Moo/se has some serious limitations. Some are design decisions which can be easily corrected, but some are due to limitations in the Perl language itself. Once I had Sawyer's backing, I realized that I didn't just have to steal syntax, I could invent syntax, though I have done so very cautiously. It's important that Cor still be Perl, but just a tiny sprinkling of syntactic sugar in the right spots makes a world of difference. So far it looks promising.

And Sawyer said he hopes a v1 will be available under a feature guard in 7.2 or 7.4. With Perl 8, the feature guard would be removed.

\
\

#### Which Perl modules are you constantly using? How do they make your life easier?

Test::Class::Moose (TCM) is a go to module for me. Most Perl developers learn how to test modules, not applications. With TCM, large test suites become easier to build and manage and, when it's written correctly, many test suites can be an order of magnitude faster.

I also have a module I write for personal code called Less::Boilerplate. It's not on the CPAN because it's too fine-tuned for my personal needs, but naturally it enables strict, warnings, signatures, autodie, and other features without having to type everything out by hand. And it pleases me to have the double meaning of "use Less::Boilerplate" at the top of my code. Yet it's part of the issue that Sawyer's pointed out with Perl. New Perl developers don't know the strange incantations experienced Perl developers put at the top of their code to get Perl to be reasonable. That hurts the language because they get a poor "out of the box" experience.

\
\

#### Which Perl feature do you overuse?

It used to be the punctuation variables that I would sprinkle around my code like magic pixie dust. Things like local $" = ', ' were natural to me. But I've stopped doing that because honestly, it's not readable. I do a lot of client work so I take care to ensure that my code is (as much as I can), easy to read and maintain. I've even rewritten some of my code to "dumb it down" because I want to ensure that it's maintainable.

\
\

#### Which Perl feature do you wish you could use more?

Given that clients call me in to help build new systems or fix existing ones, I pretty much get to pick and choose what features I want to use, so I'm fortunate in that regard. Thus, there's not much I don't get to use if I think it's useful. However, a feature I wish I could use more is a feature that doesn't exist: more standardized introspection tools, similar to a MOP. Mucking about in the symbol table for the things I need, or pulling in external libraries to find out where my code is located in the filesystem is frustrating. I often write code that magically "works" without having to be loaded (similar to plugins). But without standardized, cross-platform tools for finding the code, loading it dynamically, converting between package and filenames automatically, I find that I'm often rewriting this code again, for a different client, based on their operating system, file system layout, and so on.

\
\

####  What one thing you'd like to change about Perl?

How variables behave. There are a few things in that, but mainly, I wish Perl had invariant sigils like Raku and that arrays and hashes wouldn't flatten unless requested. But I'm not going to get that, so let's pretend I didn't ask :)

(Hmm, working threads might be interesting, too)
