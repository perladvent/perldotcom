
  {
    "title"  : "A slow boat to ... Data",
    "authors": ["Nadim Khemir"],
    "date"   : "2017-09-06T12:28:27",
    "tags"   : [],
    "draft"  : true,
    "image"  : "",
    "description" : "Dumping Perl 6 data structures",
    "categories": "perl6"
  }

## A slow boat to ... Data

[Data::Dump::Tree](https://github.com/nkh/P6-Data-Dump-Tree) aims to render your data structures in a more legible way. It's usefulness grows with the amount of data to display.

It's the not the best for dumping three variables that you will never see again (although I am not sure about that) but it's good at rendering complex data, rendering what you generate often, and rendering what will be read by other people.

## Install

You can install it with [zef](https://github.com/ugexe/zef), which comes with [Rakudo Star](http://rakudo.org) or [clone the repository](https://github.com/nkh/P6-Data-Dump-Tree):

    zef install Data::Dump::Tree

There two branches: `release` which is the branch _zef_ installs and `master` which is the main development branch. I chose to develop on the latest Rakudo because bugs are fixed there. I may change the release branch to work only with Rakudo releases in the near future. There are tests to check the fitness of the module.

It's not often that an article starts with a call for help but I have noticed that they tend to be forgotten when put at the end. There are a few things that can get better; please help if you can! The help list is at the end of the article.

## The Legibility Principles

My main problem with most data rendering modules is that they seldom generate output that is intended for human beings, and even less often for human beings who wear glasses. They often remind me of cryptic hieroglyphs on the back of a shampoo bottle are not of much help.

My idea is to make data rendering so simple and attractive that it removes the need for extracting manually the relevant information from the data and instead apply filters and present a more raw display that is simple enough for the end user and still looks technical to the developer or users with a technical penchant.

`Data::Dump::Tree` displays the data vertically which reduces the text/surface ratio. We need horizontal space to display the tree part of the rendering.

I try to apply a few principles:

### limit the text to area ratio

A screen packed with text is completely useless; maximal concentration of text has low legibility. If avoiding the need to scroll, which we should to a certain extent, means overloading ones brain to understand the spaghetti that's on the screen, then no thank you; I'll scroll. But this is of course a matter of taste, and that's why we have more than one data renderer our disposition.

### Contrast

Contrasting the rendering with color, symbols, font size, and spacing.

### Simplification

Showing less data, fewer details, transformed data, or tabulated data can make data rendering more legible.

### Relationships

`Data::Dump::Tree` is the continuation of my Perl 5 [Data::TreeDumper](http://www.metacpan.org/module/Data::TreeDumper) which I used to display hundreds of thousands of lines. Being able to see the relationships is important. I achieve that by the tree part of the rendering, numbering containers and references, and possibly coloring the tree.

## Interactivity

In a terminal with Curses and in a browser, you can collapse or expand data which reduces the amount of data displayed and thus act like a simplification of the rendering.

## `dd` vs `ddt`

There is no doubt whatsoever that `dd` builtin to Rakudo is many times faster than my `ddt` but here are some examples that, in my opinion, are much more readable and legible rendered by `ddt`.

I use `dd` to compare to the output of `ddt` but also to dump small amounts of data. I even use it instead for `.say` when debugging. Let's compare `dd` and `ddt` with a few examples.

### [1..100] examples

`dd`'s output is an example of compactness—clear and to the point.

![dd-range](/images/data-dump-tree/dd-range.png)

`ddt` lists data vertically so we get a long rendering that looks like this ... plus 76 extra lines!

![ddt-range](/images/data-dump-tree/ddt-range.png)

This is a clear advantage of `dd`'s horizontal layout but let's see what `ddt` can do and when it may be more legible than `dd`.

`ddt` has a `:flat` mode that changes the rendering orientation. It has the distinct disadvantage to take a long time for large data structures but those  large data structure are unreadable in a compact rendering and we only exchange rendering time for comprehension time.

Let's render the array of 100 elements in columns with 5 elements each:

![ddt columns](/images/data-dump-tree/ddt-columns.png)

That's a bit better and shorter but all those indexes add a bit of noise. Or does it add noise? The data I am rendering is so simplistic that I don't need any indexing. What if the data weren't sorted? What if I wanted to look at the value at the 50th index?

Here is an example with randomized data. Still finding `dd`'s output better? I also used columns of 10 rows rather than 5:

![randomized](/images/data-dump-tree/randomized.png)

Still not convinced? What about 300 hundred entries? Can you navigate in that? This is the simplest of all data

![300-entries](/images/data-dump-tree/300-entries.png)

Let's make it a bit more complicated. I want to see the values that are between 50 inclusive and 60 exclusive. I am going to present that data again and again and spending a few minutes changing how Arrays are displayed is worth it.

![50-60](/images/data-dump-tree/50-60.png)

I could have displayed a table or a text mode graph. That's even better when my data has a non-builtin type; I write a handler and give it to `ddt` and  all instances will be rendered as I wish. I can write a filter and take over how other types are displayed, including the built-ins. It's all about giving me control of how the data are rendered and giving me a few defaults that are hopefully sufficient in most cases.

Here is the code for the above examples:

```perl6
use Data::Dump::Tree ;
use Data::Dump::Tree::DescribeBaseObjects ; # for DVO
use Terminal::ANSIColor ;

dd [1..100] ;
ddt [1..100] ;

ddt [1..100], :flat({1, 5, 10}) ;

dd True, [(1..100).pick: 100] ;
ddt True, [(1..100).pick: 100], :flat({1, 10, 10}) ;

dd True, [(1..300).pick: 300] ;
ddt True, [(1..300).pick: 300], :flat({1, 10, 12}) ;

role skinny
{
multi method get_elements (Array $a)
	{
	$a.list.map:
		{
		'',
		'',
		50 <= $_ < 60
			?? DVO(color('bold red') ~ $_.fmt("%4d") ~ color('reset'))
			!! DVO($_.fmt("%4d"))
		}
	}

}

ddt True, [(1..100).pick: 100], :flat({1, 10}), :does[skinny] ;
```

The [examples](https://github.com/nkh/P6-Data-Dump-Tree/tree/release/examples) directory in the distribution contains several other examples.

## Builtin versus User types

`ddt` handles builtin types; it decides how to display them, including what parts to show and what parts to hide. I can take over a type or a specific instance of a type. It's all in the documentation.

Although `ddt` handles quite a few builtin types, there are still some types I have not taken the time to look at. Those types may render wrongly or not at all. If you catch one of those [open an issue in GitHub](https://github.com/nkh/P6-Data-Dump-Tree/issues). And if you decide to add a handler for the type, please let me have it. You can look at [lib/Data/Dump/Tree/DescribeBaseObjects.pm](https://github.com/nkh/P6-Data-Dump-Tree/blob/release/lib/Data/Dump/Tree/DescribeBaseObjects.pm) to see what's already handled.

User defined types are handled in a generic way. If they define `ddt_*` methods those will be called; otherwise the type attributes will be shown. This is also discussed at length in the documentation so I will not repeat it.

### Match

In a [review of Dumpers](https://www.learningperl6.com/2017/01/26/three-ways-to-pretty-print-perl-6/), brian wrote "ddt output is not very useful for Matches" and he was right. Not only is the default output not helpful but it even tries to hide all the details of the match. There are two reasons why. The first is that there are details in a [Match](https://docs.perl6.org/type/Match) object that are probably of no use whatsoever in a data rendering. Second, I'm either displaying a match-centric data or the data happens to contain a match. In the later case, keeping the Match rendering simple keeps the data simple.

What if I want to see Match details in a data rendering? `ddt` has a role I can use that will make it more efficient to work with Matches. There are multiple examples of the Match role usage with and without extra filtering and coloring in [examples/match.pl](https://github.com/nkh/P6-Data-Dump-Tree/blob/release/examples/match.pl) in the module repository:

![match](/images/data-dump-tree/match.png)

### Native

Look at [examples/gumbo.pl](https://github.com/nkh/P6-Data-Dump-Tree/examples/gumbo.pl). `ddt` can handle Perl 6's [NativeCall](https://docs.perl6.org/language/nativecall) support. `dd` simply displays the type:

```output
GumboNode
```

The `ddt` output breaks it down and annotates the C portions of the data structure:

![Imgur](/images/data-dump-tree/gumbonode.png)

## Filtering

You have seen an example of handler in the `[1..100]` examples. Here is an example of filter applied to the parsing of a JSON data structure:

```perl6
sub header_filter
	($dumper, \r, $s, ($depth, $path, $glyph, @renderings),
	 (\k, \b, \v, \f, \final, \want_address))
{
# simplifying the rendering

# <pair> with a value that has no sub elements can be
# displayed in a more compact way
if k eq "<pair>"
	{
	my %caps = $s.caps ;

	if %caps<value>.caps[0][0].key eq 'string'
		{
		v = ls(~%caps<string>, 40)  ~ ' => ' ~ ls(~%caps<value>, 40) ;
		final = DDT_FINAL ;
		}
	}

# Below need no details
if k eq "<object>" | "<pairlist>" | "<array>" | '<arraylist>'
	{
	v = '' ;
	f = '' ;
	}

}
```

By applying the above filter, the amount of data displayed is reduced by a factor of almost three. The output without the filter:

![unfiltered](/images/data-dump-tree/unfiltered.png)

The output with the filter:

![filtered](/images/data-dump-tree/filtered.png)

## Folding And Remoting

![folding](/images/data-dump-tree/folding-animation.gif)

I can display a rendered data structure in a curses interface by using the `:curses` adjective:

```perl6
ddt $data_structure, :curses;
```

I can also send the rendering of a data structure to another process. This makes it easier to debug without cluttering the display for example.

```perl6
ddt $data_structure, :remote;
```

## Less commonly used options

  * :nl

Adds a blank line at the end of the rendering.

  * :indent

Indents the whole rendering

  * :!display_info, :!display_address, :!display_type

Remove the type/address from the rendering, for simple data this cam make the rendering much more legible.

## Getting Help

I can be found on the *#perl6* IRC channel and will receive mail if an issue is opened on GitHub. I'm happy to help with general explanations and writing handlers/filters for new types or your types, specially if I can add it to the example section.

## Lending a hand

There are several areas that could use some help. Perhaps one of you reading this can work on one of these.

### DHTML

There is a DHTML renderer which could use some love. There is not visual cue for folded containers. The search functionality needs polishing too. I am no web person so the code is best effort so far.

### More data types tests

`ddt` support for builtin types can be expanded. That is best done by testing in your scripts and reporting when a type is not supported.

### Profiling/speed up/threading

`ddt` is sluggish; it does a lot of things but it could do them faster. I tried profiling it but did not get very far. If you are proficient in Perl 6 and would like to have a look at the code, I will be happy to assist.

### Data display application terminal and browser.

You could write an application that would accept data structures via a socket and present them to the user. It should display multiple renderings and let the user chose which rendering to display. A bit like a log viewer but for data renderings.

### Become a co-maintainer

Help maintain the module!

## Other articles

- [Perl 6 Data::Dump::Tree version 1.5](http://blogs.perl.org/users/nadim_khemir/2017/08/perl-6-datadumptree-version-15.html)

- [Take a walk on the C side, ddt, du du, du du ...](http://blogs.perl.org/users/nadim_khemir/2017/08/take-a-walk-on-the-c-side.html)

- [https://perl6advent.wordpress.com/2016/12/21/show-me-the-data/](https://perl6advent.wordpress.com/2016/12/21/show-me-the-data/)
