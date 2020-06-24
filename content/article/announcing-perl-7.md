{
   "categories" : "perl7",
   "thumbnail" : "/images/announcing-perl-7/thumb_seven_on_blue_wall.jpg",
   "authors" : [
      "brian-d-foy"
   ],
   "image" : "/images/announcing-perl-7/seven_on_blue_wall.jpg",
   "description" : "Perl 5 with modern defaults",
   "tags" : ["tpcitc","preparing-for-perl-7","indirect"],
   "draft" : false,
   "title" : "Announcing Perl 7",
   "date" : "2020-06-24T11:34:35"
}

*image credit: [Darren Wood](https://www.flickr.com/photos/darren/), ["7"](https://www.flickr.com/photos/darren/3680674672/in/photolist-6Bfqm9-ino1FQ-g9QYp-LBqJ8U-2imZyN9-2g4LBC9-JrtM4R-MsDZU1-MkbMoz-BSxoYD-KHTzJX-JYzksq-G9dfcP-G5Byr3-LrnQMb-6hwfHT-9i4upm-oJfAkJ-8cQQBf-6NVCN1-Ph8487-N1UVUo-mrXQmx-8GoTKf-6fqvZk-Gi1cPH-Mae7Mo-282AxcA-Hvehqx-HbZrvj-YoKVff-H1FRCw-d81uq-jyUXx9-JZGmJj-JTpLp-82ZDob-P19B5f-EQFLnh-aJpXi-LyYS7u-9X3iK-CCTZD-bdCtm-5SGWuB-ET4D6C-9vWh2c-4mieMj-HpYqSw-2iHee4g), on Flickr.*

\
\

This morning at [The Perl Conference in the Cloud](https://perlconference.us/tpc-2020-cloud/), Sawyer X announced that Perl has a new plan moving forward. Work on Perl 7 is already underway, but it's not going to be a huge change in code or syntax. It's Perl 5 with modern defaults and it sets the stage for bigger changes later. My latest book [Preparing for Perl 7](https://leanpub.com/preparing_for_perl7) goes into much more detail.

\
\

## Perl 7 is going to be Perl 5.32, mostly

Perl 7.0 is going to be v5.32 but with different, saner, more modern defaults. You won't have to enable most of the things you are already doing because they are enabled for you. The major version jump sets the boundary between how we have been doing things and what we can do in the future.

Remember, Perl was the "Do what I mean" language where the defaults were probably what you wanted to do. In Perl 4 and the early days of Perl 5, that was easy. But, it's been a couple of decades and the world is more complicated now. We kept adding pragmas, but with Perl's commitment to backward compatibility, we can't change the default settings. Now we're back to the old days of C where we have to include lots of boilerplate before we start doing something:

```perl
use utf8;
use strict;
use warnings;
use open qw(:std :utf8);
no feature qw(indirect);
use feature qw(signatures);
no warnings qw(experimental::signatures);
```

This is slightly better with v5.12 and later because we get [`strict` for free](https://www.effectiveperlprogramming.com/2010/08/implicitly-turn-on-strictures-with-perl-5-12/) by using setting a minimum version:


```perl
use v5.32;
use utf8;
use warnings;
use open qw(:std :utf8);
no feature qw(indirect);
use feature qw(signatures);
no warnings qw(experimental::signatures);
```

Perl 7 is a chance to make some of these the default even without specifying the version. Perl 5 still has Perl 5's extreme backward compatibility behavior, but Perl 7 gets modern practice with minimal historical baggage. I'm personally hoping signatures makes the cut, but there's still much to be done to make Unicode the default, so you'll probably need to keep some of that:

```perl
use utf8;
use open qw(:std :utf8);
```

You might miss some seedier features that you shouldn't be using anyway, such as the indirect object notation. Larry Wall said he had to do something for the C++ programmers:

```perl
my $cgi = new CGI;  # indirect object, but not in Perl 7
my $cgi = CGI->new; # direct object
```

But, the feature doesn't really disappear in Perl 7. It's already [a setting in v5.32](https://www.effectiveperlprogramming.com/2020/06/turn-off-indirect-object-notation/), but now with a different default.

## What's happening to Perl 5?

No one is taking Perl 5 away from you; it goes into long term maintenance mode—a lot longer than the two years of rolling support for the two latest user versions. That might be up to a decade from now (or half the time Perl 5 has already been around).

## When is this happening?

The work is happening now, but you won't need to worry about it for about six months when the first release candidate should appear. The target for a user release of Perl 7.0 within the next year, with some release candidates along the way.

This is an easy promise to keep, too, since Perl 7 is mostly v5.32 with different defaults. There's no big rewrite or new features, although some currently experimental features may stabilize (please choose signatures!).

## What about CPAN?

The Comprehensive Perl Archive Network, CPAN, has almost 200,000 modules. The maintained modules that people are using should still work, and for the rest there will be a compatibility mode. Remember  Perl 7 is mostly v5.32 so you shouldn't need to change much.

You may not know that the [Perl5 Porters](https://lists.perl.org/list/perl5-porters.html) tests new versions against almost all of CPAN. There's a long history of tools to check the effect that changes may have on the Perl community. As a module author, I often get messages from various people, mostly Andreas Koenig or Slaven Rezić, about weird things in my modules that may break with new Perls. Usually, it's something I need to update anyway. Tracking down problems with existing code is a solved problem. Fixing code shouldn't be that onerous because it's still Perl 5, but with better practices.

Will there be a separate CPAN for Perl 7? No one has said there can't be, but in the jump to Perl 7, the developers don't want to redo what's already working. This change should be manageable with as few side quests as possible.

Also, PAUSE, the Perl Authors Upload Server, has received quite a bit of love in the past couple of years. That makes it easier for them to adapt to future needs. The people working on that are experienced and talented, and they've made the codebase much more tractable.

## Why the jump to a major version?

A major version can have a different contract with the user. A major version jump changes that contract with new default behavior, even if that conflicts with the past. There will be a way to reset all of those settings to the old Perl 5 default if you like. Perl 7 code will still be v5.32 code (mostly) in syntax and behavior though.

Sawyer speaks about three major market segments of Perl users:

* People who are never going to change their code
* People who use new features
* People starting from scratch

Perl 5's social contract is extreme backward compatibility, and has been amazingly successful with that. The problem is that the extreme backward compatibility works for those who won't update their code, but doesn't help the two other segments. The new features crowd has to deal with a longer boilerplate section in every program, and newbies wonder why they have to include so much just to create a program so people on StackOverflow won't hector them over missing pragmas.

## Why 7 and not 6?

There are two parts to this answer. First, "Perl 6" was already taken by what is now known as [Raku](https://raku.org). A long time ago, we thought that a very ambitious rewrite effort would replace v5.8. In short, that's not what happened and the language has gone on to live a life of its own.

So, 7 was the next available number. That's it. It's just the next cardinal number in line. It's not unheard of to make such a jump: PHP went directly from 5 to 7, and isn't it time to steal something from that community? Consider these other weird jumps in history:

* Solaris 2.6 to Solaris 7
* Java 1.4 to Java 5
* Postgres 9.x as the major version to Postgres 10 as the major version
* Windows 3.1 to Windows 95 (98, ME, 2000, XP, Vista, 7, 8, 10)
* TeX (each new version more closely approximates π)

At least it's not Perl 34.

## What's disappearing?

Not much. Some things will be disabled by default, but again, this is essentially Perl 5.32 with the knobs and dials in different places. There are some things you should learn to live without, even in Perl 5 land. These are the likely candidates for the first round of changes:

* indirect object notation
* bareword filehandles (except maybe the standard filehandles)
* fake multidimensional arrays and hashes (old Perl 4 trick)
* Perl 4-style prototype definitions (use `:prototype()` instead)

## What's appearing?

Not much. Perl 7 is mostly Perl v5.32, but with all of the features enabled by default. You don't have to do anything to get most new features, such as [postfix dereferencing](https://www.effectiveperlprogramming.com/2014/09/use-postfix-dereferencing/), the new [`isa` operator](https://www.effectiveperlprogramming.com/2020/01/use-the-infix-class-instance-operator/), or several other features. That's the benefit of the new social contract a major version provides. It's a hard boundary where new features can exist by default on one side without disturbing the other side.

## What should I do right now?

If you need an older Perl to run your code, you are going to be fine. Those old versions are not going to disappear. Just like Perl 5.6 is still available, if that's the version you wish to run.

If your code runs without a problem under strictures and warnings, and you are using modern Perl style, you're probably mostly good. If you have some bareword filehandles, start converting those. Same with the indirect object notation.

With messy code, you aren't out of luck. There will be compatibility modes to assist you in the transition from Perl 5 to 7 (but not Perl 5 to 8). A pragma will set the knobs and dials back to the old settings (but this is more of a one version thing):

```perl
use compat::perl5;  # act like Perl 5's defaults
```

For modules, there are some issues to shake out, but there will be a compatibility mechanism for those too.

The good news is that these things are already being tested by major Perl stakeholders in production settings. This isn't a paper plan: it's already happening and the rough edges are being sanded out.

And, v5.32 has one of these knobs and dials in place already. You can [turn off the indirect object notation](https://www.effectiveperlprogramming.com/2020/06/turn-off-indirect-object-notation/):

```perl
no feature qw(indirect);
```

But expect two more knobs or dials, maybe like:

```perl
no multidimensional;
no bareword::filehandle;
```

I'm collecting all of this information in [Preparing for Perl 7](https://leanpub.com/preparing_for_perl7), my latest offering through [Perl School](https://perlschool.com) and LeanPub.

## The bottom line

Perl 7 is v5.32 with different settings. Your code should work if it's not a mess. Expect a user release within a year.
