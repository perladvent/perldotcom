{
   "authors" : [
      "mark-jason-dominus"
   ],
   "draft" : null,
   "slug" : "/pub/2000/12/advocacy.html",
   "description" : null,
   "image" : null,
   "title" : "Why I Hate Advocacy",
   "categories" : "community",
   "date" : "2000-12-12T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : ["advocacy"]
}



<span id="__index__"></span>

[Why I Hate Advocacy](#why%20i%20hate%20advocacy)

-   [What Does this Have to Do With Programming Languages?](#what%20does%20this%20have%20to%20do%20with%20programming%20languages)
-   [\`\`My Country Right or Wrong''](#my%20country%20right%20or%20wrong)
-   [You know we do this too!](#you%20know%20we%20do%20this%20too!)
-   [More Stories](#more%20stories)
-   [Drink the Kool-Aid](#drink%20the%20koolaid)
-   [So What is the Problem?](#so%20what%20is%20the%20problem)
-   [Perl Programmers](#perl%20programmers)
-   [It Gets Worse](#it%20gets%20worse)
-   [Any Other Problems?](#any%20other%20problems)
-   [Conclusion](#conclusion)

------------------------------------------------------------------------

<span id="why i hate advocacy">Why I Hate Advocacy</span>
=========================================================

I think programming language advocacy is a big problem, not just for the Perl community, but for the larger programming community.

I'm going to start with an example of the same phenomenon in a different community, then work around to programming languages. In his Baseball Abstract 1985, Bill James wrote:

> Why are our information systems about managers so backward? Because we have gotten trapped in an unresolvable issue about whether a manager is "good" or is "bad." The fan, beginning with a position on the goodness or the badness of the manager in question, interprets each action in the light of that reference and makes every question about him an extension of the first principle. . . . Beginning with the premise that Bill Virdon stinks, every other question becomes a sub-heading of why Bill Virdon stinks.

James tried to make a beginning on the problem of evaluating baseball managers by making a simple, qualitative assessment of different managers' styles. He put together a questionnaire with questions like \`\`Does he stay with the starter, or go to the bullpen quickly?'' and \`\`Does he pinch-hit much, and if so when?'' Then he circulated the questionnaire, asking baseball fans to describe the managers with whom they were most familiar.

James got a surprise: Questionnaires came back with vituperative complaints about managerial behavior: \`\`This is where we see Bill Virdon's real preference: go with the starter 'til he drops. Hell, Virdon makes Billy Martin look like a wimp, Simon Legree like a quiche-eater.'' How long will he stay with a starter who is struggling? \`\`Exactly one batter too long, or until he faints, whichever comes first.'' And so on.

This didn't help James at all. He was trying to understand baseball managers qualitatively, without judging in advance whether they were 'good' or 'bad'. \`\`What Stan has done with the form of the managerial box,\`\` wrote James, ''is precisely what I designed the thing to try to lead the discussion away from.\`\` But baseball fans had so many years of experience in making these judgments that they no longer knew how to talk about managers in any other terms. Even when the fans made simple, descriptive statements, other fans inevitably understood these as either indictments or praises. Discourse about managerial style was essentially impossible, except at this very low level of ''Bill Virdon is a great manager!\`\` ''No he isn't!\`\`

I think this same thing has happened to programming language discussions. Advocacy has become so natural to us that we forget there is any other way to discuss programming languages. Even if we don't forget, other people can't understand us because they *hear* advocacy whether we want them to or not.

Here's an example, parallel to the baseball example. About two years ago I was giving a talk to the local Perl user group about strong typing semantics. (I can't get into details here, but the complete talk is available at <http://perl.plover.com/yak/typing/>)

I explained what types were, and said that a lot of people had concluded that strong typing was a failed experiment, based in part on the success of weakly typed languages like Perl and in part on an idea of the state of the art that was twenty-five years out of date.

Then I gave a counterexample: I discussed the typing system in Standard ML, which is more recent, and showed how it fixed many of the big problems of other typing systems and also provided a lot of unexpected advantages. Part way through the explanation, one of the audience members raised his hand and asked \`\`But what's wrong with the way Perl does it?''

I was taken aback. I hadn't said anything was wrong with the way Perl did it. In fact, I'd specifically said that Perl's approach had been a big success. But somehow, people in my audience had gotten the idea that because I was pointing out benefits of Standard ML, I must be saying that Standard ML was good and Perl was bad. Apparently it was inconceivable that there might be *two* right ways to do something.

In that talk I discussed the Pascal type system at some length. There was only one reason that I brought up Pascal. I needed to convince people that type systems have moved forward a little since the invention of Pascal in 1968. I had found from many years of experience that when I mentioned strong typing, people would frequently say \`\`You must be kidding. Pascal sucks.'' I knew that if I did not address Pascal, people would be unpersuaded by my talk---they might go home thinking I was advocating Pascal as soon as I mentioned strong typing. So I spent a lot of time discussing the particular failures of the Pascal type system so that I could show how these problems are surmountable---Pascal is not the be-all and end-all of strong typing, as many people think. I discussed C at the same time, because the C and Pascal type systems are so similar, and I did not want people to think I was singling out Pascal.

Nevertheless, several people have written to me to complain that my talk was 'unfair to Pascal'. They saw the talk as an attack on their favorite language. I don't understand this. Even if the talk had been about Pascal, which it wasn't, it couldn't have been an attack, because I only told the truth about Pascal. The Pascal type system *does* have big problems, many of which were corrected in various incompatible ways by various vendors, and many of which were corrected by Wirth, the inventor of Pascal, in his later languages.

You can be 'unfair' to a person, and you can hurt their feelings, even if you tell only the truth. But Pascal is a programming language, not a person. It has no feelings to hurt. Criticizing Pascal's type system is like complaining that your hammer has a scratched face. There is no use getting upset about it. You just have to get a new hammer or make do. Saying that the criticism is unfair to the hammer, for whatever reason, is just silly.

I think I know what happened here, but I'd like to discuss it a little later.

I got mail a couple of days ago from Jasmine Merced-Ownby, who runs the [Perl Archive](http://www.perlarchive.com/) web site. Part of the site had been implemented with PHP, and she was getting letters from people who were concerned that this 'made Perl look bad'.

I guess an implicit admission that Perl might not be the very best tool for every possible job could be construed as making Perl look bad, but it seems like an awfully peculiar response, unless you imagine Perl and PHP engaged in a war from which there can be only one victor, and unless you think that if PHP is good for something, anything at all, then Perl must be bad.

I don't recall that Perl has ever been advertised as the One Tool for Every Job. Perl came into a world full of other tools and made a name for itself as a 'glue language' that can help a lot of other tools inter-operate. Perl fills in the spaces between the other tools. That alone is impressive and useful. In the past ten years, more and more, Perl has worked well in place of the other tools; that's even better. But Perl's motto is \`\`There's More Than One Way To Do It'', and sometimes that means that one of the ways is to use PHP. If PHP comes up a little short for some reason, maybe Perl can fill in the gap. I understand that PHP can call out to a Perl program for help. If that's true, it's not an admission of failure; it's because Rasmus Lerdorf, the author, was smart. Perl can call out to C for help, and that's not an admission of failure either. The best glues can stick to everything.

In my world, PHP can be a good solution, and Perl can be a good solution, because maybe a problem can have more than one good solution. In my world you use what works, and using PHP can't possibly reflect badly on Perl.

<span id="more stories">More Stories</span>
-------------------------------------------

Here's another example, I think of the same thing. If you look in perlfaq4, you'll see a question that says \`\`[How do I handle linked lists?]({{< perldoc "perlfaq4" "How-do-I-handle-linked-lists%3f" >}})'' The answer begins by saying \`\`In general, you usually don't need a linked list in Perl,'' which is exactly the right answer, and then goes on to explain how Perl arrays serve most of the purposes of linked lists. For example, people like to use linked lists to represent stacks in C; in Perl, the right approach is to use the `push()` and `pop()` functions on an array instead.

But after explaining that linked lists are rarely useful in Perl, the manual goes on to show an implementation of linked lists: \`\`If you really, really wanted, you could use structures...'' and then the code follows. Avi recently asked me why it bothers to show an implementation, when it says before and after that the implementation is not useful for anything.

I tried to put myself in the position of the FAQ authors, and ask why I would do such a thing. The first answer I thought of was that I might do it to show off my erudition. But then a better answer came to mind.

Of course, this is just a guess, but if I had been writing the FAQ, I would have been afraid to say \`\`You don't need linked lists in Perl'' and leave it at that, because I would have imagined someone reading that answer and concluding that it was an evasion and that linked lists couldn't be done at all in Perl. Avi seemed shocked that I could be so cynical, but I think a lot of people do think that way. Why might someone conclude that the answer was an evasion? If your belief is that the author of the Perl manual will never say anything bad about even the worst parts of Perl, then you will try to read between the lines.

<span id="drink the koolaid">Drink the Kool-Aid</span>
------------------------------------------------------

I think the root of the problem is that we tend to organize ourselves into tribes. Then people in the tribe are our friends, and people outside are our enemies. I think it happens like this: Someone uses Perl, and likes it, and then they use it some more. But then something strange happens. They start to identify themselves with Perl, as if Perl were part of their body, or vice versa. They're part of the Big Perl Tribe. They want other people to join the Tribe. If they meet someone who doesn't like Perl, it's an insult to the Tribe and a personal affront to them.

I think that explains the reaction of the folks who wrote to me to complain about my unfairness to Pascal. I think maybe they took it personally, and felt that I was being unfair to *them*.

Getting yourself confused with a programming language isn't a sane thing to do, but a lot of people do it, including people from our community.

I'm not the only person who suspects this. This section's title, \`\`Drink the Kool-Aid,'' comes from a great talk by Nat Torkington from last year's YAPC. The title of Nat's talk was \`\`[Be an advocate, not an asshole.](http://prometheus.frii.com/~gnat/yapc/2000-advocacy/)'' Nat's talk has a slide on why people do advocacy. People he asked gave a few different answers, which he mentions. But then he says: \`\`My secret suspicion is that a lot of third-party advocacy is just: Perl is the way and the light, man, so drink the Kool-Aid and ascend to programmer heaven.'' I wouldn't have put it that way, but I have the same suspicion.

<span id="so what is the problem">So What is the Problem?</span>
----------------------------------------------------------------

Why should we try to get out of this mentality? What's the big deal?

One big problem with thinking and talking like this is that it means we can't learn anything new. Suppose that PHP has some advantage over Perl that would lead Jasmine to use it in place of Perl on her web site. If that's true, wouldn't it be cool if Perl could copy that advantage in the next version?

If you approach PHP with the idea that it has to be destroyed or shut out, that Perl is Right and Everything Else is Messed Up, you aren't going to find out what PHP's advantages are. You aren't going to be in a state of mind that can recognize that PHP has something good that Perl doesn't.

Maybe there are ideas in modern strong typing systems that would improve Perl in the future; maybe not. But if you approach the strong typing discussion with a fixed notion that there must be something wrong with it just because it's different from the way Perl works now, you're not going to learn anything.

Perl got where it is today by copying a lot of stuff from a lot of other languages. Perl's most famous features, hashes and regexes, are copied from Unix utilities like AWK, grep, and sed. Perl's statement modifiers are borrowed from BASIC-plus, of all places. Perl even has features that are borrowed from Ada, including one feature you use every day.

Perl's growth won't stop if Perl stops copying stuff from other languages, but it will slow down. Drastically. And Perl might stop being Perl. I'm glad I wasn't stuck with Perl 4.036 for the last seven years, and I don't want to be stuck with Perl 5.6.0 for the next ten years either. Borrowing from other languages has been good for Perl. To keep doing it, we have to be able to look at other languages and we have to be in a frame of mind to recognize the good stuff when we see it.

One of the things I found most dismaying about the Perl 6 RFC process was the parochialism of many of the submissions. The submitter would be trying to solve some problem, and would come up with a crappy solution. And meanwhile, there would be a perfectly serviceable solution in the language next door, just waiting to be reused. But it seemed as though a lot of the people making proposals only knew Perl, and not any other languages.

<span id="perl programmers">Perl Programmers</span>
---------------------------------------------------

Here's another problem with this us-versus-them discourse. People now identify me as a 'Perl Programmer'. They automatically assume that everything that comes out of my mouth will be colored by that, that I'm going to love everything about Perl and hate everything else. If I do say anything negative about Perl, some people assume that the real truth must be ten times worse than what I would admit to. It can be hard for me to make myself understood. Tribal assumptions are impeding communication. I can't be the only one with this problem.

I don't think of myself as a Perl Programmer. I program in maybe half a dozen languages regularly, whatever's convenient. I've been a programmer since about 1978. When folks call me a Perl Programmer, it never seems to occur to them that ten years ago they would have thought I was \`\`C Programmer'' and twenty years ago I would have been a \`\`Fortran Programmer''. But they still won't take me seriously when I talk about strong typing systems, because what does a Perl Programmer know about strong typing? If I make a simple factual statement, like \`\`Standard ML has strong static typing'', people are apt to conclude from that that I think strong static typing is a bad idea, just because I said that Standard ML has it, and Mark Dominus is a Perl Programmer, not a Standard ML Programmer.

Bill James complained about almost the same thing:

> Facing the question of "what is his strongest point as a manager," I wrote for Sparky Anderson "His record." I thought that this was rather complimentary. . . But if you start with the assumption that I'm going to be ripping Sparky, then innocent comments become loaded with double meanings.

<span id="it gets worse">It Gets Worse</span>
---------------------------------------------

Maybe the biggest problem with the \`\`Perl good, others bad'' rut is that it's going to impede our ability to communicate with *ourselves*.

If we decide that the Perl Way is the One True Way, then when someone appears and asks why `length(@a)` does the wrong thing, we're not going to have an intelligent answer. We're going to come up with a lot of blather about `length()`'s argument always being in a scalar context, yak yak yak. Listen, bub, I know all about scalar context, and I still think `length(@a)` is a rotten idea and `length(%h)` is even worse. Perl won big because it does what you mean, even when that isn't orthogonal. There's no way that `length(@a)` is doing what you mean.

Someone showed up in `comp.lang.perl.misc` this week asking why `length(@a)` does the Wrong Thing, and nobody gave any indication that anyone agreed with him. I guess they were all too busy defending Tribal Turf or something. [RFC 212](http://dev.perl.org/rfc/212.pod) proves that *someone* out there agrees with this guy. But nobody would admit it.

<span id="any other problems">Any Other Problems?</span>
--------------------------------------------------------

I'm glad you asked. Us-versus-them is not a way to be an effective advocate. Says Nat: \`\`Passion doesn't convince. Passion makes you look like an idiot or an asshole.'' Telling someone that Perl is great and their thing sucks isn't going to persuade anyone of anything. This style of advocacy may be fun and easy, but it isn't effective. You have to lead people, not drive them before you.

<span id="conclusion">Conclusion</span>
---------------------------------------

I don't really hate advocacy. I just hate the way we do it most of the time. We do it in a dumb way. And I think the discoursive habits we pick up as a result are going to impede the progress of programming languages for a long time.

Perl has a strong tradition of getting along with (and borrowing from) other languages and other systems. That's one of its greatest strengths. Let's not throw that away.

> I have a book on my bookshelf that I've never read, but that has a great title. It says, "All Truth is God's Truth." And I believe that. The most viable belief systems are those that can reach out and incorporate new ideas, new memes, new metaphors, new interfaces, new extensions, new ways of doing things. My goal this year is to try to get Perl to reach out and cooperate with Java. I know it may be difficult for some of you to swallow, but Java is not the enemy. Nor is Lisp, or Python, or Tcl. That is not to say that these languages don't have good and bad points. I am not a cultural relativist. Nor am I a linguistic relativist. In case you hadn't noticed. :-)

Two points if you can guess who said that.


