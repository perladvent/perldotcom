
  {
    "title"       : "Building Map::Tube::<*> maps, a HOWTO: routing relative reality",
    "authors"     : ["paul-cochrane"],
    "date"        : "2025-05-24T10:13:12",
    "tags"        : [],
    "draft"       : false,
    "image"       : "/images/building-map-tube-maps-a-howto/tram-network-hannover-linie1-linie4-linie7-cover.png",
    "thumbnail"   : "/images/building-map-tube-maps-a-howto/Swiss-Cottage-Underground-Station-Jubilee-Line_Hugh-Llewelyn_flickr-To-Trains.jpg",
    "description" : "Finding routes between stations in a Map::Tube::<*> map.",
    "categories"  : "tutorials",
    "canonicalURL": "https://peateasea.de/building-map-tube-whatever-maps-a-howto-routing-relative-reality/"
  }

[The previous
post](/article/building-map-tube-maps-a-howto-weaving-a-web/)
focused on adding more lines to the network and adding colour to those
lines.  This time, we'll add another line, but now the map will better
match reality.  This will allow us to start finding routes between stations
on the network.

## Building complexity

It's time to get a bit trickier.  In the real tram network in Hannover, the
main hub is actually the station `Kröpcke` and not `Hauptbahnhof` as we've
been using so far.  Therefore, if we want to add further lines, we'll have
to add this station and route the lines through it correctly.  Doing so
allows us to do some cool things, like planning routes between seemingly
disjoint parts of the network.

The plan right now is to add `Linie 4` from `Garbsen` to
`Roderbruch`.[^telemax-roderbruch]  Here are the stations we want to add
along with their IDs and their station links:

[^telemax-roderbruch]: It turns out that suburb of Roderbruch doesn't have
    a coat of arms.  One of its well-known landmarks is the [Telemax
    tower](https://de.wikipedia.org/wiki/Telemax), hence I used it to make
    a coat-of-arms-like image for this station in the article's cover image.

| Station    | ID  | Links                |
|------------|-----|----------------------|
| Garbsen    | H10 | H11                  |
| Laukerthof | H11 | H10, H12             |
| Kröpcke    | H12 | H11, H13, H3, H4, H7 |
| Kantplatz  | H13 | H12, H14             |
| Roderbruch | H14 | H13                  |

As in previous posts, I've continued the numbering from where I left off.
This time, `Garbsen` is the westernmost station along `Linie 4` and hence
the "first" one along that line.

Looking at the links we have for `Kröpcke` in the table, we can see that
things are getting more complicated, especially at this particular station.
Since this node is so central to the network, we expect complexity to be
concentrated here.  To manage this increase in complexity we'll continue
using tests to guide the map's evolution.  Also, note that the links
connecting `Laatzen` and `Allerweg` to `Hauptbahnhof` will need to change
because these stations will now be connected to `Kröpcke`.

### [Many more much smaller steps](https://www.geepawhill.org/series/many-more-much-smaller-steps/)

To start making these changes, we'll need some tests.  Fortunately, we
already have a good structure in `t/map-tube-hannover.t` that we can build
upon.

What's the smallest incremental change that we can think of?  Well, the
network should now have three lines, so we update the "number of lines" test
to check for that condition:

```perl
my $num_lines = scalar @{$hannover->get_lines};
is( $num_lines, 3, "Number of lines in network correct" );
```

Running the test file, we see that this will cause the first test failure:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/?
#   Failed test 'Number of lines in network correct'
#   at t/map-tube-hannover.t line 15.
#          got: '2'
#     expected: '3'
# Looks like you failed 1 test of 4.
```

and drive us to add the new line, `Linie 4`:

```json
    "lines" : {
        "line" : [
            {
                "id" : "L1",
                "name" : "Linie 1",
                "color" : "red"
            },
            {
                "id" : "L7",
                "name" : "Linie 7",
                "color" : "blue"
            },
            {
                "id" : "L4",
                "name" : "Linie 4",
                "color" : "#f9a70c"
            }
        ]
    },
```

Here I've used an RGB colour for the line to show how this variant of
specifying colour works.  I found the colour by loading the PDF of the
[Üstra "Netzplan
U"](https://www.uestra.de/fahrplan/linien-fahrplaene/uebersichts-und-netzplaene/)
into [Gimp](https://www.gimp.org/) and using the colour picker tool.

### Managing expectations

[From prior
experience](/article/building-map-tube-maps-a-howto-extending-the-network/#walking-the-line),
we expect the tests to continue to fail, but for a different reason:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t ..     # Line id L4 consists of 0 separate components

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Line id L4 defined but serves no stations (not even as other_link)

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Looks like you failed 2 tests of 14.
```

These errors are what we expect: the validation tests are telling us that
`Linie 4` isn't connected to anything and doesn't have a station attached to
it.

To build the new line incrementally, we'll first add only the stations from
`Garbsen` to `Kröpcke`.  Then we'll connect the new line to the network by
connecting `Kröpcke` to `Hauptbahnhof`.  Later, we'll add the remaining
stations.

To begin, add these station entries after `Misburg`:

```json
            {
                "id" : "H10",
                "name" : "Garbsen",
                "line" : "L4",
                "link" : "H11"
            },
            {
                "id" : "H11",
                "name" : "Laukerthof",
                "line" : "L4",
                "link" : "H10,H12"
            },
            {
                "id" : "H12",
                "name" : "Kröpcke",
                "line" : "L1,L4,L7",
                "link" : "H3,H11"
            }
```

Running the test file gives this error:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t ..     # Not every station reachable from every other station -- map has 2 separate components; e.g., stations with ids H1//H10

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Looks like you failed 1 test of 14.
```

That's very odd.  That wasn't an error I was expecting after this change.
After all, the new line should connect to the previously defined lines.

What can the message

```
map has 2 separate components; e.g., stations with ids H1//H10
```

mean?  How could we debug this situation?

## Visual debugging

One thing we can do is to convert the map into an image with `map2image.pl`
and see if anything looks out of place:

```shell
$ perl bin/map2image.pl
```

Running the above command generates this image:

![Graphviz graph showing nodes and their connectivity in the Hannover tram network for Linie 1, 4 and 7 with a broken connection between Kröpcke and Hauptbahnhof](/images/building-map-tube-maps-a-howto/map-tube-hannover-linie-1-4-and-7-broken.png)

The problem is much clearer now!  We can see that although there's a link
from `Kröpcke` to `Hauptbahnhof`, there's no link from `Hauptbahnhof` *back*
to `Kröpcke`.  Adding that link (i.e. `H12`) to `Hauptbahnhof`:

```json
            {
                "id" : "H3",
                "name" : "Hauptbahnhof",
                "line" : "L1,L7",
                "link" : "H2,H4,H7,H8,H12"
            },
```

gets the test suite to pass again:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.54 cusr  0.06 csys =  0.63 CPU)
Result: PASS
```

Great!

### Threading the new line through the network

Now we're in a position to add the remaining stations on `Linie 4`.  We
drive this change by adding a route from `Garbsen` to `Roderbruch` to our
routes tests.  This then checks that these stations are part of the network:

```perl
my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Kabelkamp,Hauptbahnhof,Laatzen,Sarstedt",
    "Route 4|Garbsen|Roderbruch|Garbsen,Laukerthof,Kröpcke,Kantplatz,Roderbruch",
    "Route 7|Wettbergen|Misburg|Wettbergen,Allerweg,Hauptbahnhof,Vier Grenzen,Misburg",
);

ok_map_routes($hannover, \@routes);
```

This test will hopefully fail because we haven't added the `Roderbruch`
station yet:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/? Map::Tube::get_node_by_name(): ERROR: Invalid Station Name [Roderbruch]. (status: 101) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Map/Tube.pm on line 897
# Tests were run but no plan was declared and done_testing() was not seen.
# Looks like your test exited with 255 just after 3.
```

Expectations met again!  Failing for the right reason means we're on the
right track.[^pun-not-intended]

[^pun-not-intended]: I really, honestly, didn't intend that pun!

To continue, we add the remaining stations along `Linie 4` and update the
list of links for `Kröpcke` to link to the station `Kantplatz`:

```json
            {
                "id" : "H12",
                "name" : "Kröpcke",
                "line" : "L1,L4,L7",
                "link" : "H3,H11,H13"
            },
            {
                "id" : "H13",
                "name" : "Kantplatz",
                "line" : "L4",
                "link" : "H12,H14"
            },
            {
                "id" : "H14",
                "name" : "Roderbruch",
                "line" : "L4",
                "link" : "H13"
            }
```

Running the test suite gives:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/? Map::Tube::get_node_by_name(): ERROR: Invalid Station Name [Kröpcke]. (status: 101) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm on line 1434
# Tests were run but no plan was declared and done_testing() was not seen.
# Looks like your test exited with 255 just after 3.
```

Erm, what??  I expected this test to pass.  Unfortunately, we got the error

```
Invalid Station Name [Kröpcke]
```

What's going on here?

### [Schei� Encoding](https://www.getdigital.de/products/schei-encoding)

[As is my
wont](https://peateasea.de/getting-tram-stops-in-hannover-from-openstreetmap/#side-project-spawn-recursion),
this led me down quite the rabbit hole.  Yes, another one.  To cut a *very*
long story short, the issue here is that the station name contains a
non-ascii character, in particular the umlaut 'ö'.[^replacement-character]
If we change the route test to

[^replacement-character]: In case you've ever wondered, the question mark
    inside a rotated square is called [the replacement character](https://www.johndcook.com/blog/2024/01/11/replacement-character/) and has the [Unicode value U+FFFD](https://www.unicode.org/charts/PDF/UFFF0.pdf).

```perl
    "Route 4|Garbsen|Roderbruch|Garbsen,Laukerthof,Kroepcke,Kantplatz,Roderbruch",
```

and update the station entry in the map file:

```json
            {
                "id" : "H12",
                "name" : "Kroepcke",
                "line" : "L1,L4,L7",
                "link" : "H3,H11,H13"
            },
```

so that they use `oe` in place of `ö`, then the test suite will
pass:[^umlaut-equivalents]

[^umlaut-equivalents]: In German, umlauts can be written with their ASCII
    equivalents.  In other words, one can write the umlauts ä, ö and ü as
    "ae", "oe" and "ue", respectively.

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=4,  1 wallclock secs ( 0.03 usr  0.00 sys +  0.58 cusr  0.06 csys =  0.67 CPU)
Result: PASS
```

I first mentioned this behaviour in an [issue in
`Map::Tube::Frankfurt`](https://github.com/reneeb/Map-Tube-Frankfurt/issues/8#issuecomment-2572690011).
It seems that the `Map::Tube` version I'm using here (4.03) doesn't always
process UTF-8 input correctly.  I haven't yet worked out the exact reason
for this, hence the only way is to avoid umlauts and the sharp-s (ß) and use
their ASCII-compatible versions.  For German, this means that ä becomes ae,
ö becomes oe, ü becomes ue, and ß becomes ss.[^utf8-problem-fixed]

[^utf8-problem-fixed]: Since I wrote the initial draft of this series,
    Mohammad has already fixed the issue.  If you want to avoid the UTF-8
    problems, then you'll need to install `Map::Tube` with at least version
    4.08.

What's weird here is that most of the validation tests work.  It's only as
soon as one has a non-ASCII character like an umlaut or a sharp-s (ß) in the
route name (at least for German maps) that problems seem to appear.

Since we've extended the network and now have a working configuration, it's
a good time for a commit:

```shell
$ git commit -m "Add Linie 4 from Garbsen to Roderbruch via Kröpcke" share/hannover-map.json t/map-tube-hannover.t
[main 22d482e] Add Linie 4 from Garbsen to Roderbruch via Kröpcke
 2 files changed, 38 insertions(+), 2 deletions(-)
```

If you convert the map to an image, you'll find that everything is connected:

![Graphviz graph showing nodes and their connectivity in the Hannover tram network for Linie 1, 4 and 7 but with incorrect Hauptbahnhof-Kröpcke connection](/images/building-map-tube-maps-a-howto/map-tube-hannover-linie-1-4-and-7-hbf-kroepcke-wrong.png)

The lines do seem to be a bit jumbled up in the graph now, but that's just
an artefact of generating this graph automatically.

### Keeping a critical eye open

Looking at this graph made me realise something: it's wrong.

But Paul!  Our tests are passing, it *must* be correct!

The thing is, the expectations in our tests are incorrect and we need to fix
them.  If you compare the [Üstra "Netzplan
U"](https://www.uestra.de/fahrplan/linien-fahrplaene/uebersichts-und-netzplaene/)
with the graph above, then you'll find that `Laatzen` and `Allerweg` should
connect to `Kröpcke` and *not* to `Hauptbahnhof` as they are currently.

How do we solve this issue?  We update the expectations in our routes tests.
These tests now look like so:

```perl
my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Kabelkamp,Hauptbahnhof,Kroepcke,Laatzen,Sarstedt",
    "Route 4|Garbsen|Roderbruch|Garbsen,Laukerthof,Kroepcke,Kantplatz,Roderbruch",
    "Route 7|Wettbergen|Misburg|Wettbergen,Allerweg,Kroepcke,Hauptbahnhof,Vier Grenzen,Misburg",
);

ok_map_routes($hannover, \@routes);
```

where, if you look closely, you'll notice that we've squashed `Kroepcke`
between `Hauptbahnhof` and `Laatzen` and `Allerweg`, respectively:[^word-diffs-hard]

[^word-diffs-hard]: It turned out to be difficult to show a nice word diff of
    the change, so this was the best I could do to highlight what was added.

```diff
my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Kabelkamp,Hauptbahnhof,Kroepcke,Laatzen,Sarstedt",
                                                                     ^^^^^^^^^
    "Route 4|Garbsen|Roderbruch|Garbsen,Laukerthof,Kroepcke,Kantplatz,Roderbruch",
    "Route 7|Wettbergen|Misburg|Wettbergen,Allerweg,Kroepcke,Hauptbahnhof,Vier Grenzen,Misburg",
                                                    ^^^^^^^^^
);
```

### Getting by with a little help from our tests

The test suite will now fail right royally.  However, the routes test from
`Test::Map::Tube` gives us lots of informative output about what went wrong.
We thus get many hints about how to correct things.

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/?
#   Failed test 'Route 1'
#   at t/map-tube-hannover.t line 23.
#          got: 'Langenhagen (Linie 1)
# Kabelkamp (Linie 1)
# Hauptbahnhof (Linie 1, Linie 7)
# Laatzen (Linie 1)
# Sarstedt (Linie 1)'
#     expected: 'Langenhagen (Linie 1)
# Kabelkamp (Linie 1)
# Hauptbahnhof (Linie 1, Linie 7)
# Kroepcke (Linie 1, Linie 4, Linie 7)
# Laatzen (Linie 1)
# Sarstedt (Linie 1)'

#   Failed test 'Route 7'
#   at t/map-tube-hannover.t line 23.
#          got: 'Wettbergen (Linie 7)
# Allerweg (Linie 7)
# Hauptbahnhof (Linie 1, Linie 7)
# Vier Grenzen (Linie 7)
# Misburg (Linie 7)'
#     expected: 'Wettbergen (Linie 7)
# Allerweg (Linie 7)
# Kroepcke (Linie 1, Linie 4, Linie 7)
# Hauptbahnhof (Linie 1, Linie 7)
# Vier Grenzen (Linie 7)
# Misburg (Linie 7)'
# Looks like you failed 2 tests of 5.
t/map-tube-hannover.t .. Dubious, test returned 2 (wstat 512, 0x200)
Failed 2/5 subtests
```

By the way: converting the map to an image with `map2image.pl` is very
helpful in debugging connection-related problems such as those appearing in
the test failures above.

To solve these errors, we need to update `Hauptbahnhof` to look like the
following (we remove `H4` and `H7` as they should link to `Kröpcke`):

```json
            {
                "id" : "H3",
                "name" : "Hauptbahnhof",
                "line" : "L1,L7",
                "link" : "H2,H8,H12"
            },
```

and `Kröpcke` to look like this (we add in `H4` and `H7`):

```json
            {
                "id" : "H12",
                "name" : "Kroepcke",
                "line" : "L1,L4,L7",
                "link" : "H3,H4,H7,H11,H13"
            },
```

as well as `Laatzen`, where we replace `H3` (`Hauptbahnhof`) with `H12`
(`Kröpcke`):

```json
            {
                "id" : "H4",
                "name" : "Laatzen",
                "line" : "L1",
                "link" : "H5,H12"
            },
```

and `Allerweg` (again, `H12` replaces `H3`):

```json
            {
                "id" : "H7",
                "name" : "Allerweg",
                "line" : "L7",
                "link" : "H6,H12"
            },
```

The tests should now pass:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=4,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.54 cusr  0.04
csys =  0.62 CPU)
Result: PASS
```

... and they do!  Yay!

Converting the map into an image with `map2image.pl`, you should see this
output:

![Graphviz graph showing nodes and their connectivity in the Hannover tram network for Linie 1, 4 and 7](/images/building-map-tube-maps-a-howto/map-tube-hannover-linie-1-4-and-7.png)

where most of the connections go through `Kröpcke` as we'd expect for such a
central node.

What's nice about the network graph now is that it's starting to look more
and more like the *actual* network graph in the [Üstra "Netzplan
U"]((https://www.uestra.de/fahrplan/linien-fahrplaene/uebersichts-und-netzplaene/)).

Since we've reached a new stable state of the code, let's commit this change
and move on.

```shell
$ git commit share/hannover-map.json t/map-tube-hannover.t -m "Fix connections through Kröpcke
>
> Routes 1 and 7 in the tests were no longer correct as they didn't reflect
> reality.  The stations Allerweg and Laatzen were actually connected to
> Kröpcke and not to Hauptbahnhof.  This change fixes the issue and ensures
> the network better reflects the actual tram network in Hannover."
[main f931ec1] Fix connections through Kröpcke
 2 files changed, 6 insertions(+), 6 deletions(-)
```

## Getting to the route of the problem

Now that our map has gained more complexity, it means that we can start to
do interesting things.  `Map::Tube` is, after all, a routing framework.
Thus, we can start planning routes across lines, not only within lines as
we've been doing so far.  In other words, we can now look for a route
requiring us to change trains and transfer to another line.  To search for
routes, we use the `get_shortest_route()` method.

Let's build a small program that we can use to find routes within our
network.  Then we can try finding a route from `Garbsen` (on `Linie 4`) to
`Sarstedt` (on `Linie 1`) as an example.

I'm going to avoid creating tests for the program and I'll skip input
validation[^naughty] so that we can get things up and running quickly.
These skipped steps are left as an exercise for the reader. :wink:

[^naughty]: Naughty me!  Bad Paul!

Create a file called `bin/get_route.pl` in your favourite editor and enter
this code:

```perl
use strict;
use warnings;

use lib qw(lib);

use Map::Tube::Hannover;


# grab the start and end stations of the route
my $from = $ARGV[0];
my $to = $ARGV[1];

# show how to get from one to the other
my $hannover = Map::Tube::Hannover->new;
print $hannover->get_shortest_route($from, $to), "\n";

# vim: expandtab shiftwidth=4
```

This should be sufficient for our needs.  As with `map2image.pl`, we set the
`lib` path explicitly so that we don't have to mention `-I lib` on the
command line.  Then we import the `Map::Tube::Hannover` module.  We grab the
start and end stations of our route from the `@ARGV` array because we're
supplying this information via command line arguments.  Thus, we'll run the
program like so:

```shell
$ perl get_route.pl 'start station name' 'end station name'
```

We then create an instance of a `Map::Tube::Hannover` object and call the
`get_shortest_route()` method on that.  The names of our start and end
stations are passed as arguments to `get_shortest_route()`.  We print the
result of this method call to the terminal, thus showing the route to take.

Let's see it in action.  In our first example, we want to find a route from
`Garbsen` to `Sarstedt`:

```shell
$ perl bin/get_route.pl Garbsen Sarstedt
Garbsen (Linie 4), Laukerthof (Linie 4), Kroepcke (Linie 1, Linie 4, Linie 7), Laatzen (Linie 1), Sarstedt (Linie 1)
```

That was easy, wasn't it?  Now we know that to get from `Garbsen` to `Sarstedt`,
we have to change trains at `Kröpcke`.

How do we handle stations with spaces in their names, such as `Vier
Grenzen`?  Simply add quotes around the name when calling the program:

```shell
$ perl bin/get_route.pl Garbsen 'Vier Grenzen'
Garbsen (Linie 4), Laukerthof (Linie 4), Kroepcke (Linie 1, Linie 4, Linie 7), Hauptbahnhof (Linie 1, Linie 7), Vier Grenzen (Linie 7)
```

This example highlights two options for the shortest route: one could change
to `Linie 1` at `Kroepcke` and then change to `Linie 7` at `Hauptbahnhof`,
or one could change directly to `Linie 7` at `Kroepcke`.  Both paths are
equivalent ways of getting from `Garbsen` to `Vier Grenzen`.

Cool!

That looks like a handy program to have around.  Let's add it to the
repository and commit the change:

```shell
$ git add bin/get_route.pl
$ git commit -m "Add program to get a route from one station to another"
[main ff27347] Add program to get a route from one station to another
 1 file changed, 17 insertions(+)
 create mode 100644 bin/get_route.pl
```

## Wrapping up

We've finally been able to use our module for what we intended it to do:
find routes through the railway network.  We've also seen that it's useful
to have a visual representation of the map as a debugging aid.  Also, we've
maintained our flow, using tests to drive new features and [committing
changes to Git](https://github.com/paultcochrane/MapTubeHannoverHowTo/) as
soon as the code achieves a suitable stable state.

In the final post in this series, we'll see how to build connections between
stations that aren't connected directly.

Originally posted on
[https://peateasea.de](https://peateasea.de/building-map-tube-whatever-maps-a-howto-routing-relative-reality/).

Image credits: [Hannover coat of arms: Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Coat_of_arms_of_Hannover.svg),
[U-Bahn symbol: Wikimedia Commons](https://de.m.wikipedia.org/wiki/Datei:U-Bahn.svg),
[Langenhagen coat of arms: Wikimedia Commons](https://commons.wikimedia.org/wiki/File:DEU_Langenhagen_COA.svg),
[Sarstedt coat of arms: Wikimedia Commons](https://commons.wikimedia.org/wiki/File:DE-NI_03-2-54-028_Sarstedt_COA.svg),
[Wettbergen coat of arms](https://de.m.wikipedia.org/wiki/Datei:Wappen_Wettbergen.jpg),
[Misburg coat of arms](https://de.m.wikipedia.org/wiki/Datei:Wappen_Misburg.png),
[Garbsen coat of arms](https://commons.wikimedia.org/wiki/File:DEU_Garbsen_COA.svg),
[Telemax tower](https://commons.wikimedia.org/wiki/File:2021-10-28_Telemax_01.JPG).

Thumbnail credits: [Swiss Cottage Underground Station (Jubilee
Line)](https://www.flickr.com/photos/58433307@N08/53726096544) by [Hugh
Llewelyn](https://www.flickr.com/photos/camperdown/)
