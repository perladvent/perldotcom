{
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : " Table of Contents Design Principles So, uh, what is it? Where did it get? What else can be done? What can't be done? Structure of a Sapphire The future of Sapphire Reflections through a Sapphire Naming languages after stones...",
   "slug" : "/pub/2000/09/sapphire.html",
   "title" : "Sapphire",
   "image" : null,
   "categories" : "perl-internals",
   "date" : "2000-09-19T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : []
}



<span id="sapphire  another gem of an idea"></span>
<span id="__index__"></span>

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td>Table of Contents</td>
</tr>
<tr class="even">
<td><p>•<a href="#design%20principles">Design Principles</a><br />
•<a href="#so,%20uh,%20what%20is%20it">So, uh, what is it?</a><br />
•<a href="#where%20did%20it%20get">Where did it get?</a><br />
•<a href="#what%20else%20can%20be%20done">What else can be done?</a><br />
•<a href="#what%20can&#39;t%20be%20done">What can't be done?</a><br />
•<a href="#structure%20of%20a%20sapphire">Structure of a Sapphire</a><br />
•<a href="#the%20future%20of%20sapphire">The future of Sapphire</a><br />
•<a href="#reflections%20through%20a%20sapphire">Reflections through a Sapphire</a><br />
</p></td>
</tr>
</tbody>
</table>

Naming languages after stones is getting a bit old-hat these days. We all know and love Perl; you might have heard of the [Ruby language](http://www.ruby-lang.org/), which I'll talk more about another time. There's also Chip Salzenberg's Topaz project, an idea to rewrite Perl in C++, which ended with the announcement of the Perl 6 effort. And now, there's Sapphire. So what's this all about?

Sapphire is one of the many projects which was started purely and simply to prove a point. In this case, the point was that building a large program from scratch in this day and age is crazy. I was going to prove it by showing how rapidly software can be developed when using established libraries, and **that** was done by seeing how quickly I could rewrite Perl 5.

Also, as a secondary goal, I wanted to show the flexibility of some of my design ideas for Perl 6. It's dangerous when people are sitting around for a long time discussing software design without implementations, without benchmarks and without a single line of code. I prefer getting up and doing something rather than talking about it. So I was going to show my ideas in software, not in words.

### <span id="design principles">Design Principles</span>

Here are some of the ideas I was intending to showcase:

**<span id="item_Being_Good_Open_Source_Citizens">Being Good Open-Source Citizens</span>**
  
What do I mean by this? Perl 5 is extremely self-sufficient. Once you've got the source kit, it'll compile anywhere, on almost any platform and requiring very few \`\`support'' libraries. It'll make do with what you have. One of the unfortunate side-effects of this is that if Perl wants to do something, it implements it itself. As a result, Perl contains a load of interesting routines, but keeps them to itself. It also doesn't use any of the perfectly fine implementations of those interesting routines which are already out there.

Some people think this is a feature; I think it's a wart. If we can give things back to the open-source community, and work with them to help improve their tools, then everyone benefits.

**<span id="item_Generalising_Solutions">Generalizing Solutions</span>**
  
One of the great design choices of Perl 5 which appears to have been completely and utterly rejected in the discussions on Perl 6's proposed language is that we do things in the most general way possible. This is why Perl doesn't *need* huge numbers of new built-ins - it just needs a way to make user-defined syntax with the same status as built-ins. It doesn't *need* beautiful new OO programming models - it just needs a way to help people write their own OO models. Sapphire tries to do things in the most general way possible.

**<span id="item_Modularity">Modularity</span>**
  
Perl 5 consists of a number of parts, including a stunning regular expression engine and a decent way of dealing with multityped variables. Unfortunately, in the current implementation, these parts are all highly interdependent in twisty ways. Separating them out into modules means that you can test them independently, distribute them as independent libraries, and upgrade them independently.

Seems like a winner to me!

### <span id="so, uh, what is it">So, uh, what is it?</span>

Sapphire, then, is a partial implementation of the Perl 5 API. I wasn't setting out to create a new interpreter, although that would have been necessary for some of the API routines, such as those which execute Perl code. What I wanted was to re-create the programming environment which Perl 5 gives you internally - a sort of \`\`super C,'' a C customized for creating things such as Perl interpreters.

Specifically, I wasn't trying to do anything new. I *like* Perl 5. It has a lot going for it. Of course, it could be tidier, since five years of cruft have accumulated all around it now. It could be less quirky, and it could display the design goals I have just mentioned. That's what I wanted to do.

### <span id="where did it get">Where did it get?</span>

I gave myself a week. I was going to hack on it for one week, and see where that got me. I didn't spend a lot of time on it, but I still managed to achieve a fair amount: I had scalars, arrays and hashes working, as well as Unicode manipulation to the level of Perl 5 and slightly beyond.

How? Well, I started by looking at the glib library, at [http://developer.gnome.org/doc/API/glib/.](http://developer.gnome.org/doc/API/glib/) This provided a fantastic amount of what I needed. The `GPtrArray` corresponds nicely with a Perl `AV`, and glib also implements hashes, which saved a lot of time, although to have `HE`s (hash entries) you need to dig a little into the glib source.

All the Unicode support was there. I initially used GNOME's libunicode, but then found that the development version of glib added UTF8 support and was much easier to deal with. There were a few functions I needed which Perl 5 already had, and I'll be pushing those back to the glib maintainers for potential inclusion.

Perl uses a lot of internal variable types to ensure portability - an `I32` is an integer type guaranteed to be 32 bits, no matter where it runs. Not surprisingly, I didn't have much work to do there, since glib provides a family of types, such as `gint32`, to do the same thing. Differing byte orders are also catered for. The \`\`super C'' environment the Perl 5 API provides is largely out there, in existing code.

Oh, and let's be honest: There was one large piece of existing code that was just *too* tempting not to use, and that was Perl itself. When you're trying to replicate something and you've got a working version in front of you, it's tricky not to borrow from it; it seems a shame to throw away five years of work without looking for what can be salvaged from it. A lot of the scalar handling code came from Perl 5, although I did rearrange it and make it a lot more sensible and maintainable. I wasn't just interested in developing with external libraries. I also wanted to see if I could correct some other misfeatures of Perl's internals.

The first problem to solve was the insidious use of macros on macros on macros. The way I went about this was by first outlawing lvalue macros. That is, for example,

        SvPVX(sv) = "foo";

had to turn into

        sv_setpv(sv, "foo");

Incidentally, this is how *perlapi* says it should be done. Perl 5 often optimizes for speed (sometimes too enthusiastically) at the expense of maintainability - Sapphire questions that trade-off, preferring to trust compiler optimization and Moore's Law.

Next, I wrote a reasonably sophisticated Perl program to convert inline functions into macros. That is, it would take
        #ifdef EXPAND_MACROS
        INLINE void sv_setpv (SV* sv, char * pv) {
           ((XPV*)  SvANY(sv))->xpv_pv = pv;
        }
        #endif

and turn it, automatically, into:

        #ifdef EXPAND_MACROS
        #ifdef EXPAND_HERE
        INLINE void sv_setpv (SV* sv, char * pv) {
           ((XPV*)  SvANY(sv))->xpv_pv = pv;
        }
        #endif
        #else
        #define sv_setpv(sv, pv) ((XPV*)  SvANY(sv))->xpv_pv = pv
        #endif

Now you can choose whether your macros should be expanded by flipping on `-DEXPAND_MACROS` and whether they should be inline by playing with `-DINLINE`. But what's `EXPAND_HERE` for? Well, the above code snippet would go into an include file, maybe `sv.h`, and one C file - let's call it *sv\_inline.c* - would contain the following code:

        #include <sapphire.h>
        #define EXPAND_HERE
        #include <sv.h>

Then if `EXPAND_MACROS` was defined, the function definitions would all be provided in one place; if macros were not expanded, `sv_inline.c` would define no functions. The function prototypes would be extracted automatically with [C::Scan](https://metacpan.org/pod/C::Scan).

With the state of compiler optimization these days, it's likely that turning everything into macros makes no significant speed difference. In which case, it's best to turn on `EXPAND_MACROS` to assist with source-level debuggers which cannot read macros. However, you can't tell until you benchmark, and the \`\`optional expansion'' method gives you a nice easy way to do that.

I also took a swipe at memory allocation; it seems the first job in every large project is to write your own memory allocator. I had heard from perl5-porters and other places that the biggest speed overhead in XS routines is SV creation, so I wrote an allocator which would maintain pools of ready-to-ship variables, refreshing the pools when there was nothing else to do, like a McDonald's burger line.

### <span id="what else can be done">What else can be done?</span>

If I had given myself two weeks, where would I be? Sticking with glib, I could very easily have safe signal handling, portable loadable module support, a main event dispatch loop and a safe threading model. It's all there, ready to go. It's free software, and that's just one library.

To be honest, I wouldn't advocate the use of glib for everything I could do with it. For example, I replaced Perl's main run loop `Perl_runops_standard` in *run.c*) with a `GMainLoop` and benchmarked the two. The glib version, although signal safe, was at least five times slower. (However, you may want to contemplate what it means for graphical application programming if you have, effectively, a GNOME event loop right there in your interpreter.)

Heavier Unicode support would probably need libunicode. What about regular expressions? Well, the glib developers are working on a fully Unicode-aware Perl-compatible regular expression library (which, frankly, is more than we have). If they don't finish that, [Philip Hazel's Perl Compatible Regular Expression library](ftp://ftp.cus.cam.ac.uk/pub/software/programs/pcre/) does exactly what it says on the tin.

### <span id="what can't be done">What can't be done?</span>

There are some areas of Perl's programming environment where I'm not aware of a pre-existing solution. For instance, *scope.c* in the Perl source distribution gives C the concept of \`\`dynamic scope,'' allowing you to save variables and restore them at the end of a block, just like the `local` operator in Perl.

And some problems just can't be solved in C. There's no good way, for instance, to get a partitioned namespace. I didn't bother trying. Once you've told the developer what the API is, it's his responsibility to ensure it works.

On the other hand, C is not meant to be a language that gives you this type of support. Some would argue that C++ solves these problems, but in my experience, C++ never solves anything.

### <span id="structure of a sapphire">Structure of a Sapphire</span>

As I've mentioned, I tried to plan the structure of Sapphire along modular lines, so that pieces could be tested individually and upgraded. My proposed structure was a series of libraries, like this:

**<span id="item_libsvar">`libsvar`</span>**
  
Standing for \`\`Sapphire variables,'' `libsvar` contains all the functions for manipulating SVs, AVs and HVs. This is an interesting library in its own right which can be used for programming outside of the Sapphire environment - having SVs in an ordinary C program without the overhead of a Perl interpreter really expands your programming possibilities, and, as far as I'm aware, there isn't a good variable-handling library around.

**<span id="item_libre">`libre`</span>**
  
The regular expression engine would be separated into its own library, again so that external applications can use it without an entire Perl interpreter. I didn't implement this myself, leaving it to PCRE or glib to provide this.

**<span id="item_libutf8">`libutf8`</span>**
  
Again, we can split off the Unicode handling functions into their own library, although this functionality can be implemented by libunicode or glib.

**<span id="item_libscope">`libscope`</span>**
  
The present-day *scope.c* and *scope.h* solve a problem in C by giving it dynamic scoping; this is something that contributes to the friendliness of the Perl programming environment, and something we can separate and share.

**<span id="item_libpp">`libpp`</span>**
  
Although this wouldn't be useful outside of Sapphire, `libpp` would contain the \`\`push-pop'' code which runs the operations inside the interpreter.

**<span id="item_libutil">`libutil`</span>**
  
`Libutil` would contain everything else which was potentially useful outside of Sapphire - the memory allocation, the stack manipulation and so on.

### <span id="the future of sapphire">The future of Sapphire</span>

So, what am I going to do with Sapphire now? To be honest, nothing at all. I hope it has served its purpose by presenting the argument for reusable code and stable design principles.

I certainly don't, at present, want to be placed in a position where I'm choosing between spending time fiddling with Sapphire and spending time contributing to coding Perl 6. Please understand: Sapphire is emphatically not intended to be a fork of Perl, merely an interesting interlude, and this is shown by the fact that I didn't try to make any exciting changes.

If anyone has some interesting ideas on how to take this ball and run with it, feel free. It's free software, and this is exactly what you should be doing. Contact me if you'd like a copy of the source.

I do have some thoughts on what my next experiment is going to be, however ... .

### <span id="reflections through a sapphire">Reflections through a Sapphire</span>

What have I learned from all this? I've learned a lot about the structure of Perl 5. I've realized that roughly half of it is support infrastructure for the other half, the business half. Is this good or bad? Well, it certainly means that we're not beholden to anyone else - an external library may suddenly change its implementation, semantics or interface, and Sapphire would have to struggle to catch up. Perhaps it's all about control. By implementing everything ourselves, the porters retain control over Perl.

I've also learned that Perl 5, internally, has a lot to share, yet, even though we claim to believe in code reuse where the CPAN's concerned, we do very little of it on a lower level, neither really giving nor really taking.

I've learned that rapid development can come out of a number of things. First, having external code already written to do the work for you helps a lot, even though you don't have much control over it.

Second, having an existing implementation of what you're trying to program also helps, although you have to walk a fine line. Taking Perl 5 code wholesale meant I either had to do a lot of surgery or support things I didn't really want to support, but ignoring the whole of the existing code base would feel like throwing the baby out with the bathwater. (Hence I would caution the Perl 6 internals people to thresh carefully the Perl 5 code; there is some wheat in that chaff, or else you wouldn't be using it ... .)

Finally, rapid development can come from having a well-organized and disciplined team. My team swiftly agreed on all matters of design and implementation and got down to coding without interminable and fruitless discussions, taking unanimous decisions on how to get around problems - because I was my team.

Would I say the Sapphire experiment was a success? Well, since it taught me all the above, it certainly couldn't have been a failure. Did it prove the point that developing with reusable code is worth the sacrifice in terms of control? That remains to be seen.
