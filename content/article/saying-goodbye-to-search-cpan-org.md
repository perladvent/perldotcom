
  {
    "title"       : "Saying Goodbye to search.cpan.org",
    "authors"     : ["olaf-alders"],
    "date"        : "2018-06-26T17:00:46",
    "tags"        : ["metacpan", "plack", "minion", "catalyst"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "cpan"
  }

If you've visited [search.cpan.org](http://search.cpan.org) in the last day or
so, you may have noticed that the site is now directing all of its
traffic to [metacpan.org](https://metacpan.org). Let's talk about what this change
means.

### Why is this change taking place?

The maintainers behind [search.cpan.org](http://search.cpan.org) have decided
that it's time to move on. After many, many years of keeping this site up and
running they have decided to pass on the torch (and the traffic) to
[metacpan.org](https://metacpan.org). Myself and the rest of the MetaCPAN team
have been working very hard to prepare for the influx of new traffic (and new
users). On behalf of Perl users everywhere, the we'd like to thank
[Graham Barr and all of the crew](https://log.perl.org/2018/05/goodbye-search-dot-cpan-dot-org.html)
behind [search.cpan.org](http://search.cpan.org) for their many years of
working behind the scenes to keep this valuable resource up and running.

### How does this change CPAN?

It doesn't. CPAN is the central repository of uploaded Perl modules. Both
[search.cpan.org](http://search.cpan.org) and
[metacpan.org](https://metacpan.org) are search interfaces for CPAN data.
They're layers on top of CPAN. CPAN doesn't know (or care) about them.

### How does this change PAUSE?

See above. Nothing changes on the PAUSE side of things.

### What's the difference between search.cpan.org and metacpan.org?

[search.cpan.org](http://search.cpan.org) was the original CPAN module search.
MetaCPAN followed many years later. Unlike
[search.cpan.org](http://search.cpan.org), the MetaCPAN site is publicly
available at [GitHub](https://github.com/metacpan). Contributions to the site
are welcome and encouraged. It's very easy to get up and running. If you want
to change the front end of the site, [you can start an app in a couple of
minutes](https://github.com/metacpan/metacpan-web/#installing-manually). If
you want to make changes to the MetaCPAN API, you can [spin up a Vagrant
box](https://github.com/metacpan/metacpan-developer).

The MetaCPAN interface has more bells and whistles. This isn't to everyone's
taste, but there is a planned UI overhaul.

MetaCPAN's search interface does not always return the same results as
[search.cpan.org](http://search.cpan.org) used to.

If you're interested in helping improve the UI or search results, please get in
touch either at [GitHub](https://github.com/metacpan/metacpan-web) or at
`#metacpan` on irc.perl.org.

We're a small team and keeping this site up and running is a big
job, so the team is grateful for all contributions.

### Do I need to create a MetaCPAN account?

Only if a) you're an author and you want to modify your profile or b) you want
to use the "++" buttons to upvote your favorite modules.

### What does this mean moving forward?

It was nice to have two different interfaces to CPAN, because this provided all
of us with a fallback for search results as well as some redundancy. If either
site had downtime, you could just use the other one. This is no longer an
option. However, the interface which we do have is open source, built on an
interesting stack and is a place where you can contribute. Don't like
something?  Please help to fix it.

MetaCPAN is housed in two different data centers
([Bytemark](https://www.bytemark.co.uk/) in the UK and [Liquid
Web](https://www.liquidweb.com/) in the US). The MetaCPAN stack uses
[Fastly](https://fastly.com) for caching and redundancy. Other parts
include: Puppet, vagrant, Debian, [Plack](https://metacpan.org/pod/Plack),
Elasticsearch, [Minion](https://metacpan.org/pod/Minion),
[Catalyst](https://metacpan.org/pod/Catalyst) and
Bootstrap. If you're interested in learning more about any of these
technologies, please get involved with the project. We'd love to
have you on board.
