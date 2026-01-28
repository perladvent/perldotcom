+++
canonicalUrl=""
categories="tooling"
date=2026-01-27T18:13:16
description="This article introduces Podlite to the Perl community, explores the 1.0 specification, shows real examples, and demonstrates early integrations with Perl."
draft=false
image="/images/podlite-comes-to-perl-a-lightweight-block-based-markup-language-for-everyday-use/podlite-social-logo.png"
thumbnail="/images/podlite-comes-to-perl-a-lightweight-block-based-markup-language-for-everyday-use/podlite-social-logo-circle.png"
title="Podlite comes to Perl: a lightweight block-based markup language for everyday use"
authors=[
  "aliaksandr-zahatski",
]
tags=["documentation", "markdown", "pod"]
+++

My name is Alex. Over the last years I’ve implemented several versions of the Raku's documentation format (Synopsys 26 / Raku's Pod) in Perl and JavaScript.

At an early stage, I shared the idea of creating a lightweight version of Raku's Pod, with Damian Conway, the original author of the Synopsys 26 Documentation specification (S26).
He was supportive of the concept and offered several valuable insights that helped shape the vision of what later became Podlite.

Today, Podlite is a small block-based markup language that is easy to read as plain text, simple to parse, and flexible enough to be used everywhere — in code, notes, technical documents, long-form writing, and even full documentation systems.

This article is an introduction for the Perl community — what Podlite is, how it looks, how you can already use it in Perl via a source filter, and what’s coming next.

The Block Structure of Podlite
--------------------------------

One of the core ideas behind Podlite is its consistent block-based structure.
Every meaningful element of a document — a heading, a paragraph, a list item, a table, a code block, a callout — is represented as a block. This makes documents both readable for humans and predictable for tools.

Podlite supports three interchangeable block styles: `delimited`, `paragraph`, and `abbreviated`.

### Abbreviated blocks (`=BLOCK`)

This is the most compact form.
A block starts with `=` followed by the block name.

```perl
=head1 Installation Guide
=item Perl 5.8 or newer
=para This tool automates the process.
```

* ends on the next directive or a blank line
* best used for simple one-line blocks
* cannot include configuration options (attributes)

### Paragraph blocks (`=for BLOCK`)

Use this form when you want a multi-line block or need attributes.

```perl
=for code :lang<perl>
say "Hello from Podlite!";
```

* ends when a blank line appears
* can include complex content
* allows attributes such as `:lang`, `:id`, `:caption`, `:nested`, …

### Delimited blocks (`=begin BLOCK` … `=end BLOCK`)

The most expressive form. Useful for large sections, nested blocks, or structures that require clarity.

```perl
=begin nested :notify<important>
Make sure you have administrator privileges.
=end nested
```

* explicit start and end markers
* perfect for code, lists, tables, notifications, markdown, formulas
* can contain other blocks, including nested ones

These block styles differ in syntax convenience, but all produce the same internal structure.

![diagram here showing the three block styles and how they map to the same internal structure](/images/podlite-comes-to-perl-a-lightweight-block-based-markup-language-for-everyday-use/podlite-blocktypes.png)

Regardless of which syntax you choose:

* all three forms represent the same **block type**
* attributes apply the same way (`:lang`, `:caption`, `:id`, …)
* tools and renderers treat them uniformly
* nested blocks work identically
* you can freely mix styles inside a document

Example: Comparing POD and Podlite
-----------------------------------

Let's see how the same document looks in traditional POD versus Podlite:

![POD vs Podlite](/images/podlite-comes-to-perl-a-lightweight-block-based-markup-language-for-everyday-use/pod-podlite.png)

Each block has clear boundaries, so you don't need blank lines between them. This makes your documentation more compact and easier to read.
This is one of the reasons Podlite remains compact yet powerful:
the syntax stays flexible, while the underlying document model stays clean and consistent.

This Podlite example rendered as on the following screen:

![Podlite example](/images/podlite-comes-to-perl-a-lightweight-block-based-markup-language-for-everyday-use/podlite-renderexample.png)

Inside the Podlite Specification 1.0
-------------------------------------

One important point about Podlite is that it is first and foremost a specification.
It does not belong to any particular programming language, platform, or tooling ecosystem.
The specification defines the document model, syntax rules, and semantics.

From the Podlite 1.0 specification, notable features include:

* headings (`=head1`, `=head2`, …)
* lists and definition lists, and including task lists
* tables (simple and advanced)
* CSV-backed tables
* callouts / notifications (`=nested :notify<tip|warning|important|note|caution>`)
* table of contents (`=toc`)
* includes (`=include`)
* embedded data (`=data`)
* pictures (`=picture` and inline `P<>`)
* formulas (`=formula` and inline `F<>`)
* user defined blocks and markup codes
* Markdown integration

The `=markdown` block is part of the standard block set defined by the Podlite Specification 1.0.
This means Markdown is not an add-on or optional plugin — it is a fully integrated, first-class component of the language.

Markdown content becomes part of Podlite’s unified document structure, and its headings merge naturally with Podlite headings inside the TOC and document outline.

Below is a screenshot showing how Markdown inside Perl is rendered in the in-development VS Code extension, demonstrating both the block structure and live preview:

![Podlite source, including =markdown block](/images/podlite-comes-to-perl-a-lightweight-block-based-markup-language-for-everyday-use/podlite_for_perl.png)

Using Podlite in Perl via the source filter
--------------------------------------------

To make Podlite directly usable in Perl code, there is a module on CPAN:
[Podlite]({{< mcpan "Podlite" >}})  — Use Podlite markup language in Perl programs

A minimal example could look like this:

```perl
use Podlite; # enable Podlite blocks inside Perl

=head1 Quick Example
=begin markdown
Podlite can live inside your Perl programs.
=end markdown
print "Podlite active\n";
```

Roadmap: what's next for Podlite
---------------------------------

Podlite continues to grow, and the Specification 1.0 is only the beginning.
Several areas are already in active development, and more will evolve with community feedback.

Some of the things currently planned or in progress:

* CLI tools
  * command-line utilities for converting Podlite to HTML, PDF, man pages, etc.
  * improve pipelines for building documentation sites from Podlite sources
* VS Code integration
* Ecosystem growth
  * develop comprehensive documentation and tutorials
  * community-driven block types and conventions

Try Podlite and share feedback
-------------------------------

If this resonates with you, I’d be very happy to hear from you:

* ideas for useful block types
* suggestions for tools or integrations
* feedback on the syntax and specification

[https://github.com/podlite/podlite-specs/discussions](https://github.com/podlite/podlite-specs/discussions)

Even small contributions — a comment, a GitHub star, or trying an early tool — help shape the future of the specification and encourage further development.

Useful links:

* CPAN: [https://metacpan.org/pod/Podlite](https://metacpan.org/pod/Podlite)
* GitHub:[https://github.com/podlite](https://github.com/podlite)
* Specification
  * (HTML): [https://podlite.org/specification](https://podlite.org/specification)
  * source: [https://github.com/podlite/podlite-specs](https://github.com/podlite/podlite-specs)
* Project site: [https://podlite.org](https://podlite.org)
* Roadmap: [https://podlite.org/#Roadmap](https://podlite.org/#Roadmap)

Thanks for reading,
**Alex**
