
  {
    "title"       : "Building Map::Tube::<*> maps, a HOWTO: weaving a web",
    "authors"     : ["paul-cochrane"],
    "date"        : "2025-05-18T07:55:16",
    "tags"        : [],
    "draft"       : false,
    "image"       : "/images/building-map-tube-maps-a-howto/tram-network-hannover-linie1-linie7-cover.png",
    "thumbnail"   : "/images/building-map-tube-maps-a-howto/Swiss-Cottage-Underground-Station-Jubilee-Line_Hugh-Llewelyn_flickr-To-Trains.jpg",
    "description" : "Weaving more tram lines into our Map::Tube::<*> map.",
    "categories"  : "tutorials",
    "canonicalURL": "https://peateasea.de/building-map-tube-whatever-maps-a-howto-weaving-a-web/"
  }

A real tram network is more like a web of interconnecting lines.  Although
more lines mean more complexity, they allow
[`Map::Tube`](https://metacpan.org/pod/Map::Tube) to better reflect reality
and thus be more useful and interesting.

[Last
time](/article/building-map-tube-maps-a-howto-extending-the-network/),
we extended the tram network and created a graph of its stations.  This time
we're adding a new line to carefully make the network more "real".   At the
end, we'll add colour to the lines so that it's easier to tell them apart.

## Weaving a web

A railway network with only one line is a bit boring, so it's high time we
added another.  Let's now add [`Linie 7` from `Wettbergen` to
`Misburg`](https://www.uestra.de/fahrplan/linien-fahrplaene/uebersichts-und-netzplaene/).
This line also goes through `Hauptbahnhof`, so we can keep that station as a
central node in the network.

The pace might seem slow and that is intentional: we need to add more
complexity to the map and doing so with care and patience will help keep the
complexity under control.  I also want to show how the elements of a
`Map::Tube` map fit together while also not overwhelming you.  My hope is
that a slower pace will help the material to be more easily digestible.
Fortunately, this post is shorter than the others, so even with the slower
pace it won't take long to get through.

### Devising a plan

A little bit of preparation will help us create the new line.  Here's my
plan for the list of stations, the IDs and the links between them.

| Station      | ID | Links       |
|--------------|----|-------------|
| Wettbergen   | H6 | H7          |
| Allerweg     | H7 | H6,H3       |
| Hauptbahnhof | H3 | H2,H4,H7,H8 |
| Vier Grenzen | H8 | H3,H9       |
| Misburg      | H9 | H8          |

Again, I've chosen the westernmost station as the first station on the line.
Also, I'm continuing the ID numbers from where I left off with `Linie 1`.
When building the complete network, one would likely continue incrementing
the IDs by labelling stations along `Linie 2`, `Linie 3`, etc.  Yet, this
isn't so interesting for Hannover and this HOWTO because `Linie 2` shares
most of the same stations as `Linie 1`.  Hence, I decided to extend the
network in our example with `Linie 7`.

Note that `Hauptbahnhof` retains the ID it had before, but it ends up having
more links because of the extra stations now connected to it.

### Driving the changes

How to drive this change with tests?  Well, we now expect there to be two
lines.  Thus, we can call the `get_lines()` method on a
`Map::Tube::Hannover` object and we should see two objects returned.  We can
also test that a route from `Wettbergen` to `Misburg` contains the stations
we expect.  That sounds like a plan!

There's a fair bit of work involved, so we'd best get started.  Add a check
for the expected number of lines to the `t/map-tube-hannover.t` test file
after the validation tests and before the routes tests:

```perl
my $num_lines = scalar @{$hannover->get_lines};
is( $num_lines, 2, "Number of lines in network correct" );
```

Note that the `get_lines()` call returns a reference to an array, hence we
have to dereference it to get an array so that we can count its items.

We expect the test to fail and to tell us that there's currently only one
line:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/?
#   Failed test 'Number of lines in network correct'
#   at t/map-tube-hannover.t line 15.
#          got: '1'
#     expected: '2'
# Looks like you failed 1 test of 4.
t/map-tube-hannover.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/4 subtests

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 256 (exited 1) Tests: 4 Failed: 1)
  Failed test:  3
  Non-zero exit status: 1
Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.55 cusr  0.05 csys =  0.64 CPU)
Result: FAIL
```

Expectations met!  To fix this, we need to a new line to our map file.
Extend the `lines` attribute to look like this:

```json
    "lines" : {
        "line" : [
            {
                "id" : "L1",
                "name" : "Linie 1"
            },
            {
                "id" : "L7",
                "name" : "Linie 7"
            }
        ]
    },
```

Running the tests gives:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t ..     # Line id L7 consists of 0 separate components

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Line id L7 defined but serves no stations (not even as other_link)

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Looks like you failed 2 tests of 14.
t/map-tube-hannover.t .. 1/?
#   Failed test 'ok_map_data'
#   at t/map-tube-hannover.t line 11.
get_lines() returns incorrect line entries at t/map-tube-hannover.t line 12.

#   Failed test at t/map-tube-hannover.t line 12.
#          got: 0
#     expected: 1

#   Failed test 'Number of lines in network correct'
#   at t/map-tube-hannover.t line 15.
#          got: '1'
#     expected: '2'
# Looks like you failed 3 tests of 4.
t/map-tube-hannover.t .. Dubious, test returned 3 (wstat 768, 0x300)
Failed 3/4 subtests

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 768 (exited 3) Tests: 4 Failed: 3)
  Failed tests:  1-3
  Non-zero exit status: 3
Files=1, Tests=4,  1 wallclock secs ( 0.03 usr  0.00 sys +  0.50 cusr  0.07 csys =  0.60 CPU)
Result: FAIL
```

Oh dear, that doesn't look good.

The main issues here are at the top of the error messages; in particular:

```
Line id L7 consists of 0 separate components
```

and

```
Line id L7 defined but serves no stations (not even as other_link)
```

These errors are our validation tests telling us that `Linie 7` isn't
connected to anything.  This is a good thing because it tells us that our
validation tests are protecting us from any silly mistakes we might make in
the future.

The remaining errors look like follow-on errors from these, so it's best to
focus on the first ones when debugging.

### Stitching things together

So, how do we move forward?  We could try adding only the `Wettbergen`
station and see if that helps.  But that means it won't be linked to
anything, which will still raise an error.  How about we add the first two
stations on `Linie 7` and link them to each other?  Let's give that a go.
Add the following entries after `Sarstedt` in the map file:

```json
            {
                "id" : "H6",
                "name" : "Wettbergen",
                "line" : "L7",
                "link" : "H7"
            },
            {
                "id" : "H7",
                "name" : "Allerweg",
                "line" : "L7",
                "link" : "H6"
            }
```

The test suite now says this:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t ..     # Map has 2 separate components; e.g., stations with ids H1, H6

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Looks like you failed 1 test of 14.
t/map-tube-hannover.t .. 1/?
#   Failed test 'ok_map_data'
#   at t/map-tube-hannover.t line 11.
# Looks like you failed 1 test of 4.
t/map-tube-hannover.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/4 subtests

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 256 (exited 1) Tests: 4 Failed: 1)
  Failed test:  1
  Non-zero exit status: 1
Files=1, Tests=4,  1 wallclock secs ( 0.03 usr  0.01 sys +  0.54 cusr  0.05 csys =  0.63 CPU)
Result: FAIL
```

The issue here is:

```
Map has 2 separate components; e.g., stations with ids H1, H6
```

Wow!  The validation tests check everything very thoroughly!  That's
impressive!

### Making the connection

Ok, so we didn't get the tests to pass, but things look much better.  Let's
connect `Linie 7` to `Linie 1` by adding a link to `Hauptbahnhof` and see if that
makes things work.  Change the entry for `Allerweg` to:

```json
            {
                "id" : "H7",
                "name" : "Allerweg",
                "line" : "L7",
                "link" : "H3,H6"
            }
```

which adds a link to `Hauptbahnhof`.  Now change the entry for
`Hauptbahnhof` to:

```json
            {
                "id" : "H3",
                "name" : "Hauptbahnhof",
                "line" : "L1,L7",
                "link" : "H2,H4,H7"
            },
```

which links to the `Allerweg` station and adds `Hauptbahnhof` to `Linie 7`,
thus connecting the two lines as expected by our validation tests.

How did we do?

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=4,  1 wallclock secs ( 0.04 usr  0.01 sys +  0.57 cusr  0.02 csys =  0.64 CPU)
Result: PASS
```

Brilliant!  We've got passing tests again!  I love it when a test suite passes!

![Hannibal from the A-team saying I love it when a test suite
passes!](/images/building-map-tube-maps-a-howto/i-love-it-when-a-test-suite-passes.jpg)

### Completing the line

We've now got the confidence to add the remaining stations for `Linie 7` to
the map.  Again, we want to drive the change with a test, so we add a test
for a route from `Wettbergen` to `Misburg` to our test suite like so:

```perl
my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Kabelkamp,Hauptbahnhof,Laatzen,Sarstedt",
    "Route 7|Wettbergen|Misburg|Wettbergen,Allerweg,Hauptbahnhof,Vier Grenzen,Misburg",
);

ok_map_routes($hannover, \@routes);
```

This test fairly obviously fails because we've not yet added all stations on
`Linie 7`:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/? Map::Tube::get_node_by_name(): ERROR: Invalid Station Name [Misburg]. (status: 101) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Map/Tube.pm on line 897
# Tests were run but no plan was declared and done_testing() was not seen.
# Looks like your test exited with 255 just after 3.
t/map-tube-hannover.t .. Dubious, test returned 255 (wstat 65280, 0xff00)
All 3 subtests passed

Test Summary Report
-------------------
t/map-tube-hannover.t (Wstat: 65280 (exited 255) Tests: 3 Failed: 0)
  Non-zero exit status: 255
  Parse errors: No plan found in TAP output
Files=1, Tests=3,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.55 cusr  0.05 csys =  0.64 CPU)
Result: FAIL
```

We expected the tests to fail, so all's good.  The error message also looks
like the kind of error we should be expecting.  Now we can extend `Linie 7`
to the end of the line.  Adding these two entries after `Allerweg`:

```json
            {
                "id" : "H8",
                "name" : "Vier Grenzen",
                "line" : "L7",
                "link" : "H3,H9"
            },
            {
                "id" : "H9",
                "name" : "Misburg",
                "line" : "L7",
                "link" : "H8"
            }
```

we find that the tests pass again:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=4,  1 wallclock secs ( 0.03 usr  0.00 sys +  0.55 cusr  0.06 csys =  0.64 CPU)
Result: PASS
```

Woohoo!  It's time for another commit!

```shell
$ git commit -m "Add Linie 7 to network via Hauptbahnhof" share/hannover-map.json t/map-tube-hannover.t
[main f4c6a97] Add Linie 7 to network via Hauptbahnhof
 2 files changed, 35 insertions(+), 3 deletions(-)
```

### Graphing the network

What does our map now look like?  Let's run `map2image.pl` and find out:

```shell
$ perl bin/map2image.pl
```

which gives:

![Graphviz graph showing nodes and their connectivity in the Hannover tram network for Linie 1 and Linie 7](/images/building-map-tube-maps-a-howto/map-tube-hannover-linie-1-and-7.png)

If you're used to the usual way railway networks are visually
presented,[^london-tube] then this output could
be a bit confusing.  However, if you stare at it, you'll realise that the
stations and how they're connected do reflect the same connectivity as in
[the Üstra "Netzplan U"
map](https://www.uestra.de/fahrplan/linien-fahrplaene/uebersichts-und-netzplaene/).
The layout is just a bit different, that's all.  The code that automatically
generates the graph doesn't have the same context as the Üstra map does,
hence, at first glance, things will look a bit odd.

[^london-tube]: The London Underground network is *the* classic example.

## A splash of colour

We can make the individual lines in the graph stand out a bit more by
assigning colours to them.  One sets the colour for a line by setting its
`color` attribute (note the spelling *without* the 'u').  The colour can be
set either as an [RGB hex
triple](https://en.wikipedia.org/wiki/RGB_color_model#Numeric_representations)
or as a name defined in the [`color-names.txt` file in the `Map::Tube`
distribution](https://metacpan.org/release/MANWAR/Map-Tube-4.03/source/share/color-names.txt).

Ok, let's get back to adding colour to our lines.  The Üstra "Netzplan U"
uses red for `Linie 1` and blue for `Linie 7`.  Let's use these colour names
in our map:

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
            }
        ]
    },
```

Re-running `bin/map2image.pl` gives this image:

![Graphviz graph showing nodes and their connectivity in the Hannover tram network for Linie 1 (red) and Linie 7 (blue)](/images/building-map-tube-maps-a-howto/map-tube-hannover-linie-1-and-7-colour.png)

Now it's clearer which line is which.  Also, it's clearer that `Hauptbahnhof`
is connected to both because it kept its black colour.

Let's commit this change quickly and finish up for today.

```shell
$ git commit share/hannover-map.json -m "Add colour to lines in the network
>
> To make the individual lines more obvious in the graphical output, we've
> set the colours of the (currently two) lines to match the colours in the
> official Üstra tram network map."
[main d592035] Add colour to lines in the network
 1 file changed, 4 insertions(+), 2 deletions(-)
```

## Wrapping up

A shorter post this time.[^no-verb]  Hopefully, I avoided both over- and
under-whelming any readers!

[^no-verb]: This sentence, no verb. Or: [This sentence intentionally left verbless](https://en.wikipedia.org/wiki/Intentionally_blank_page).

We used test-driven development to add a new line to our example network and
then added colour, making it easier to tell the lines apart.  Also, [we were
consistent in our Git
usage](https://github.com/paultcochrane/MapTubeHannoverHowTo), ensuring that
we committed atomic, logically cohesive changes.  We also made sure that
each change is a working state of the project, as verified by the test
suite.

Next time, we'll add more lines to the network which, will allow us to plan
routes between stations.

Originally posted on
[https://peateasea.de](https://peateasea.de/building-map-tube-whatever-maps-a-howto-weaving-a-web/).

Image credits: [Hannover coat of arms: Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Coat_of_arms_of_Hannover.svg),
[U-Bahn symbol: Wikimedia Commons](https://de.m.wikipedia.org/wiki/Datei:U-Bahn.svg),
[Langenhagen coat of arms: Wikimedia Commons](https://commons.wikimedia.org/wiki/File:DEU_Langenhagen_COA.svg),
[Sarstedt coat of arms: Wikimedia Commons](https://commons.wikimedia.org/wiki/File:DE-NI_03-2-54-028_Sarstedt_COA.svg),
[Wettbergen coat of arms](https://de.m.wikipedia.org/wiki/Datei:Wappen_Wettbergen.jpg),
[Misburg coat of arms](https://de.m.wikipedia.org/wiki/Datei:Wappen_Misburg.png)

Thumbnail credits: [Swiss Cottage Underground Station (Jubilee
Line)](https://www.flickr.com/photos/58433307@N08/53726096544) by [Hugh
Llewelyn](https://www.flickr.com/photos/camperdown/)
