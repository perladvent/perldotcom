{
   "title" : "Pod::Parser Notes",
   "slug" : "/pub/2000/05/podparser.html",
   "authors" : [
      "brad-appleton"
   ],
   "thumbnail" : null,
   "description" : "Pod::Parser Notes -> Some of my co-workers noticed the p5p weekly summary discussing (among other things) Pod::Parser. They mentioned it to me, and said they thought it cast me in an unfavorable light. So I'd like to clear up a...",
   "tags" : [],
   "image" : null,
   "categories" : "development",
   "draft" : null,
   "date" : "2000-05-20T00:00:00-08:00"
}





\
\
Some of my co-workers noticed the p5p weekly summary discussing (among
other things) `Pod::Parser`. They mentioned it to me, and said they
thought it cast me in an unfavorable light. So I'd like to clear up a
few things that may have been missing or misunderstood from the
summary....

I freely admit `Pod::Parser` has had very little performance
optimization optimization attempted. (I've mentioned this before on p5p
and pod-people and have asked for help). I certainly agree with many of
the issues of POD format that Mark raised. But I think it is very
important to note that most of the slowness of `Pod::Parser` has less to
do with POD format itself, and more to do with the cost of creating an
flexible & extensible O-O framework to meet the needs of pod-parsing in
general (not just tasks specific to translating POD to another output
format).

Most of the overhead in `Pod::Parser` is from parsing line-by-line (to
track line numbers and give better diagnostics) and from providing
numerous places in the processing pipeline for callbacks and "hook"
methods. Since `Pod::Parser` uses O-O methods to provide lots of
pre/post processing hooks at line and file and command/sequence level
granularity, the overhead from method-lookup resolution is quite high.
(In fact I'd lay odds that at least a 10X performance speedup could be
had optimizing away the method lookups at run time to precompute them
once at the beginning.)

Regarding the "benchmark" of 185X as a prospective performance target
for podselect (which uses `Pod::Select` which uses `Pod::Parser` :-),
please realize that podselect's purpose in life is to do a whole lot
more than what Tom's lean-and-mean POD dumper script does. It so happens
that podselect will do this same task if given no arguments. But its
*real* reason for existence is to select specific sections of the PODs
to be spit out based on matching criteria specified by the user. This is
what `Pod::Usage` employs in order to format only the usage-msg-related
sections of a POD.

When I mentioned podselect in this thread on p5p, I was just pointing
out that existing code - which is already designed to have hooks for
reuse, can fulfill the same functional task - I didn't intend to claim
it was comparable in performance. I don't think that the "185X" figure
is reasonable to achieve for `Pod::Parser`. Not only is there imore
parsing that `Pod::Parser` has to do, but most of that overhead comes
from enabling better diagnostics and extensibility for purposes above
and beyond what Tom's script implements for one very specific and
limited purpose.

185X may be a fair benchmark for something whose purpose is limited in
scope to that particular thing, but I think not so for something with
much broader scope and applicability and use like `Pod::Parser`. Not
that speed improvement still isn't needed - but I think a 50X
improvement would a more reasonable benchmark, and IMHO within the realm
of what's reasonably possible.

In another place - I think the summary may have missed a reply I made to
p5p about the structure of `Pod::Parser` "output". Its not just spitting
out tags or a linear stream, and it will spit-out parse-trees *if* you
ask it to.

I agree that there is a need for a module to impose more structure, but
the notion that `Pod::Parser` must somehow be the module that does this
is a misconception IMHO. `Pod::Parser` was deliberately created to be a
flexible framework to build on top of and there is nothing to stop
someone from creating a module" on top of `Pod::Parser` to do all the
nicer stuff.

But much of that "nicer" stuff will break a lot of existing code if its
added into `Pod::Parser` - because `Pod::Parser` is used for more than
just translation to another output format. I've recommended many times
on p5p and elsewhere that someone create a `Pod::Compiler` or
`Pod::Translator` to impose this added structure (and the existing
`Pod::Checker` module might be a good start).

Also, the summary suggests that `Pod::Parser` and Russ' POD modules have
been "under development for years." I think maybe Mark meant to write
that various POD-related parsing and translating/formatting modules have
been under development for years. In particular, I believe Russ only
just started on his "pod-lators" modules in the past year.

`Pod::Parser` development started years earlier, but it's "gestation
period" was only about 6 months before a useful and working version was
available. Since then, I've done bugfixes and enhancements over the last
2-3 years. The main addition of significant functionality was adding the
capability for parse-trees, (and the development of a test-suite for pod
"stuff", which was too long in coming :-). It didn't become part of the
core perl distribution until v5.6 because it was necessary to wait until
some kind folks (like Russ') took the time to re-write the most common
`pod2xxx` modules to use the same base parsing code provided in
`Pod::Parser`.

Now - I'm not claiming `Pod::Parser` is perfect - but I felt the summary
left out some important points that add more balance to the discussion.
Could `Pod::Parser` be faster? You betcha! Could it be lots faster?
Sure. Is it unusable for its most common purpose? Not at all IMHO. Is it
unusable for processing large numbers of PODs? Quite likely. But as I
said, thats not because of POD, thats because of the need for designed
in flexibility.

At least now there is a common base of POD parsing code to focus our
collective optimizing efforts upon instead of lots of parsing engines
from disparate `pod2xxx` modules. Now that it's in the core, maybe it
will encourage more people to focus on optimizing the common base parser
for POD-stuff (which I've been wanting help with for years `:-)`

    -- 
    Brad Appleton <bradapp@enteract.com>  http://www.bradapp.net/
      "And miles to go before I sleep." -- Robert Frost


