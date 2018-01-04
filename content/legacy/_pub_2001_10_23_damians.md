{
   "date" : "2001-10-23T00:00:00-08:00",
   "categories" : "perl-6",
   "title" : "Perl 6 : Not Just For Damians",
   "image" : null,
   "tags" : [
      "damian-conway",
      "larry-wall",
      "perl-6"
   ],
   "thumbnail" : "/images/_pub_2001_10_23_damians/111-damian.jpg",
   "description" : " London.pm technical meetings are always inspiring events with top notch speakers. At our most recent gathering Richard Clamp and Mark Fowler gave us \"Wax::On, Wax::Off - how to become a Perl sensei\"; Paul Mison showed us how to make...",
   "slug" : "/pub/2001/10/23/damians.html",
   "draft" : null,
   "authors" : [
      "piers-cawley"
   ]
}



London.pm technical meetings are always inspiring events with top notch speakers. At our most recent gathering Richard Clamp and Mark Fowler gave us "Wax::On, Wax::Off -- how to become a Perl sensei"; Paul Mison showed us how to make an infobot read the BBC news; Richard Clamp and Michael Stevens explained "Pod::Coverage", their contribution to Kwalitee assurance; and, for the first time ever, Leon Brocard didn't talk about Graphing Perl.

However, the highlight of the evening was Simon Cozens's first public demonstration of Parrot, the new virtual computer that will one day run Perl 6.

After he'd finished the talk we expected, he pulled a crumpled piece of paper from a secret pocket. This, he whispered, was an early draft of Apocalypse 3 which he'd smuggled out at great personal risk from under the very noses of the Design Team. An expectant hush fell as he proceeded to reveal the highlights.

The reception his heroic effort received was... low key. Everyone was pleased to get an early peek at what Larry was thinking, but there were widespread mutterings about "all this needless complexity" and "mere syntactic sugar". Almost everyone grumbled about the use of '`.`' for dereferencing. Almost everyone groused about using '`_`' for concatenation. And the reassurance that "It's only syntax" didn't seem to appease the doubters.

And then we all went for beer and/or Chinese food.

Fast forward to last weekend. The Apocalypse was [up on the website](/pub/2001/10/02/apocalypse3.html) and Damian had just published his Exegesis when Simon Wistow (London.pm's official scapegoat) warned the mailing list that he had:

> ... an impending sense of doom about Perl 6. The latest Apocalypse/Exegesis fill me with fear rather than wonder. I've got a horrible feeling that Perl 6 is trying to do too much at once.

This provoked a firestorm of agreement. The general consensus was that the latest Apocalypse was:

> reinventing wheels which we already have in abundance. And those new wheels have syntax that is only going to confuse those who are already experienced perl5 users

It seems that what we have here is a failure to communicate.

Yes, Damian's efforts have been superb in providing examples of code based on the Apocalypses, and I don't think anyone denies the sterling work that Dan and his team are doing with Parrot. But people do seem to be worried about Perl 6 being a rewrite for the Damians of this world, not for the ordinary Joe.

Well, I'm here to tell you that this ordinary Piers doesn't have a problem with Perl 6. In fact I'm excited and inspired by most of the work that's been done so far, and I hope to convince you too.

### <span id="perl6 doesn't look like perl">"Perl 6 doesn't look like Perl"</span>

Well, up to a point. The thing that you have to remember when reading the sample code that Damian provides in his Exegeses is that he is deliberately exercising all the new features in a condensed example. The most recent code sample is initially scary because there's so *much* stuff in Apocalypse 3. Admittedly, `$self.method()` looks weird now, but then, `$self->method()` looked weird when Perl 5 was introduced. And, on rereading Damian's example with an eye to what *hasn't* changed, the whole thing still looks like Perl.

### <span id="perl 6 just gives us syntax for stuff we can already do">"Perl 6 just gives us syntax for stuff we can already do"</span>

That's a mighty big 'just' there, partner. Consider the currying syntax. Before this came along, currying was possible, but required an unreasonable amount of manual work to implement. Just consider the following, 'simple' example:

In perl 6 we have:

        $^_ + $^_

In perl 5, if you didn't worry about currying you'd write:

        sub { $_[0] + $_[1] }

If you *do* worry about currying, you'll have to write:

        do { 
            my $self;
            $self = sub {
                my ($arg1, $arg2) = @_;
                return $arg1 + $arg2             if @_==2;
                return sub { $self->($arg1,@_) } if @_==1;
                return $self;
            }
        }

And I don't want to *think* about the hoops I'd have to jump through in the case of a curried function with three arguments, or if I wanted named arguments. Now, you could very well argue that you don't use anonymous functions much anyway, so you're certainly not going to be doing tricks with currying, and you may be right. But then, of course, if you don't want to use them *you don't have to*.

However, I'm betting that before long it will be just another spanner in your toolbox along with all the other gadgets and goodies that Larry's shown us so far. Tools that you use without a second thought.

If you've ever done any academic computer science, you might have come across Functional Programming, in which case an awful lot of what's new in Perl 6 so far will be looking surprisingly familiar. The thing is, until now, Functional Programming has been seen as only of concern to academics and the kind of weirdoes who are daft enough to write Emacs extensions and, dammit, Perl doesn't need it. There is even [an RFC](http://dev.perl.org/rfc/28.html) to this effect.

I remember saying almost exactly the same thing about another language feature of 'purely academic interest' that got introduced with perl 5; the closure.

I don't know about you, but closures are old friends now; another tool that gets pulled out and used where appropriate, with hardly a second thought.

### <span id="perl 6 doesn't give us anything that perl 5 doesn't.">"Perl 6 doesn't give us anything that Perl 5 doesn't."</span>

Yeah, and Perl 5 doesn't give us anything that a Universal Turing Machine, Intercal, or Python don't. We use it because it 'fits our brains'. The Perl 6 redesign is all about improving that fit.

### <span id="apocalypse 3 is mostly mere syntactic sugar">"</span>[Apocalypse 3](/pub/2001/10/02/apocalypse3.html) is mostly mere syntactic sugar"

You say that like it's a *bad* thing. Perl's creed has always been to make the easy things easy and the hard things possible. In many ways, Perl 6 is going further than that: making hard things easy. And Apocalypse 3 continues this trend.

Well chosen syntactic sugar is good voodoo. It's Laziness with a capital L, and Laziness, as we all know, is a virtue.

Let's look at what we get in Apocalypse 3.

#### <span id="item_The_hyper_operator%2E">The hyper operator.</span>

Well, this is just a `foreach` loop isn't it? Yes, but as Damian subsequently pointed out, would you rather write and maintain:

        my @relative;
        my $end = @max > @min ? @max > @mean ? $#max : $#mean
                              : @min > @mean ? $#min : $#mean;
        foreach my $i ( 0 .. $end ) {
            $relative[$i] = $mean[$i]) / ($max[$i] - $min[$i]);
        }

or

        my @relative = @mean ^/ (@max ^- @min);

In the second case, the intent of the code is clear. In the first it's obfuscated by the loop structure and set up code.

#### <span id="item_Chainable_file_test_ops">Chainable file test ops</span>

Why hasn't it *always* worked like this? Ah yes, because the internals of perl 5 wouldn't allow for it. This is an example of the far reaching effects of some of the earlier Apocalypses giving us cool stuff.

Let's do the comparison again.

Perl 5:

        my @writable_files = grep {-f $_ && -r _ && -w _ && -x _} @files;

Perl 6:

        my @writable_files = grep { -r -w -x -f $_ } @files;

Shorter and clearer. Huzzah.

#### <span id="item_Binary_%27%3B%27">Binary ';'</span>

This one's a bit odd. We've not yet seen half of what's going to be done with it, but I have the feeling that the multidimensional array mongers are going to have a field day.

#### <span id="item_%3D%3E_is_a_pair_builder">=&gt; is a pair builder</span>

Mmmm... pairs. Lisp flashbacks! Well, yes. But if hashes are to become 'bags' of pairs, then it seems that hash keys won't be restricted to being simple strings. Which is brilliant. On more than several occasions I've found myself wanting to do something along the lines of

        $hash{$object}++;

and then later do

        @results = map  { $_.some_method }
                   grep { $hash{$_} > 1 }
                       keys %hash;

Try doing that in Perl 5.

The use of pairs for named arguments to subroutines looks neat too, and should avoid the tedious hash setup that goes at the top of any subroutine that's going to accept named parameters in Perl 5.

#### <span id="item_Lazy_lists">Lazy lists</span>

Lazy lists are cool, though I note that Damian couldn't squeeze a compelling example of their usage in Exegesis 3. For some applications they are a better mousetrap, and if you don't actually need them they're not going to get in your way. I'm not sure if Larry has confirmed it yet, but I do like the idea of being able to do:

        my($first,$second,$third) = grep is_prime($_), 2 .. Inf;

and have things stop when the first three primes have been found.

And having

        my($has_matches) = grep /.../ @big_long_list;

stop at the first match would be even better.

#### <span id="item_Logical_operators_propagating_context">Logical operators propagating context</span>

Where's the downside? This can only be a good thing. Multiway comparison `0 < $var <= 10` is another example of unalloyed goodness.

#### <span id="item_Backtracking_operators">Backtracking operators</span>

I'm not entirely sure I understand this yet. But it looks like it has the potential to be a remarkably powerful way of programming (just like regular expressions are, which do *loads* of backtracking). I have the feeling that parser writers are going to love this, and equation solvers, and...

But again, if you don't need the functionality, don't use it. It'll stay out of your way.

#### <span id="item_All_operators_get_%27proper%27_function_names%2E">All operators get 'proper' function names.</span>

This one almost had me punching the air. It's brilliant. Especially if, like me, you're the kind of person who goes slinging function references around. (One of the things that I really like about Ruby is its heady mix of functional style higher order functions and hard core object orientation. It looks like Perl's getting this too.)

Again, time to make with the examples. Consider the following perl code from an Assertion package (this is in Perl 6, it's too hard to write clearly in Perl 5).

        &assert_with_comparator := {
            unless ($^comparator.($^a, $^b)) {
                throw Exception::FailedComparison :
                    comparator => $^comparator,
                    result     => $^a,
                    target     => $^b
            }
        }

        &assert_string_equals := assert_with_comparator(&operator:eq);
        &assert_num_equals    := assert_with_comparator(&operator:==);
        &assert_greater_than  := assert_with_comparator(&operator:>);

That's full strength Perl 6 that is, complete with currying, operators as functions, [`:=`](#item_%3A%3D) binding, `:` used to disambiguate indirect object syntax, the whole nine yards. And it is still obviously a Perl program. The intent of the code is clear, even without comments, and it took very little time to write. Of course, I am assuming an Exception class, but we've already got that in Perl 5; take a look at the lovely `Error.pm`.

I'm not going to rewrite `assert_with_comparator`, but just look at the Perl 5 version of the last line of that example:

        *Assert::assert_greater_than =
            $assert_with_comparator->(sub { $_[0] > $_[1] });

Don't try and tell me that the intent is clearer in Perl 5 than in Perl 6, because I'll be forced to laugh at you.

#### <span id="item_binary_and_unary_%27%2E%27">binary and unary '.'</span>

I confess that I'm still not sure I see where binary '`.`' is a win over '`->`', especially given that Larry has mandated that most of the time you won't even need it.

Unary '`.`' is looking really cool. If I read the Apocalypse right, this means that, instead of writing object methods like:

        sub method {
            my $self = shift;
            ...
            $self->{attribute} = $self->other_method(...);
            ...
        }

We can write:

        sub method {
            ...
            $.attribute = .other_method(...);
            ...
        }

Which is, once more clean, clear and perl like. This is the kind of notation I want Right Now. And, frankly, it'd just look silly if you replaced those '.'s with '`->`' (and should one parse `$->attribute` as an instance variable accessor, or as `$- > attribute`). Okay, I'm convinced. Replace '`->`' with '`.`' already.

#### <span id="item_Explicit_stringification_and_numification_operator">Explicit stringification and numification operators</span>

Again, these have got to be good magic, especially with the `NaN` stuff (though that's been the cause of some serious debate on perl6-language and may not be the eventual name). In at least one of the modules I'm involved in writing and maintaining, this would have been *so* useful:

        # geq: Generic equals
        sub operator:geq is prec(\&operator:eq($$)) ($expected, $got)
        {
            # Use numericness of $expected to determine which test to use
            if ( +$expected eq 'NaN') { return $expected eq $got }
            else                      { return $expected == $got }
        }

        sub assert_equals ($expected, $got; $comment)
        {
            $comment //= "Expected $expected, got $got";
            $expected geq $got or die $comment;
        }

Hey! That looks just like Perl! (Except that, to do the same thing in Perl 5, you have to jump through some splendidly non-obvious hoops. Trust me, I've done that.)

#### <span id="item_%3A%3D">:=</span>

This one had me scratching my head as I read the Apocalypse. On reading the Exegesis, things become a good deal clearer. [`:=`](#item_%3A%3D) looks like it's going to be an easy way to export symbols from a module, now that typeglobs have gone away:

        package Foo;
        sub import ($class, @args) {
            # This is an example, ignore the args
            &{"${class}::foo"} := &Foo::foo;
        }

Of course, this isn't the only place where [`:=`](#item_%3A%3D) will be used. Thankfully we'll be able to use it almost everywhere without having to remember all the caveats that used to surround assigning to typeglobs. Here's another example in Perl 6 of something that would be impossible in Perl 5:

        $Sunnydale{ScoobyGang}{Willow}{Traits} = [qw/cute geeky/];

        # Oooh Seasons 4 and 5 happened and I want
        # to use a trait object now

        $traits := $Sunnydale{ScoobyGang}{Willow}{Traits};
        $traits = new TraitCollection: qw/sexy witch lesbian geek/;

Nothing special there you say. Well, yes, but let's take a look at

        print $Sunnydale{ScoobyGang}{Willow}{Traits}
        # sexy witch lesbian geek
        # Or however a TraitCollection stringifies.

You can *almost* do this in Perl 5, but only if you continue to use an array:

        local *traits = $Sunnydale{ScoobyGang}{Willow}{Traits};
        @traits = qw/sexy witch lesbian geek/;

If you want to switch to using a `TraitCollection`, you'll have to go back and use the full specifier.

I think this is another of those bits of syntax that I'd like now, please.

#### <span id="item_Binary_%3A">Binary :</span>

This is going to make life so much easier for the parser if nothing else. Right now, indirect object syntax can be very useful. However, if you've ever tried to use it in anger, well, you've ended up using it in anger because there are some subtle gotchas that will catch you out. Binary : lets us disambiguate many of these cases and helps to reclaim indirect object syntax as a useful way of working.

And so on... What's not to like? The sugar is sweet, the consistency is just right, and the old annoyances are going away.

### <span id="perl 6 inspires fear.">"Perl 6 inspires fear."</span>

Well, maybe. But it also just flat out inspires. If you don't believe me, take a look at the response to Perl 6 on CPAN. Damian's `Attribute::Handlers` successfully attempts to graft some of Perl 6's ease of manipulation of attributes back into Perl 5, and does a remarkably good job of it. Just look at all the really cool new modules that have sprung up around it. And that's just a small part of what we're going to get with Perl 6.

There are many new modules that exist only to 'mutate' perl5 behaviour -- `NEXT`, `Hook::LexWrap`, `Aspect`, `Switch`, `Coro` etc. I would argue that many of these have arisen in response to discussions about making Perl 6 a far more mutable language than Perl 5. And, if nothing else, these modules have gone some way to demonstrating that even now, Perl is more flexible than we ever realised.

### <span id="perl 6 is taking too long">Perl 6 is taking too long</span>

I'm not quoting anyone else here; that's me complaining. I want it all and I want it now! But I also want a well thought out and coherent design. The choice between doing it Right and doing it Now is not a choice. Doing it Right is imperative.

The changes that Larry is making to the language will have far reaching and probably unforeseen consequences. But that's no reason for shying away from them. I've been programming in Perl for long enough to remember the transition from Perl 4 to Perl 5, and I remember delaying my own move to perl 5 for an embarrassingly long time. I didn't understand the new stuff in 5 and I hadn't a clue why anyone would want it, so I put off the move.

Eventually, I held my nose and jumped in. References were so cool. The new, 'real', data structures meant an end to contortions like:

        $hash{key} = join "\0", @list;

        # and later...

        @list = split /\0/, $hash{key};

Within a remarkably short space of time almost everything that had confused and scared me became almost second nature. Stuff that had been a complete pain in Perl 4 was a breeze Perl 5 (who remembers Oraperl now?) It seemed that all you had to remember was to change `"pdcawley@bofh.org.uk"` to `"pdcawley\@bofh.org.uk"`.

The same thing is going to happen with Perl 6. Even if it doesn't, all those perl 5 binaries aren't going to disappear from the face of the earth.

What I'm most looking forward to are the gains we're going to see from Perl becoming easier to parse. Over in the Smalltalk world they have this almost magical thing called the 'Refactoring Browser' which is a very smart tool for messing with your source code. Imagine being able highlight a section of your code, then telling the browser to 'extract method'.

The browser then goes away, works out what parameters the new method will need, creates a brand new method which does the same thing as the selected code and replaces the selected section with a method call.

This is Deep Magic. Right now it's an almost impossible trick to pull off in Perl, because the only thing that knows how to parse Perl is perl. It is my fond hope that, once we get Perl 6, it's going to be possible to implement a Perl refactoring browser, and my work with ugly old code bases will become far, far easier.

But even if that particular magic wand never appears, Perl 6 is still going to give us new and powerful ways to do things, some of which we'd never even have tried to do before. Internally it's going to be fast and clean, and we're going to get real Garbage Collection at last. If Parrot fulfils its early promise, we may well see Perl users taking advantages of extensions written in Ruby, or Python, or Smalltalk. World peace will ensue! The lion will lay down with the lamb, and the camel shall abide with the serpent! Cats and dogs living together! Ahem.

It's been a long strange trip from perl 1.0 to where we are today. Decisions have been taken that made sense at the time, which today see us lost in a twisty little maze of backward compatibility (or should that be a little twisty maze...). Anyone who looks at the source code for Perl 5 will tell you it's scary, overly complex, and a complete nightmare to maintain. And that's if they understand it.

Perl 6 is our chance to learn from Perl 5, but Perl 6 is also going to be Perl remade. If everything goes to plan (and I see no reason why it won't) we will arrive at Perl 6 with the crud jettisoned and the good stuff improved. We'll be driven by a gleaming, modern engine unfettered by the limitations of the old one. We'll have a shiny new syntax that builds on the best traditions of the old to give us something that is both brand new and comfortingly familiar.

And there, in the Captain's chair, you'll still find Larry, smiling his quiet smile, comfortable in the knowledge that, even if he doesn't know exactly where we're going, it'll be a lot of fun finding out. Over there, at the science officer's station, Damian is doing strange things with source filters, haikus and Quantum. A calm voice comes up from engineering; it's Dan, telling us that the new engines *can* take it. And at the helm Nat Torkington gently steers Perl 6 on her continuing mission towards new code and new implementations.

And Ensign Cawley? Well... there's a strange alien device called a refactoring browser. I'm going to be replicating one for Perl.
