  {
    "title": "The Perl Toolchain Summit 2025: Security, Testing, and Community Collaboration",
    "authors": ["breno-g-de-oliveira"],
    "tags": [],
    "date": "2025-05-30T12:00:00",
    "draft": false,
    "image": "/images/perl-toolchain-summit-2025-key-results/pts-2025-group-photo.jpg",
    "thumbnail": "/images/perl-toolchain-summit-2025-key-results/pts-2025-group-photo.jpg",
    "description": "33 Perl ecosystem maintainers gathered in Leipzig for four days of intensive collaboration, delivering major security tooling improvements, testing infrastructure updates, and core performance enhancements that benefit the entire Perl community.",
    "categories": "community"
  }

# The Perl Toolchain Summit 2025

![](pts-2025-group-photo.jpg)

From May 1–4, 2025, the invite-only [Perl Toolchain Summit](https://perltoolchainsummit.org/pts2025/) (PTS) brought together in Leipzig, Germany, 33 of the ecosystem’s most active maintainers — and welcomed 6 first-timers — for four days of uninterrupted deep-dive collaboration in pair-programming sessions, consensus discussions, and critical infrastructure work. Attendees tackled security tooling and infrastructure, modernization and redesign proposals, several CI and test harness improvements, Perl core optimizations, and metadata/spec updates.

Thanks to all the sponsors support —financial, in-kind, and community— this year's Summit was a huge success and produced multiple module releases, consensus on future smoke-testing and CPAN Testers architecture, and a new CPANSec advisory feed that will allow developers to quickly assess any Perl project's security using either CLI tools or the MetaCPAN website itself. Those advancements benefit all organizations relying on Perl directly or indirectly.

## PTS 2025 Key Results & Deliverables

### Security Tooling

 - [Test::CVE](https://metacpan.org/pod/Test::CVE): Released new versions with unified CVE reporting, `has_no_cves` checks across core modules, and integrated CVE data into CPAN testers pipelines, making it extremely straightforward to check the security status of a distribution or application;
 - The CPANSec advisories feed was updated with extra data regarding security issues and advisories, and is now aligned with MetaCPAN requirements;
 - SBOM information and tools for Perl authors and developers using packages from CPAN, ensuring the commercial reliability and sustainability of Perl modules on CPAN by conforming to the european Cyber Resilience Act (CRA);
 - MFA and auth keys on PAUSE were successfully prototyped, with a stable implementation on the way;

### Testing and Quality Assurance

 - Initiated deprecation plan for dual PerlIO/stdio testing, spun up a Linux-focused [Test::Smoke](ihttps://metacpan.org/pod/Test::Smoke) farm proof of concept, and defined patching workflow for test runs;
 - Converted smoke testers results from MariaDB to PostgreSQL, paving the way for unified reporting with CPAN Testers;
 - Several discussions and work ensuring [cpantesters.org](https://cpantesters.org)'s stability, availability and improved reporting for the entire ecosystem;
 - Creation of a CPAN Reporter client able to work from a manual installation without an attached cpan client;
 - Complete refactor of the common [CPAN Reporter](https://metacpan.org/pod/CPAN::Reporter) library, used in cpan and cpanm reporter clients;
 - The [Test2](https://metacpan.org/pod/Test2) family of modules, including the new web user interface, was greatly improved, with many issues fixed and new features implemented;
 - [Devel::Cover](https://metacpan.org/pod/Devel::Cover) released new versions that now support the upcoming Perl v5.42 and provide many bug fixes and features;
 - [cpancover.com](https://cpancover.com/) now uses btrfs with compression to allow more coverage reports on the server;

### Supply Chain and Other Modules

 - [MetaCPAN](https://metacpan.org/) updated with several long standing issues and improvements in place, making the service more resilient and useful to the wider Perl community;
 - [YAML::XS](https://metacpan.org/pod/YAML::XS) is now YAML 1.2 compatible and has a new object-oriented interface available;
 - A new trial release of [Clone](https://metacpan.org/pod/Clone) was uploaded with many bug fixes and copy-on-write improvements;
 - Initial draft of a next-generation cpan client with pluggable dependency resolution, parallel operations, and policy-based decisions;

### Core Updates and Performance Enhancements

 - Included `^^=` operator support;
 - Faster signature optimizations targeting up to 13% speedups;
 - Fixed exception handling in `defer`/`finally` blocks;

## Why Sponsor Support Matters

Bringing 30–35 experts under one roof enabled unprecedented collaboration with real-time problem solving, saving months of remote coordination and alignment. That kind of accelerated development and knowledge transfer not only brings the community together but fuels the contributors of critical open source products for the rest of the year so they can renew their shared goals and work in the same direction. Having 6 first-time attendees gaining direct mentorship is also fundamental to seed future contributions and expand the volunteer base, ensuring the longevity of the Perl ecosystem and toolchain.

The continued support of our sponsors ensures that the Perl Toolchain Summit remains a catalyst for Perl sustainability — translating sponsor investment into tangible improvements in performance, security, and ecosystem features and coherence. We look forward to partnering again to power the next wave of innovation in Perl's toolchain.

### Monetary Sponsors

[Booking.com](https://www.booking.com/), [WebPros](https://www.webpros.com/),
[CosmoShop](https://www.cosmoshop.de/), [Datensegler](https://datensegler.at/),
[OpenCage](https://opencagedata.com), [SUSE](https://www.suse.com/),
[Simplelists Ltd](https://www.simplelists.com/), [Ctrl O Ltd](https://www.ctrlo.com/),
[Findus Internet-OPAC](https://www.findus-internet-opac.de/), [plusW GmbH](https://www.plusw.de/).

### In-kind sponsors

[Grant Street Group](https://www.grantstreet.com/), [Fastmail](https://www.fastmail.com/),
[shift2](https://en.shift2.nl/), [Oleeo](https://www.oleeo.com/), [Ferenc Erki](https://ferki.it/).

### Community Sponsors

[The Perl and Raku Foundation](https://www.perlfoundation.org/), [Japan Perl Association](https://japan.perlassociation.org/),
Harald Jörg, Alexandros Karelas ([PerlModules.net](https://www.perlmodules.net/)), Matthew Persico,
Michele Beltrame ([Sigmafin](https://www.blendgroup.it/)), Rob Hall, Joel Roth, Richard Leach,
Jonathan Kean, Richard Loveland, Bojan Ramsa.
