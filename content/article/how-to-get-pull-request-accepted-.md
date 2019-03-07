
  {
    "title"       : "How to get your Pull Request accepted",
    "authors"     : ["mohammad-anwar"],
    "date"        : "2019-03-05T20:35:00",
    "tags"        : ["github", "metacpan"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Sharing my secrets to getting a PR approved",
    "categories"  : "cpan"
  }

Recently, someone I met online (and a respected name in Perl community), asked me if I could share my tips for how to get a Pull Request accepted. I have been submitting PRs for over 4 years, over the course of which I've seen a few successful patterns.

Keep it short and simple
------------------------
The golden rule is "keep the change simple and minimal". Always remember the distribution owner doesn't have time to go through big changes in a single sitting. So it is better to split the big changes into smaller units. Ideally one commit per PR.

If you fancy then you may want to have one change per commit in a PR. But the downside is, if a PR has more than 2 commits then you are back to square one, expecting the owner to spend too much time to review. So keep it simple, one PR one commit. 

Pick active distributions
-------------------------
The second most important thing to keep in mind is to pick an active distribution, i.e. one with regular releases. In my experience, you have more chance of a PR being reviewed and accepted if the author is active. MetaCPAN's recent uploads [page](https://metacpan.org/recent?size=500) can help you identify distributions with recent changes.

Build rapport
-------------
If you can get in the good books of the distribution owner they'll be more likely to accept your PR. Not every PR you submit will be accordance with the owner's coding style or way of thinking. So be prepared to get pushback, or even rejection. This is an opportunity to converse with the owner, find out what they *do* want. Maintaining a sense of humor throughout the discussion can go a long way to removing friction.


### Final thoughts
Those are my tips for getting your PR accepted. If you'd like to get started in Open Source but aren't sure where to start, my previous two articles ([one]({{< relref "how-to-become-cpan-contributor.md" >}}), [two]({{< relref "how-to-become-cpan-contributor-part-2.md" >}})) cover how to identify simple fixes for modules.

Many people have asked me, where do I get the motivation to submit PRs non-stop for so many years. The real joy for me is when the owner acknowledges my PR and says "Thank you". It means a lot to me. If you need any help getting started, feel free to [email me](mailto:mohammad.anwar@yahoo.com) and if necessary, we can remote pair program to get you going.

