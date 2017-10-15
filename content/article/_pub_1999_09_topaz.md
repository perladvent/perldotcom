{
   "description" : " Introduction One of the more interesting talks at the O'Reilly 1999 Open Source Convention was by Chip Salzenberg, one of the core developers of Perl. He described his work on Topaz, a new effort to completely re-write the internals...",
   "draft" : null,
   "tags" : [
      "c",
      "internals",
      "systems-programming-languages"
   ],
   "slug" : "/pub/1999/09/topaz.html",
   "categories" : "community",
   "title" : "Topaz: Perl for the 22nd Century",
   "authors" : [
      "chip-salzenberg"
   ],
   "image" : null,
   "thumbnail" : null,
   "date" : "1999-09-28T00:00:00-08:00"
}



### Introduction

*One of the more interesting talks at the O'Reilly 1999 Open Source Convention was by Chip Salzenberg, one of the core developers of Perl. He described his work on Topaz, a new effort to completely re-write the internals of Perl in C++. The following article is an abridged version of the transcript of this talk that provide the basic context for Topaz and the objectives for this new project. You can also listen to the complete 85-minute talk using the RealPlayer.*

|                                                                                                                                                                                                          |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Listen to Chip Salzenburg's Topaz talk! Choose either [Real Audio](http://g2.songline.com:8080/ramgen/perl.com/realaudio/Topaz1.rm) or you can [download the MP3](/media/_pub_1999_09_topaz/Topaz1.mp3). |

Topaz is a project to re-implement all of Perl in C++. If it comes to fruition, if it actually works, it's going to be Perl 6. There is, of course, the possibility that for various reasons, things may change and it may not really work out, so that's why I'm not really calling it Perl 6 at this point. Occasionally I have been known to say, "It will be fixed in Perl 6," but I'm just speaking through my hat when I say that.

**Who's doing it?** Well, it's me mostly for now because when you're starting on something like this, there's really not a lot of room to fit more than one or two people. The core design decisions can't be done in a bazaar fashion (with an "a"), although obviously they can be bizarre (with an "i").

**When?** The official start was last year's Perl conference. I expected to have something, more or less equivalent to Perl 4 by, well, now. That was a little optimistic.

**So how will it be done?** Well, it's being done in C++, and there are some reasons for that, one of which is, of course, I happen to like C++. Actually the very first discussion/argument on the Perl 6 porter's mailing list was what language to use. We had some runners-up that actually were under serious consideration.

### Choosing A Systems Programming Language

**Objective C** has some nice characteristics. It's simple and, with a GNU implementation, it is pretty much available everywhere. The downside is that Objective C has no equivalent of inline functions, so you'd have to resort to heavy use of macros again, which is something I'd like to get away from. Also, it doesn't have any support for namespaces, which means that the entire mess we currently have would have to be carried forward: maintaining a separate list of external functions that need to be renamed by the preprocessor during compilation so that you don't conflict with somebody else when you embed it in another program. I really hate that part. Even though it's well done, it's just one of those things you wish you didn't have to do.

In C++ you solve that problem by saying "namespace Perl open curly brace," and the rest is automatic. So that is the reason why Objective C fell out of the running.

**Eiffel** actually was a serious contender for a long time. That is, until I realized that to get decent performance, Eiffel compilers—or I should say the free Eiffel compiler, because there are multiple implementations—needed to do analysis at link-time as to all the classes that were actually in the program. Eiffel has no equivalent of declaring member functions—I'm using the C++ terminology—declaring them to be virtual or nonvirtual. It intuits this by figuring out the equivalent of the Java characteristic final, i.e., I have no derived classes, at link-time. And so it says, well, if there are no derived classes, then therefore I can just inline this function call. Which is clever and all, but the problem is that Topaz must be able to load classes dynamically at run time and incorporate them into the class structure, and so obviously anything that depends on link-time analysis is right out. So that was the end of Eiffel.

**Ada**, actually as a language, has much to recommend it. Conciseness is not one of them, but it does have some good characteristics. I do secretly tend toward the bondage and discipline style of programming, i.e., the more you tell the compiler, the more it can help you to enforce the things you told it. However, the only free implementation of Ada, at least the only one I'm aware of, GNAT, is written in Ada. This is an interesting design decision and it obviously helped them. They obviously like Ada so they use it, right? The problem is that if Perl 6 were written in Ada—it would require people to bootstrap GNAT before they could even get to Perl. That's too much of a burden to put on anybody.

So, we're left with C++. It's rather like the comment that I believe Winston Churchill is reported to have said about democracy: It's absolutely the worst system except for all the others. So, C++ is the worst language we could have chosen, except for all the others.

**So, where will it run?** The plan is for it to run anywhere that there's an ANSI-C++ compiler. Those of you who have seen the movie the mini-series Shogun might remember when the pilot is suppose to learn Japanese, and if he doesn't learn it the entire village will be killed. He can't stand the possibility of all these deaths being on his head so he's about to commit suicide and finally the shogun says, "Well, whatever you learn, it will be considered enough," and so then he's okay with it. Well, that's kind of how I feel about Visual C++. Whatever Visual C++ implements, we shall call that "enough," because I really don't think that we can ignore Windows as a target market. If nothing else, we need the checklist item—works on Windows. Otherwise the people who don't understand what's going on will refuse to Perl in situations where they really need to.

So, you know, unless there's an overriding reason why it's absolutely impossible, although we will use ANSI features as much as possible because ANSI C++ really is a well-done description and a well-done specification for C++ with a few minor things I don't like. Visual C++ is so common we really just can't afford to ignore it.

As for non-Windows platforms, and even for Windows platforms for some people, EGCS (which actually has now been renamed to GCC 2.95) is a really amazingly good implementation of the C++ language. The kind of bugs, the kind of features that they're working on the mailing list, are so esoteric that actually it takes me two or three times to read through just the description of the bug before I understand it. The basic stuff is no problem at all.

The ANSI C++ library for EGCS/GCC is really not all that good at this point, but work is under way on that. I expected them to be more or less done by now, but obviously they're not. I still expect them to be done by the next conference. It's just that the next conference is now the conference 4.0. By then I hope that we'll be able to use that library in the Topaz implementation.

Now, the big question:

**Why in the world would I do such a thing?** Or rather start the ball rolling? Well the primary reason was difficulty in maintenance. Perl's guts are, well, complicated. Nat Torkington described them well. I believe he said that they are "an interconnected mass of livers and pancreas and lungs and little sharp pointy things and the occasional exploding kidney." It really is hard to maintain Perl 5. Considering how many people have had their hands in it; it's not surprising that this is the situation. And you really need indoctrination in all the mysteries and magic structures and so on—before you can really hope to make significant changes to the Perl core without breaking more things than you're adding.

Some design decisions have made certain bugs really hard to get rid of. For example, the fact that things on the stack do not have the reference counts incremented has made it necessary to fake the reference counting in some circumstances, � la the mortality concept, for those of you who have been in there.

Really, when you think about it, the number of people who can do that sort of deep work because they're willing to or have been forced to put enough time into understanding it, is very limited, and that's bad for Perl, I think. It would be better if the barrier to entry to working on the core were lower. Right now the only thing that's really accessible to everyone is the surface language, so anytime anybody has the feeling that they want to contribute to Perl, the only thing they know how to do is suggest a new feature. I hope in the future they'll be able to do things like suggest an improvement in the efficiency layer or something like that.

The secondary reason actually is new features. There are some features there where people say, "Yeah, I want that just cuz it's cool." First of all, dynamic loading of basic types—and I'll give an example of that later—the basic concept is if you want to invent a new thing like a B-tree hash, you shouldn't have to modify the Perl core for that. You should just be able to create an add-on that's dynamically loaded and inserts itself and then you'd be able to use it.

Robust byte-code compilation is another such feature. Now, in complete honesty, I don't know. I haven't looked at the existing byte-code compilation output, but I do know from examining how the internals work that retrofitting something like that is quite difficult. If you incorporate it into the structure of the OP-tree (for those of you who know what that is, the basic operations), there's the concept of a separation between designing the semantic tree (as in "this is what I want") versus designing the runtime representation for efficient execution. Once you've made that separation, now you can also have a separate implementation of the semantic tree, which is, say, just a list of byte codes that would be easy to write to a file and then read back later. So, separation of representing the OP-tree statically versus what you use dynamically is an important part of that part the internals.

Also, something that could be done currently but nobody's gotten around to it—Micro Perl. Now if you built Perl, you've noticed that there's a main Perl, and then there's Mini Perl, which you always to expect to have a little price tag hanging off of, and then there's the concept of Micro Perl, which is even smaller than Mini Perl. The idea here is: What parts of Perl can you build without any knowledge that Configure would give you. Or perhaps, only very, very, very little configure tests. For example, we could assume ANSI or we could assume pseudo-POSIX. In any case, even if you limit yourself to ANSI, you've got quite a bit of stuff. You, of course, have all the basic internal data structures in the language. You can make a call to system, to spawn children, and a few other things, and that basically gives you Perl as your scripting language. Then you can write the configure in Micro Perl. I don't know about you, but I'd much rather use Micro Perl as a language for configuration than sh, because who knows what particular weird variant of sh you're going to have, and really isn't it kind of a pain to have to spawn an external text program just to see if two strings are equal? Come on. Okay, so that's also part of the plan. We could do this with Perl 5, who knows maybe now that I've mentioned it somebody will, but that's also something I have in mind.

**Why not use C?** Certainly C does have a lot to recommend it. The necessity of using all those weird macros for namespace manipulation, which I'd rather just use the namespace operator for, and the proliferation of macros are all disadvantages. Stroustrup makes the persuasive argument that every time you can eliminate a macro and replace it with an inline function or a const declaration or something or that sort, you are benefiting yourself because the preprocessor is so uncontrolled and all of the information from it is lost when you get to the debugger. So I'd prefer to use C++ for that reason.

**Would it be plausible to use Perl, presumably Perl 5 to automatically generate parts of Perl 6?** And the answer is yes, that absolutely will be done. The equivalent of what is now opcode.pl will still exist, and it will be generating a whole bunch of C++ classes to implement the various types of OPs.

A perfect Perl doesn't have systems programming as part of its target problem domain. That's what C++ and C and those other languages are for. Those are systems programming languages. Perl is an application language, and in fact one of the things that I really felt uncomfortable about Eiffel was that it also is really an applications programming language. The whole concept of pointers and pointer arithmetic and memory management—if you read Meyer's new book, the chapter on memory management begins with "Ideally, we would like to completely forget about memory management." And I thought to myself, well that's great if you're doing applications, but for systems programming, that's nuts. It's an example of what the language is for. When I was trying to figure out how to be persuasive on this subject, I finally realized that Perl may be competing with Java in the problem space, but when you're writing Perl, implementing the Perl runtime, really what you're doing is something equivalent to writing a JVM. You're writing the equivalent of a Java Virtual Machine. Now, would you write a JVM in Eiffel? I don't think so. No, so neither would you write the Perl runtime in Java or in Eiffel.

### How or Why Perl Changes

The language changes only when Larry says so. What he has said on this subject is that anything that is officially deprecated is fair game for removal. Beyond that I really need to leave things as is. He's the language designer. I'm the language implementer, at least for this particular project. It seems like a good separation of responsibilities. You know, I've got enough on my plate without trying to redesign the language.

Larry is open to suggestions, and in fact that was an interesting discussion we had recently on the Perl 5 Porters mailing list. Was the syntax appropriate for declaring variables to give appropriate hints to a hypothetical compiler? That is to say MY INT $X or MY STR $Y -- and I thought that the INT and the STR and the NUM should be suffixes, something like MY $X:NUM—and, in fact, that suffix syntax is something that Larry officially has blessed, but just not for this purpose. That's the instinct of the language designer coming to the fore saying that something that is a string or a number should not be so hard to type. It should read better.

Meanwhile, if you want to declare something as being a reference to a class - MY DOG SPOT—that's going to work. You can say that $SPOT when it has a defined value will be a reference to an object of type DOG or at least of a type that is compatible with DOG, and the syntax is already permitted in the Perl parser; it doesn't do very much yet but that will be more fully implemented in the future as well. Many of the detailed aspects of this came about not just springing fully formed from Larry's forehead but as a result of discussion. So yes, he absolutely is taking suggestions.

### Getting into the Internals

Now I'd like to ask how many of you do not know anything about C++? Okay, a fair number, so I'm going to have to explain—everyone else is lying. Two kinds of people: people who say that they know C++ and the truthful. Okay. C++ is complicated, definitely. Actually that reminds me, I'm doing this in C++ and I use EMACS. Tom Christiansen asked me, "Chip, is there anything that you like that isn't big and complicated?" C++, EMACS, Perl, Unix, English—no, I guess not.

*At this point, Chip begins to dive rather deep into a discussion of the internals. You can [listen](http://g2.songline.com:8080/ramgen/perl.com/realaudio/OSSC99-Topaz.rm) to the rest of his talk if you are interested in these details.*
