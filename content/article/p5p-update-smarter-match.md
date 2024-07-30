
  {
    "title"       : "P5P update: Smarter Match",
    "authors"     : ["sawyer-x"],
    "date"        : "2018-02-22T08:30:36",
    "tags"        : ["p5p","smartmatch"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Explaining the recent smartmatch confusion",
    "categories"  : "perl-internals"
  }

*This post will be part of a new communication channel between p5p and the community. We hope to share more with you and keep you up-to-date using this platform.*

On December 20th, 2017, we released Perl 5.27.7, which included a massive change to [smartmatch]({{< perldoc "perlop" "Smartmatch-Operator" >}}). Since then it has been reverted. What happened?

Smartmatch has a long history. It was introduced in 5.10 back in December 2007 and significantly revised in 5.10.1. It was a good idea, but ended up causing more harm than good to the point it was deemed unreliable.

In an unprecedented step, it was marked as "experimental" in Perl 5.18.0, released in May 2013. Here is the mention of this in [perldelta]({{<perldoc "perl5180delta" >}}):

> Smartmatch, added in v5.10.0 and significantly revised in v5.10.1, has been a regular point of complaint. Although there are some ways in which it is useful, it has also proven problematic and confusing for both users and implementors of Perl. There have been some proposals on how to best address the problem. It is clear that smartmatch is almost certainly either going to change or go away in the future. Relying on its current behavior is not recommended.
>
> Warnings will now be issued when the parser sees `~~`, `given`, or `when`.
>

Since then, various threads were raised on how to resolve it. The decided approach was to simplify the syntax considerably. It took several rounds of discussions (with some bike-shedding) to settle what to simplify and to reach an agreement on the new behavior.

Last year we had finally reached an agreement on the significant perspectives. The changes were implemented by Zefram, a core developer. The work was published on a public branch for comments.

When no objections were filed, Zefram merged the new branch. It was included in the [5.27.7](https://github.com/Perl/perl5/releases/tag/v5.27.7) development release.

Following the release of this development version, issues started popping up with the effect this change made. A fair portion of CPAN was breaking to the point that one of the dedicated Perl testers decided it was unfeasible for them to continue testing. Subsequently, we decided to revert this change.

### What went wrong?

First of all, it was clear that moving smartmatch to experimental did not achieve what we had hoped. Features are marked as experimental to allow us to freely (for some value of "freely") adjust and tinker with them until we are comfortable making them stable. The policy is that any experimental feature can be declared stable after two releases with no behavioral change. With smartmatch, it was marked after numerous versions in which it existed as a stable feature.

Secondly, the change was massive. This in and of itself is not necessarily wrong, but how we handled it leaves room for improvement.

Thirdly, centering the communication around this change on the core mailing list was insufficient to receive enough feedback and eyes on the problem and the proposed solution. We should have published it off the list and sought more input and comments. We hope to use this platform to accomplish that.

Fourthly, we could have asked our dedicated testers for help on running additional, specific tests, to view what would break on CPAN and how damaging this change could be.

### Where do we go from here?

Despite not being the best way to learn from a mistake, there was minimal damage. The new syntax and behavior were only available on a single development release, did not reach any production code, and was reverted within that single release.

To address smartmatch again, we will need to reflect upon our mistakes and consider approaching it again by communicating the change better and by receiving additional feedback to both offer a useful feature and pleasing syntax. This will take time, and we are not rushing to revisit smartmatch at the moment.

We apologize for the scare and we appreciate the quick responses to resolve this situation. Thank you.
