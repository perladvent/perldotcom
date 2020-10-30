
  {
    "title"       : "Extracting the list of O'Reilly Animals",
    "authors"     : ["brian-d-foy"],
    "date"        : "2020-10-29T18:02:50",
    "tags"        : [mojolicious promises oreilly],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "community"
  }

O'Reilly Media, who publishes most of my books, is distinctively known
by the animals it chooses for their covers. Edie Freedman explains how she came up with the well-known design in [A short history of the O’Reilly animals](https://www.oreilly.com/content/a-short-history-of-the-oreilly-animals/). I think I first saw this design on the cover of [sed & awk](https://shop.oreilly.com/product/9781565922259.do); those Slender Lorises (Lori?) are a bit creepy.

![sed & awk](/images/extracting-the-list-of-o-reilly-animals/sed.jpeg)

O'Reilly has [a list of almost all of the animals](https://www.oreilly.com/animals.csp) from their covers, even if "animals" is a bit of a loose term that encompasses "Catholic Priests" (*[Ethics of Big Data](https://shop.oreilly.com/product/0636920021872.do)*) or "Soldiers or rangers, with rifles" (*[SELinux](https://shop.oreilly.com/product/9780596007164.do)*). You can page through that list 20 results at a time, or search it. But, as with most lists I see online, I want them all at once, and locally.

Scrapping a bunch of pages is no problem for Perl, especially with [Mojolicious](https://www.mojolicious.org) (as I write about in *[Mojo Web Clients](https://leanpub.com/mojo_web_clients)*). I whipped up a quick script and soon had it [all of the animals in a JSON file](https://gist.github.com/briandfoy/d68915eb425e1fc4932ceac5cdf2d60d).

There's nothing particularly fancy in my programming, although I do use [Mojo::Promise](https://docs.mojolicious.org/Mojo/Promise) so I can make the requests in parallel. That wasn't something that I cared that much about, but I had just answered [a StackOverflow question about Promises](https://stackoverflow.com/q/64597755/2766176). This is only slightly different than "regular" Mojo; I set up all of the web requests but don't run them right away. Once I have all of them, I run them at once through the `all()` Promise:

```perl
#!perl
use v5.20;
use experimental qw(signatures);

use Mojo::JSON qw(encode_json);
use Mojo::Promise;
use Mojo::UserAgent;
use Mojo::Util qw(dumper);

my @grand;
END {
	# Since the results come out of order,
	# sort by animal name then title
	@grand = sort {
		$a->{animal} cmp $b->{animal}
			or
		$a->{title} cmp $b->{title}
		} @grand;

	my $json = encode_json( \@grand );
	say $json;
	}

my $url = 'https://www.oreilly.com/animals.csp';
my( $start, $interval, $total );

my $ua = Mojo::UserAgent->new;

# We need to get the first request to get the total number of
# requests. Note that that number is actually larger than the
# number of results there will be, by about 80.
my $first_page_tx = $ua->get_p( $url )->then(
	sub ( $tx ) {
		push @grand, parse_page( $tx )->@*;
		( $start, $interval, $total ) = get_pagination( $tx );
		},
	sub ( $tx ) { die "Initial fetch failed!" }
	)->wait;

my @requests =
	map {
		my $page = $_;
		$ua->get_p( $url => form => { 'x-o' => $page } )->then(
			sub ( $tx ) { push @grand, parse_page( $tx )->@* },
			sub ( $tx ) { warn "Something is wrong" }
			);
		}
	map {
		$_ * $interval
		}
	1 .. ($total / $interval)
	;

Mojo::Promise->all( @requests )->wait;

sub get_pagination ( $tx ) {
	# 1141 to 1160 of 1244
	my $pagination = $tx
		->result
		->dom
		->at( 'span.cs-prevnext' )
		->text;

	my( $start, $interval, $total ) = $pagination =~ /
		(\d+) \h+ to \h+ (\d+) \h+ of \h+ (\d+) /x;
	}

sub parse_page ( $tx ) {
=pod

<div class="animal-row">
    <a class="book" href="..." title="">
      <img class="book-cvr" src="..." />
      <p class="book-title">Perl 6 and Parrot Essentials</p>
    </a>
    <p class="animal-name">Aoudad, aka Barbary sheep</p>
  </div>

=cut

	my $results = eval {
		$tx
			->result
			->dom
			->find( 'div.animal-row' )
			->map( sub {
				my %h;
				$h{link}      = $_->at( 'a.book' )->attr( 'href' );
				$h{cover_src} = $_->at( 'img.book-cvr' )->attr( 'src' );
				$h{title}     = $_->at( 'p.book-title' )->text;
				$h{animal}    = $_->at( 'p.animal-name' )->text;
				\%h;
				} )
			->to_array
		} or do {
			warn "Could not process a request!\n";
			[];
			};
	}
```

Those parallel requests make this program much faster than it would be if I did them individually one after the other. Most of the web request time is simply waiting and I get all of those requests to wait at the same time. Now, this isn't really parallelism because once once request has something to do, such as reading the data, the other requests still need to wait their turn. Perhaps I'll rewrite this program later to use [Minion](https://docs.mojolicious.org/Minion), the Mojo-based job queue that can do things in different processes.

The rest of the program is data extraction. In `parse_page`, I have various [CSS Selectors](https://docs.mojolicious.org/Mojo/DOM/CSS) to extract all the `div.animal-row` in the result and turn each animal into its own hash (again, I have lots of examples in *[Mojo Web Clients](https://leanpub.com/mojo_web_clients)*). Each Promise adds those results to the `@grand` array. At the end, I turn that into a JSON file, which I've also uploaded as a [gist](https://gist.github.com/briandfoy/d68915eb425e1fc4932ceac5cdf2d60d).

As someone who has been doing this sort of extraction for quite a while, I'm always quite pleased how easy Mojolicious makes this. I get the page and select some elements. A long time ago, I would have had long series of substitutions, regexes, and other low-level text processing. Perl's certainly good at text processing, but that doesn't mean I want to work at that level in every program.

## A few tricks

I do use a few interesting tricks just because I do. Lately in these sorts of programs I'm collecting things into data structure then presenting it at the end. Typically that means I do the setup at the top of the program file and the output at the end.  However, after I've defined the `@grand` variable, I immediately define an `END` block to specify what to do with `@grand` once everything else has happened:

```perl
my @grand;
END {
	# Since the results come out of order,
	# sort by animal name then title
	@grand = sort {
		$a->{animal} cmp $b->{animal}
			or
		$a->{title} cmp $b->{title}
		} @grand;

	my $json = encode_json( \@grand );
	say $json;
	}
```

## A little safari

And I leave you with a little safari. My animals are the Llama, Alpaca, Vicuñas, Camel, and Hamadryas Butterfly. Search the O'Reilly list (or my JSON) to find those titles. Some of them are missing and some have surprising results.

![](/images/extracting-the-list-of-o-reilly-animals/learning_perl.jpeg)

Here are some interesting [jq](https://stedolan.github.io/jq/) commands to play with the [Animals JSON file](https://gist.github.com/briandfoy/d68915eb425e1fc4932ceac5cdf2d60d):

```
# get all the title
$ jq -r '.[].title' < animals.json | sort | head -10
.NET & XML
.NET Compact Framework Pocket Guide
.NET Framework Essentials
.NET Gotchas
.NET Windows Forms in a Nutshell
20 Recipes for Programming MVC 3
20 Recipes for Programming PhoneGap
21 Recipes for Mining Twitter
25 Recipes for Getting Started with R
50 Tips and Tricks for MongoDB Develope

# tab-separated list of animals and titles
$ jq -r '.[] | "\(.animal) => \(.title)"' < animals.json | sort
12-Wired Bird of Paradise	Mobile Design and Development
3-Banded Armadillo	Windows PowerShell for Developers
Aardvark	Jakarta Commons Cookbook
Aardwolf	Clojure Cookbook
Addax, aka Screwhorn Antelope	Ubuntu: Up and Running
Adjutant (Storks)	Social eCommerce
Aegina Citrea, narcomedusae, jellyfish	BioBuilder
African Civet	JRuby Cookbook
African Crowned Crane aka Grey Crowned Crane	C# 5.0 Pocket Reference
African Crowned Crane aka Grey Crowned Crane	Programming C# 3.0

# find a title by exact match of animal
$ jq -r '.[] | select(.animal=="Llama") | .title' < animals.json
Randal Schwartz on Learning Perl

# find a title with a regex match against the animal
$ jq -r '.[] | select(.animal|test("ama")) | .title' < animals.json | sort
Access Cookbook
Access Database Design & Programming
ActionScript for Flash MX Pocket Reference
ActionScript for Flash MX: The Definitive Guide
Ajax on Java
Appcelerator Titanium: Up and Running
Embedding Perl in HTML with Mason
Fluent Python
Identity, Authentication, and Access Management in OpenStack
Introduction to Machine Learning with Python
Learning Perl 6
PDF Explained
Randal Schwartz on Learning Perl
SQL Pocket Guide
SQL Tuning
Solaris 8 Administrator's Guide
The Little Book on CoffeeScript
Writing Game Center Apps in iOS

# find an animal with a regex match against the title
$ jq -r '.[] | select(.title|test("Perl")) | .animal' < animals.json | sort
Alpaca
Aoudad, aka Barbary sheep
Arabian Camel, aka Dromedary
Arabian Camel, aka Dromedary
Arabian Camel, aka Dromedary, Head
Badger
Bighorn Sheep
Black Leopard
Blesbok (African antelope)
Camel, aka Dromedary
Cheetah
Emu, large and fluffy
Emu, young
Fan-footed Gecko, aka Wall Gecko
Flying Dragon (lizard)
Flying Dragon (lizard)
Greater Honeyguide
Green Monkey 1 (adult holding a baby)
Hamadryas Baboon
Hamadryas Butterfly
Llama
Mouse
North American Bullfrog
Proboscis Monkey
Red Colobus Monkey
Sea Otter
Staghound
Tadpole of a Greenfrog (sketch)
Thread-winged Lacewing, aka Antlion
White-tailed Eagle
Wolf
```
