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
   "description" : "The person behind the text-based Massive Multiplayer Online Browser Game (MMOBG), Tau Station",
   "date" : "2020-07-22T04:40:00"
}

This month's interview is Curtis 'Ovid' Poe, one of the most-respected and well-known leaders in the Perl community.

Curtis has been building software for decades. He specializes in building database-driven websites through his global development and consulting firm, [All Around The World](https://allaroundtheworld.fr/). He's the main developer behind [Tau Station](https://taustation.space/), a text-based Massive Multiplayer Online Browser Game (MMOBG) set in a vibrant, far-future universe.

He's the author of [Beginning Perl](https://www.amazon.com/Beginning-Perl-Curtis-Poe/dp/1118013840/) and [Perl Hacks](https://www.amazon.com/Perl-Hacks-Programming-Debugging-Surviving/dp/0596526741/). You can out more about his activities at [https://ovid.github.io/](https://ovid.github.io/).

He joined The Perl Foundation [boards of directors](https://news.perlfoundation.org/post/new_board_member) in 2009.

If you'd like me to interview you, or know someone you'd like me to interview, let me know. Take the same set of questions and send me your answers!

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

First, for those who are not familiar with Cor, you can read about it at [https://github.com/Ovid/Cor/wiki](https://github.com/Ovid/Cor/wiki). In short, Cor is a plan to add modern OO to the Perl core. But the motto is "'Good enough' is not good enough." We have to stop settling for what we can have and start dreaming about what we want. For a trivial example, here's a naïve LRU cache implementation in Cor:

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

#### How does your company "All around the world" help people with Perl?

The consulting world is a mess. Anyone can call themselves a consultant and presto, they're a consultant. This means that for the vast majority of consulting firms out there, quality is very hit-or-miss. So most companies hiring consultants are taking a huge gamble. But banks, insurance companies, and other "enterprise" companies prefer to stick with high-end consulting firms. From what I've seen, their code is more likely to do what you want it to do, but that's only if you can afford them.

So we decided to try a different approach. We can give our customers the reliability they want but at a more reasonable price if we do two things. First, we only hire the handful of senior developers who can pass both our technical test and a structured interview. Second, we limit the number of projects we take so we can dedicate serious attention to each customer. I'll put our team's quality up against the top-tier consulting firms any day of the week. But we're going to cost a much less than they do and we'll deliver faster, too.

To give a concrete example, we had a client who had two weeks to improve their performance by an order of magnitude. They had worked with us before, so they turned to us. Here's the case study of that project. It's a fun read and gives you a lot of insight into how top-level developers really work.

I should also note that while we have a deep specialization in Perl, we have also done work in quite a few other languages and technologies, such as Golang, C++, Lua, Node, Angular, and so on.

\
\

#### How is "Tau Station" going and how much Perl helped in building the game?

For those not familiar with it, [Tau Station](https://taustation.space) is a free to play narrative MMORPG with the backend written entirely in Perl. It's a beautiful sci-fi universe (unlike anything you've ever played before) and has all the stars within 20 light years of Earth. We're around half a million lines of code and we're still in open alpha. We're currently in the "final stretch" of building what we feel we need, so we anticipate the launch by the end of this year. Perl's tremendous flexibility has made it very easy to build out many of the features that we've needed. For example, we have a declarative system for building out many of the behaviors. Here's how you refuel a spaceship:

```perl
        Steps(
            Area(      $character => is_in            => 'docks' ),
            Ship(      $ship      => is_owned_by      => $character ),
            Ship(      $ship      => is_docked_on     => $character->station ),
            Character( $character => not_onboard_ship => $ship ),
            Ship(      $ship      => 'needs_refueling' ),
            Money(     $character => pay              => $ship->get_refuel_price ),
            Ship(      $ship      => 'refuel' ),
            Character(
                $character => set_cooldown => {
                    cooldown_type  => 'ship_refuel',
                    period         => $ship->get_refuel_time,
                },
            ),
        )
```

People are sometimes surprised to learn that this is Perl code because it's so easy to read, but they'd be even more surprised to learn that much of this would be harder to write in early-binding languages such as Java.

And by creating standard components like that, the developer who creates a new kind of behavior for the game often doesn't need to worry about database transactions, exceptions, or messages to the character. Instead, they can quickly assemble these "steps" in the correct order and you have new gameplay. If we ever had the time, we'd love to release the above framework as open source, but that would take time and we need to keep our clients happy, first.

\
\

#### Which Perl modules are you constantly using? How do they make your life easier?

[Test::Class::Moose]({<% mcpan Test::Class::Moose %>}) is a go to module for me. Most Perl developers learn how to test modules, not applications. With [Test::Class::Moose]({<% mcpan Test::Class::Moose %>}), large test suites become easier to build and manage and, when it's written correctly, many test suites can be an order of magnitude faster.

I also have a module I write for personal code called `Less::Boilerplate`. It's not on the CPAN because it's too fine-tuned for my personal needs, but naturally it enables [strict]({<% mcpan strict %>}), [warnings]({<% mcpan warnings %>}), signatures, [autodie]({<% mcpan autodie %>}), and other features without having to type everything out by hand. And it pleases me to have the double meaning of `use Less::Boilerplate` at the top of my code. Yet it's part of the issue that Sawyer's pointed out with Perl. New Perl developers don't know the strange incantations experienced Perl developers put at the top of their code to get Perl to be reasonable. That hurts the language because they get a poor "out of the box" experience.

\
\

#### Which Perl feature do you overuse?

It used to be the punctuation variables that I would sprinkle around my code like magic pixie dust. Things like local `$" = ', '` were natural to me. But I've stopped doing that because honestly, it's not readable. I do a lot of client work so I take care to ensure that my code is (as much as I can), easy to read and maintain. I've even rewritten some of my code to "dumb it down" because I want to ensure that it's maintainable.

\
\

#### Which Perl feature do you wish you could use more?

Given that clients call me in to help build new systems or fix existing ones, I pretty much get to pick and choose what features I want to use, so I'm fortunate in that regard. Thus, there's not much I don't get to use if I think it's useful. However, a feature I wish I could use more is a feature that doesn't exist: more standardized introspection tools, similar to a MOP. Mucking about in the symbol table for the things I need, or pulling in external libraries to find out where my code is located in the filesystem is frustrating. I often write code that magically "works" without having to be loaded (similar to plugins). But without standardized, cross-platform tools for finding the code, loading it dynamically, converting between package and filenames automatically, I find that I'm often rewriting this code again, for a different client, based on their operating system, file system layout, and so on.

\
\

####  What one thing you'd like to change about Perl?

How variables behave. There are a few things in that, but mainly, I wish Perl had invariant sigils like Raku and that arrays and hashes wouldn't flatten unless requested. But I'm not going to get that, so let's pretend I didn't ask :)

(Hmm, working threads might be interesting, too)
