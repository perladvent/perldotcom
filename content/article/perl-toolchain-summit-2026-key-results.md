  {
    "title": "The Perl Toolchain Summit 2026: Security, Testing, Porting and Community Collaboration",
    "authors": [ "thibault-duponchelle", "breno-g-de-oliveira"],
    "tags": ["perl-toolchain-summit", "pts"],
    "date": "2026-04-30T12:00:00",
    "draft": false,
    "image": "/images/perl-toolchain-summit-key-results/pts-2026-group-photo.jpg",
    "thumbnail": "/images/perl-toolchain-summit-key-results/pts-2026-group-photo.jpg",
    "description": "Around thirty Perl ecosystem maintainers gathered in Vienna for four days of intensive collaboration, delivering major security tooling improvements, testing infrastructure updates, and core performance enhancements that benefit the entire Perl community.",
    "categories": "community"
  }

From April 23-26, 2026, the invite-only [Perl Toolchain Summit](https://perltoolchainsummit.org/pts2026/) (PTS) brought together about 30 of the ecosystem’s most active maintainers — including four first-timers — in Vienna, Austria for four days of uninterrupted deep-dive collaboration in pair-programming sessions, consensus discussions, and critical infrastructure work. Attendees tackled security tooling and infrastructure, modernization and redesign proposals, several CI and test harness improvements, Perl core optimizations, and metadata/spec updates.

Thanks to all the sponsors' support (financial, in-kind, and community), this year's Summit was a success. It produced multiple module releases, consensus on future smoke-testing and CPAN Testers architecture, and a new CPANSec advisory feed that will allow developers to quickly assess any Perl project's security using either CLI tools or the MetaCPAN website itself. Those advancements benefit all organizations relying on Perl directly or indirectly.

## PTS 2026 Key Results & Deliverables

### Security

CPANSec took it to another level, getting faster at discovering vulnerabilities (in modules, infrastructure and core) and improving its process:

- Vulnerability triage;
- CNA improvements;
- Meta V3 is moving forward;
- Deprecated Module::Signature, considered "security theater".

### Testing and Quality Assurance

Testing and QA work included:

- On the road to [Devel::Cover](https://metacpan.org/pod/Devel::Cover) **2.00**;
- Several improvements made to [Test::Smoke](https://metacpan.org/pod/Test::Smoke), with 3 releases: removal of dual PerlIO/stdio testing, making install more robust (and portable);
- Test::Smoke [backend](https://perl5.test-smoke.org/) full rewrite to ensure sustainability with new features and better performance;
- The [Test2](https://metacpan.org/pod/Test2) family of modules, including the new web user interface, was greatly improved, with many issues fixed and new features implemented;
- Syncing from [backpan.perl.org](https://backpan.perl.org) to fill in CPAN Testers' [backpan](https://backpan.cpantesters.org/);
- New MCP server [mcp.cpantesters.org](https://mcp.cpantesters.org) to browse CPAN Testers reports from your preferred LLM CLI.

### Supply Chain and Other Modules

Many CPAN authors and maintainers worked on:

- Release of [cpm v1](https://skaji.medium.com/cpm-v1-making-installs-stable-b2236b8eda44);
- Fixes and hardening to [YAML::XS](https://metacpan.org/pod/YAML::XS), [YAML::PP](https://metacpan.org/pod/YAML::PP) and [libyaml](https://github.com/yaml/libyaml);
- [PPI](https://metacpan.org/pod/PPI) saw several fixes and no fewer than 7 new releases;
- [Perl::Version::Bumper](https://metacpan.org/pod/Perl::Version::Bumper) updated to take advantage of the first of those 7 PPI releases;
- Continuous effort on [MetaCPAN](https://metacpan.org/) infrastructure: migration to Hetzner, improving secret management and monitoring;
- Proof of Concept of integrating [GitHub Flavored Markdown](https://github.github.com/gfm/) to [MetaCPAN](https://metacpan.org/);
- Huge progress on Automation Policy Metadata.

### PAUSE

Very hacktive PAUSE table:

- Implemented new [API token access](https://github.com/andk/pause/pull/576);
- Security fixes ("rand rand rand rand", "ABRA time" and "META symlinks");
- New dockerized PAUSE;
- Various pentesting (e.g. reviewing YAML parser);
- Ongoing work on OAuth/OIDC;
- Several Pull Requests merged.

### Funding

Recent years brought the topic of funding to the front of the stage. In particular to ensure the sustainability of Perl maintenance funds, accelerate some initiatives (e.g. CPAN Security efforts) and finance community events (like this one!).

A lot of things happened on this front during the Perl Toolchain Summit:

- A strong effort towards funding security work;
- General discussions about funding of the community.

### Group discussions

The Perl Toolchain Summit also provides a lot of opportunity for interaction.
Whether they're corridor discussions, small talk to get to know each other and build trust, discussions around a drink or group discussions (that led in the past to "consensus" or "amendment" papers), it all ends up strengthening the Perl toolchain.

During this PTS in particular, there were a lot of group discussions, probably helped by having a dedicated meeting room.

#### On the topic of Toolchain

- META V3
- CPAN clients

#### On the topic of AI

- AI Policies Materials
- AI Policies Governance
- Share your AI tooling and tips!

#### On the topic of Security

- CRA presentation and Q&A

#### On the topic of Perl core

- Perl Ongoing and future features
- Perl core class/roles implementation
- Configure
- UTF-8 
- Plan for Perl Platforms

### Podcasts

As in 2025, PTS 2026 was an opportunity to record new episodes for [The Underbar](https://underbar.cpan.io/).
There were over five hours of conversations recorded, about:

- Configure
- Vienna.pm
- PPI
- the Perl Steering Council
- Karl Williamson

## Why Sponsor Support Matters

Bringing 30–35 experts under one roof enabled unprecedented collaboration with real-time problem solving, saving months of remote coordination and alignment. That kind of accelerated development and knowledge transfer not only brings the community together but fuels the contributors of critical open source projects for the rest of the year so they can renew their shared goals and work in the same direction. Having four first-time attendees gaining direct mentorship is also fundamental to seed future contributions and expand the volunteer base, ensuring the longevity of the Perl ecosystem and toolchain.

The continued support of our sponsors ensures that the Perl Toolchain Summit remains a catalyst for Perl sustainability — translating sponsor investment into tangible improvements in performance, security, and ecosystem features and coherence. We look forward to partnering again to power the next wave of innovation in Perl's toolchain.

### Sponsors

- [The Perl and Raku Foundation](https://www.perlfoundation.org/),
- [Grant Street Group](https://www.grantstreet.com/),
- [Geizhals Preisvergleich](https://geizhals.de/),
- [Vienna.pm](https://vienna.pm.org/),
- [SUSE](https://www.suse.com/),
- Trans-Formed Media LLC,
- [Ctrl O](https://www.ctrlo.com/),
- [Simplelists](https://www.simplelists.com/),
- [HKS3 / Koha Support](https://koha-support.eu/),
- Harald Jörg,
- Michele Beltrame ([Sigmafin](https://www.blendgroup.it/)),
- Laurent Boivin.

