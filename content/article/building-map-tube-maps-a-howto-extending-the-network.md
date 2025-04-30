
  {
    "title"       : "Building Map::Tube::<*> maps, a HOWTO: extending the network",
    "authors"     : ["paul-cochrane"],
    "date"        : "2025-04-30T12:00:09",
    "tags"        : [],
    "draft"       : false,
    "image"       : "/images/building-map-tube-maps-a-howto/tram-network-langenhagen-hannover-sarstedt-cover.png",
    "thumbnail"   : "/images/building-map-tube-maps-a-howto/Swiss-Cottage-Underground-Station-Jubilee-Line_Hugh-Llewelyn_flickr-To-Trains.jpg",
    "description" : "Extending the network of a Map::Tube::<*> map",
    "categories"  : "tutorials",
    "canonicalURL": "https://peateasea.de/building-map-tube-whatever-maps-a-howto-extending-the-network/"
  }

The [first post in this
series](/article/building-map-tube-maps-a-howto-first-steps/)
introduced us to `Map::Tube`.  There, we built the fundamental structure of
the `Map::Tube::Hannover` module and created the basic map file for the
Hannover tram network.  This time, we'll look at a map file's structure and
extend the network.  At the end, we'll visualise a graph of the railway
network we've created so far.

## Structural understanding

Now that we've created a basic map, our goal is to understand the structure
of `Map::Tube` maps a bit more.  This way we won't trip up when extending
our map to a more full network.

As a reminder, the map file we have at present looks like this:

```json
{
    "name"  : "Hannover",
    "lines" : {
        "line" : [
            {
                "id" : "L1",
                "name" : "Linie 1"
            }
        ]
    },
    "stations" : {
        "station" : [
            {
                "id" : "H1",
                "name" : "Hauptbahnhof",
                "line" : "L1",
                "link" : "H2"
            },
            {
                "id" : "H2",
                "name" : "Langenhagen",
                "line" : "L1",
                "link" : "H1"
            }
        ]
    }
}
```

Let's consider each of the elements in this map.

Each map can have a name.  This is a string providing a human-readable
name of the map, specified by the `name` attribute.  Even though a map
doesn't necessarily have to have a name, it's very handy to have, hence I've
included it here.

Each map has one `lines` attribute which contains a `line` array containing
the individual lines in the network.  There should be at least one line in
the map.  Each line has to have an ID (specified by the `id` attribute) and
a name (specified by the `name` attribute).

A valid map must also have at least two stations on one line.  We define
stations in the `stations` attribute.  It contains a `station` array of
individual stations.  A given station must have an ID (given by the `id`
attribute) and a name (given by the `name` attribute).  We must assign a
station to at least one of the lines specified in the `lines` attribute.  It
should also link to at least one other station by specifying the relevant ID
in its `link` attribute.

There are more things that a map file can contain.  For instance, a line can
have a `color` attribute to specify its colour.  Also, stations can link to
other stations indirectly by using the `other_link` attribute.  This way we
can represent connections via something like a tunnel, passageway or
escalator.

For all the gory details, check out the [formal requirements for maps
section of the `Map::Tube::Cookbook`
documentation](https://metacpan.org/pod/Map::Tube::Cookbook#FORMAL-REQUIREMENTS-FOR-MAPS).

## Extending the network

Where to from here?  Well, `Linie 1` needs more stations to better reflect
the situation in real life.  Also, the network needs more lines as well as
connections between those lines, again reflecting reality better.
Fortunately, these are things we can test, so we'll expand the test suite as
we go along.

We'd best get on with it then!

### Walking the line

We currently only have two stations in our network.  That's not enough!  To
flesh things out a bit, let's add some more stations along `Linie 1`.  To be
specific, let's add the other terminal station on that line, `Sarstedt`, as
well as stations between `Hauptbahnhof` and the respective terminal
stations.  I've decided to choose `Kabelkamp` on the north side and
`Laatzen` on the south side.

One thing that we're going to have to be careful with is giving each station
an ID.  How are we going to do that in some kind of systematic way?  The
first thing I thought of was to go left to right across the network.  By
this, I mean that the station furthest in the west along the given line is
what I shall consider to be the first station along that line.  This
decision is arbitrary, but it should be good enough for our purposes.

Although it's not clear from the [Üstra network
plan](https://www.uestra.de/fahrplan/linien-fahrplaene/uebersichts-und-netzplaene/),[^netzplan-u]
it turns out that `Langenhagen` is further west than `Sarstedt`.  So, I chose
`Langenhagen` to be the first station along that line.  Because this is also
the first line in the network, `Langenhagen` has the honour of having the
first station ID in the map file.

[^netzplan-u]: You'll need to follow that link and then download the PDF for
    "Netzplan U".  A direct link would get outdated very quickly, so I
    thought it best only to mention how to get the right info.  The "U"
    in "Netzplan U" stands for U-Bahn: i.e. the "underground" tram network.
    I use quotes around "underground" here because only the very centre of
    the network is underground; the rest is overground.  This is why I use
    the English term "tram" rather than "subway", because "tram" fits
    reality so much better.  Also, I think there's a certain class of train
    geek which takes exception at calling such a railway network an U-Bahn.

Thus, for `Linie 1`, we have these stations, their respective new labels, and
their links:

| Station      | ID | Links |
|--------------|----|-------|
| Langenhagen  | H1 | H2    |
| Kabelkamp    | H2 | H1,H3 |
| Hauptbahnhof | H3 | H2,H4 |
| Laatzen      | H4 | H3,H5 |
| Sarstedt     | H5 | H4    |

Our goal for now is to have these stations connected along `Linie 1` with
their respective IDs and links.  We'll achieve this goal in small steps so
that we're not changing too much in one go.

Note also that I'm doing all this work by hand.  This allows us to see how
all the pieces fit together, which is one main goal of this HOWTO.  In
reality, however, a railway network is much more complex and with many more
stations.  Thus, to create the full network, one would need an [automated
way to extract line and station data from e.g.
OpenStreetMap](https://peateasea.de/getting-tram-stops-in-hannover-from-openstreetmap/).
We would then collect this information and export it in the form that
`Map::Tube` needs.  But, [that's not important right
now](https://www.youtube.com/watch?v=AK3gB7DpaM0), so we'll continue adding
stations and lines manually.

Each station in our current network describes the connection it has to other
stations via its `link` attribute.  Stations at the ends of the line only
link to one other station because that's what it means for a station to be
at the end of a line.  The remaining stations link to two stations each,
connecting one end of the line to the other like the proverbial string of
pearls.  In general, one can have many links at a given station, especially
if many lines cross at a given station.  Right now we don't need this extra
complexity and will keep things simple.

Let's kick-start the implementation of the full list of stations for `Linie
1` by adding the station `Sarstedt`.  To get the ball rolling, we'll start
(as usual) with a test.

What we want to check is that there is a route from `Langenhagen` to `Sarstedt`
and that stations along that route match our expectations.  How do we go
about doing this?  Again, the `Map::Tube` framework comes to our rescue.  It
provides the `ok_map_routes()` assertion in the `Test::Map::Tube` module
which we can use to check our route.  Also, the docs help again, by
providing [a simple route-checking
example](https://metacpan.org/pod/Map::Tube#FUNCTIONAL-VALIDATION).

Before we add this test, let's remove some code duplication in our test
suite.  Note that currently, we're creating a `Map::Tube::Hannover` object
twice in the tests.  Really, we only need to do that once.  Let's
instantiate a single object and pass that to our test functions.

Assign a variable called `$hannover` to the instantiated
`Map::Tube::Hannover` object before the `ok_map*()` functions, like so:

```perl
my $hannover = Map::Tube::Hannover->new;
```

Then replace `Map::Tube::Hannover->new` in the calls to the `ok_map*()`
functions with the new variable:

```perl
ok_map($hannover);
ok_map_functions($hannover);
```

Our test file (`t/map-tube-hannover.t`) now looks like this:

```perl
use strict;
use warnings;

use Test::More;

use Map::Tube::Hannover;
use Test::Map::Tube;

my $hannover = Map::Tube::Hannover->new;

ok_map($hannover);
ok_map_functions($hannover);

done_testing();
```

Running this test with `prove`, we find that the tests still pass.

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=2,  0 wallclock secs ( 0.04 usr  0.00 sys +  0.48 cusr  0.05 csys =  0.57 CPU)
Result: PASS
```

Great!  That's worthy of a commit:

```shell
$ git commit -m "Extract repeated object instantiation into variable in tests" t/map-tube-hannover.t
[main f9005d1] Extract repeated object instantiation into variable in tests
 1 file changed, 4 insertions(+), 2 deletions(-)
```

Now we're ready to check the route from `Langenhagen` to `Sarstedt` via
`Hauptbahnhof`.  We start by defining an array of strings containing route
descriptions:

```perl
my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Hauptbahnhof,Sarstedt",
);
```

Although this array only contains one element, we'll be extending it later,
so using a plural name is ok in this situation.  Also, the
[`ok_map_routes()`](https://metacpan.org/pod/Test::Map::Tube#ok_map_routes(-$map,-\@routes-[,-$message-]-))
test function requires an array reference as one of its arguments, hence
creating an array now is sensible forward-thinking.

We check the route by calling `ok_map_routes()` like so:

```perl
ok_map_routes($hannover, \@routes);
```

The complete test file is now:

```perl
use strict;
use warnings;

use Test::More;

use Map::Tube::Hannover;
use Test::Map::Tube;

my $hannover = Map::Tube::Hannover->new;

ok_map($hannover);
ok_map_functions($hannover);

my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Hauptbahnhof,Sarstedt",
);

ok_map_routes($hannover, \@routes);

done_testing();
```

We don't expect the tests to pass.  Even so, what feedback do they give us?

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/? Map::Tube::get_node_by_name(): ERROR: Invalid Station Name [Sarstedt]. (status: 101) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Map/Tube.pm on line 897
# Tests were run but no plan was declared and done_testing() was not seen.
# Looks like your test exited with 255 just after 2.
t/map-tube-hannover.t .. Dubious, test returned 255 (wstat 65280, 0xff00)
All 2 subtests passed

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 65280 (exited 255) Tests: 2 Failed: 0)
  Non-zero exit status: 255
  Parse errors: No plan found in TAP output
Files=1, Tests=2,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.47 cusr  0.05 csys =  0.56 CPU)
Result: FAIL
```

Ok, so `Map::Tube::Hannover` doesn't know about the station `Sarstedt`.
Let's update the map file and add a station entry for `Sarstedt`, linking it
to `Hauptbahnhof` at this step.  We'll also relabel `Langenhagen` and
`Hauptbahnhof` and reorder the entries within the map file so that
`Langenhagen` is at the top and `Sarstedt` at the bottom, thus matching the
north-south direction of this line.  Remember that the links I'm using right
now aren't those that we want in the end: this is merely a step along that
path.

Our list of stations now looks like this:

```json
    "stations" : {
        "station" : [
            {
                "id" : "H1",
                "name" : "Langenhagen",
                "line" : "L1",
                "link" : "H3"
            },
            {
                "id" : "H3",
                "name" : "Hauptbahnhof",
                "line" : "L1",
                "link" : "H1,H5"
            },
            {
                "id" : "H5",
                "name" : "Sarstedt",
                "line" : "L1",
                "link" : "H3"
            }
        ]
    }
```

Testing this change:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=3,  1 wallclock secs ( 0.06 usr  0.00 sys +  0.49 cusr  0.05 csys =  0.60 CPU)
Result: PASS
```

Great!  We've got a working route from `Langenhagen` to `Sarstedt`!  Let's add
in the stations that we left out in the last step.

Update the routes test to this:

```perl
my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Kabelkamp,Hauptbahnhof,Laatzen,Sarstedt",
);

ok_map_routes($hannover, \@routes);
```

And check what the test output tells us:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/? Map::Tube::get_node_by_name(): ERROR: Invalid Station Name [Kabelkamp]. (status: 101) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm on line 1434
# Tests were run but no plan was declared and done_testing() was not seen.
# Looks like your test exited with 255 just after 2.
t/map-tube-hannover.t .. Dubious, test returned 255 (wstat 65280, 0xff00)
All 2 subtests passed

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 65280 (exited 255) Tests: 2 Failed: 0)
  Non-zero exit status: 255
  Parse errors: No plan found in TAP output
Files=1, Tests=2,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.50 cusr  0.04 csys =  0.57 CPU)
Result: FAIL
```

Ok, `Kabelkamp` is missing.  Adding its entry to the map file after
`Langenhagen`, and updating the links for the `Langenhagen` and
`Hauptbahnhof` stations, we now have this stations list:

```json
    "stations" : {
        "station" : [
            {
                "id" : "H1",
                "name" : "Langenhagen",
                "line" : "L1",
                "link" : "H2"
            },
            {
                "id" : "H2",
                "name" : "Kabelkamp",
                "line" : "L1",
                "link" : "H1,H3"
            },
            {
                "id" : "H3",
                "name" : "Hauptbahnhof",
                "line" : "L1",
                "link" : "H2,H5"
            },
            {
                "id" : "H5",
                "name" : "Sarstedt",
                "line" : "L1",
                "link" : "H3"
            }
        ]
    }
```

and re-running the tests, we get:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/? Map::Tube::get_node_by_name(): ERROR: Invalid Station Name [Laatzen]. (status: 101) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm on line 1434
# Tests were run but no plan was declared and done_testing() was not seen.
# Looks like your test exited with 255 just after 2.
t/map-tube-hannover.t .. Dubious, test returned 255 (wstat 65280, 0xff00)
All 2 subtests passed

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 65280 (exited 255) Tests: 2 Failed: 0)
  Non-zero exit status: 255
  Parse errors: No plan found in TAP output
Files=1, Tests=2,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.48 cusr  0.05 csys =  0.56 CPU)
Result: FAIL
```

The tests are still failing, but *we're getting the failure that we expect
to see*.  In other words, we expect to see the error about `Kabelkamp`
disappear but expect to see an error about `Laatzen`.  This is because we
haven't added `Laatzen` yet.  Adding the station entry for `Laatzen` and
fixing up the links in the stations list, we get:

```json
    "stations" : {
        "station" : [
            {
                "id" : "H1",
                "name" : "Langenhagen",
                "line" : "L1",
                "link" : "H2"
            },
            {
                "id" : "H2",
                "name" : "Kabelkamp",
                "line" : "L1",
                "link" : "H1,H3"
            },
            {
                "id" : "H3",
                "name" : "Hauptbahnhof",
                "line" : "L1",
                "link" : "H2,H4"
            },
            {
                "id" : "H4",
                "name" : "Laatzen",
                "line" : "L1",
                "link" : "H3,H5"
            },
            {
                "id" : "H5",
                "name" : "Sarstedt",
                "line" : "L1",
                "link" : "H4"
            }
        ]
    }
```

You'll find that the tests now pass:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=3,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.51 cusr  0.03 csys =  0.57 CPU)
Result: PASS
```

Yay!

That's worth another commit:

```shell
$ git commit -m "Extend list of stations on Linie 1" share/hannover-map.json t/map-tube-hannover.t
[main a742db3] Extend list of stations on Linie 1
 2 files changed, 27 insertions(+), 3 deletions(-)
```

### Seeing the bigger picture

To visualise what our map looks like, we can use the
[`Map::Tube::Plugin::Graph`](https://metacpan.org/pod/Map::Tube::Plugin::Graph)
plugin.  Let's install the plugin and see what it does:

```shell
$ cpanm Map::Tube::Plugin::Graph
```

Note that you might need to install [Graphviz](https://graphviz.org/) before
installing the plugin, e.g.:

```shell
$ sudo apt install graphviz
```

We're going to create a small program to convert our `Map::Tube` map into a
PNG image of a Graphviz graph.  To keep things nice and tidy, let's create a
`bin/` directory to keep our program in:

```shell
$ mkdir bin
```

Now, with your favourite editor, open a file called `bin/map2image.pl` and
enter into it the following code:

```perl
use strict;
use warnings;

use lib qw(lib);

use Map::Tube::Hannover;

my $hannover = Map::Tube::Hannover->new;
my $map_name = $hannover->name;

open(my $map_image, ">", "$map_name.png")
    or die "ERROR: Can't open $map_name.png: $!";
binmode($map_image);
print $map_image $hannover->as_png;
close($map_image);

# vim: expandtab shiftwidth=4
```

In this program, we specify the location of the `lib` directory explicitly.
This saves us from having to use `-I lib` when invoking `perl` on the
command line.  We then import our `Map::Tube::Hannover` module and
instantiate a new `Map::Tube::Hannover` object.  We also save the map's name
for later use as part of the output image filename.

Then we open the output file and
[barf](https://hackersdictionary.com/html/entry/barf.html) if something went
wrong.  Since the output image is a PNG, we need to set the output mode to
binary.  After that, we print the output of the `Map::Tube::Plugin::Graph`
plugin's `as_png()` method[^monkey-patch] to file and close the file.

[^monkey-patch]: As far as I can tell, the `as_png()` method gets monkey
    patched onto the `Map::Tube` role, hence why we can call it from our
    `Map::Tube::Hannover` object.

Running our new program like so:

```shell
$ perl bin/map2image.pl
```

produces an image file called `Hannover.png` in the base project directory.
Opening this image in an image viewer, you should output similar to this:

![Graphviz graph showing nodes in the Hannover tram network for Linie 1](/images/building-map-tube-maps-a-howto/map-tube-hannover-only-linie-1.png)

Nice!

It's fairly obvious from the input map file that our network is a straight
line.  Even so, it's nice to see this in an image rather than having to
deduce it from only the map file's structure.

It'll be handy having such a tool around when developing the map further, so
let's add it to the repository and commit that change:

```shell
$ git commit -m "Add program to convert map into a PNG image"
[main bb709e8] Add program to convert map into a PNG image
 1 file changed, 17 insertions(+)
 create mode 100644 bin/map2image.pl
```

## Wrapping up

We didn't do as much this time, but that's OK.  We put in a lot of work in
the previous post getting everything up and running, so taking it easy for a
bit will let us catch our breath.  Still, we weren't mucking around.  We
used test-driven development to extend the tram network map for Hannover and
wrote a small program to visualise it.  We're making steady progress toward
our goal: a working `Map::Tube` map that we can use to find our way from
station to station.

The next post in the series will describe how to add more lines to the
network as well as how to use colour to tell them apart.  Until then, [keep
cool till after school!](https://www.youtube.com/watch?v=9cIeVmCY0NA)

Originally posted on
[https://peateasea.de](https://peateasea.de/building-map-tube-whatever-maps-a-howto-extending-the-network/).

Image credits: [Hannover coat of arms: Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Coat_of_arms_of_Hannover.svg),
[U-Bahn symbol: Wikimedia Commons](https://de.m.wikipedia.org/wiki/Datei:U-Bahn.svg),
[Langenhagen coat of arms: Wikimedia Commons](https://commons.wikimedia.org/wiki/File:DEU_Langenhagen_COA.svg),
[Sarstedt coat of arms: Wikimedia Commons](https://commons.wikimedia.org/wiki/File:DE-NI_03-2-54-028_Sarstedt_COA.svg)

Thumbnail credits: [Swiss Cottage Underground Station (Jubilee
Line)](https://www.flickr.com/photos/58433307@N08/53726096544) by [Hugh
Llewelyn](https://www.flickr.com/photos/camperdown/)
