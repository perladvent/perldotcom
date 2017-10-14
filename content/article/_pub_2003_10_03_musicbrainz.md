{
   "image" : null,
   "authors" : [
      "paul-mison"
   ],
   "tags" : [
      "cddb",
      "freedb",
      "mp3",
      "music",
      "musicbrainz"
   ],
   "categories" : "Data",
   "slug" : "/pub/2003/10/03/musicbrainz.html",
   "date" : "2003-10-03T00:00:00-08:00",
   "title" : "Identifying Audio Files with MusicBrainz",
   "draft" : null,
   "thumbnail" : "/images/_pub_2003_10_03_musicbrainz/111-musicbrainz.gif",
   "description" : "It's quite possible to end up with digital music files that don't have good information about what they are. Files that don't have ID3 information can rely on paths for album information, for example, and that is lost easily. M3U..."
}





It's quite possible to end up with digital music files that don't have
good information about what they are. Files that don't have ID3
information can rely on paths for album information, for example, and
that is lost easily. M3U files describing track order can be deleted or
ignored by naive archiving.

Wouldn't it be nice if, once you had a music file, you could use Perl to
take what information you did have about a track, send it to the
Internet, and get back the data you were missing? Well, you can.

### [A Step Through History]{#a_step_through_history}

In the beginning (well, more or less), music was on CDs. People started
listening to CDs on computers shortly after that, and they found that it
would be nice to know the track's name, not just the number.
Applications were developed that could store the CD metadata locally.
Still, it was tedious to type in all those CD lists, so people shared
the metadata in a single index file on the Internet.

As with most other single-file data stores in Internet history, soon it
became sensible to turn this into a proper database. And so the CDDB was
born. Clients could upload a description of the disc (the Table of
Contents, which described how long each track is) and either download
the information for that CD, or contribute it if it wasn't in the
database.

During 1999 and 2000, however, the CDDB (after its acquisition by
Gracenote) moved from an open position (with GPLed downloads of its data
files) to a proprietary one. During this time it stopped access to
clients speaking the first version of the CDDB protocol, and instead
moved to licensing -- at some cost -- CDDB2 clients, and stopped
offering downloads of its data.

However, a few projects started up, taking advantage of the data that
had been freely available until this point. One of these was FreeDB,
which quickly established an open replacement for the CDDB. The other is
MusicBrainz, which is much more interesting.

### [FreeDB]{#freedb}

FreeDB replicates the structure of the old CDDB very faithfully. This
means that a number of Perl modules for handling CDDB data are
applicable to the FreeDB as well.

However, despite the large number of FreeDB modules on CPAN, it's not
really well suited to the task of finding or correcting digital music
file metadata. FreeDB grew out of CDDB, which was designed around the
task of identifying entire CDs, not merely single tracks, and that is
still reflected in the way most of the modules work; they require you to
either have or fake the CD's table of contents to get results.

FreeDB also has a search form on its web site, and there's a Perl module
-- `Webservice::FreeDB` -- that you can use to find out information on a
per-track basis. However, wherever possible a web service is probably
preferable to using a screen scraper, and thankfully such a service is
available.

### [MusicBrainz]{#musicbrainz}

MusicBrainz has similar origins to FreeDB in the post-Gracenote era.
Unlike FreeDB, MB was much more ambitious; as the description says,
\`"MusicBrainz is a community music metadatabase that attempts to create
a comprehensive music information site.''

In addition to taking the FreeDB data and making it available (in fact,
the FreeDB changes appear to be regularly merged into MusicBrainz), MB
takes care to make sure that their data is moderated regularly. FreeDB's
discid-based system didn't always make sure that different versions CDs
were recognized as duplicates, for example, whereas the MB volunteers
attempt to consolidate such data. They also offer fairly powerful
searches of the data from a web-based front end.

More importantly for our purposes, MusicBrainz has a web services API.
Rather than using SOAP, it's a REST-based service based on RDF.

You can see an example of this by downloading the data at a URL like
<http://mm.musicbrainz.org/mm-2.1/album/1073abfc-768e-455b-9937-9b41b923c746/4>.
This returns RDF for the Underworld album *Beaucoup Fish*. The long hex
string is the album's unique identifier within MusicBrainz, and the
number at the end (4) tells MusicBrainz how deeply to go when building
the RDF graph. This level of depth means that as well as merely getting
a track listing as references to other RDF documents (like
<http://musicbrainz.org/track/55ef9194-bb58-4397-a8a2-e0d41d2e1435>),
you get the name of the track inlined in the document.

#### [Using MusicBrainz::Client]{#using_musicbrainz::client}

However, requesting that URL directly requires you know the MusicBrainz
ID for that album, track, or artist, and that you can parse RDF.
Unsurprisingly, there's code out there that can do both from a given
piece of information.

`the MusicBrainz::Client manpage` is a Perl interface to the C client
library for MB, and is available as part of the [Client SDK
download](http://musicbrainz.org/products/client/download.html), as well
as on CPAN.

Here's a small example of using one of the more useful queries provided,
the snappily-entitled `MBQ_FileInfoLookup`. This takes up to 10
parameters, as documented in the [Query
reference](http://musicbrainz.org/docs/mb_client/queries_h.html#a84).
However, you can provide as many or as few items as you wish, and in
this example, merely two pieces of information are provided: an artist,
and a track name.

      #!/usr/bin/perl -w
      use strict;
      
      use MusicBrainz::Client;
      use MusicBrainz::Queries qw(:all);

      my $mb = MusicBrainz::Client->new();
      my $query = [ '', 'Underworld', '', 'Air Towel' ];
      my $result;

Now we've set up the script, and initialized a client object, let's
actually talk to the server.

      if (!$mb->query_with_args( MBQ_FileInfoLookup, $query )) {
        die "Query failed ".$mb->get_query_error();
      }
      
      if (!$mb->select1(MBS_SelectLookupResult, 1)) {
        die "No lookup result";
      }

This sends off a query to the MusicBrainz server, and does two checks to
see if it's worth continuing. If there's no return value from
query\_with\_args, the script dies with the error returned. If there's
not at least one result in the returned data, it also dies.

The exact arguments that `MBQ_FileInfoLookUp` take are documented in the
query reference above. Notably, the first argument is the TRM ID. This
is a generated, unique identifier for the file, based on a number of
weighted checks, including wavelet analysis. Generally I've found it's
still possible to get good results without including it, though.

      my $type = $mb->get_result_data(MBE_LookupGetType);
      my $frag = $mb->get_fragment_from_url($type);
      
      if ($frag eq 'AlbumTrackResult') {
        $result = handle_album_track_list($mb);
      }
      else {
        die "Not an AlbumTrackResult; instead of type '$frag'";
      }

`MBQ_FileInfoLookup` can return different types of result. This code
uses two more functions from MusicBrainz to find out the type of the
result (the LookupGetType function) and then to parse out from the URL
what type of result that is. We're only interested in AlbumTrackResult
type, so we die if that's not what's found. If it is of that type, it's
handled by a subroutine, which we'll look at now.

      sub handle_album_track_list {
        my $mb = shift;
        my $result;

First, we get the MusicBrainz client object and pre-declare our result
variable.


        for (my $i = 1;; $i++) {
          $mb->select(MBS_Rewind);

          if (!$mb->select1(MBS_SelectLookupResult, $i)) {
            last;
          }

MusicBrainz results sets are a lot like database rows. You loop over
them, and pull out the data you want.

However, the interface to the results is somewhat C-like. As you can
see, we loop over the results one by one, stopping only when there isn't
a result in the set.

          my $relevance = $mb->get_result_int(MBE_LookupGetRelevance);

However, once there is a result, we can pull out information from it,
like the relevance of that data.


          # get track info
          $mb->select(MBS_SelectLookupResultTrack);
          my $track   = $mb->get_result_data(MBE_TrackGetTrackName);
          my $length  = $mb->get_result_data(MBE_TrackGetTrackDuration);     
          my $artist  = $mb->get_result_data(MBE_TrackGetArtistName);
          $mb->select(MBS_Back);

To get the information about the track, you select the track portion of
that result, then issue get\_result\_data calls for each of the pieces
of information you want (such as the artist name, track name and so on).

          # get album info
          $mb->select(MBS_SelectLookupResultAlbum);
          my $album   = $mb->get_result_data(MBE_AlbumGetAlbumName);
          my $trackct = $mb->get_result_int(MBE_AlbumGetNumTracks);
          $mb->select(MBS_Back);

Similarly, you select the album data, and then select the information
about the album you want to return.


          $result->[$i-1] = { relevance => $relevance,
                              track     => $track,
                              album     => $album,
                              artist    => $artist,
                              total     => $trackct,
                              time      => $length,
                            };

This is stored in a hash reference, itself stored in the list of
results. (Note we move from MusicBrainz offset of 1 to the Perl offset
of 0 here.)

        }
        return $result;
      }

      use Data::Dumper;
      print Dumper($result);

Finally the result is returned and (crudely) inspected. Of course, you
could instead take the result with the highest relevance and tag a file
here, or offer the choice via some user interface of which result is
more likely to be appropriate.

#### [Using AudioFile::Identify::MusicBrainz]{#using_audiofile::identify::musicbrainz}

As you can see, returning the data from MusicBrainz::Client is a fairly
verbose procedure. In addition, it's not a pure Perl implementation, so
installing the module isn't as easy as it could be, and in some places
it's not possible at all.

Given that the REST interface is open, Tom Insam and I decided to play
with getting the RDF results and parsing them, putting together Perl
modules along the way to help. The result is
`the AudioFile::Identify::MusicBrainz manpage`:

      #!/usr/bin/perl -w
      use strict;

      use AudioFile::Identify::MusicBrainz::Query;
      my $query = { artist => 'Underworld', 
                    track  => 'Air Towel',
                  };
      my $result;

Again, this is simple setup stuff. You'll note that instead of a list,
AIM takes a hash reference with named fields, which is hopefully a
little easier to use.

      my $aim = AudioFile::Identify::MusicBrainz::Query->new()
                or die "Can't make query";
      
      $aim->FileInfoLookup($query);

This block of code instantiates the AIM object and sends off the query.

      for my $record (@{ $aim->results }) {
        push @{ $result }, {  relevance => $record->relevance,
                              track     => $record->track->title,
                              album     => $record->album->title,
                              artist    => $record->track->artist->title,
                              tracknum  => $record->track->trackNum,
                              total     => scalar @{$record->album->tracks},
                              time      => $record->track->duration,
                           };
      };

This manipulates the results from AIM such that they match the result
list that we created from MusicBrainz::Client. Each of them is a method
on the returned object. Some, such as the artist name, are objects
referenced from other objects.

      use Data::Dumper;
      print Dumper($result);

Again, we crudely inspect the output, which is identical but for the
addition of the track number.

### [Inside AudoFile::Identify::MusicBrainz]{#inside_audofile::identify::musicbrainz}

As you'd expect, Perl (and its retinue of modules) made writing this
module fairly straightforward. Firstly, LWP makes requesting data from
the MusicBrainz server pretty easy. (This code is in
`the AudioFile::Identify::MusicBrainz::Query manpage, for the curious.)`

      use LWP;
      use LWP::UserAgent;

      # ...

      my $ua = LWP::UserAgent->new();

      my $req = HTTP::Request->new(POST => $self->url,);
      $req->content($rdf);

      my $res = $ua->request($req);

This sets up an LWP user agent, and sends the RDF query (more on that
later) to a URL (returned by another method in the module). That's all
you need to get the returned result into the string \$res. (The real
module has a custom UserAgent string that I've omitted to save space.)

      # Check the outcome of the response
      if ($res->is_success) {
        $self->response($res->content);
        return $self->parse();
      }

As long as there's a result, it gets stored and then parsed. (Don't
worry; the real module also handles errors.) So, what does the parser
do?

      my $parser = new XML::DOM::Parser;
      my $doc = $parser->parse($self->response);

MusicBrainz returns results in RDF, but that RDF is itself encapsulated
in XML. Although it's not ideal to use XML tools on RDF, it works well
enough in this case.

      my $result_nodes = $doc->getElementsByTagName('mq:AlbumTrackResult');
      
      $n = $result_nodes->getLength;
      for (my $i = 0; $i < $n; $i++) {
        my $node = $result_nodes->item($i);
        my $result =
          AudioFile::Identify::MusicBrainz::Result->new()
                                                  ->store($self->store)
                                                  ->type('Track')
                                                  ->parse($node);
        push @$results, $result;
      }

This block of code is a good example of how the XML is parsed. Firstly,
all elements with the name mq:AlbumTrackResult are found. These are
progressively looped over, and stored in a new Result object (of type
Track), and parsed. So, what happens within the parser?

      my $child = $node->getFirstChild();
      while($child) {
        if ($child->getNodeType == 1) {
          my $tag = $child->getTagName;
          $tag =~ s/.*://;
          if ($self->can($tag)) {
            $self->$tag($child);
          }
        }
        $child = $child->getNextSibling();
      }

The node (as passed in above) is examined, and the first child node is
examined. While we have a child node to examine, the program checks that
it's an element (of node type 1), gets the tag name and removes the
namespace, then calls the appropriate get/set method with the
appropriate XML node, before moving on to the next child. (This is a
somewhat simplified version, with the error checking removed.)

What happens in an example get/set method? Here's part of the title
method from the Track package.

      if (defined($set)) {
        if ($set->isa('XML::DOM::Element') and $set->getFirstChild) {
          $self->{title} = $set->getFirstChild->toString;
        } else {
          $self->{title} = $set;
        }
        return $self;
      } else {
        return $self->{title};
      }

If the method is called with some data, the program makes sure it's an
XML::DOM element, then parses it and stores the string within that
element, or stores the data that was passed in. Otherwise, it returns
the data that was previously stored.

One point to note is that MusicBrainz doesn't return all the track
information you might need in the initial FileInfoLookup query.
Therefore the Result package uses another method, called getData in the
Track package, to download the RDF for the track from MusicBrainz. This
is then parsed and stored in the same way as the RDF above.

### [Conclusion]{#conclusion}

In this article I've shown you how to connect to MusicBrainz and
retrieve information from their web services API with both the
MusicBrainz::Client and AudioFile::Identify::MusicBrainz modules, and a
little of the internal workings of the latter. This should allow you to
find out all those niggling missing pieces of information about the
tracks at the bottom of your music collection.


