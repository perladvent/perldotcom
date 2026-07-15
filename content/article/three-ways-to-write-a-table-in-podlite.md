+++
canonicalUrl=""
categories="tooling"
date=2026-07-15T10:00:00
description="A sequel to Podlite comes to Perl: a deep-dive into the three syntaxes for tables (text-mode, structured, and data-driven) with concrete examples and error recovery rules."
draft=false
image="/images/three-ways-to-write-a-table-in-podlite/podlite-social-logo.png"
thumbnail="/images/three-ways-to-write-a-table-in-podlite/podlite-social-logo.png"
title="Three ways to write a table in Podlite"
authors=[
  "aliaksandr-zahatski",
]
tags=["documentation", "pod", "podlite", "syntax"]
+++

In my [previous article](/article/podlite-comes-to-perl-a-lightweight-block-based-markup-language-for-everyday-use/) I introduced Podlite as a block-based markup language. Today I'll zoom into one piece: tables.

I write tables in three rough shapes: a few rows of words I'm jotting down, a visual grid like a tic-tac-toe board, or a data export I want to embed in a document. Podlite has three syntaxes around the same model, one per shape. The first has several flavors, so let's start with that.

## One model, three syntaxes

The first syntax is text-mode. It's flexible. The simplest version is `=table` followed by rows. Pipes for separators:

```podlite
=table
    mouse    | mice
    horse    | horses
    elephant | elephants
```

![Plurals rendered as a two-column table. Pipes mark column boundaries; no header.](/images/three-ways-to-write-a-table-in-podlite/01-plurals.png)

Plus signs work too, and you can leave cells empty:

```podlite
=table
    X | O |
   ---+---+---
      | X | O
   ---+---+---
      |   | X
```

![Tic-tac-toe board rendered as a 3×3 grid. Empty cells preserved; horizontal separators (+---+---+) mark row boundaries.](/images/three-ways-to-write-a-table-in-podlite/02-tic-tac-toe.png)

That renders as a tic-tac-toe board. Three rows of three cells, same table model as anything else.

When you want a header and a caption, use the delimited form. Add `:caption(...)` and put a `=====` row under the head:

```podlite
=begin table :caption('Critters')
    Animal     Legs    Eats
    ======     ====    ====
    Zebra      4       Cookies
    Human      2       Pizza
    Shark      0       Fish
=end table
```

![Critters rendered with bold header and caption. The ===== row marks the previous row as a semantic header.](/images/three-ways-to-write-a-table-in-podlite/03-critters.png)

The parser handles whitespace, pipes, or plus signs as column boundaries. A `=====` line marks the previous row as a header. I reach for this form first when I'm typing into a notebook. It stays readable as I edit, and it survives copy-paste from a terminal.

The second syntax is structured. Use it when you need cell spans, semantic markup, or rich content in cells. Each row and each cell becomes its own block. The `=====` line becomes a `:header` attribute on the row:

```podlite
=begin table :caption('My coffee morning')

=begin row :header
=cell Step
=cell Tool
=cell Time
=end row

=begin row
=cell Grind
=cell Burr grinder
=cell 20s
=end row

=begin row
=cell Brew
=for cell :colspan(2)
Aeropress, 90 seconds with bloom
=end row

=end table
```

![My coffee morning rendered as a structured table. The Brew step spans the Tool and Time columns via :colspan(2).](/images/three-ways-to-write-a-table-in-podlite/04-coffee-morning.png)

A cell can hold any Podlite block: a paragraph, a code block, a picture, an embedded diagram. This call was made early in the spec: tables in Podlite are not a visual feature, they are containers that render as a grid.

The third syntax is data-driven. If the numbers are short enough to live in the document, put them directly inside a `=data-table` block:

```podlite
=begin data-table :caption('Build status') :mime-type<'text/csv; header=present'>
component,status
parser,green
renderer,green
playground,yellow
=end data-table
```

![Build status rendered from inline CSV. The =data-table body holds the data; header=present marks the first row as a header.](/images/three-ways-to-write-a-table-in-podlite/05a-build-status.png)

Some data has its own life: a CSV export, a TSV log, anything that exists before the document does. Keep it in a separate `=data` block and reference it via `:src`. If the data starts with column labels, mark them with the `header=present` parameter from RFC 4180 §3:

```podlite
=for data-table :src<data:walks> :caption('Walks this month')

=begin data :key<walks> :mime-type<'text/tab-separated-values; header=present'>
date	distance	note
2026-04-12	5km	morning fog
2026-04-15	3km	park loop
2026-04-22	8km	coastal trail
=end data
```

![Walks this month rendered with a semantic header. The date/distance/note row is marked via the header=present parameter from RFC 4180 §3.](/images/three-ways-to-write-a-table-in-podlite/05-walks-this-month.png)

The `=data` block holds raw TSV: tab-split, no quoting, which is what most TSV tools emit. Tools that walk the document read the structured data directly, and readers see the rendered table from the same source.

## When tables break

Tables break in real documents. A copy-paste loses a column, two rows pick different separators, a CSV cell holds an unmatched quote. The Podlite spec defines four rules so the parser warns you instead of silently corrupting the document:

* Per-line separator detection. Each row decides its separator from what it sees.
* Cell count validation. Short rows pad with empty cells, long rows truncate. Both produce a warning.
* Mixed-separator warning. Pipes in the header and whitespace in data still work, but you get a warning.
* CSV recovery. Missing data renders an empty table. A non-CSV MIME type falls back to a `=code` block so the content stays visible.

I'd rather see a warning in the console than ship a document with a dropped row.

## Try it

Paste any of these examples into [pod6.in](https://pod6.in). The playground renders Podlite live, no install needed. The full table grammar lives in the [Podlite specification](https://podlite.org/specification).

If you build something with this, or hit a case the spec does not cover, open a discussion at [podlite-specs](https://github.com/podlite/podlite-specs/discussions).

Thanks for reading,

Alex
