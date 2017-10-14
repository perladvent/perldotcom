{
   "image" : null,
   "categories" : "Community",
   "tags" : [
      "wiki-openguides"
   ],
   "draft" : null,
   "date" : "2003-10-31T00:00:00-08:00",
   "slug" : "/pub/2003/10/31/openguides.html",
   "title" : "Open Guides",
   "authors" : [
      "kake-pugh"
   ],
   "thumbnail" : "/images/_pub_2003_10_31_openguides/111-openguides.gif",
   "description" : " First, a disclaimer. I'm not a wiki celebrity. I don't look good in StudlyCaps. I'm not part of the wiki culture — I've never contributed to Ward's Wiki, never used TWiki, am baffled by MoinMoin, and every time I..."
}





First, a disclaimer.

I'm not a wiki celebrity. I don't look good in StudlyCaps. I'm not part
of the wiki culture — I've never contributed to [Ward's
Wiki](http://c2.com/cgi/wiki?WelcomeVisitors), never used
[TWiki](http://twiki.org/), am baffled by
[MoinMoin](http://twistedmatrix.com/users/jh.twistd/moin/moin.cgi/FrontPage),
and every time I look at [UseMod](http://www.usemod.com/cgi-bin/wiki.pl)
code, my brain turns to mashed banana. Most wiki people probably have no
idea who I am.

Having said that, I'm going to spend 2,500 words or so advocating the
possibilities of Ward Cunningham's simple, potent idea, and explaining
how I and a couple of other [Perlmongers](http://london.pm.org) have
applied it to create what I think is one of the most exciting Perl
applications currently in existence — OpenGuides.

### Beginnings

grubstreet, the predecessor to OpenGuides, was conceived in early 2002
when I asked Earle Martin whether he knew of a London wiki:

    It seems that my friend's Wiki is running UseModWiki; I think I rather
    like it.  It would be good if there was one of these for info about
    London; do you know if anyone's done that?  Things like which pubs
    serve food and good beer, etc.; which is the best end of the platform
    to stand at to get a seat (discussed this kind of thing with blech
    recently).

Earle was enthusiastic and made it so. We both got very excited and
started filling the thing with content. Wiki makes this easy! You're
reading a web page and spot something that's wrong or missing. Click the
"edit" link, add your comment, and it's right there.

### Continuings

It didn't take long before we started bumping our heads against the
limitations of the `usemod` software. Even leaving aside its tendency to
clamp down on its (custom-format) flat-file database and refuse anyone
edit access, I found myself writing umpteen screenscrapers to do simple
things like find a nice pub in Soho. I hate screenscraping, but I love
my beer.

We tried to patch and amend `usemod`. We tried very hard. Ivor Williams,
in particular, spent a lot of time in its guts. I decided in the end
that writing software should only hurt some of the time, and after
several beers one night, made a pact with Chris Ball that grubstreet's
software would be rewritten in Real Perl. Chris held me to it, and a
CPAN-friendly wiki toolkit —
[CGI::Wiki](http://search.cpan.org/~kake/CGI-Wiki/) — resulted. Once we
had that to build on, we started on the CGI script that eventually
turned into [the OpenGuides
distribution](http://search.cpan.org/~kake/OpenGuides/).

### What It Says on the Tin

> [OpenGuides](http://openguides.org/) is a complete web application for
> managing a collaboratively written guide to a city or town.

Install OpenGuides, and what you get is a blank framework waiting for
you to put content into it.

+-----------------------------------------------------------------------+
| <div class="secondary">                                               |
|                                                                       |
| There's an opportunity right here for anyone wanting to join the      |
| project team. Write a set of pages for bundling with new installs of  |
| the OpenGuides software — how to use the Guide, how to format your    |
| entries, maybe stub pages for things that all cities have in common,  |
| maybe a category framework for transport pages — you're bound to be   |
| able to come up with better ideas than those of us who've been using  |
| the software for ages and are blind to its confusing spots.           |
|                                                                       |
| </div>                                                                |
+-----------------------------------------------------------------------+

### Just a Skeleton, But a Damned Sturdy One

No, we didn't just give you the equivalent of an empty directory to put
your HTML files into. Start adding pages and you'll see.

Suppose I want to add a page about my local pub. I'll click on "Create a
new page" and type in the page name. What should I call it? Well, this
is a new OpenGuides install, with no established conventions, so I could
call it "The Drapers Arms", "Drapers Arms", "The Drapers Arms
(Islington)", or whatever. I just need to keep in mind that the name
needs to be unique, so if I expect there to be more than one Drapers
Arms in my city, I really should add some other kind of identifying
information. [The Open Guide to London](http://london.openguides.org/)
has a convention of including the postcode — thus "Drapers Arms, N1
1ER".

OK, so I've done that, and now I'm presented with an editing form with
several boxes for me to type into. The first, Content, is a freeform box
where I can put any information that doesn't fit into the particular
boxes below.

Locales and Categories are the next boxes. I can put whatever I like
into these, and so can later visitors to this Guide. I don't need to
decide right now on a useful way to divide my city into locales; it'll
just emerge from the aggregated opinion of all the people who
contribute. I can always come back to this, my first page, in a few
months and add any later-defined categories or locales that seem to
apply to it. Or I may not need to; someone else may have got around to
it before me.

Locales and categories are excellent ways to make sure that your newly
added content doesn't drift off into a decoupled purgatory of unlinked
pages. Just add the Pubs category and the Islington locale to the
Drapers Arms page, and anyone doing a search — whether a simple
type-into-box or a directed
[locale](http://london.openguides.org/index.cgi?action=index;index_type=locale;index_value=Islington)
or
[category](http://london.openguides.org/index.cgi?action=index;index_type=category;index_value=Pubs)
search — will find it.

Next, we get a set of smaller boxes for entering things like
more-detailed location information, contact information, and opening
hours. These boxes may be completely irrelevant to many, most, or all
pages in your Guide. That's OK. They're optional. But if you *do* fill
them in, you get to play with what I feel is one of the most innovative,
yet simple, features of OpenGuides — [find me everything within half a
kilometre of Piccadilly Circus Tube
station](http://london.openguides.org/index.cgi?distance_in_metres=500&id=Piccadilly+Circus+Station&action=find_within_distance&Go=Go).
Please. Because my feet hurt and I could murder a glass of wine.

### Customization and Extension

I meant it when I said I wanted to be able to find pubs. I want to find
all pubs in Notting Hill that serve food and have a beer garden. The
Open Guide to London must have this information! There's no obvious way
to get to it directly, though. I may have to write some code.

Given that I'm one of the admins, I have access to the database on the
server — so I can call the CGI::Wiki `list_nodes_by_metadata` method
directly to find all pages in Category Pubs, Locale Notting Hill, and
Category Pub Food.

I wrote a CGI script to take in options for selecting pubs and output
results. It's very useful, so will be in one of the next few official
OpenGuides releases. Here's an excerpt. Note that the locale and
categories are simply stored as CGI::Wiki metadata. Note also the use of
CGI::Wiki::Plugin::Locator::UK to allow searching by nearest Tube
station. You could easily adapt this if you live in a city where people
navigate by some other kind of landmark.

    my %possible_features = (
        "beer gardens"    => "Has beer garden",
        "function room"   => "Has function room",
        "good beer guide" => "Appears in the CAMRA Good Beer Guide",
        "real cider"      => "Serves real cider",
        "belgian beer"    => "Serves Belgian beer",
        "pub food"        => "Serves food of some kind",
    );

    if ( $action eq "search" ) {
        my @locales       = CGI::param( "locale" );
        my @features      = CGI::param( "feature" );
        my @tube_stations = CGI::param( "tube" );

        # Ignore the blank "any locales" option.
        @locales = grep { $_ } @locales;

        # Ensure that we only look for 'allowed' features.
        @features = grep { $possible_features{$_} } @features;

        # Ensure that we only look for extant Tube stations.
        my %is_tube = map { $_ => 1 } list_tube_stations();
        @tube_stations = grep { $is_tube{$_} } @tube_stations;

        # Grab all the pubs, to start with.
        my @pubs = $wiki->list_nodes_by_metadata(
                       metadata_type => "category",
                       metadata_value => "pubs",
                       ignore_case   => 1,
        );

        # Filter by locale if specified.
        if ( scalar @locales > 0 ) {
            my @in_locale;
            foreach my $locale ( @locales ) {
                push @in_locale,
                     $wiki->list_nodes_by_metadata(
                         metadata_type  => "locale",
                         metadata_value => $locale,
                         ignore_case    => 1,
                     );
            }
            my %in_locale_hash = map { $_ => 1 } @in_locale;
            @pubs = grep { $in_locale_hash{$_} } @pubs;
        }

        # Filter by Tube station if specified.
        if ( scalar @tube_stations > 0 ) {
            my $locator = CGI::Wiki::Plugin::Locator::UK->new;
            $wiki->register_plugin( plugin => $locator );
            my @near_station;
            foreach my $station ( @tube_stations ) {
                push @near_station,
                    $locator->find_within_distance(
                        node   => $station . " Station",
                        metres => 600,
                    );
             }
             my %near_station_hash = map { $_ => 1 } @near_station;
             @pubs = grep { $near_station_hash{$_} } @pubs;
        }

        # Filter by features if specified.
        if ( scalar @features > 0 ) {
            my %has_feature = map { $_ => [] } @pubs;
            foreach my $feature ( @features ) {
                my @has_this_feature = $wiki->list_nodes_by_metadata(
                         metadata_type  => "category",
                         metadata_value => $feature,
                         ignore_case    => 1,
                     );
                foreach my $pub ( @has_this_feature ) {
                    push @{ $has_feature{$pub} }, $feature;
                }
            }
            # Only keep pubs that have *all* the requested features.
            @pubs = grep { scalar @{ $has_feature{$_} } == scalar @features }
                         @pubs;
        }

        show_results(
                      pubs          => \@pubs,
                      locales       => \@locales,
                      tube_stations => \@tube_stations,
                      features      => [ @possible_features{ @features } ],
                    );

### You Can Do It, Too

Suppose I'd had the idea for this directed pub search but didn't have
direct access to any OpenGuides data store? No problem — I can play with
the RDF interface. Most OpenGuides pages have a link to an RDF version,
and this includes the auto-generated pages like locale or category
search results.

I can send a query like
<http://london.openguides.org/index.cgi?action=index;index_type=category;index_value=Pubs;format=rdf>
and then use RDF::Core::Parser to parse the returned RDF/XML and get the
data that otherwise would have required CGI::Wiki calls.

The RDF interface isn't too well advertised. A list of places where any
kind of link to an RDF version is missing would be most useful.

Given the simple data model of an OpenGuides page, such an external
add-on would be trivial to incorporate into the core distribution. So
once you've written one, send it to us.

The RDF interface is also ideal for people interested in writing IRC
bots:

    15:12 <Kake> grotbot: things in Chinatown
    15:12 <grotbot> OK, working on it
    <grotbot> Kake: things in Chinatown: Crispy Duck, W1D 6PR; De Hems,
              W1D 5BW; Golden Harvest, WC2H 7BE; HK Diner; Hung's, W1D 6PR;
              Misato, W1D 6PG; Tai, W1D 4DH; Tokyo Diner; Zipangu, WC2H 7JJ

### Caveats

The OpenGuides software is still young. The install procedure, in
particular, needs a good going-over, plus some of the location features
only currently work for guides to cities located in the UK.

### Live OpenGuides Installs

-   The biggest and most widely used install is [the original London
    one](http://london.openguides.org/).
-   Oxford has two OpenGuides sites — [The Oxford
    Guide](http://oxford.openguides.org/) and [The Vegan Guide to
    Oxford](http://the.earth.li/~kake/cgi-bin/openguides/vegan-oxford.cgi)
-   ... Your city belongs here! ...

### Similar systems

-   [Knowhere](http://knowhere.co.uk/)
-   [RegVeg](http://www.regveg.org)
-   [Capitan Cook](http://www.capitancook.com)


