{
   "date" : "2000-11-03T00:00:00-08:00",
   "categories" : "community",
   "image" : null,
   "title" : "Hold the Sackcloth and Ashes",
   "tags" : [],
   "thumbnail" : null,
   "description" : " (This is a slightly edited and expanded version of the reply I sent to perl6-meta@perl.org spurred by Mark-Jason Dominus sending the URL to his critique on the Perl 6 RFC process.) I agree partly on Mark-Jason Dominus' critique, but...",
   "slug" : "/pub/2000/11/jarkko.html",
   "draft" : null,
   "authors" : [
      "jarkko-hietaniemi"
   ]
}



(This is a slightly edited and expanded version of the reply I sent to `perl6-meta@perl.org` spurred by Mark-Jason Dominus sending the URL to his critique on the Perl 6 RFC process.)

------------------------------------------------------------------------

I agree partly on Mark-Jason Dominus' critique, but not fully.

He did point out several shortcomings that I agree with: we should have exercised tighter control by requiring authors to record the opposing opinions or pointed-out deficiencies, and in general by defining better the roles of the workgroup chairs or moderators, and giving those moderators the power to force changes or even drop controversial or simply bad RFCs.

But I certainly don't agree that the whole process was a fiasco.

Firstly, now, for the first time in the Perl history, we opened up the floodgates, so the speak, and had at least some sort of (admittedly weakly) formalized protocol of submitting ideas for enhancement, instead of the shark tank known as the perl5-porters (p5p).

(On the other hand, we do need shark tanks. If an idea wasn't solid enough to survive the p5p ordeal by fire, it probably wasn't solid enough to begin with. In p5p you also ultimately had to have the code to prove your point.)

Secondly, what was -- and still is -- sorely missing form the p5p process is writing things down. The first round of the Perl 6 RFCs certainly weren't shining examples of how RFCs should be written, but at least they were written down. Unless an idea is written down, it is close to impossible to discuss it in any serious terms in the email medium. Also, often writing down an idea is a very good way to organize your thoughts better, possibly even leading into seeing why the idea wouldn't work anyway.

Thirdly, to continue on the theme of the first point, now we have a record of the kind of things people want, seven years after Perl 5 came out. Not necessarily a representative list, not perhaps a well thought-out list, but a list. The ideas are quite often suggested in a much too detailed way, or they are trying to shoehorn new un-Perlish ways into Perl, suggesting things that clearly do not belong to a language core, breaking backward compatibility, and other evil things. But now we have an idea of the kind of things (both language-wise and application/data-wise) people want to do in Perl and with Perl, or don't like about Perl.

Based on that feedback Larry can design Perl 6 to be more flexible, to accommodate as many as possible of those requests in some way. Not all of them, and most of them will probably be implemented in some more Perlish way than suggested, and I guess often in some much more lower level way than the RFC submitter thought it should be done. After all, Perl is a general-purpose programming language, not a language designed for some specific application task, nor is Perl a language with theoretical axes to grind, as Larry points out in his [Atlanta Linux Showcase talk](http://dev.perl.org/~ask/als/).

Without the RFC process we wouldn't have had that feedback.

I vehemently disagree with the quip that we would have been better off by everybody just sending Larry their suggestions. Now we did have a process: it was public, it was announced, it began, we had rules, we had discussions, it had a definite deadline.

The state of the IMPLEMENTATION sections is not a cause for great concern. At this stage of Perl 6 where no code exists any deep implementation details would be pointless. For many relatively small RFC ideas that would cause only surface changes to the language "trivial" is a perfectly good implementation description.

We certainly expected (I certainly expected) RFCs of deeper technical level and detail, with more implementation plans or details, or with more background research on existing practices in other languages or application areas. But obviously our expectations were wrong, and we will have to work with what we got.

On the whole I think the process was a success. Of course it, like everything, could have been conducted better, with tighter rein, but we do have a good start into Perl 6 as a result.
