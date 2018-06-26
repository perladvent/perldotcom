
  {
    "title"       : "Saying Goodbye to search.cpan.org",
    "authors"     : ["olaf-alders"],
    "date"        : "2018-06-26T09:50:46",
    "tags"        : ["CPAN", "MetaCPAN"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "development"
  }

If you've visited [search.cpan.org](http://search.cpan.org) in the last day or
so, you may have noticed that this CPAN search site is now directing all of its
traffic to [metacpan.org](https://metacpan.org).  Let's talk about what this change
means.

## Why is this change taking place?

The maintainers behind [search.cpan.org](http://search.cpan.org) have decided
that it's time to move on.  After many, many years of keeping this site up and
running they have decided to pass on the torch (and the traffic) to
[metacpan.org](https://metacpan.org).  The MetaCPAN team has been working very
hard to prepare for the influx of new traffic (and new users).  On behalf of
Perl users everywhere, the MetaCPAN team would like to thank all of the crew
behind [search.cpan.org](http://search.cpan.org) for their many years of
working behind the scenes to keep this valuable resource up and running.

## How does this change CPAN?

It doesn't.  CPAN is the central repository of uploaded Perl modules.  Both
[search.cpan.org](http://search.cpan.org) and
[metacpan.org](https://metacpan.org) are search interfaces for CPAN data.
They're layers on top of CPAN.  CPAN doesn't know (or care) about them.

## How does this change PAUSE?

See above.  Nothing changes on the PAUSE side of things.

## What's the difference between search.cpan.org and metacpan.org?

[search.cpan.org](http://search.cpan.org) was the original CPAN module search.
MetaCPAN followed many years later.  Unlike,
[search.cpan.org](http://search.cpan.org), the MetaCPAN site is publicly
available at [GitHub](https://github.com/metacpan).  Contributions to the site
are welcome and encouraged.  It's very easy to get up and running.  If you want
to change the front end of the site, [you can start an app in a couple of
minutes](https://github.com/metacpan/metacpan-web/#installing-manually).  If
you want to make changes to the MetaCPAN API, you can [spin up a Vagrant
box](https://github.com/metacpan/metacpan-developer).

The MetaCPAN interface has more bells and whistles.  This isn't to everyone's
taste, but there is a planned UI overhaul.  If you're interested in helping
with this, please get in touch either at
[GitHub](https://github.com/metacpan/metacpan-web) or at #metacpan on
irc.perl.org

It should be noted that MetaCPAN's search interface may not give you all of the
same results you're used to if you're coming from
[search.cpan.org](http://search.cpan.org).  As noted above, you can get in
touch in the same places if you'd like to discuss changes or improvements to
our search.  There's a small team and keeping this site up and running is a big
job, so the team is grateful for any and all contributions.

## Do I need to create a MetaCPAN account?

Only if a) you're an author and you want to modify your profile or b) you want
to use the "++" buttons to upvote your favourite modules.

## What does this mean moving forward?

It was nice to have two different interfaces to CPAN, because this provided all
of us with a fallback for search results as well as some redundancy.  If either
site had downtime, you could just use the other one.  This is no longer an
option.  However, the interface which we do have is open source, built on an
interesting stack and is a place where you can contribute.  Don't like
something?  Please help to fix it.

MetaCPAN is housed in two different data centres (one at
[Bytemark](https://www.bytemark.co.uk/) in the UK and [Liquid
Web](https://www.liquidweb.com/) one in the US).  The MetaCPAN stack
[Fastly](https://fastly.com) for caching and redundancy.  Some other parts of
includes: Puppet, vagrant, Debian, Plack, Elasticsearch, Catalyst and
Bootstrap.  If you're interested in learning more about any of these
technologies, please get involved with the project.  The team would love to
have you on board.
