{
   "draft" : null,
   "title" : "Find What You Want with Plucene",
   "date" : "2004-02-19T00:00:00-08:00",
   "slug" : "/pub/2004/02/19/plucene.html",
   "tags" : [
      "plucene-lucene-search"
   ],
   "categories" : "web",
   "authors" : [
      "simon-cozens"
   ],
   "image" : null,
   "description" : " For the past few months, my former employers and I have been working on a port of the Java Lucene search engine toolkit. On the February 3rd, Plucene was released to the world, implementing almost all of the functionality...",
   "thumbnail" : "/images/_pub_2004_02_19_plucene/111-plucene.gif"
}





For the past few months, my [former employers](http://www.kasei.com) and
I have been working on a port of the Java
[Lucene](http://jakarta.apache.org/lucene/) search engine toolkit.

On the February 3rd, [Plucene](http://search.cpan.org/perldoc?Plucene)
was released to the world, implementing almost all of the functionality
of the Java equivalent. Satisfied with a job done, I parted company with
Kasei to pursue some projects of my own -- about which I'm sure you'll
be hearing more later.

Very soon after, the phone rang, and it turned out that someone actually
wanted to use this Plucene thing; they needed to add a search engine to
a web-based book that they had produced, and had some pretty complex
requirements that meant that the usual tools -- HTDig, Glimpse and
friends -- couldn't quite do the job. Could I come around and write a
Plucene-based search engine for them?

Well, this turned out to have its challenges, and these turned out to
make an interesting introduction to using Plucene, so I decided to share
them with you. I won't tell you how to do all of the complicated things
we had to do for this custom engine, but I should give you enough to get
your own Plucene indexes up and running.

### [Making It Easy: Plucene::Simple]{#Making_it_easy_-_Plucene::Simple}

The easiest way to use Plucene is through the `Plucene::Simple` module.
To write our index, we say:

        use Plucene::Simple;

        my $index = Plucene::Simple->open( "/var/plucene/site" );
        for my $id (keys %documents) {
            $index->add($id => $documents{$id});
        }
        $index->optimize;

But what goes in our `%documents` hash?

One difference between Plucene and other search systems like HTDig is
that Plucene only provides a toolkit; it doesn't provide a complete
indexer to suck up a directory of files, for instance. You have to make
your own representation of the content of a document, and then add that
to the index. For instance, we want to end up with a hash like this:

     %documents = (
        "chapter5.html" => { chapter => 5,
                             title => "In which Piglet meets a Heffalump",
                             content => "One day, when Christopher Robin...",
                           }
     );

This means that we can't simply index the book by providing a list of
files to a command-line program. We have to actually write some code.

Some people may think this is a problem, but I see it as an opportunity.
For instance, most web pages these days (this one included) are
surrounded in a template with banners, titles, and navigation bars down
the side. These things are static and appear on every page, so can only
harm search engine results; we don't want to index them. Our indexing
code can look at the structure of the document, extract some metadata
from it, and construct a hash reference that represents just the
important bits of content.

The HTML files I had to deal with looked a bit like this:

        <head>
            <meta name="chapter" value="...">
            <!-- other useful metadata here -->
            <title> ... </title>
        </head>
        <div id="navigation">...</div>
        <div id="content">...</div>

I wanted to extract what was in the `meta` tags, the `title`, and
everything in the `content` div. One of the nicest ways to do this in
Perl is with the
[`HTML::TreeBuilder`](http://search.cpan.org/perldoc?HTML::TreeBuilder),
which allows us to "dig down" for the elements that we want to find:

        use HTML::TreeBuilder;
        my $tree = HTML::TreeBuilder->new->parse_file("chapter1.html");
        my $document = { chapter => 1 };

        my $title_tag = $tree->look_down( _tag => "title" );
        $document->{title} = $title_tag->as_text;

        my $content_tag = $tree->look_down( _tag => "div", id => "content" );
        $document->{content} = $content_tag->as_text;

It also allows us to extract attributes from tags:

        for my $tag ($tree->look_down( _tag => "meta")) {
            $document{$tag->attr("name")} = $tag->attr("content");
        }

Now we have the salient parts of the chapter extracted as a hash
reference, and we can add this to our index, keyed by the filename:

        $index->add( "chapter1.html" => $document );

To do this for a whole directory tree of files, we can use the wonderful
[`File::Find::Rule`](http://search.cpan.org/perldoc?File::Find::Rule)
module:

        for my $filename (File::Find::Rule->file
                          ->name( qr/^(?!index).*\.html/ )->in(".")) {
            print "Processing $filename...\n";
            $writer->writer( $filename => file2hash($filename) );
        }
        $index->optimize;

This finds all files underneath the current directory called `*.html`
that don't start with the characters `index`. (We needed some special
treatment on the index of the book itself, since providing search
results to pages in the index would not be helpful.)

### [Running the Search]{#Running_the_Search}

The search part of the operation is now pretty easy. We have a CGI
script or equivalent that gets the search query string, and then we say:

        use Plucene::Simple;

        my (@ids, $error);
        if (!$query) {
            $error = "Your search term was empty";
        } else {
            $index = Plucene::Simple->open( "/var/plucene/site" );
            @ids = $index->search($query);
        }

and this returns the list of filenames that matched the query. Because I
tend to use Template Toolkit for pretty much everything these days, it
became:

        my $t = Template->new();
        $t->process("searchResult.html", {
            query   => $query,
            results => \@ids,
            error   => $error,
        });

And the relevant part of the template is:

        [% IF error %]
           <H2> Search had errors </H2>
           <FONT COLOR="#ff0000"> [% error %] </FONT>
        [% ELSE %]
           <H2> Search results for [% query %] </H2>
            [% IF results.size > 0 %]
                <OL>
                  [% FOR result = results %]
                  <LI>
                      <A HREF="/[% filename %]"> [% filename %] </A>
                  </LI>
                  [% END %]
                </OL>
            [% ELSE %]
                <P>No results found</P>
            [% END %]
        [% END %]

However, this isn't very pretty, for a couple of reasons. The first
reason is that we're linking the result to a filename, rather than
displaying something friendly like the name of the chapter. The second
is that when you get results from a web search engine, you generally
also expect to see some context for the terms that you've just searched
for, so you know how the terms appear on the page.

We can't easily solve the first problem with `Plucene::Simple`, so we'll
come back to it. But contextualizing search results is something we can
do.

### [Contextualizing Results]{#Contextualising_results}

The [`Text::Context`](http://search.cpan.org/perldoc?Text::Context)
module was written to solve a similar contextualizing problem; it takes
a bunch of keywords and a source document, and produces a
paragraph-sized chunk of text highlighting where the keywords occur.

Since it works by trying to subdivide the text into paragraphs, it's
helpful to have a text-only version of the document available. If we
don't, we can use `HTML::TreeBuilder` again to produce them:

        sub snippet {
            my $filename = shift;
            use HTML::Tree;
            my $tree = HTML::TreeBuilder->new();
            $tree->parse_file(DOCUMENT_ROOT . "/" . $filename)
                or die "Couldn't parse file";
            my $content;
            my($div) = $tree->look_down("_tag","div", "id", "content");
            for my $p ($div->look_down(sub { shift->tag() =~ /^(h\d+|p)/i })) {
                $content . = $p->as_text."\n\n";
            }

This looks for headings and paragraphs and extracts the text from them.
Now we can split the search query into individual terms, and then call
our `Text::Context` module to get a snippet to pass to the templater:

            my @terms = split /\s+/, $query;
            my $snippet = Text::Context->new($stuff, @terms)->as_html();
            return $snippet;
        }

So far, so good! Then, of course, the specifications changed ...

### [Plucene Components]{#Plucene_Components}

One of the things that makes a good search engine into a great search
engine is the ability to automatically search for variations and
inflections of the terms. For instance, if you search for "looking
good," you should also find documents that contain "looked good," "looks
good," and so on.

There are two ways to deal with this; the way HTDig chooses is to
replace the "looking" with "(look OR looked OR looks OR looking)," but
this isn't particularly efficient or comprehensive.

A second way is to index the words a little differently; filtering them
through a stemmer which takes off the suffixes, so that all of the above
collapse to "look."
[`Lingua::Stem::En::stem`](http://search.cpan.org/perldoc?Lingua::Stem::En::stem)
does this, but we can't plug it into `Plucene::Simple` directly. To do
this, we need to slip under the covers of `Plucene::Simple` and meddle
with the Plucene API itself.

Before we see how to do this, let's look at the various components of
Plucene.

The indexing part of the process is handled by `Plucene::Index::Writer`;
this takes in `Plucene::Document` objects, and uses a
`Plucene::Analysis::Analyzer` subclass to break up the text of the
document into tokens. The default analyzer as used by `Plucene::Simple`
is `Plucene::Analysis::SimpleAnalyzer`, which breaks up words on
non-letter boundaries and then forces them to lowercase them. The
broken-up tokens are put into `Plucene::Index::Term` to have a field
associated with them; for instance, in our example:

        <TITLE>In which Pooh goes visiting and gets into a tight place</HEAD>

will be turned by our `HTML::TreeBuilder` munging into

        {
        title => "In which Pooh goes visiting and gets into a tight place"
        }

and `Plucene::Simple` turns this into a `Plucene::Document::Field`:

        bless {name => "title",
        string => "In which Pooh goes visiting and gets into a tight place"},
        "Plucene::Document::Field"

and then into a set of `Plucene::Index::Term` objects like so:

        bless { field => "title", text => "in" }, "Plucene::Document::Term"
        bless { field => "title", text => "which" }, "Plucene::Document::Term"
        bless { field => "title", text => "pooh" }, "Plucene::Document::Term"
        bless { field => "title", text => "goes" }, "Plucene::Document::Term"
        bless { field => "title", text => "visiting" }, "Plucene::Document::Term"
        ...

Then various classes write out the terms and their frequencies into the
index.

When we come to searching, the `Plucene::Search::IndexSearcher` acts as
the top-level classes. It calls a `Plucene::QueryParser` to turn the
query into a set of `Plucene::Search::Query` objects: this allows
Plucene to differentiate between phrase queries such as `"looks good"`,
negated queries (`looks -good`), queries in different fields
(`looks title:good`), and so on.

This `QueryParser`, in turn, uses the same analyzer as the indexer to
break up the search terms into tokens. This is because if our indexer
has seen `BORN2run` and turned it into two tokens, `born` and `run`, and
then we do a search on `BORN2run`, we aren't going to find it unless we
transform the search terms to `born` and `run` in the same way.

### [Using the Porter Analyzer]{#Using_the_Porter_Analyzer}

We need to replace the `SimpleAnalyzer` with an analyzer that filters
through `Lingua::Stem::En`. Thankfully, here's one I prepared earlier:
`Plucene::Plugin::Analyzer::Porter`. However, since `Plucene::Simple`
doesn't allow us to change analyzers, we have to do everything manually.

First, we produce a `Plucene::Index::Writer`, with the appropriate
analyzer:

        my $writer = Plucene::Index::Writer->new(
            "/var/plucene/site",
            Plucene::Plugin::Analyzer::PorterAnalyzer->new(),
            1 # Create the index from scratch
        );

Next we have to build up the `Plucene::Document` ourselves, instead of
just feeding a hash of attributes to `Plucene::Simple->add`.

      my $doc = Plucene::Document->new();
      $doc->add(Plucene::Document::Field->Keyword(filename => $filename));

      my $title_tag = $tree->look_down( _tag => "title" );
      $doc->add(Plucene::Document::Field->Text( title => $title_tag->as_text ));

      for my $tag ($tree->look_down( _tag => "meta")) {
          $document{$tag->attr("name")} = $tag->attr("content");
      }

      my $content_tag = $tree->look_down( _tag => "div", id => "content" );
      $doc->add(Plucene::Document::Field->UnStored( title => $content_tag->as_text ));

You'll notice that there are three different constructors for
`Plucene::Document::Field` objects -- the `Keyword` is stored and can be
retrieved, but isn't broken up into tokens; this is used for things like
filenames, where you want to get them back from the index verbatim.
Fields constructed using `Text` can be retrieved, but are also broken up
into tokens for searching in the index. `UnStored` text can't be
retrieved, but is indexed, so we use this for the content, the main bulk
of the book.

This will also solve our problem with the English description of the
link, since it will allow us to retrieve the title field for a search
hit.

Once we have our document object, we can add it into the index:

        $writer->add($doc);

Now that we have the text filtered through the Porter stemmer, the
tokens indexed will look like "`in which pooh goe visit`." Now we need
to make sure that the same filter is used in searching, which means we
also have to rewrite the search code to use this analyzer. First, we
open the index for searching:

        my $searcher = Plucene::Search::IndexSearcher->new( "/var/plucene/site" );

Now we parse the query, specifying that any unqualified terms should be
sought in the `content` field:

        my $parser = Plucene::QueryParser->new({
                analyzer => Plucene::Plugin::PorterAnalyzer->new(),
                default  => "content"
            });
        my $parsed = $parser->parse($query);

Finally, we declare a `Plucene::Search::HitCollector`; this is a
callback which is called every time a search hit is found. We use it to
populate an array of information about hits:

        my @docs;
        my $hc       = Plucene::Search::HitCollector->new(
            collect => sub {
                my ($self, $doc, $score) = @_;
                my $res = eval { $searcher->doc($doc) };
                push @docs, $res if $res;
            });

And we do the search:

        $searcher->search_hc($parsed, $hc);

This fills `@docs` with `Plucene::Document` objects; from these, we want
to extract the filename and the title fields, to pass to the templates:

        @results = map {{ 
            filename => $_->get("filename")->string,
            title => $_->get("title")->string,
        }} @docs;

        for (@results) {
            $_->{snippet} = snippet($_->{filename})
        }

Now we can put together a more impressive display for each result:

        <LI>
        <BLOCKQUOTE>
        [% result.snippet %]
        </BLOCKQUOTE>
        <P>In <A HREF="/[% result.filename %]"> [% result.title %]</A></P>

This ends up looking like the following:

### Search results for "bears build"

> It's a very funny thought that, if **Bears** were Bees, they'd
> **build** their nests are the bottom of trees.

In *We are introduced*

Which looks quite nice and professional. Except for one slight matter.

Suppose we had looked for `bear builds`. We'd still match the same bit
of text, thanks to stemming. However, the exact words that we're looking
for aren't in that bit of text, so the contextualizer won't do the right
thing. What we need, then, is a version of `Text::Context` that knows
about Porter stemming. Thankfully,
[`Text::Context::Stemmer`](http://search.cpan.org/perldoc?Text::Context::Stemmer)
steps into the breach.

We have a web search engine that understands Porter stemming. The first
part of my job is done.

### [And Everything Else]{#And_everything_else}

There are plenty of other things we can do with Plucene: use the
metadata to restrict the search to particular chapters, for instance;
filter out stop words with the `Plucene::Analysis::StopFilter`; restrict
the search to a series of dates, using the
`Plucene::Document::DateSerializer` module, and so on.

Plucene is a general-purpose search engine; while the `Plucene::Simple`
interface to it allows you to get a good search tool up and running very
quickly, that's very much only the tip of the iceberg. By getting into
the Plucene API itself, we can build a complex, customized search engine
for any application.


