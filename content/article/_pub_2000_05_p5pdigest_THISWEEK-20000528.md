{
   "date" : "2000-05-28T00:00:00-08:00",
   "title" : "This Week on p5p 2000/05/28",
   "image" : null,
   "categories" : "community",
   "thumbnail" : null,
   "tags" : [],
   "description" : " Notes Regex Engine Enhancements eq and UTF8 operator Caching of the get*by* Functions Forbidden Declarations Continued Perl in the News readonly Pragma Continues Magical Autoincrement Doctor, Doctor, it Hurts When I Do This! use strict 'formatting' Complex Expressions in...",
   "slug" : "/pub/2000/05/p5pdigest/THISWEEK-20000528.html",
   "authors" : [
      "mark-jason-dominus"
   ],
   "draft" : null
}



-   [Notes](#Notes)
-   [Regex Engine Enhancements](#Regex_Engine_Enhancements)
-   [`eq` and UTF8 operator](#eq_and_UTF8_operator)
-   [Caching of the `get`\*`by`\* Functions](#Caching_of_the_getby_Functions)
-   [Forbidden Declarations Continued](#Forbidden_Declarations_Continued)
-   [Perl in the News](#Perl_in_the_News)
-   [`readonly` Pragma Continues](#readonly_Pragma_Continues)
-   [Magical Autoincrement](#Magical_Autoincrement)
-   [Doctor, Doctor, it Hurts When I Do This!](#Doctor_Doctor_it_Hurts_When_I_Do_This)
-   [`use strict 'formatting'`](#use_strict_formatting)
-   [Complex Expressions in Formats](#Complex_Expressions_in_Formats)
-   [`pack("U")`](#packU)
-   [Various](#Various)

### <span id="Notes">Notes</span>

You can subscribe to an email version of this summary by sending an empty message to [`p5p-digest-subscribe@plover.com`.](mailto:p5p-digest-subscribe@plover.com)

Please send corrections and additions to `mjd-perl-thisweek-YYYYMM@plover.com` where `YYYYMM` is the current year and month.

This week's report is a little early, because tomorrow I have to leave to go on the Perl Whirl. Next week's report will be late, for the same reason.

Quite a lot of discussion this month, much of it rather pointless. Not one of our better weeks, I'm afraid.

### <span id="Regex_Engine_Enhancements">Regex Engine Enhancements</span>

Ben Tilly, Ilya Zakharevich, and François Désarménien had a discussion about an alternative implementation of the regex engine. I'm going to try to summarize the necessary background as briefly as possible.

The regex engine is a state machine. The engine looks through the characters in the target string one at a time and makes a state transition on each one; at the end of the string it looks to see if it is in an \`accepting state' and if so, the pattern matches. What regex you get depends on how the states are arranged and what are the transitions between them.

The basic problem that all regex engines face is that a certain state might have two different transitions on the same condition. For example, suppose you are matching `/foo(b*)bar/` and you have seen `foo` already. You are now in a state that expects to see an upcoming `b`. When you see the `b`, however, you get two choices: You can go back to the same state and look for another `b`, or you can go on to the next state and look for an `a`. If the string is `foobbbar` then the first choice is correct; if the string is `foobar` then the second choice is correct.

There are basically two ways to deal with this. One way is to use a representation of the state machine that keeps track of all the states that the machine could be in at once. In the example above, it would note that the machine might be in either of the two possible states. Future transitions might lead to more uncertainty about the state that the machine was actually in. At the end of the string, the engine just checks to see if *any* of the possible result states are acceptingstates, and if so, it reports that there is a match. This is called the 'DFA' approach.

The other approach is to take one of the two choices arbitrarily and remember that if the match does not work out, you can backtrack and try the other alternative instead. This is called the 'NFA' approach, and it is what Perl does. It choses to go back and try the current state first, before it tries going on to the next state; that is what makes Perl's `*` operator greedy. For the non-greedy `*?` operator it just chooses the other alternative first.

Both approaches have upsides and downsides. Downsides of the NFA approach: It is generally slower at run-time. It is more difficult to handle non-greedy matching and backreferences. Downsides of the DFA approach: It is prone to take a very long time for certain regexes, because of its habit of trying many equivalent alternatives one at a time. Also, it is very hard to specify that you want the longest possible match---consider writing a Perl regex that matches whichever of `/elsif|\w+/` is longer. This is easy to implement if you use an NFA.

Ben's idea is that you would start with an NFA and then apply a well-known transformation to turn it into a DFA. The well-known transformation is that each state in the DFA corresponds to a set of states that the original NFA could have been in; Ben's idea is that you can retain the information about the order in which the states would have been visited, and use those ordered sets of NFA states as single DFA states. The problem with this sort of construction is that under some circumstances the number of states explodes exponentially---if the original NFA had n states then the resulting DFA could have up to 2<sup>n</sup> states. With Ben's idea this is evenworse, because the resulting DFA might have up to (n+1)! states. But as Ben points out, in practice it is usually well-behaved. You would be trading off an unusual run-time bad behavior for a (probably) more unusual compile-time bad behavior. On the other hand, if Ben's scheme went bad at compile time, it would go really bad and eat all your memory. Also, it is really unclear how to handle backreferences with his scheme. Ben waved his hands over this and Ilya did not have any ideas about how to do it.

There was some discussion of various other regex matters. Ben had formerly suggested a `(?\/)` operator that matches the empty string but which inhibits backtracking; if the engine tries to backtrack past it, it fails. SNOBOL had something like this, called `FENCE`. Ilya said he did not want to do this because he thought all the useful uses were already covered by `(?>...)` and because he did not want to implement a feature that was only explainable in terms of backtracking. He also said you could get this behavior by doing

            (?:|(?{die}))

and putting the regex match into an `eval` block. (Did you get that? It first tries to match the empty string, to the left of the `|`, and if that doesn't work, it tries to match `(?{die})`, which throws an exception.)

Ben suggested that the regex engine could have a hook in it that would call an alternative regex engine, handing it the string to be matched and the current position, and the subengine would return a value saying how far it had matched up to; this would facilitate trying out alternative implementations or new features.

Ilya spent some time discussion new features he thought might be useful. [One such message.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg01056.html)

When Ilya mentioned SNOBOL is went into SNOBOL-berserk mode and posted a twelve-page excerpt from the SNOBOL book about SNOBOL pattern-matching optimizations, which was not particularly relevant to the rest of the discussion.

[Root of this thread](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00853.html)

### <span id="Perl_in_the_News">Perl in the News</span>

[The News](http://news.cnet.com/news/0-1007-200-1939586.html?tag=st.ne.1002.tgif.ni)

Dick Hardt was quoted out of context. This led to a really boring and offtopic advocacy discussion. Several people were asked to take the discussion to the advocacy mailing list. This meant that they cc'ed the discussion to both lists. Brilliant.

Folks, I love the advocacy list because then people who want to have interminable discussions about why Perl is considered slow and bloated have somewhere to do it where I don't have to hear it. Maybe someday I will commit a heinous crime and be sentenced to produce a weekly summary of discussion on the Perl Advocacy mailing list, and I will be unable to plea-bargain my way to a lesser offense that carries the death penalty. Until then, please do me a favor and keep advocacy discussion out of p5p.

### <span id="Doctor_Doctor_it_Hurts_When_I_Do_This">Doctor, Doctor, it Hurts When I Do This!</span>

> **Garrett Goebel:**
>
>     my $val = shift; 
>     substr($bitstring,2,4) = pack('p',$val); 
>
> **Ilya Zakharevich:**
>
> Do not.
> Hope this helps,
> Ilya

### <span id="eq_and_UTF8_operator">`eq` and UTF8 operator</span>

Clark Cooper asked why a UTF8 string will not compare `eq` to a non-UTF8 string whose bytes are identical.

Ilya replied that the short answer is that they should not compare `eq` because they represent different sequences of characters.

He then elaborated and said that the internal representation does not matter; that a string is a sequence of characters, and a character is just an integer in some range. In old Perls the range was 0..255; now the range is 0..(2\*\*64-1), and the details about how these integers are actually represented is not part of the application's business.

### <span id="Caching_of_the_getby_Functions">Caching of the `get`\*`by`\* Functions</span>

Last week Steven Parkes complained that when he used the `LWP::UserAgent` module, each new agent caused a call to one of the `getprotoby`\* functions, which opened the `/etc/protocols` file and searched it. Many agents, many searches. He pointed out that there is no way to get `LWP::protocol::http` or `IO::Socket::inet::_sock_info`, the culprit functions, to cache the protocol information.

Ben Tilly suggested adding a caching layer to those functions, or having the standard modules use a cached version. Tom pointed out that the uncached call only takes 1/6000 second on his machine, so it is unlikely to be a real problem in practice, and that the caching is hard to get right in general. Russ pointed out that it is a very bad idea to have application-level caching of `gethostby`\* and `getaddrby`\* calls, because such caching ignores the TTL in the DNS record. Other points raised: Caching of DNS information is already done in the `named`, and correctly. Any caching of DNS information done at the `gethostby`\* level is guaranteed to be wrong.

### <span id="Forbidden_Declarations_Continued">Forbidden Declarations Continued</span>

Last week I complained about the error

            In string, @X::Y must now be written as \@X::Y...

In the ensuing discussion, I suggested that this error message be removed. We have been threatening since 1993 that

> Someday it will simply assume that an unbackslashed`@` interpolates an array.

Sarathy said that he thought this should have appened two years ago, so I provided a patch. Interpolating an undeclared array into a string is no longer a fatal error; instead, it will raise the warning

            Array @X::Y will be interpolated in string

if you have warnings enabled.

[The patch.](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-05/msg00850.html)

[This article has a detailed explanation of the history of this error message.](http://www.plover.com/~mjd/perl/at-error.html)

[Previous Discussion](/pub/2000/05/p5pdigest/THISWEEK-20000521.html#Forbidden_Declarations)

### <span id="readonly_Pragma_Continues">`readonly` Pragma Continues</span>

[Previous Discussion](/pub/2000/05/p5pdigest/THISWEEK-20000521.html#readonly_Pragma)

Mark Summerfield does not like any of the alternatives that were proposed. There are several `tie`-based solutions which are too slow. He does not like William Setzer's `Const` module because at happens at run time so you have to declare the readonly variable separately from the place you make it constant. (I wonder if

            const my $x = 12;

would work?)

He also complained that even if you mark a scalar as readonly, someone else can go into the glob and replace the entire scalar, with

            *pi = \3;

A couple of people replied that if someone wants to change your read-only value so badly that they are willing to hack the symbol table to do it, then they should be allowed to do so.

Tom posted what I think was a quote from Larry saying that

            my $PI : constant = 4 * atan2(1,1);

was coming up eventually.

### <span id="Magical_Autoincrement">Magical Autoincrement</span>

Vadim Konovalov complained that

            $a = 'a';
            $a==5;
            $a++;

Increments `$a` to 1 instead of to `b`. This is as documented:

> The auto-increment operator has a little extra builtin magic to it. If you increment a variable that is numeric, **or that has ever been used in a numeric context**, you get a normal increment.

### <span id="use_strict_formatting">`use strict 'formatting'`</span>

Ben Tilly suggested a `use strict 'formatting'` declaration that would tell Perl to issue a diagnostic whenever the indentation and the braces were inconsistent. However, he did not provide a patch.

### <span id="Complex_Expressions_in_Formats">Complex Expressions in Formats</span>

H. Merijn Brand points out that complex variable references, such as `$e[1]{101}` seem to be illegal in formats. However, he did not provide a patch.

### <span id="packU">`pack("U")`</span>

Meng Wong pointed out that `pack("U")`, which is documented as

            [pack] A Unicode character number.  Encodes to UTF-8
            internally.  Works even if C<use utf8> is not in effect.

does not produce a UTF8 string. Simon provided a patch for that. Then a discussion between Ilya, Sarathy, and Gisle Aas ensued about whether this was the right thing to do. Gidle said it was not, and asked what `pack("UI")` should produce. Sarathy said that `"U"` packs a character in the UTF-8 encoding, and UTF-8 is encoded with bytes; therefore the result of the `pack` should be bytes, not another UTF-8 string. Ilya asked then what should happen if someone did

            $a = pack "A20 I", $string, $number;

where `$string` contained characters with values larger than 255. Sarathy said that `"A"` is defined to be ASCII, so it should die. Then Ilya pointed out that if it did that there would be no way to take a UTF8 string and insert it into a 20-byte fixed-width field. Discussion went on, and I was not able to discern a clear conclusion.

### <span id="Various">Various</span>

A large collection of bug reports, bug fixes, non-bug reports, questions, answers, and a small amount and spam. No serious flamage however.

Until next week I remain, your humble and obedient servant,

------------------------------------------------------------------------

[Mark-Jason Dominus](mailto:mjd-perl-thisweek-200005+@plover.com)
