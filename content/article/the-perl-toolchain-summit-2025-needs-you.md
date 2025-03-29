# The Perl Toolchain Summit 2025 needs you

This year in particular,
[the organizers](https://blogs.perl.org/users/book/2025/02/announcing-the-perl-toolchain-summit-2025.html)
have had difficulty reaching our fundraising targets for the
[Perl Toolchain Summit](https://perltoolchainsummit.org/pts2025/).

[In the words of Ricardo Signes](https://rjbs.cloud/blog/2024/05/pts-2024-lisbon/):
> The Perl Toolchain Summit is one of the most important events in the
> year for Perl. A lot of key projects have folks get together to get
> things done.

Everyone who is *invited* to the Summit is a project leader or important
contributor that is going to give their time and expertise for four
days, to move the Perl toolchain forward. They give their time
(sometimes having to take days off work, which is already a loss of
income or holidays for them).

This is why, since 2011, we've done our best to *at least partially
refund* their travel and accommodation expenses when needed. Everyone
who's attending the PTS should really *only* have to give four days of
their life for it.

If the PTS can't support its participants, then more and more of them
are going have to either decline our invitation, or spend their own
money, in addition to their time, to continue supporting the Perl
Toolchain.

**This is bad for Perl and CPAN.**

Perl is not like Java or Go: it doesn't have a large corporation behind
it. It's entirely supported by the community and its corporate sponsors.
In others words, by you.

## How much does a PTS cost, by the way?

Let's do a quick back-of-the-enveloppe calculation, assuming:
* hotel: 100€/night (most people are staying 5 nights, arriving the
  day before and leaving the day after),
* travel to Leipzig from Europe: 500€ round-trip,
* travel to Leipzig from outside Europe: 1,500€ round-trip,
* venue cost: 2,000€
* lunch, snacks and coffee breaks: 15€/day/person

We're expecting about 35 people coming (out of 44 invitations sent), 22
from Europe, and 13 from outside Europe.

That brings us to a total estimate of 53,100 €, almost all costs
considered. That's a lot of money.

The organizers never actually spend that amount, because many of our
attendees pay for themselves, or have their expenses covered by their
employer (which we list as in-kind sponsors, alongside our financial
sponsors).

Our budget for 2025 is of 25,000 €: that is our financial sponsoring
target, as well as the amount we expect to pay directly to various
suppliers. The rest is covered by in-kind sponsors or the attendees
themselves.

## What did the PTS produce?

Here are a few examples of some of the many results of past Perl Toolchain Summits:
* during the first edition, in 2008 in Oslo, a number of QA and
  toolchain authors, maintainers and experts came together to agree on
  some common standards and practices. This became known as "[The Oslo
  Consensus](https://github.com/Perl-Toolchain-Gang/toolchain-site/blob/master/oslo-consensus.md)".
* in 2013 in Lancaster, a similar brain trust came together to address
  new issues requiring consensus (e.g. minimum Perl version supported by
  he toolchain) This became known as "[The Lancaster
  concensus](https://github.com/Perl-Toolchain-Gang/toolchain-site/blob/master/lancaster-consensus.md)"
* in 2015 in Berlin, another group assembled to address new issues, with
  a particular focus on toolchain governance and recommended standards
  of care for CPAN authors. This led to the "[river
  analogy](https://github.com/Perl-Toolchain-Gang/toolchain-site/blob/master/berlin-consensus.md#the-river-analogy)",
  now widely used all around CPAN.
* in 2023 in Lyon, the minimum Perl version supported by the toolchain
  was [amended](https://github.com/Perl-Toolchain-Gang/toolchain-site/blob/master/lyon-amendment.md) to a rolling window of ten years
* also in 2023, the [CPAN Security
  Group](https://security.metacpan.org/) was created. It assembled again
  in 2024 in Lisbon, and met with the [Perl Steering
  Council](https://perldoc.perl.org/perlgov#The-Steering-Council). It
  recently published its [retrospective for
  2024](https://security.metacpan.org/cpansec/update/2025/03/12/CPANSec-Retrospective-2024.html)
* the [PAUSE Operating
  Model](https://github.com/andk/pause/blob/master/doc/operating-model.md)
  (a document which defines the permissions model for PAUSE and the
  community rules for how we manage them) came out of a discussion at
  the 2017 event, and built on discussions at earlier events.
* numerous improvements to multiple toolchain modules
  ([Test2](https://metacpan.org/pod/Test2),
  [Devel::Cover](https://metacpan.org/pod/Devel::Cover),
  [PPI](https://metacpan.org/pod/PPI)), CPAN clients
  ([CPAN](https://metacpan.org/pod/CPAN),
  [cpanminus](https://metacpan.org/pod/App::cpanminus),
  [cpm](ihttps://metacpan.org/dist/App-cpm/view/script/cpm)) and
  services ([MetaCPAN](https://metacpan.org/),
  [PAUSE](https://pause.perl.org/), [CPAN
  Testers](http://www.cpantesters.org/)) have been discussed and
  implemented at PTS events

## What will *this* PTS achieve?

In this section, we'll present two important projects some of the
participants intend to work on this year.

### CPAN Testers

The [CPAN Testers](http://www.cpantesters.org/) is a system that collects
all test reports sent by individual testers for all modules published on
CPAN, on a wide collection of systems. This infrastructure has collected
millions of test reports over the years, and provides an invaluable
service to the community.

It makes those reports available to the module authors so that they can
figure out failures on systems they don't have access to, and
[other](https://metacpan.org/) [services](http://matrix.cpantesters.org/)
depend on it to provide test-related data. Perl core development also
depends on it, via a system we call
[Blead Breaks CPAN](https://github.com/Perl/perl5/issues?q=is%3Aissue%20%20label%3ABBC%20)
where development versions of Perl are used to test CPAN distributions,
to ensure backwards compatibility.

Every company that depends on even a single CPAN module benefits from
CPAN Testers.

The service has been running in a "degraded state" (as indicated on its
home page) for several months now. One of the issues is that it has had
a single person maintaining it for several years.

That person, as well as several volunteers willing to help them, will
be attending the summit. The goal is not to just work together for 4
days to bring things back up, but to come up with a long term solution,
and increase the size of the maintainer pool.

These volunteers are in the US, Brazil and France, to name a few.

### Secure PAUSE uploads

[PAUSE](https://pause.perl.org/) is the Perl Authors Upload SErvice. This
is where CPAN authors uploads the tarballs for the distributions that
end up on CPAN. That service took its first upload on August 26, 1995.

Accounts and uploads are only protected by passwords. As some people
move away from Perl and CPAN, they stop using their accounts, making
them targets for attackers. This is a very real supply chain attack
vector. The PAUSE admins are very vigilant, but quickly reacting to
issues is not a sustainable solution.

One of the topic that keeps coming up is protecting the accounts using
SSH keys or Two Factor Authentication. This is not a trivial task, which
involves dealing with very legacy code. Other avenues of improvement
involve the expiration of accounts or permissions.

Over the years, in addition to fixing bugs and adding features, the
maintainers attending the PTS have been able to port the server to a new
web stack, made it possible to build the entire service on Docker for
isolated testing, etc. The topic of 2FA came up in the past, but so far
hasn't been fully tackled yet. This will be on the agenda this year.

The PAUSE maintainers come from Austria, the US, and Japan.

## Our sponsors

Here's our current list of confirmed sponsors for the Perl Toolchain
Summit 2025. (We're currently in discussion with other sponsors, but
nothing has been confirmed yet.)

### Financial Sponsors

These sponsors simply wire some money to [Les Mongueurs de
Perl](https://www.mongueurs.net/), the French non-profit that
handles the organization of the event (they get an invoice in
return), and expect the organizers to spend it on PTS expenses
(see above).

Any money left over is used to kickstart the budget for the event the
following year, as is our tradition since 2011.

#### Diamond Sponsors

* [Booking.com](https://www.booking.com/)

#### Gold Sponsors

* [WebPros](https://www.webpros.com/)

#### Silver sponsors

* [CosmoShop](https://www.cosmoshop.de/)
* [Datensegler](https://datensegler.at/)
* [SUSE](https://www.suse.com/)
* [OpenCage](https://opencagedata.com)

#### Bronze sponsors

* [Simplelists Ltd](https://www.simplelists.com/)
* [Ctrl O Ltd](https://www.ctrlo.com/)
* one individual who wishes to remain anonymous
* [Findus Internet-OPAC](https://www.findus-internet-opac.de/)

### In-Kind Sponsors

We are very grateful for the companies whose employees are invited and
that decide to cover their travel and accommodation expenses, and let
them spend work hours on the event. This means a lot! This is why we're
promoting them as "in-kind" sponsors.

These sponsors pay for some of the PTS expenses directly (usually they
own employees' expenses). Just like our financial sponsors, the PTS
wouldn't be possible without them.

#### Corporate

* [Grant Street Group](https://www.grantstreet.com/)
* [Fastmail](https://www.fastmail.com/)
* [shift2](https://en.shift2.nl/)
* [Zoopla](https://www.zoopla.co.uk/)
* [Oleeo](https://www.oleeo.com/)
* [Ferenc Erki](https://ferki.it/)

#### Community

* [The Perl and Raku Foundation](https://www.perlfoundation.org/)
* [Japan Perl Association](https://japan.perlassociation.org/)

## You too can help the Perl Toolchain Summit and Perl

First, you can read [five reasons to sponsor the Perl Toolchain
Summit](https://www.perl.com/article/5-reasons-to-sponsor-the-perl-toolchain-summit/).

Now that you're conviced, here's how you can help:

* as a company, you can get in touch with us and pick one of our
  sponsoring levels on our [Sponsor
  Prospectus](http://perltoolchainsummit.org/pts2025/PTS2025-Sponsor-Prospectus.pdf)
* as an individual, you can get on our [donation
  page](http://perltoolchainsummit.org/pts2025/donate.html) hit the
  PayPal button, and chip in directly

On behalf of everyone who depends on Perl and CPAN, thank you in advance
for your support!
