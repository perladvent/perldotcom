{
   "description" : " Editor's Note: this Apocalypse is out of date and remains here for historic reasons. See Synopsis 03 for the latest information. Table of Contents  RFC 025: Operators: Multiway comparisons  RFC 320: Allow grouping of -X file tests...",
   "draft" : null,
   "tags" : [],
   "slug" : "/pub/2001/10/02/apocalypse3.html",
   "categories" : "perl-6",
   "title" : "Apocalypse 3",
   "authors" : [
      "larry-wall"
   ],
   "thumbnail" : "/images/_pub_2001_10_02_apocalypse3/111-apocalypse.jpg",
   "image" : null,
   "date" : "2001-10-02T00:00:00-08:00"
}



*Editor's Note: this Apocalypse is out of date and remains here for historic reasons. See [Synopsis 03](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the latest information.*

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td></td>
</tr>
<tr class="even">
<td><p>Table of Contents</p>
<p>• <a href="/pub/a/2001/10/02/apocalypse3.html?page=2#rfc%20025:%20operators:%20multiway%20comparisons">RFC 025: Operators: Multiway comparisons</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=2#rfc%20320:%20allow%20grouping%20of%20x%20file%20tests%20and%20add%20filetest%20builtin">RFC 320: Allow grouping of -X file tests and add <code>filetest</code> builtin</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=2#rfc%20290:%20better%20english%20names%20for%20x">RFC 290: Better english names for -X</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=3#rfc%20283:%20tr///%20in%20array%20context%20should%20return%20a%20histogram">RFC 283: <code>tr///</code> in array context should return a histogram</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=3#rfc%20084:%20replace%20=%3E%20(stringifying%20comma)%20with%20=%3E%20(pair%20constructor)">RFC 084: Replace <code>=&gt;</code> (stringifying comma) with <code>=&gt;</code> (pair constructor)</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=3#rfc%20081:%20lazily%20evaluated%20list%20generation%20functions">RFC 081: Lazily evaluated list generation functions</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=4#rfc%20285:%20lazy%20input%20/%20contextsensitive%20input">RFC 285: Lazy Input / Context-sensitive Input</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=4#rfc%20082:%20arrays:%20apply%20operators%20elementwise%20in%20a%20list%20context">RFC 082: Arrays: Apply operators element-wise in a list context</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=4#rfc%20045:%20%7C%7C%20and%20&amp;&amp;%20should%20propagate%20result%20context%20to%20both%20sides">RFC 045: <code>||</code> and <code>&amp;&amp;</code> should propagate result context to both sides</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=5#rfc%20054:%20operators:%20polymorphic%20comparisons">RFC 054: Operators: Polymorphic comparisons</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=5#rfc%20104:%20backtracking">RFC 104: Backtracking</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=5#rfc%20143:%20case%20ignoring%20eq%20and%20cmp%20operators">RFC 143: Case ignoring <code>eq</code> and <code>cmp</code> operators</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=5#rfc%20170:%20generalize%20=~%20to%20a%20special%20applyto%20assignment%20operator">RFC 170: Generalize <code>=~</code> to a special ``apply-to'' assignment operator</a><br />
<br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#nonrfc%20considerations">Non-RFC considerations</a></p>
<table>
<tbody>
<tr class="odd">
<td> </td>
<td><span class="tiny"> • <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#binary%20.%20(dot)">Binary <code>.</code> (dot)</a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#unary%20.%20(dot)">Unary <code>.</code> (dot)</a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#binary%20_">Binary <code>_</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#unary%20_">Unary <code>_</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#unary%20+%20X">Unary <code>+</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#binary%20:=%20Y">Binary <code>:=</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#unary%20*%20XX">Unary <code>*</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#list%20context">List context</a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#binary%20:%20YY">Binary <code>:</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#trinary%20::">Trinary <code>??::</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#binary%20//%20YYY">Binary <code>//</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#binary%20;%20YYYY">Binary <code>;</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#unary%20%5E%20XXX">Unary <code>^</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#unary%20">Unary <code>?</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#binary%20">Binary <code>?</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#binary%20~%20YYYYY">Binary <code>~</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#binary%20~~%20YYYYYY">Binary <code>~~</code></a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#user%20defined%20operators">User defined operators</a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#unicode%20operators">Unicode operators</a><br />
• <a href="/pub/a/2001/10/02/apocalypse3.html?page=6#precedence">Precedence</a><br />
</span></td>
</tr>
</tbody>
</table></td>
</tr>
<tr class="odd">
<td></td>
</tr>
</tbody>
</table>

To me, one of the most agonizing aspects of language design is coming up with a useful system of operators. To other language designers, this may seem like a silly thing to agonize over. After all, you can view all operators as mere syntactic sugar -- operators are just funny looking function calls. Some languages make a feature of leveling all function calls into one syntax. As a result, the so-called functional languages tend to wear out your parenthesis keys, while OO languages tend to wear out your dot key.

But while your computer really likes it when everything looks the same, most people don't think like computers. People prefer different things to look different. They also prefer to have shortcuts for common tasks. (Even the mathematicians don't go for complete orthogonality. Many of the shortcuts we typically use for operators were, in fact, invented by mathematicians in the first place.)

So let me enumerate some of the principles that I weigh against each other when designing a system of operators.

-   Different classes of operators should look different. That's why filetest operators look different from string or numeric operators.
-   Similar classes of operators should look similar. That's why the filetest operators look like each other.
-   Common operations should be \`\`Huffman coded.'' That is, frequently used operators should be shorter than infrequently used ones. For how often it's used, the `scalar` operator of Perl 5 is too long, in my estimation.
-   Preserving your culture is important. So Perl borrowed many of its operators from other familiar languages. For instance, we used Fortran's `**` operator for exponentiation. As we go on to Perl 6, most of the operators will be \`\`borrowed'' directly from Perl 5.
-   Breaking out of your culture is also important, because that is how we understand other cultures. As an explicitly multicultural language, Perl has generally done OK in this area, though we can always do better. Examples of cross-cultural exchange among computer cultures include XML and Unicode. (Not surprisingly, these features also enable better cross-cultural exchange among human cultures -- we sincerely hope.)
-   Sometimes operators should respond to their context. Perl has many operators that do different but related things in scalar versus list context.
-   Sometimes operators should propagate context to their arguments. The `x` operator currently does this for its left argument, while the short-circuit operators do this for their right argument.
-   Sometimes operators should force context on their arguments. Historically, the scalar mathematical operators of Perl have forced scalar context on their arguments. One of the RFCs discussed below proposes to revise this.
-   Sometimes operators should respond polymorphically to the types of their arguments. Method calls and overloading work this way.
-   Operator precedence should be designed to minimize the need for parentheses. You can think of the precedence of operators as a partial ordering of the operators such that it minimizes the number of \`\`unnatural'' pairings that require parentheses in typical code.
-   Operator precedence should be as simple as possible. Perl's precedence table currently has 24 levels in it. This might or might not be too many. We could probably reduce it to about 18 levels, if we abandon strict C compatibility of the C-like operators.
-   People don't actually want to think about precedence much, so precedence should be designed to match expectations. Unfortunately, the expectations of someone who knows the precedence table won't match the expectations of someone who doesn't. And Perl has always catered to the expectations of C programmers, at least up till now. There's not much one can do up front about differing cultural expectations.

It would be easy to drive any one of these principles into the ground, at the expense of other principles. In fact, various languages have done precisely that.

My overriding design principle has always been that the complexity of the solution space should map well onto the complexity of the problem space. Simplification good! Oversimplification bad! Placing artificial constraints on the solution space produces an impedence mismatch with the problem space, with the result that using a language that is artificially simple induces artificial complexity in all solutions written in that language.

One artificial constraint that all computer languages must deal with is the number of symbols available on the keyboard, corresponding roughly to the number of symbols in ASCII. Most computer languages have compensated by defining systems of operators that include digraphs, trigraphs, and worse. This works pretty well, up to a point. But it means that certain common unary operators cannot be used as the end of a digraph operator. Early versions of C had assignment operators in the wrong order. For instance, there used to be a `=-` operator. Nowadays that's spelled `-=`, to avoid conflict with unary minus.

By the same token (no pun intended), you can't easily define a unary `=` operator without requiring a space before it most of the time, since so many binary operators end with the `=` character.

Perl gets around some of these problems by keeping track of whether it is expecting an operator or a term. As it happens, a unary operator is simply one that occurs when Perl is expecting a term. So Perl could keep track of a unary `=` operator, even if the human programmer might be confused. So I'd place a unary `=` operator in the category of \`\`OK, but don't use it for anything that will cause widespread confusion.'' Mind you, I'm not proposing a specific use for a unary `=` at this point. I'm just telling you how I think. If we ever do get a unary `=` operator, we will hopefully have taken these issues into account.

While we can disambiguate operators based on whether an operator or a term is expected, this implies some syntactic constraints as well. For instance, you can't use the same symbol for both a postfix operator and a binary operator. So you'll never see a binary `++` operator in Perl, because Perl wouldn't know whether to expect a term or operator after that. It also implies that we can't use the \`\`juxtaposition'' operator. That is, you can't just put two terms next to each other, and expect something to happen (such as string concatenation, as in *awk*). What if the second term started with something looked like an operator? It would be misconstrued as a binary operator.

Well, enough of these vague generalities. On to the vague specifics.

The RFCs for this apocalypse are (as usual) all over the map, but don't cover the map. I'll talk first about what the RFCs do cover, and then about what they don't. Here are the RFCs that happened to get themselves classified into chapter 3:

        RFC   PSA    Title
        ---   ---    -----
        024   rr     Data types: Semi-finite (lazy) lists
        025   dba    Operators: Multiway comparisons
        039   rr     Perl should have a print operator 
        045   bbb    C<||> and C<&&> should propagate result context to both sides
        054   cdr    Operators: Polymorphic comparisons
        081   abc    Lazily evaluated list generation functions
        082   abc    Arrays: Apply operators element-wise in a list context
        084   abb    Replace => (stringifying comma) with => (pair constructor)
        104   ccr    Backtracking
        138   rr     Eliminate =~ operator.
        143   dcr    Case ignoring eq and cmp operators
        170   ccr    Generalize =~ to a special "apply-to" assignment operator
        283   ccc    C<tr///> in array context should return a histogram
        285   acb    Lazy Input / Context-sensitive Input
        290   bbc    Better english names for -X
        320   ccc    Allow grouping of -X file tests and add C<filetest> builtin

Note that you can click on the following RFC titles to view a copy of the RFC in question. The discussion sometimes assumes that you've read the RFC.

*Editor's Note: this Apocalypse is out of date and remains here for historic reasons. See [Synopsis 03](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the latest information.*

### <a href="http://dev.perl.org/rfc/25.html" id="rfc 025: operators: multiway comparisons">RFC 025: Operators: Multiway comparisons</a>

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td></td>
</tr>
<tr class="even">
<td><p>Previous Apocalypses</p>
<p>• <a href="/pub/a/2001/04/02/wall.html">Apocalypse 1</a><br />
<br />
• <a href="/pub/a/2001/05/03/wall.html">Apocalypse 2</a><br />
<br />
</p></td>
</tr>
<tr class="odd">
<td></td>
</tr>
</tbody>
</table>

This RFC proposes that expressions involving multiple chained comparisons should act like mathematician would expect. That is, if you say this:

        0 <= $x < 10

it really means something like:

        0 <= $x && $x < 10

The `$x` would only be evaluated once, however. (This is very much like the rewrite rule we use to explain assignment operators such as `$x += 3`.)

I started with this RFC simply because it's not of any earthshaking importance whether I accept it or not. The tradeoff is whether to put some slight complexity into the grammar in order to save some slight complexity in some Perl programs. The complexity in the grammar is not much of a problem here, since it's amortized over all possible uses of it, and it already matches the known psychology of a great number of people.

There is a potential interaction with precedence levels, however. If we choose to allow an expression like:

        0 <= $x == $y < 20

then we'll have to unify the precedence levels of the comparison operators with the equality operators. I don't see a great problem with this, since the main reason for having them different was (I believe) so that you could write an exclusive of two comparisons, like this:

        $x < 10 != $y < 10

However, Perl has a built-in `xor` operator, so this isn't really much of an issue. And there's a lot to be said for forcing parentheses in that last expression anyway, just for clarity. So unless anyone comes up with a large objection that I'm not seeing, this RFC is accepted.

### <a href="http://dev.perl.org/rfc/320.html" id="rfc 320: allow grouping of x file tests and add filetest builtin">RFC 320: Allow grouping of -X file tests and add <code>filetest</code> builtin</a>

This RFC proposes to allow clustering of file test operators much like some Unix utilities allow bundling of single character switches. That is, if you say:

        -drwx $file

it really means something like:

        -d $file && -r $file && -w $file && -x $file

Unfortunately, as proposed, this syntax will simply be too confusing. We have to be able to negate named operators and subroutines. The proposed workaround of putting a space after a unary minus is much too onerous and counterintuitive, or at least countercultural.

The only way to rescue the proposal would be to say that such operators are autoloaded in some fashion; any negated but *unrecognized* operator would then be assumed to be a clustered filetest. This would be risky in that it would prevent Perl from catching misspelled subroutine names at compile time when negated, and the error might well not get caught at run time either, if all the characters in the name are valid filetests, and if the argument can be interpreted as a filename or filehandle (which is usually). Perhaps it would be naturally disallowed under `use strict`, since we'd basically be treating `-xyz` as a bareword. On the other hand, in Perl 5, *all* method names are essentially in the unrecognized category until run time, so it would be impossible to tell whether to parse the minus sign as a real negation. Optional type declarations in Perl 6 would only help the compiler with variables that are actually declared to have a type. Fortunately, a negated 1 is still true, so even if we parsed the negation as a real negation, it might still end up doing the right thing. But it's all very tacky.

So I'm thinking of a different tack. Instead of bundling the letters:

        -drwx $file

let's think about the trick of returning the value of `$file` for a true value. Then we'd write nested unary operators like this:

        -d -r -w -x $file

One tricky thing about that is that the operators are applied right to left. And they don't really short circuit the way stacked `&&` would (though the optimizer could probably fix that). So I expect we could do this for the default, and if you want the `-drwx` as an autoloaded backstop, you can explicitly declare that.

In any event, the proposed `filetest` built-in need not be built in. It can just be a universal method. (Or maybe just common to strings and filehandles?)

My one hesitation in making cascading operators work like that is that people might be tempted to get cute with the returned filename:

        $handle = open -r -w -x $file or die;

That might be terribly confusing to a lot of people. The solution to this conundrum is presented at the end of the next section.

### <a href="http://dev.perl.org/rfc/290.html" id="rfc 290: better english names for x">RFC 290: Better english names for -X</a>

This RFC proposes long names as aliases for the various filetest operators, so that instead of saying:

        -r $file

you might say something like:

        use english;
        freadable($file)

Actually, there's no need for the `use english`, I expect. These names could merely universal (or nearly universal) methods. In any case, we should start getting used to the idea that `mumble($foo)` is equivalent to `$foo.mumble()`, at least in the absence of a local subroutine definition to the contrary. So I expect that we'll see both:

        is_readable($file)

and:

        $file.is_readable

Similar to the cascaded filetest ops in the previous section, one approach might be that the boolean methods return the object in question for success so that method calls could be stacked without repeating the object:

        if ($file.is_dir
                 .is_readable
                 .is_writable
                 .is_executable) {

But `-drwx $file` could still be construed as more readable, for some definition of readability. And cascading methods aren't really short-circuited. Plus, the value returned would have to be something like \`\`$file is true,'' to prevent confusion over filename \`\`0.''

There is also the question of whether this really saves us anything other than a little notational convenience. If each of those methods has to do a *stat* on the filename, it will be rather slow. To fix that, what we'd actually have to return would be not the filename, but some object containing the stat buffer (represented in Perl 5 by the `_` character). If we did that, we wouldn't have to play `$file is true` games, because a valid stat buffer object would (presumably) always be true (at least until it's false).

The same argument would apply to cascaded filetest operators we talked about earlier. An autoloaded `-drwx` handler would presumably be smart enough to do a single stat. But we'd likely lose the speed gain by invoking the autoload mechanism. So cascaded operators (either `-X` style or `.is_XXX` style) are the way to go. They just return objects that know how to be either boolean or stat buffer objects in context. This implies you could even say

        $statbuf = -f $file or die "Not a regular file: $file";
        if (-r -w $statbuf) { ... }

This allows us to simplify the special case in Perl 5 represented by the `_` token, which was always rather difficult to explain. And returning a stat buffer instead of `$file` prevents the confusing:

        $handle = open -r -w -x $file or die;

Unless, of course, we decide to make a stat buffer object return the filename in a string context. `:-)`

*Editor's Note: this Apocalypse is out of date and remains here for historic reasons. See [Synopsis 03](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the latest information.*

### <a href="http://dev.perl.org/rfc/283.html" id="rfc 283: tr/// in array context should return a histogram">RFC 283: <code>tr///</code> in array context should return a histogram</a>

Yes, but ...

While it's true that I put that item into the Todo list ages ago, I think that histograms should probably have their own interface, since the histogram should probably be returned as a complete hash in scalar context, but we can't guess that they'll want a histogram for an ordinary scalar `tr///`. On the other hand, it could just be a `/h` modifier. But we've already done violence to `tr///` to make it do character counting without transliterating, so maybe this isn't so far fetched.

One problem with this RFC is that it does the histogram over the input rather than the output string. The original Todo entry did not specify this, but it was what I had intended. But it's more useful to do it on the resulting characters because then you can use the `tr///` itself to categorize characters into, say, vowels and consonants, and then count the resulting V's and C's.

On the other hand, I'm thinking that the `tr///` interface is really rather lousy, and getting lousier every day. The whole `tr///` interface is kind of sucky for any sort of dynamically generated data. But even without dynamic data, there are serious problems. It was bad enough when the character set was just ASCII. The basic problem is that the notation is inside out from what it should be, in the sense that it doesn't actually show which characters correspond, so you have to count characters. We made some progress on that in Perl 5 when, instead of:

        tr/abcdefghijklmnopqrstuvwxyz/VCCCVCCCVCCCCCVCCCCCVCCCCC/

we allowed you to say:

        tr[abcdefghijklmnopqrstuvwxyz]
          [VCCCVCCCVCCCCCVCCCCCVCCCCC]

There are also shenanigans you can play if you know that duplicates on the left side prefer the first mention to subsequent mentions:

        tr/aeioua-z/VVVVVC/

But you're still working against the notation. We need a more explicit way to put character classes into correspondence.

More problems show up when we extend the character set beyond ASCII. The use of `tr///` for case translations has long been semi-deprecated, because a range like `tr/a-z/A-Z/` leaves out characters with diacritics. And now with Unicode, the whole notion of what is a character is becoming more susceptible to interpretation, and the `tr///` interface doesn't tell Perl whether to treat character modifiers as part of the base character. For some of the double-wide characters it's even hard to just *look* at the character and tell if it's one character or two. Counted character lists are about as modern as hollerith strings in Fortran.

So I suspect the `tr///` syntax will be relegated to being just one quote-like interface to the actual transliteration module, whose main interface will be specified in terms of translation pairs, the left side of which will give a pattern to match (typically a character class), and the right side will say what to translation anything matching to. Think of it as a series of coordinated parallel `s///` operations. Syntax is still open for negotiation till apocalypse 5.

But there can certainly be a histogram option in there somewhere.

### <a href="http://dev.perl.org/rfc/84.html" id="rfc 084: replace =&gt; (stringifying comma) with =&gt; (pair constructor)">RFC 084: Replace <code>=&gt;</code> (stringifying comma) with <code>=&gt;</code> (pair constructor)</a>

I like the basic idea of pairs because it generalizes to more than just hash values. Named parameters will almost certainly be implemented using pairs as well.

I do have some quibbles with the RFC. The proposed `key` and `value` built-ins should simply be lvalue methods on pair objects. And if we use pair objects to implement entries in hashes, the key must be immutable, or there must be some way of re-hashing the key if it changes.

The stuff about using pairs for mumble-but-false is bogus. We'll use properties for that sort of chicanery. (And multiway comparisons won't rely on such chicanery in any event. See above.)

### <a href="http://dev.perl.org/rfc/81.html" id="rfc 081: lazily evaluated list generation functions">RFC 081: Lazily evaluated list generation functions</a>

Sorry, you can't have the colon--at least, not without sharing it. Colon will be a kind of \`\`supercomma'' that supplies an adverbial list to some previous operator, which in this case would be the prior colon or dotdot.

(We can't quite implement `?:` as a `:` modifier on `?`, because the precedence would be screwey, unless we limit `:` to a single argument, which would preclude its being used to disambiguate indirect objects. More on that later.)

The RFCs proposal concerning `attributes::get(@a)` stuff is superseded by value properties. So, `@a.method()` should just pull out the variable's properties directly, if the variable is of a type that supports the methods in question. A lazy list object should certainly have such methods.

Assignment of a lazy list to a tied array is a problem unless the tie implementation handles laziness. By default a tied array is likely to enforce immediate list evaluation. Immediate list evaluation doesn't work on infinite lists. That means it's gonna fill up your disk drive if you try to say something like:

        @my_tied_file = 1..Inf;

Laziness should be possible, but not necessarily the norm. It's all very well to delay the evaluation of \`\`pure'' functions in the realm of math, since presumably you get the same result no matter when you evaluate. But a lot of Perl programming is done with real world data that changes over time. Saying `somefunc($a .. $b)` can get terribly fouled up if `$b` can change, and the lazy function still refers to the variable rather than its instantaneous value. On the other hand, there is overhead in taking snapshots of the current state.

On the gripping hand, the lazy list object *is* the snapshot of the values, that's not a problem in this case. Forget I mentioned it.

The tricky thing about lazy lists is not the lazy lists themselves, but how they interact with the rest of the language. For instance, what happens if you say:

        @lazy = 1..Inf;
        @lazy[5] = 42;

Is `@lazy` still lazy after it is modified? Do we remember the `@lazy[5]` is an \`\`exception'', and continue to generate the rest of the values by the original rule? What if `@lazy` is going to be generated by a recursive function? Does it matter whether we've already generated `@lazy[5]`?

And how do we explain this simply to people so that they can understand? We will have to be very clear about the distinction between the abstraction and the concrete value. I'm of the opinion that a lazy list is a definition of the *default* values of an array, and that the actual values of the array override any default values. Assigning to a previously memoized element overrides the memoized value.

It would help the optimizer to have a way to declare \`\`pure'' array definitions that can't be overridden.

Also consider this:

        @array = (1..100, 100..10000:100);

A single flat array can have multiple lazy lists as part of it's default definition. We'll have to keep track of that, which could get especially tricky if the definitions start overlapping via slice definitions.

In practice, people will treat the default values as real values. If you pass a lazy list into a function as an array argument, the function will probably not know or care whether the values it's getting from the array are being generated on the fly or were there in the first place.

I can think of other cans of worms this opens, and I'm quite certain I'm too stupid to think of them all. Nevertheless, my gut feeling is that we can make things work more like people expect rather than less. And I was always a little bit jealous that REXX could have arrays with default values. `:-)`

*Editor's Note: this Apocalypse is out of date and remains here for historic reasons. See [Synopsis 03](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the latest information.*

### <a href="http://dev.perl.org/rfc/285.html" id="rfc 285: lazy input / contextsensitive input">RFC 285: Lazy Input / Context-sensitive Input</a>

Solving this with `want()` is the wrong approach, but I think the basic idea is sound because it's what people expect. And the `want()` should in fact be unnecessary. Essentially, if the right side of a list assignment produces a lazy list, and the left side requests a finite number of elements, the list generator will only produce enough to satisy the demand. It doesn't need to know how many in advance. It just produces another scalar value when requested. The generator doesn't have to be smart about its context. The motto of a lazy list generator should be, \`\`Ours is not to question why, ours is but to do (the next one) or die.''

It will be tricky to make this one work right:

        ($first, @rest) = 1 .. Inf;

### <a href="http://dev.perl.org/rfc/82.html" id="rfc 082: arrays: apply operators elementwise in a list context">RFC 082: Arrays: Apply operators element-wise in a list context</a>

APL, here we come... :-)

This is by far the most difficult of these RFCs to decide, so I'm going to be doing a lot of thinking out loud here. This is research--or at least, a search. Please bear with me.

I expect that there are two classes of Perl programmers--those that would find these \`\`hyper'' operators natural, and those that wouldn't. Turning this feature on by default would cause a lot of heartburn for people who (from Perl 5 experience) expect arrays to always return their length under scalar operators even in list context. It can reasonably be argued that we need to make the scalar operators default, but make it easy to turn on hyper operators within a lexical scope. In any event, both sets of operators need to be visible from anywhere--we're just arguing over who gets the short, traditional names. All operators will presumably have longer names for use as function calls anyway. Instead of just naming an operator with long names like:

        operator:+
        operator:/

the longer names could distinguish \`\`hyperness'' like this:

        @a scalar:+ @b
        @a list:/ @b

That implies they could also be called like this:

        scalar:+(@a, @b)
        list:/(@a, @b)

We might find some short prefix character stands in for \`\`list'' or \`\`scalar''. The obvious candidates are `@` and `$`:

        @a $+ @b
        @a @/ @b

Unfortunately, in this case, \`\`obvious'' is synonymous with \`\`wrong''. These operators would be completely confusing from a visual point of view. If the main psychological point of putting noun markers on the nouns is so that they stand out from the verbs, then you don't want to put the same markers on the verbs. It would be like the Germans starting to capitalize all their words instead of just their nouns.

Instead, we could borrow a singular/plural memelet from shell globbing, where `*` means multiple characters, and `?` means one character:

        @a ?+ @b
        @a */ @b

But that has a bad ambiguity. How do you tell whether `**` is an exponentiation or a list multiplication? So if we went that route, we'd probably have to say:

        @a ?:+ @b
        @a *:/ @b

Or some such. But if we're going that far in the direction of gobbledygook, perhaps there are prefix characters that wouldn't be so ambiguous. The colon and the dot also have a visual singular/plural value:

        @a .+ @b
        @a :/ @b

We're already changing the old meaning of dot (and I'm planning to rescue colon from the `?:` operator), so perhaps that could be made to work. You could almost think of dot and colon as complementary method calls, where you could say:

        $len = @a.length;   # length as a scalar operator
        @len = @a:length;   # length as a list operator

But that would interfere with other desirable uses of colon. Plus, it's actually going to be confusing to think of these as singular and plural operators because, while we're specifying that we want a \`\`plural'' operator, we're not specifying how to treat the plurality. Consider this:

        @len = list:length(@a);

Anyone would naively think that returns the length of the list, not the length of each element of the list. To make it work in English, we'd actually have to say something like this:

        @len = each:length(@a);
        $len = the:length(@a);

That would be equivalent to the method calls:

        @len = @a.each:length;
        $len = @a.the:length;

But does this really mean that there are two array methods with those weird names? I don't think so. We've reached a result here that is spectacularly close to a *reductio ad absurdum*. It seems to me that the whole point of this RFC is that the \`\`eachness'' is most simply specified by the list context, together with the knowledge that `length()` is a function/method that maps one scalar value to another. The distribution of that function over an array value is not something the scalar function should be concerned with, except insofar as it must make sure its type signature is correct.

And there's the rub. We're really talking about enforced strong typing for this to work right. When we say:

        @foo = @bar.mumble

How do we know whether `mumble` has the type signature that magically enables iteration over `@bar`? That definition is off in some other file that we may not have memorized quite yet. We need some more explicit syntax that says that auto-interation is expected, regardless of whether the definition of the operator is well specified. Magical auto-iteration is not going to work well in a language with optional typing.

So the resolution of this is that the unmarked forms of operators will force scalar context as they do in Perl 5, and we'll need a special marker that says an operator is to be auto-iterated. That special marker turns out to be an uparrow, with a tip o' the hat to higher-order functions. That is, the hyper-operator:

        @a ^* @b

is equivalent to this:

        parallel { $^a * $^b } @a, @b

(where `parallel` is a hypothetical function that iterates through multiple arrays in parallel.)

Hyper operators will also intuit where a dimension is missing from one of its arguments, and replicate a scalar value to a list value in that dimension. That means you can say:

        @a ^+ 1

to get a value with one added to each element of `@a`. (`@a` is unchanged.)

I don't believe there are any insurmountable ambiguities with the uparrow notation. There is currently an uparrow operator meaning exclusive-or, but that is rarely used in practice, and is not typically followed by other operators when it is used. We can represent exclusive-or with `~` instead. (I like that idea anyway, because the unary `~` is a 1's complement, and the binary `~` would simply be doing a 1's complement on the second argument of the set bits in the first argument. On the other hand, there's destructive interference with other cultural meanings of tilde, so it's not completely obvious that it's the right thing to do. Nevertheless, that's what we're doing.)

Anyway, in essence, I'm rejecting the underlying premise of this RFC, that we'll have strong enough typing to intuit the right behavior without confusing people. Nevertheless, we'll still have easy-to-use (and more importantly, easy-to-recognize) hyper-operators.

This RFC also asks about how return values for functions like `abs()` might be specified. I expect sub declarations to (optionally) include a return type, so this would be sufficient to figure out which functions would know how to map a scalar to a scalar. And we should point out again that even though the base language will not try to intuit which operators should be hyperoperators, there's no reason in principle that someone couldn't invent a dialect that does. All is fair if you predeclare.

### <a href="http://dev.perl.org/rfc/45.html" id="rfc 045: || and &amp;&amp; should propagate result context to both sides">RFC 045: <code>||</code> and <code>&amp;&amp;</code> should propagate result context to both sides</a>

Yes. The thing that makes this work in Perl 6, where it was almost impossible in Perl 5, is that in Perl 6, list context doesn't imply immediate list flattening. More precisely, it specifies immediate list flattening in a notional sense, but the implementation is free to delay that flattening until it's actually required. Internally, a flattened list is still an object. So when `@a || @b` evaluates the arrays, they're evaluated as objects that can return either a boolean value or a list, depending on the context. And it will be possible to apply both contexts to the first argument simultaneously. (Of course, the computer actually looks at it in the boolean context first.)

There is no conflict with RFC 81 because the hyper versions of these operators will be spelled:

        @a ^|| @b
        @a ^&& @b

*Editor's Note: this Apocalypse is out of date and remains here for historic reasons. See [Synopsis 03](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the latest information.*

### <a href="http://dev.perl.org/rfc/54.html" id="rfc 054: operators: polymorphic comparisons">RFC 054: Operators: Polymorphic comparisons</a>

I'm not sure of the performance hit of backstopping numeric equality with string equality. Maybe vtables help with this. But I think this RFC is proposing something that is too specific. The more general problem is how you allow variants of built-ins, not just for `==`, but for other operators like `<=>` and `cmp`, not to mention all the other operators that have scalar and list variants.

A generic equality operator could potentially be supplied by operator definition. I expect that a similar mechanism would allow us to define how abstract a comparison `cmp` would do, so we could sort and collate according to the various defined levels of Unicode.

The argument that you can't do generic programming is somewhat specious. The problem in Perl 5 is that you can't name operators, so you couldn't pass in a generic operator in place of a specific one even if you wanted to. I think it's more important to make sure all operators have real function names in Perl 6:

        operator:+($a, $b);     # $a + $b
        operator:^+(@a, @b);    # @a ^+ @b

        my sub operator:<?> ($a, $b) { ... }
        if ($a <?> $b) { ... }
        @sorted = collate \&operator:<?>, @unicode;

### <a href="http://dev.perl.org/rfc/104.html" id="rfc 104: backtracking">RFC 104: Backtracking</a>

As proposed, this can easily be done with an operator definition to call a sequence of closures. I wonder whether the proposal is complete, however. There should probably be more make-it-didn't-happen semantics to a backtracking engine. If Prolog unification is emulated with an assignment, how do you later unassign a variable if you backtrack past it?

Ordinarily, temporary values are scoped to a block, but we're using blocks differently here, much like parens are used in a regex. Later parens don't undo the \`\`unifications'' of earlier parens.

In normal imperative programming these temporary determinations are remembered in ordinary scoped variables and the current hypothesis is extended via recursion. An `andthen` operator would need to have a way of keeping BLOCK1's scope around until BLOCK2 succeeds or fails. That is, in terms of lexical scoping:

        {BLOCK1} andthen {BLOCK2}

needs to work more like

        {BLOCK1 andthen {BLOCK2}}

This might be difficult to arrange as a mere module. However, with rewriting rules it might be possible to install the requisite scoping semantics within BLOCK1 to make it work like that. So I don't think this is a primitive in the same sense that continuations would be. For now let's assume we can build backtracking operators from continuations. Those will be covered in a future apocalypse.

### <a href="http://dev.perl.org/rfc/143.html" id="rfc 143: case ignoring eq and cmp operators">RFC 143: Case ignoring <code>eq</code> and <code>cmp</code> operators</a>

This is another RFC that proposes a specific feature that can be handled by a more generic feature, in this case, an operator definition:

        my sub operator:EQ { lc($^a) eq lc($^b) }

Incidentally, I notice that the RFC normalizes to uppercase. I suspect it's better these days to normalize to lowercase, because Unicode distinguishes titlecase from uppercase, and provides mappings for both to lowercase.

### <a href="http://dev.perl.org/rfc/170.html" id="rfc 170: generalize =~ to a special applyto assignment operator">RFC 170: Generalize <code>=~</code> to a special ``apply-to'' assignment operator</a>

I don't think the argument should come in on the right. I think it would be more natural to treat it as an object, since all Perl variables will essentially be objects anyway, if you scratch them right. Er, left.

I do wonder whether we could generalize `=~` to a list operator that calls a given method on multiple objects, so that

        ($a, $b) =~ s/foo/bar/;

would be equivalent to

        for ($a, $b) { s/foo/bar/ }

But then maybe it's redundant, except that you could say

        @foo =~ s/foo/bar/

in the middle of an expression. But by and large, I think I'd rather see:

        @foo.grep {!m/\s/}

instead of using `=~` for what is essentially a method call. In line with what we discussed before, the list version could be a hyperoperator:

        @foo . ^s/foo/bar/;

or possibly:

        @foo ^. s/foo/bar/;

Note that in the general case this all implies that there is some interplay between how you declare method calls and how you declare quote-like operators. It seems as though it would be dangerous to let a quote-like declaration out of a lexical scope, but then it's also not clear how a method call declaration could be lexically scoped. So we probably can't do away with `=~` as an explicit marker that the thing on the left is a string, and the thing on the right is a quoted construct. That means that a hypersubstitution is really spelled:

        @foo ^=~ s/foo/bar/;

Admittedly, that's not the prettiest thing in the world.

*Editor's Note: this Apocalypse is out of date and remains here for historic reasons. See [Synopsis 03](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the latest information.*

### <span id="nonrfc considerations">Non-RFC considerations</span>

The RFCs propose various specific features, but don't give a systematic view of the operators as a whole. In this section I'll try to give a more cohesive picture of where I see things going.

#### <span id="binary . (dot)">Binary `.` (dot)</span>

This is now the method call operator, in line with industry-wide practice. It also has ramifications for how we declare object attribute variables. I'm anticipating that, within a class module, saying

        my int $.counter;

would declare both a `$.counter` instance variable and a `counter` accessor method for use within the class. (If marked as public, it would also declare a `counter` accessor method for use outside the class.)

#### <span id="unary . (dot)">Unary `.` (dot)</span>

It's possible that a unary `.` would call a method on the current object within a class. That is, it would be the same as a binary `.` with `$self` (or equivalent) on the left:

        method foowrapper ($a, $b) {
            .reallyfoo($a, $b, $c)
        }

On the other hand, it might be considered better style to be explicit:

        method foowrapper ($self: $a, $b) {
            $self.reallyfoo($a, $b, $c)
        }

(Don't take that declaration syntax as final just yet, however.)

#### <span id="binary _">Binary `_`</span>

Since `.` is taken for method calls, we need a new way to concatenate strings. We'll use a solitary underscore for that. So, instead of:

        $a . $b . $c

you'll say:

        $a _ $b _ $c

The only downside to that is the space between a variable name and the operator is required. This is to be construed as a feature.

#### <span id="unary _">Unary `_`</span>

Since the `_` token indicating stat buffer is going away, a unary underscore operator will force stringification, just as interpolation does, only without the quotes.

#### <span id="unary + X">Unary `+`</span>

Similarly, a unary `+` will force numification in Perl 6, unlike in Perl 5. If that fails, NaN (not a number) is returned.

#### <span id="binary := Y">Binary `:=`</span>

We need to distinguish two different forms of assignment. The standard assignment operator, `=`, works just as it does Perl 5, as much as possible. That is, it tries to make it look like a value assignment. This is our cultural heritage.

But we also need an operator that works like assignment but is more definitional. If you're familiar with Prolog, you can think of it as a sort of unification operator (though without the implicit backtracking semantics). In human terms, it treats the left side as a set of formal arguments exactly as if they were in the declaration of a function, and binds a set of arguments on the right hand side as though they were being passed to a function. This is what the new `:=` operator does. More below.

#### <span id="unary * XX">Unary `*`</span>

Unary `*` is the list flattening operator. (See Ruby for prior art.) When used on an rvalue, it turns off function signature matching for the rest of the arguments, so that, for instance:

        @args = (\@foo, @bar);
        push *@args;

would be equivalent to:

        push @foo, @bar;

In this respect, it serves as a replacement for the prototype-disabling `&foo(@bar)` syntax of Perl 5. That would be translated to:

        foo(*@bar)

In an lvalue, the unary `*` indicates that subsequent array names slurp all the rest of the values. So this would swap two arrays:

        (@a, @b) := (@b, @a);

whereas this would assign all the array elements of `@c` and `@d` to `@a`.

        (*@a, @b) := (@c, @d);

An ordinary flattening list assignment:

        @a = (@b, @c);

is equivalent to:

        *@a := (@b, @c);

That's not the same as

        @a := *(@b, @c);

which would take the first element of `@b` as the new definition of `@a`, and throw away the rest, exactly as if you passed too many arguments to a function. It could optionally be made to blow up at run time. (It can't be made to blow up at compile time, since we don't know how many elements are in `@b` and `@c` combined. There could be exactly one element, which is what the left side wants.)

#### <span id="list context">List context</span>

The whole notion of list context is somewhat modified in Perl 6. Since lists can be lazy, the interpretation of list flattening is also by necessity lazy. This means that, in the absence of the `*` list flattening operator (or an equivalent old-fashioned list assignment), lists in Perl 6 are object lists. That is to say, they are parsed as if they were a list of objects in scalar context. When you see a function call like:

        foo @a, @b, @c;

you should generally assume that three discrete arrays are being passed to the function, unless you happen to know that the signature of `foo` includes a list flattening `*`. (If a subroutine doesn't have a signature, it is assumed to have a signature of `(*@_)` for old times' sake.) Note that this is really nothing new to Perl, which has always made this distinction for builtins, and extended it to user-defined functions in Perl 5 via prototypes like `\@` and `\%`. We're just changing the syntax in Perl 6 so that the unmarked form of formal argument expects a scalar value, and you optionally declare the final formal argument to expect a list. It's a matter of Huffman coding again, not to mention saving wear and tear on the backslash key.

#### <span id="binary : YY">Binary `:`</span>

As I pointed out in an earlier apocalypse, the first rule of computer language design is that everybody wants the colon. I think that means that we should do our best to give the colon to as many features as possible.

Hence, this operator modifies a preceding operator adverbially. That is, it can turn any operator into a trinary operator (provided a suitable definition is declared). It can be used to supply a \`\`step'' to a range operator, for instance. It can also be used as a kind of super-comma separating an indirect object from the subsequent argument list:

        print $handle[2]: @args;

Of course, this conflicts with the old definition of the `?:` operator. See below.

In a method type signature, this operator indicates that a previous argument (or arguments) is to be considered the \`\`self'' of a method call. (Putting it after multiple arguments could indicate a desire for multimethod dispatch!)

#### <span id="trinary ::">Trinary `??::`</span>

The old `?:` operator is now spelled `??::`. That is to say, since it's really a kind of short-circuit operator, we just double both characters like the `&&` and `||` operator. This makes it easy to remember for C programmers. Just change:

        $a ? $b : $c

to

        $a ?? $b :: $c

The basic problem is that the old `?:` operator wastes two very useful single characters for an operator that is not used often enough to justify the waste of two characters. It's bad Huffman coding, in other words. Every proposed use of colon in the RFCs conflicted with the `?:` operator. I think that says something.

I can't list here all the possible spellings of `?:` that I considered. I just think `??::` is the most visually appealing and mnemonic of the lot of them.

#### <span id="binary // YYY">Binary `//`</span>

A binary `//` operator is the defaulting operator. That is:

        $a // $b

is short for:

        defined($a) ?? $a :: $b

except that the left side is evaluated only once. It will work on arrays and hashes as well as scalars. It also has a corresponding assignment operator, which only does the assignment if the left side is undefined:

        $pi //= 3;

#### <span id="binary ; YYYY">Binary `;`</span>

The binary `;` operator separates two expressions in a list, much like the expressions within a C-style `for` loop. Obviously the expressions need to be in some kind of bracketing structure to avoid ambiguity with the end of the statement. Depending on the context, these expressions may be interpreted as arguments to a `for` loop, or slices of a multi-dimensional array, or whatever. In the absence of other context, the default is simply to make a list of lists. That is,

        [1,2,3;4,5,6]

is a shorthand for:

        [[1,2,3],[4,5,6]]

But usually there will be other context, such as a multidimension array that wants to be sliced, or a syntactic construct that wants to emulate some kind of control structure. A construct emulating a 3-argument `for` loop might force all the expressions to be closures, for instance, so that they can be evaluated each time through the loop. User-defined syntax will discussed in apocalypse 18, if not sooner.

#### <span id="unary ^ XXX">Unary `^`</span>

Unary ^ is now reserved for hyper operators. Note that it works on assignment operators as well:

        @a ^+= 1;    # increment all elements of @a

#### <span id="unary ">Unary `?`</span>

Reserved for future use.

#### <span id="binary ">Binary `?`</span>

Reserved for future use.

#### <span id="binary ~ YYYYY">Binary `~`</span>

This is now the bitwise XOR operator. Recall that unary `~` (1's complement) is simply an XOR with a value containing all 1 bits.

#### <span id="binary ~~ YYYYYY">Binary `~~`</span>

This is a logical XOR operator. It's a high precedence version of the low precedence `xor` operator.

#### <span id="user defined operators">User defined operators</span>

The declaration syntax of user-defined operators is still up for grabs, but we can say a few things about it. First, we can differentiate unary from binary declarations simply by the number of arguments. (Declaration of a return type may also be useful for disambiguating subsequent parsing. One place it won't be needed is for operators wanting to know whether they should behave as hyperoperators. The pressure to do that is relieved by the explicit `^` hypermarker.)

We also need to think how these operator definitions relate to overloading. We can treat an operator as a method on the first object, but sometimes it's the second object that should control the action. (Or with multimethod dispatch, both objects.) These will have to be thrashed out under ordinary method dispatch policy. The important thing is to realize that an operator is just a funny looking method call. When you say:

        $man bites $dog

The infrastruture will need to untangle whether the man is biting the dog or the dog is getting bitten by the man. The actual biting could be implement in either the `Man` class or the `Dog` class, or even somewhere else, in the case of multimethods.

#### <span id="unicode operators">Unicode operators</span>

Rather than using longer and longer strings of ASCII characters to represent user-defined operators, it will be much more readable to allow the (judicious) use of Unicode operators.

In the short term, we won't see much of this. As screen resolutions increase over the next 20 years, we'll all become much more comfortable with the richer symbol set. I see no reason (other than fear of obfuscation (and fear of fear of obfuscation))) why Unicode operators should not be allowed.

Note that, unlike APL, we won't be hardware dependent, in the sense that any Perl implementation will always be able to parse Unicode, even if you can't display it very well. (But note that Vim 6.0 just came out with Unicode support.)

#### <span id="precedence">Precedence</span>

We will at least unify the precedence levels of the equality and relational operators. Other unifications are possible. For instance, the `not` logical operator could be combined with list operators in precedence. There's only so much simplification that you can do, however, since you can't mix right association with left association. By and large, the precedence table will be what you expect, if you expect it to remain largely the same.

And that still goes for Perl 6 in general. We talk a lot here about what we're changing, but there's a lot more that we're not changing. Perl 5 does a lot of things right, and we're not terribly interested in \`\`fixing'' that.
