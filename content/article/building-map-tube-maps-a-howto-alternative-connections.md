
  {
    "title"       : "Building Map::Tube::<*> maps, a HOWTO: alternative connections",
    "authors"     : ["paul-cochrane"],
    "date"        : "2025-06-03T13:09:47",
    "tags"        : [],
    "draft"       : false,
    "image"       : "/images/building-map-tube-maps-a-howto/tram-network-hannover-linie1-linie4-linie7-linie10-cover.png",
    "thumbnail"   : "/images/building-map-tube-maps-a-howto/Swiss-Cottage-Underground-Station-Jubilee-Line_Hugh-Llewelyn_flickr-To-Trains.jpg",
    "description" : "Handling alternative node connections in a Map::Tube::<*> map.",
    "categories"  : "tutorials",
    "canonicalURL": "https://peateasea.de/building-map-tube-whatever-maps-a-howto-alternative-connections/"
  }

[In the previous
post](https://peateasea.de/building-map-tube-whatever-maps-a-howto-routing-relative-reality/),
we created a network close enough to reality so that finding routes between
stations was possible and sufficiently interesting.  In this final post in
the series, we're going to see how to handle indirect connections between
stations.

## Alternative connections

Not all stations in the Hannover tram network are directly connected.  A
good example is the line `Linie 10`, which starts at the bus station next to
the main train station and has the station name
`Hauptbahnhof/ZOB`.[^hbf-zob]  As its name suggests, this station is
associated with the station `Hauptbahnhof`.  Although they're very close to
one another, they're not connected directly. You have to cross a road to get
to `Hauptbahnhof` from the `Hauptbahnhof/ZOB` tram stop.  A routing
framework such as [`Map::Tube`](https://metacpan.org/pod/Map::Tube) should
allow such indirect connections, thus joining `Linie 10` to the rest of the
network.

So how do we connect such indirectly connected stations?
[`Map::Tube`](https://metacpan.org/pod/Map::Tube) has a solution: the
`other_link` attribute.

[^hbf-zob]: For those wondering who don't speak German: Hauptbahnhof means
    "main train station" or equivalently "central train station".  ZOB is
    the abbreviation of Zentralomnibusbahnhof, which looks like it literally
    translates as "central omnibus train station", but really means "central
    bus station".

### Planning a path

To see this attribute in action, let's add the line `Linie 10` to the
network and connect `Hauptbahnhof` to `Hauptbahnhof/ZOB` with an
`other_link`.  Then we can try creating a route from `Ahlem` (at the end of
`Linie 10`) to `Misburg` (at the end of `Linie 7`) and see if our new
connection type works as we expect.  Let's get cracking!

Here's the planned list of stations, IDs and links:

| Station          | ID  | Links    |
|------------------|-----|----------|
| Ahlem            | H15 | H16      |
| Leinaustraße     | H16 | H15, H17 |
| Hauptbahnhof/ZOB | H17 | H16      |

`Ahlem` is the westernmost station, hence it's the "first" station along
`Linie 10`.  Therefore, it gets the next logical ID carrying on from where we
left off in the map file.

### Letting the tests lead the way

As we've done before, we drive these changes by leaning on our test suite.
We want to have four lines in the network now, hence we update our number of
lines test like so:

```perl
my $num_lines = scalar @{$hannover->get_lines};
is( $num_lines, 4, "Number of lines in network correct" );
```

We can test that we've added the line and its stations correctly by checking
for the expected route.  Our routes tests are now:

```perl
my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Kabelkamp,Hauptbahnhof,Kroepcke,Laatzen,Sarstedt",
    "Route 4|Garbsen|Roderbruch|Garbsen,Laukerthof,Kroepcke,Kantplatz,Roderbruch",
    "Route 7|Wettbergen|Misburg|Wettbergen,Allerweg,Kroepcke,Hauptbahnhof,Vier Grenzen,Misburg",
    "Route 10|Ahlem|Hauptbahnhof/ZOB|Ahlem,Leinaustraße,Hauptbahnhof/ZOB",
);

ok_map_routes($hannover, \@routes);
```

where we've added the expected list of stations for `Linie 10` to the end of
the `@routes` list.

Let's make sure the tests fail as expected:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/?
#   Failed test 'Number of lines in network correct'
#   at t/map-tube-hannover.t line 15.
#          got: '3'
#     expected: '4'
```

Yup, that looks good.  We expect four lines but only have three.  Let's add
the line to our maps file now:

```json
{
    "id" : "L10",
    "name" : "Linie 10",
    "color" : "PaleGreen"
}
```

where I've guessed that the line colour used in the [Üstra "Netzplan
U"](https://www.uestra.de/fahrplan/linien-fahrplaene/uebersichts-und-netzplaene/)
is pale green.

### A line takes shape

Re-running the tests, we have:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t ..     # Line id L10 consists of 0 separate components

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Line id L10 defined but serves no stations (not even as other_link)

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Looks like you failed 2 tests of 14.
```

Again, we expected this as this line doesn't have any stations yet.  Let's
add them to the map file.

```json
{
    "id" : "H15",
    "name" : "Ahlem",
    "line" : "L10",
    "link" : "H16"
},
{
    "id" : "H16",
    "name" : "Leinaustraße",
    "line" : "L10",
    "link" : "H15,H17"
},
{
    "id" : "H17",
    "name" : "Hauptbahnhof/ZOB",
    "line" : "L10",
    "link" : "H16"
}
```

This time, we expect the tests to tell us that this line isn't connected to
the network.  Sure enough:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t ..     # Map has 2 separate components; e.g., stations with ids H1, H15

    #   Failed test 'Hannover'
    #   at
/home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
    # Looks like you failed 1 test of 14.
```

The error message

```
Map has 2 separate components; e.g., stations with ids H1, H15
```

means that the line isn't connected to any of the other lines already
present because the map contains separate components.

### Consider the alternative

To fix this, let's change the entry for `Hauptbahnhof/ZOB` to use the
`other_link` attribute and see if that helps:

```json
{
    "id" : "H17",
    "name" : "Hauptbahnhof/ZOB",
    "line" : "L10",
    "link" : "H16",
    "other_link" : "Street:H3"
}
```

Oddly, the tests still raise an error:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t ..     # Map has 2 separate components; e.g., stations with ids H1, H15

    #   Failed test 'Hannover'
    #   at /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm line 196.
t/map-tube-hannover.t .. 1/?     # Looks like you failed 1 test of 14.

#   Failed test 'ok_map_data'
#   at t/map-tube-hannover.t line 11.
```

Oh, that's right!  We've only linked `Hauptbahnhof/ZOB` to `Hauptbahnhof`;
we need to add the `other_link` in the other direction as well.  We could
have debugged this situation by running `bin/map2image.pl` and inspecting
the generated image.  Yet [we've seen this issue
before](https://peateasea.de/building-map-tube-whatever-maps-a-howto-routing-relative-reality/#visual-debugging)
and can call on experience instead.

We can fix the problem by updating the entry for `Hauptbahnhof` like so:

```json
{
    "id" : "H3",
    "name" : "Hauptbahnhof",
    "line" : "L1,L7",
    "link" : "H2,H8,H12",
    "other_link" : "Street:H17"
},
```

Now the tests still fail, even though we thought we'd fixed everything:

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. 1/? Map::Tube::get_node_by_name(): ERROR: Invalid Station Name [Leinaustraße]. (status: 101) file /home/cochrane/perl5/perlbrew/perls/perl-5.38.3/lib/site_perl/5.38.3/Test/Map/Tube.pm on line 1434
# Tests were run but no plan was declared and done_testing() was not seen.
```

What's going wrong?

Oh, yeah, [the sharp-s (ß) character messes with the routing
tests](https://peateasea.de/building-map-tube-whatever-maps-a-howto-routing-relative-reality/#schei-encoding)
as we saw in the previous article in the series.

Let's replace ß with the equivalent "double-s" for the `Leinaustraße`
station.  First in the map file:

```json
{
    "id" : "H16",
    "name" : "Leinaustrasse",
    "line" : "L10",
    "link" : "H15,H17"
},
```

and then in the routes tests:

```perl
my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Kabelkamp,Hauptbahnhof,Kroepcke,Laatzen,Sarstedt",
    "Route 4|Garbsen|Roderbruch|Garbsen,Laukerthof,Kroepcke,Kantplatz,Roderbruch",
    "Route 7|Wettbergen|Misburg|Wettbergen,Allerweg,Kroepcke,Hauptbahnhof,Vier Grenzen,Misburg",
    "Route 10|Ahlem|Hauptbahnhof/ZOB|Ahlem,Leinaustrasse,Hauptbahnhof/ZOB",
);

ok_map_routes($hannover, \@routes);
```

How did we do?

```shell
$ prove -lr t/map-tube-hannover.t
t/map-tube-hannover.t .. ok
All tests successful.
Files=1, Tests=4,  0 wallclock secs ( 0.03 usr  0.00 sys +  0.55 cusr  0.05 csys =  0.63 CPU)
Result: PASS
```

Success! :tada:

### A view from the top

We've reached the end of the development phase of the HOWTO.  At this point,
the complete test file (`t/map-tube-hannover.t`) looks like this:

```perl
use strict;
use warnings;

use Test::More;

use Map::Tube::Hannover;
use Test::Map::Tube;

my $hannover = Map::Tube::Hannover->new;

ok_map($hannover);
ok_map_functions($hannover);

my $num_lines = scalar @{$hannover->get_lines};
is( $num_lines, 4, "Number of lines in network correct" );

my @routes = (
    "Route 1|Langenhagen|Sarstedt|Langenhagen,Kabelkamp,Hauptbahnhof,Kroepcke,Laatzen,Sarstedt",
    "Route 4|Garbsen|Roderbruch|Garbsen,Laukerthof,Kroepcke,Kantplatz,Roderbruch",
    "Route 7|Wettbergen|Misburg|Wettbergen,Allerweg,Kroepcke,Hauptbahnhof,Vier Grenzen,Misburg",
    "Route 10|Ahlem|Hauptbahnhof/ZOB|Ahlem,Leinaustrasse,Hauptbahnhof/ZOB",
);

ok_map_routes($hannover, \@routes);

done_testing();
```

with the other Perl files remaining unchanged.

The full JSON content of the map file is too long to display here, but if
you're interested, you can see it in [the Git repository accompanying this
article series](https://github.com/paultcochrane/MapTubeHannoverHowTo/).

To get a feeling for what the network looks like, try running
`bin/map2image.pl`.  Doing so, you'll find a network graph similar to this:

![Graphviz graph showing nodes and their connectivity in the Hannover tram network for Linie 1, 4, 7 and 10](/images/building-map-tube-maps-a-howto/map-tube-hannover-linie-1-4-7-and-10.png)

Although the graph doesn't highlight the indirect link, it does show the
connectivity in the entire map and gives us a high-level view of what we've
achieved.

### Taking the indirect route

With our latest map changes in hand, we can find our way from `Ahlem` to
`Misburg`:

```shell
$ perl bin/get_route.pl Ahlem Misburg
Ahlem (Linie 10), Leinaustrasse (Linie 10), Hauptbahnhof/ZOB (Linie 10, Street), Hauptbahnhof (Linie 1, Linie 7, Street), Vier Grenzen (Linie 7), Misburg (Linie 7)
```

Wicked!  It worked!  And it got the connection from `Hauptbahnhof/ZOB` to
`Hauptbahnhof` right.  Nice!

We can also plan more complex routes, such as travelling from `Ahlem` to
`Roderbruch`:

```shell
$ perl bin/get_route.pl Ahlem Roderbruch
Ahlem (Linie 10), Leinaustrasse (Linie 10), Hauptbahnhof/ZOB (Linie 10, Street), Hauptbahnhof (Linie 1, Linie 7, Street), Kroepcke (Linie 1, Linie 4, Linie 7), Kantplatz (Linie 4), Roderbruch (Linie 4)
```

Looking closely, we find that we have to change at `Hauptbahnhof` and then
again at `Kroepcke` to reach our destination.  Comparing this with the
[Üstra "Netzplan
U"](https://www.uestra.de/fahrplan/linien-fahrplaene/uebersichts-und-netzplaene/)
we can see (for the simpler map created here) that this matches reality.
Brilliant!

Let's commit that change and give ourselves a pat on the back for a job well
done!

```shell
$ git ci share/hannover-map.json t/map-tube-hannover.t -m "Add Linie 10 to network
>
> The most interesting part about this change is the use of other_link
> to ensure that Hauptbahnhof/ZOB and Hauptbahnhof are connected to one
> another and hence Linie 10 is connected to the rest of the network
> and routes can be found from Linie 10 to other lines."
[main bc34daa] Add Linie 10 to network
 2 files changed, 29 insertions(+), 3 deletions(-)
```

## Here, at the end of all things

Welcome to the end of the article series!  Thanks for staying until the end.
:slightly_smiling_face:

Wow, that was quite a lot of work!  But it was fun, and we learned a lot
along the way.  For instance, we've learned:

  - [how to start a Perl module from scratch](https://peateasea.de/building-map-tube-whatever-maps-a-howto-first-steps/#creating-a-stub-module),
  - [how a `Map::Tube` map is structured](https://peateasea.de/building-map-tube-whatever-maps-a-howto-extending-the-network/#structural-understanding),
  - how to build a railway network using `Map::Tube` in a test-driven
    manner,
  - how to use Git as a natural element of development flow,
  - [how to visualise the graph of a `Map::Tube` network](https://peateasea.de/building-map-tube-whatever-maps-a-howto-extending-the-network/#seeing-the-bigger-picture),
  - and [how to find routes from one station to another](https://peateasea.de/building-map-tube-whatever-maps-a-howto-routing-relative-reality/#getting-to-the-route-of-the-problem).

This discussion has hopefully given you the tools you need to create your
own `Map::Tube` map.  There's so much more you can do with `Map::Tube`, so
it's a good idea to spend some time browsing the
[documentation](https://metacpan.org/pod/Map::Tube).  Therein you will find
many nuggets of information and hints for ideas of things to play with.

I wish you the best of luck and have fun!
