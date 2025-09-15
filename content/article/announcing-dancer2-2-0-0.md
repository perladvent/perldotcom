+++
canonicalUrl=""
categories="web"
date=2025-09-12T18:12:41
description="The Dancer Core Team is excited to announce the release of Dancer2 2.0.0."
draft=false
image="/images/announcing-dancer2-2-0-0/perldancer-logo.png"
thumbnail="/images/announcing-dancer2-2-0-0/perldancer-header-logo.png"
title="Announcing Dancer2 2.0.0"
authors=[
  "jason-a-crome",
]
tags=[]
+++

## Your Favorite Perl Web Framework, Now Even Better

The Dancer Core Team project is proud to announce the release of **Dancer2 2.0.0**!

This release has been a long time coming, and while open source sometimes takes longer
than we’d like, we believe the wait has been worth it. With fresh documentation, architectural
improvements, and developer-friendly new features, version 2.0.0 represents a significant
evolution of Dancer2 and the Perl web ecosystem.

If you'd like a more extensive overview, I gave a talk at the [Perl and Raku Conference 2025](https://perlconference.us/tprc-2025-gsp/),
about Dancer2 2.0.0, covering new features and where we’re headed next. You can watch the full presentation here:
[Dancer2 2.0.ohh myyy on YouTube →](https://www.youtube.com/watch?v=pCTj-lT2Y40&list=PLA9_Hq3zhoFxvyYYyf9P2eYxitFRyEGza&index=4&pp=iAQB)

## Release Highlights
Every major release is an opportunity to take stock of where a project stands and where it’s going. For Dancer2, 2.0.0 represents:

- A renewed commitment to documentation and developer experience
- A modernization of the framework’s core
- A better foundation for web development with Perl

Here are some of the most important changes included in Dancer2 2.0.0:

- **Brand New Documentation**
  Thanks to a grant from the Perl and Raku Foundation, Dancer2’s documentation has been
  completely rewritten. Clearer guides and reference materials will make it easier than
  ever to get started and to master advanced features.
  [Read the docs →](https://perldancer.org/documentation)

- **Extendable Configuration System**
  Thanks to first-time contributor **Mikko Koivunalho**, the new configuration system
  allows for greater flexibility in how Dancer2 applications are configured and extended.
  Developers can build new configuration modules, and even integrate configuration systems
  from other applications or frameworks.

  Building on this work, long-time core team member **Yanick Champoux** enhanced the new
  configuration system even further, enabling additional configuration readers to be
  bootstrapped by the default one.
  [Learn more in the config guide →](https://metacpan.org/dist/Dancer2/view/lib/Dancer2/Config.pod)

- **A Leaner Core Distribution**
  Why have two configuration systems in the core framework when you can have zero?
  - `Dancer2::Template::Simple` has been removed from the core. It is now available
    as a separate distribution on [MetaCPAN](https://metacpan.org/pod/Dancer2::Template::Simple)
    for migration projects from Dancer 1.
  - Our fork of `Template::Tiny` has been retired, with its improvements merged upstream (thanks,
    Karen Etheridge!), and `Dancer2::Template::TemplateTiny` is now just an adapter for the official
    version. [See the documentation →](https://metacpan.org/pod/Dancer2::Template::Tiny)

- **Smarter Data Handling**
  Dancer2 now supports configurable data/secrets censoring using `Data::Censor`, helping developers
  protect sensitive information in logs and debug pages. [Learn more about Data::Censor →](https://perldancer.org/documentation/logging)

- **Better Logging and Debugging**
  Hooks are now logged as they are executed, and a brand-new hook — `on_hook_exception` — provides
  a way to handle unexpected issues more gracefully. [See the hooks documentation →](https://github.com/PerlDancer/Dancer2/blob/main/lib/Dancer2/Manual.pod#Hooks)

- **CLI Improvements**
  The command-line interface also received some attention:
  - Allows new Dancer2 applications to be scaffolded from the [Dancer2 Tutorial](https://github.com/PerlDancer/Dancer2/blob/main/lib/Dancer2/Manual/Tutorial.pod).
  - Behind-the-scenes improvements to allow future scaffolding of plugins and extensions.

## Thank You to Our Contributors
Dancer2 is what it is because of its community. A heartfelt thank you goes out to everyone who made this release possible, including:

- **Mikko Koivunalho**, for his first-time contribution of the extendable configuration system.
- **Yanick Champoux**, for building on Mikko’s work and extending what's possible with the new configuration system.
- **Karen Etheridge**, for integrating improvements back into `Template::Tiny`, helping us to streamline the Dancer2 core.
- The **Perl and Raku Foundation**, for supporting the documentation grant that gave us our brand-new docs.
- **Sawyer X**, for being a great grant manager, and his endless patience, great suggestions, and encouragement throughout the grant process.
- And of course, everyone who tested, reported issues, submitted patches, and offered feedback along the way.

Your contributions and support are what keep the project moving forward. ❤️

## What’s Next?
Dancer2 remains an active, community-driven project, and version 2.0.0 shows our continued dedication
to advancing the framework and supporting our community.

We invite you to try out Dancer2 2.0.0, explore the new documentation, and join the conversation on
[GitHub](https://github.com/PerlDancer/Dancer2) or the project’s mailing list.

## Keep Dancing!
We’re excited about this release and can’t wait to see what the Perl community builds with it.

Jason (CromeDome) and the Dancer2 Core Team
