{
   "image" : null,
   "description" : "We talk to brian about Mastering Perl second edition, technical writing and his new Perl projects!",
   "categories" : "community",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "title" : "Perl master - an interview with brian d foy",
   "slug" : "75/2014/3/6/Perl-master---an-interview-with-brian-d-foy",
   "tags" : [
      "community",
      "interview"
   ],
   "date" : "2014-03-06T03:52:17"
}


*brian d foy is is a prolific Perl author, programmer and trainer whose new book, the second edition of Mastering Perl was recently published by O'Reilly. We caught up with brian to discuss the new book, his thoughts on technical writing and find out what other projects he's working on.*

**Let's talk about the elephant in the room, that new cover of Mastering Perl. Do you like it?**
 I saw the change when the book was nearing completion, because they usually save that activity for the end of the publication process. I haven't seen it in print yet, but I don't think it will influence people that much, as people tend to buy technical books based on the title and the content rather than the cover. It seems similar to what Apple did with iOS 7—make everything very thin and flat. I'm getting old so I need everything to be bigger! It's something different than what people have seen before and I think it will take a while for the style to take hold and then people will identify it with the Perl series much like the previous style.

![](/images/67/mastering_perl_first_second_cover.png)

**Originally you set out the vision for Mastering Perl to be: "teach people to work on their own and get them on the road to being a Perl master" — how do you think the new edition of Mastering Perl achieves that?**

The second edition is very much like that the first in structure, although I've updated various things. The first edition was published in 2006 and it's almost 10 years later. A lot of things have changed, such as which modules we're using and how we think about the details, but the big stuff is the same.

When I teach classes based on Mastering Perl, this is the stuff that people haven't ever really thought about. We spend a lot of time teaching people how to deal with the language itself at the statement level, but not much on the higher, architectural level. It's at that higher level where people can really get into trouble because they create things that syntactically work out but turn into a big mess when they operate as a whole.

> We spend a lot of time teaching people how to deal with the language itself at the statement level, but not much on the higher, architectural level

Mastering Perl covers topics like debugging, profiling, logging, things that help people get things done. I've been very happy with the feedback I get from the book, now I just need to get everyone to read it!

**I saw it was number 2 on the Amazon Perl sales charts recently, so it seems to have had a positive impact so far?**

Amazon ratings can be very dynamic as people buy books so infrequently, (especially technical books), that if I sell one book on one day, it can move me very far up the sales charts. Also, initially for any new book there is a sales spike, I think pre-orders count as soon as the book ships. Mastering Perl is an advanced book too, so it may be popular for a while but never as popular as [Learning Perl](http://www.learning-perl.com) or [Programming Perl](http://www.programmingperl.org).

**Learning Perl has been the best-selling Perl book for a long time.**

I think ever since it came out it has been the best-selling Perl book. But nowhere near the numbers that Randal Schwartz was seeing in the first edition. That was just amazing. I hope to someday write a book that popular!

**In the new edition of Mastering Perl, there is a lot of new content. Which parts of that content were you most happy with or excited to tell other people about?**

The big changes were in the "Lightweight Persistence" and "Regular Expressions" chapters. In "Lightweight Persistence" we finally admitted to the community that [Storable]({{< perldoc "Storable" "SECURITY-WARNING" >}}) has a a huge problem with security because in the Storable format we can inject various things to make Perl do things, especially with duplicate keys and class names that don't exist. I had to rewrite all of the book's content for Storable, and it was interesting to track that information down.

There's a lot that's happened between 2005 and now; for example JSON just exploded. It seems everyone is using it and not so much YAML anymore. So I had to add JSON in. In my programming, JSON features a lot in what I'm doing now. It's easy to exchange into other languages, to throw at your browser, and it's decent to read (at least, it's not that bad).

The other huge change in the Regular Expressions chapter. When I looked at was in the that chapter, a lot of that stuff has moved down into either Learning Perl or Intermediate Perl and our goal with Mastering Perl, when Alison Randal and I both set out to write it, was to not include content that's available in another book already, especially if it was one of the books that had my name on it.

I had to take out a lot of that stuff, like non-greedy matching and anchors, which are in the other books. In order to keep the chapter, I had to replace that content with something advanced.

Since 5.10 we've had a huge number of really powerful new features that no one has really seen yet; grammars, new flags, and the cool things you can do with those.

I had to work really quite a bit on this chapter and luckily as I was writing it, Randal Schwartz came out with this [regular expression](http://www.perlmonks.org/?node_id=995856) that parses JSON, using a lot of the new key features. I don't know if I would actually use it to parse JSON as he's written it in a minimal way for a particular client problem that works for them. But it demonstrated a bunch of the stuff I wanted to talk about. So I built the chapter around that. I had to research what a lot of those feature do: they're not very well explained in the Perl documentation (at least so far as I could understand them). Taking the new features and experimenting with them to understand them for Mastering Perl was something I really enjoyed doing.

**On that topic, you write for all kinds of audiences, but would say that you enjoy writing for the advanced (Perl) audience more, because it gives you more opportunities to do things like that?**

I enjoy it in different ways. I get to do a lot more with Mastering Perl because as I say in the introduction, I'm assuming you already know Perl, or you know how to find out something by using the docs and where to ask questions. I'm not going to write out step-by-step how the map function works; the reader should already know how it works.

That assumption let's me expand on the idea of what we're trying to do rather than the syntax. Whereas in Learning Perl you have to do very simple things because the reader is going to struggle with the concept of the particular feature that they're using.

I'm not sure I would say I enjoy it more, it's a different sort of enjoyment. I really like the beginning stuff. There's a lot you get from kick-starting someone into the language and setting them on right path and then they can turn into a programmer. And I think that's probably more rewarding to me than writing the very advanced material. That's not to say one is better than the other, it's just more satisfying to turn people into new Perl programmers than it is to level-up existing programmers. But I recognize the need to do both.

**The chapter structure of Mastering Perl is largely the same as before, do you think you got it right the first time around? I know there was a public development process that was involved.**

I think we did. In the first edition of Mastering Perl I had a lot of input from Alison Randal (the editor) and she was a big name in the Perl community. Unfortunately she's moved on to other things, but she really knew Perl, the community, and how to program in Perl. So when we sat down to talk about the book, she had great ideas and input about how to organize things, and what to put and leave out.

We ran the book completely in the open. As I wrote things I let people see it (which is a very dangerous thing to do!) and people were not shy in telling me what they thought. Which is great, because you want them to say it before the book is published and not afterwards in an Amazon review. So that process really shaped the book.

When I got to writing the second edition of Mastering Perl, I put it online again, and got a lot of good feedback for that. There wasn't anyone saying "you need to have a chapter on x" (that wasn't there before). I think that's because most topics are covered elsewhere already. For instance we don't have a chapter on XS, as it's already covered in Tim Jenness' [book](http://www.manning.com/jenness/), or you're going to have to talk to perl5-porters because they don't even have a good set of docs that explain everything. You just have to get your hands dirty. And XS keeps changing because of release of Perl, they're improving the Perlguts interface to make it easier to use (which is fantastic). XS was one of the things that motivated Perl 6 because the Perl 5 core was so hard to hack on. I think for Mastering Perl, we got it right.

The thing to remember for any book is that no book is going to give you everything. Learning Perl is a very targeted book. There's that Randal Schwartz quote: "80% of the behavior of Perl can be described in 20% of the documentation"<sup>[[1]](#1)</sup>.

In Intermediate Perl we move on to how to write Perl with people in teams, reusable code, how to share it and references. But they're both very short books of about three hundred pages each and Mastering Perl is about the same size.

If you look in some other languages and look at their books, they've got these gargantuan things that are a thousand pages or more. I know in Programming Perl we were limited to a certain page count because they couldn't physically bind it otherwise.

But not everyone needs 1200 pages. There are some people who'll use Learning Perl and stop, because that's all they need. So to people who say "why can't you combine all this material into one big book", the answer is you can, just buy the separate books and glue their back covers together, and there's your one big book. The chapter sequence would be the same anyway!

> to people who say "why can't you combine all this material into one big book", the answer is you can, just buy the separate books and glue their back covers together

There's a great Perl book market out there. The Perl community is really good at getting information out there. There's a lot of beginning Perl books, there are enough of the advanced ones. My idea is if I teach you how to do something you don't need a book on every particular topic. Once you learn how to use the documentation, you can quickly get up to speed on the particulars yourself.

**You've written a lot about Perl, and you've been published in many different formats and mediums. What do you think are some of the key considerations for good technical writing?**

I always remember what Randal told me when I first started writing Perl books. He mentored me and explained to me how to be a good technical writer. You always have at least three audiences: the people with no clue who have never heard of the thing you're talking about, then there are the people who get the concept, but they need a reason to read it, and then there are the advanced users (who might not be a huge proportion of the audience), and they'll want to learn something new or clever.

Taking the JSON parser example from Mastering Perl, there are three people I'm thinking about. People who have never seen those features before; they haven't seen a recursive regular expression and so I have to explain it as if talking to a beginner. There are people who have seen it, are aware of it, and have just never used it. So I had to do something interesting for them as they know how it works, but never had a reason to put it into practice. Then I think about that advanced group, who know all of this, but they want to be surprised by it somehow. And that's what Randal's final JSON parser example does.

Another thing that Randal drilled into my head which is that you've got to realize where you're starting and where you're ending and you've got to lead the reader there because you're telling a story; there's a narrative. You can see that in my books. It's not that there's one section and then in the next section we've completely forgotten what was covered in the preceding section. We're always on some kind of progression. In my writing, I start of at some point and write a story that progresses you to a final point which ties everything together. You have to keep that story line in mind, so you know what you need to emphasize and not, what to include and to leave out, to take people along the path you want them to travel.

**What about code examples? That's something that always features in technical writing. Do you have any guidelines or rules or rules of thumb that you follow when you're including code examples in your writing?**

I try to write code examples that have the least number of distractions. I could write a program that was [Perl::Critic]({{<mcpan "Perl::Critic" >}}) clean and uses all the modern Perl conveniences, but that would distract from the concept I'm trying to communicate, so I write very minimal programs. I don't remember if I did this in Mastering Perl or not, but I don't think I used the strict or warnings pragmas in the code examples. I didn't want to have those extra two lines all the time. I think I do have the shebang line in there, but not those other two. It's not that I'm saying don't use strict or warnings, it's just not what I'm thinking about. In the code examples I'm trying to focus on a particular concept and especially in Mastering Perl, I assume that people know how to write complete Perl programs on their own using good practices, so I'm not harping on about strict and warnings.

That's one of the things the Perl community is killing itself with because every time someone comes in with a casual question, that's the feedback they get: "we're not going to help you unless you use strict in your program", even if there was no strict problem in their question.

Some of the other things I try to think about: how does the code look, and how does it fit together? I try to write code in paragraphs: there'll be a bunch of statements together with no blank lines between them, then I'll add blank line and begin coding the next paragraph. Different people have different ideas about that, but in Mastering Perl I'm the only name on the book so I get to decide the style!

> Different people have different ideas about that (code style), but in Mastering Perl I'm the only name on the book so I get to decide the style!

One thing I think is important (and I try to pass this on in my classes) is that you're going to have to look at all kinds of different styles anyway. So having a consistent style across every Perl book isn't really helping the reader. When that reader sits down and opens a Perl program written by a C programmer, it will look very different and they won't have the style crutch to help them. There are tools that can help you in this scenario, in Mastering Perl we cover perltidy, which formats Perl code to a coding style you define. It's also like fiction: detective novels are not written in the same style as advanced literature, because the authors are trying to achieve different things. I think the coding style used in technical books is a lot like that. I don't want to say much more on coding style else I might spark an online war about it.

**That's interesting, considering Perl's motto, TIMTOWTDI (there is more than one way to do it), do you find it challenging to write about Perl, because it seems no matter how you write about something, someone else will always have another way of doing it?**

It doesn't bother me so much in terms of writing the books or reading other people's code, but while we have TIMTOWTDI there is the corollary "but most of them are wrong" (I don't remember who invented that). I think TIMTOWTDI is great; it let's people with limited knowledge get stuff done. They don't need to learn the one optimal function call to use, they can fake it with something else. You can parse a string tediously with an index, or use split or regex captures. For the person who just needs to get things done by the end of the day, that's great because they may only need to know a couple of those methods, and not spend the time figuring out the one right method they don't know. Later they can go back and optimize that code if they have to. So I don't get too upset about TIMTOWTDI.

I come from the Physics world where I have seen much worse code than the examples the community typically criticizes. I've seen this awful code running in big labs and bespoke equipment and it worked. I wouldn't want to work on that code myself, but there is a point where you just have to get work done and I can't expect everyone to be thinking about Perl all day long.

I do appreciate beautiful code—there are some people who write code that is amazing to look at and fun to read, because the way they think about things and the features they use all weave together to make something really interesting. But I don't expect that from everyone because that's not the goal for most people. If I want to make people into Perl programmers I can't make that the goal, I'm not trying to turn them into people who win code reading contests at conferences. I want to turn them into people who say "I used Perl and I got my work done and I was able to go and do something else".

> I'm not trying to turn them into people who win code reading contests at conferences. I want to turn them into people who say "I used Perl and I got my work done and I was able to go and do something else".

**On code readability, most textbooks print code in plain text without syntax highlighting (for cost savings or whatever). Do you think that's a missed opportunity?**

I think my book [Effective Perl Programming](http://www.effectiveperlprogramming.com) had syntax highlighting, but really I don't pay attention to my books after they're published because I don't want to see what the editors did to it. I write the book initially but there's a whole bunch of people that come in and make it better. And sometimes they make it better in ways that I don't like and it will take me a couple of years to come around to the fact that it was probably a good change.

Syntax highlighting is a personal decision though. For example in my terminal I have a black background and 30% opacity and yellow text. I work mostly in [BBEdit](http://www.barebones.com/products/bbedit/), and I just use the default syntax highlighting settings. Keywords are blue and comments are red and documentation is grey (I think). But when I look at code presented at conferences, there's all kinds of things going on: braces are a particular color, etc. Everyone has their own particular way that they expect to see things so if I choose one syntax highlighting scheme in the book, it's probably not going to work for anybody. Even the highlighting in Effective Perl Programming didn't work out because they didn't want to use red ink as they're worried about people who have trouble seeing red (it can appear as grey). So the publishers changed the color, and now the things that would have usually been red are cyan and it makes me feel weird reading it. Syntax highlighting is a personal preference, and choosing any one particular style will not work for the majority of readers of the book.

I've always maintained that people should use whatever tools and settings they want to use. With the proviso that their choice does not affect anybody else. If I use BBEdit that's great as long as people using VI, Emacs or Komodo or whatever they want to use aren't affected.

If we had really fancy ebooks—which I'm still waiting for as ebooks now are still mostly static content—but if we had really fancy ones where we could load our code settings into it where we could see the code in our preferred syntax highlighting style. But we don't have a way yet to inject a personal CSS into an ebook. I think there are huge missed opportunities there and I don't think we're going to get them now that Steve Jobs has passed on as I don't think anyone cares as much as he did about how things look.

**In terms of that stance on not minding what other people use as long as it doesn't affect what you use. There was that recent controversy about the Dist::Zilla authors on CPAN. What's your take on that? Should we all reach for the MakeMaker approach, or do you have a different view?**

I'm not in love with [MakeMaker]({{<mcpan "ExtUtils::MakeMaker" >}}) but it's the best we've got. Module::Build solved a lot of problems, but it also didn't work in some scenarios, so we're back to MakeMaker now. I wish there were a better thing, but so far there isn't.

Regarding [Dist::Zilla]({{<mcpan "Dist::Zilla" >}}), my only real problem with that is when you drop into a Dist::Zilla project and you're not a Dist::Zilla author, there's absolutely nothing that tells you what to do. A lot of times there's not even a readme. For a while there was a fad of making the readme just a copy of the pod in the main module. But I've always wanted to readme to be "this is how you can get started with this directory". So in my readme files I explain how to build the program. The Dist::Zilla approach gets rid of all that. There is dzil.ini file and a bunch of directories but there's nothing that says "this is what you need to do". I think a lot of people wouldn't even know what module to install so they can begin the installation process. When I brought this up on twitter, some people thought it would be a good idea to include a file that explains the installation process with Dist::Zilla. Then I went one step further and thought wouldn't it be great to have a program that manages that process for the user, but then that's topologically similar to the Makefile.PL route.

> my only real problem with that is when you drop into a Dist::Zilla project and you're not a Dist::Zilla author, there's absolutely nothing that tells you what to do

I know why Ricardo made Dist::Zilla, I know why some people use it, but I get annoyed when people push off their preferences for their particular activities onto others. Ricardo and David Golden are prolific CPAN authors and Dist::Zilla helps them be manage that. But the way that they work doesn't have to be the way that the maintainer of a single module works. I'm not saying that we shouldn't use Dist::Zilla, but that every time we use a tool we have to figure out how much it helps and how much it hurts.

I think in a lot of cases, people have told me that when they drop into a git repository (to contribute a change) and there's only a dist.ini file and they can't find where they need to their change, they just give up. A lot of the stuff I do are doc patches for instance, but with Dist::Zilla some of the text comes from plugins that are created as part of the distribution. So the error might be higher up in the tool chain, but I don't know which tool that is, and I'm not going to go looking for it. I'll grep the distribution, and if I don't find the thing I want to change, I'll move on. That's my personal decision—that it's not worth my effort. Some people are going to be fine with that, they may think that they don't get many contributions anyway, or that their users are all Dist::Zilla users, so they'll get the contributions they need. It's something that the community hasn't really discussed, and when the subject does come up, it gets heated very quickly.

There are a lot of people that don't want to use Dist::Zilla for whatever particular reason. For me it's not about Dist::Zilla, it's about my philosophy on tools: should your personal tool choices impact mine? I like using the tools I use, if I had to use VI, I probably wouldn't want to do much programming. If you talk to Ovid (Curtis Poe) for instance, he practically lives in VI, and if he couldn't use it, he probably wouldn't want to program either. So when we talk about build systems, it could be a completely different ballgame if Perl came with everything required to interact with a distribution built with Dist::Zilla, but that's not the case.

I don't want to tell people to use Dist::Zilla or not to use it, I want people to think about (and this is the point of Mastering Perl) there are many tools available but does this tool make sense for your particular situation? There is not such thing as best practice unless you specify the context. So when we talk about whether a tool is a good thing or a bad thing, we need to have a situational context.

As programmers what we really like to do is find "the one way", even though Perl has TIMTOWTDI, we want to find the one right way to do it, and then tell everyone to do it that way (despite our disdain for Java, which often follows that approach). The Perl community version of that is "the right module". For instance, something that just happened in the past couple of weeks, we've been telling people for years to use File::Slurp. It's in the documentation, it's in the FAQ. Every time someone asks the question "how do I read a file into a string" they've been told to use File::Slurp. It turns out the File::Slurp always wants to assume a particular encoding on the input file, and so slurping a file that does not follow the expected encoding, various bad things can happen. [There's a ticket](https://rt.cpan.org/Ticket/Display.html?id=83126) in RT for that now, and people are saying that the module is "fundamentally broken"—there is not a way to get around it. We have been pushing this tool on people, and it's critically broken. Is it that great? Sure it saves some typing, is a bit faster and works on some files, but is it that much better than localizing $/ and slurping the file manually? This way I have no dependency and I don't need to go back and change anything if the module fails. It might be a tiny bit slower, but if I'm doing anything interesting (in the code), the time won't make much difference.

> As programmers what we really like to do is find "the one way" ... The Perl community version of that is "the right module"

Context really matters and this is why, back in the 90s I got into Perl. Perl was full of these kinds of people. One of the best people for this is Mark Jason Dominus. If you go to one of his talks, he has such a breadth of programming knowledge, he can really speak to the question of "is this a good idea?" because he's aware of the different implementations in ML or Java or some other language most of us have never heard of, and he's aware of the the consequences of those decisions.

**It seems you're always writing something, so I'm sure you can't keep your pen still for long. What's next for you in terms of Perl writing?**

I've got a book I'm working on and it's going a lot more slowly than I thought it would. I want to write a very thin book about Perl on Windows. It's been a lot more painful than I expected. Not necessarily the writing, but just dealing with Windows. Partly because I'm not that experienced with Windows (which is one reason to write a book about something), but also it's because Perl is from such a different universe, and I want to be true to the Perl on Windows concept (not Perl on Cygwin which is just Unix). Windows has a completely different filesystem to Unix filesystems, the metadata you can get out are different, how you name files is different and so on. I thought I could do it in two months but I'm coming up on two months and I've barely got through writing the first chapter, which is just about how to get Perl on Windows.

Other than that, I want to do a series of experiments, to cover a topic in a short book, say 50 to 100 pages, and get some kind of crowdfunding for it. Maybe even a crowdfunding competition where the most funded project wins. The idea would be to get enough money to justify spending my time on it and I could put it out there, develop it in public and people could comment on it. Then I would make the book available on Amazon for some ridiculously low price. I would love to have books out there that are a dollar and sell ten thousand copies rather that a price of ten dollars and sell a thousand copies. I don't really care how many sales I get, just that I get enough money to live and write the next book, that would be fantastic. I'm going to do this experiment at some point, I just have to get through this Windows book first!

There's a website for the Windows book, it's [WindowsPerl.com](http://windowsperl.com). There's not much there yet, but I'm taking suggestions from people and letting them know what's going on with the development process. I don't know who is going to publish it yet, I have an idea, but we haven't made a contract (but it's not going to be O'Reilly). I'm talking about the book in the usual places so if people want to follow progress or comment, they can.

**Is there anything else your working on that you'd like to make people aware of?**

There is one thing I have thought about for a long time and I guess I should just get off my butt and do it. For a while I've run the White Camel awards, it's announced on Perl's birthday (December 18), for outstanding non-technical achievement in Perl. We want to recognize people for doing all the stuff that no one ever remembers—things like working in the user group community, people who organize conferences and Perl monger events, people who are doing general Perl advocacy, like PerlTricks.

What I want to do is create a new award, like a tangible award that they can use it to show that the community appreciates what they've done. And this would be for a technical achievement. I'm thinking something like a medal or I don't know, we don't wear lapels so if we gave out a lapel pin we'd have nothing to put it on!

I've just done the Nerd Merit badges and I was thinking maybe something along that line. I don't know quite how it would work, but every so often, I would just like the community to say that it's time to give out another one of these awards somehow, and to decide who gets it. Like when Miyagawa released [cpanminus](http://cpanmin.us) it was such a ground-breaking thing, if everyone said "this person deserves an award", and if we had some way to actually provide that award and show that we appreciate people for doing cools things, and it's not just a pat on the back or a blog mention. It's something tangible that they can show to their friends or whomever. I've thought about this for years, and I guess I should just do it, but I don't quite know how it would work. We get so focused on algorithms, code and big ideas. But really it's just people. The more that we can show our appreciation, the better we'll feel, the nicer we'll be to each other and the more we'll be able to do together.

<sup>[1]</sup>Randal's quote comes from [Learning Perl, Third Edition](http://books.google.com/books?id=va1PSgaO4xIC&pg=PA3&lpg=PA3&dq=80%25+of+the+behavior+of+Perl+can+be+described+in+20%25+of+the+documentation&source=bl&ots=BOc7Eyc4YV&sig=ZEb4WZRk9eWvjk9j6PNhp_xgJOQ&hl=en&sa=X&ei=rOcXU-mTFIyekAelkICoAQ&ved=0CCgQ6AEwAA#v=onepage&q=80%25%20of%20the%20behavior%20of%20Perl%20can%20be%20described%20in%2020%25%20of%20the%20documentation&f=false)

The second edition of brian's Mastering Perl is [available now](http://www.amazon.com/gp/product/144939311X/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=144939311X&linkCode=as2&tag=perltrickscom-20) (affiliate link).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
