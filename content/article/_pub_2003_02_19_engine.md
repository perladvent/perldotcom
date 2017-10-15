{
   "slug" : "/pub/2003/02/19/engine.html",
   "tags" : [
      "search-engine-vector-space"
   ],
   "description" : " Building a Vector Space Search Engine in Perl A Few Words About Vectors Getting Down To Business Building the Search Engine Making it Better Further Reading Why waste time reinventing the wheel, when you could be reinventing the engine?...",
   "draft" : null,
   "date" : "2003-02-19T00:00:00-08:00",
   "thumbnail" : "/images/_pub_2003_02_19_engine/111-vector_search.gif",
   "image" : null,
   "title" : "Building a Vector Space Search Engine in Perl",
   "authors" : [
      "maciej-ceglowski"
   ],
   "categories" : "Tooling"
}



<span id="__index__"></span>
-   [Building a Vector Space Search Engine in Perl](#building%20a%20vector%20space%20search%20engine%20in%20perl)
-   [A Few Words About Vectors](#a%20few%20words%20about%20vectors)
-   [Getting Down To Business](#getting%20down%20to%20business)
-   [Building the Search Engine](#building%20the%20search%20engine)
-   [Making it Better](#making%20it%20better)
-   [Further Reading](#further%20reading)

<span id="building a vector space search engine in perl"></span>
*Why waste time reinventing the wheel, when you could be reinventing the engine?* *-Damian Conway*

As a Perl programmer, sooner or later you'll get an opportunity to build a search engine. Like many programming tasks - parsing a date, validating an e-mail address, writing to a temporary file - this turns out to be easy to do, but hard to get right. Most people try end up with some kind of reverse index, a data structure that associates words with lists of documents. Onto this, they graft a scheme for ranking the results by relevance.

Nearly every search engine in use today - from Google on down - works on the basis of a **reverse keyword index**. You can write such a keyword engine in Perl, but as your project grows you will inevitably find yourself gravitating to some kind of relational database system. Since databases are customized for fast lookup and indexing, it's no surprise that most keyword search engines make heavy use of them. But writing code for them isn't much fun.

More to the point, companies like Google and Atomz already offer excellent, free search services for small Web sites. You can get an instant search engine with a customizable interface, and spend no time struggling with Boolean searches, text highlighting, or ranking algorithms. Why bother duplicating all that effort?

As Perl programmers, we know that laziness is a virtue. But we also know that there is more than one way to do things. Despite the ubiquity of reverse-index search, there are many other ways to build a search engine. Most of them originate in the field of information retrieval, where researchers are having all kinds of fun. Unfortunately, finding documentation about these alternatives isn't easy. Most of the material available online is either too technical or too impractical to be of use on real-world data sets. So programmers are left with the false impression that vanilla search is all there is.

In this article, I want to show you how to build and run a search engine using a **vector-space model**, an alternative to reverse index lookup that does not require a database, or indeed any file storage at all. Vector-space search engines eliminate many of the disadvantages of keyword search without introducing too many disadvantages of their own. Best of all, you can get one up and running in just a few dozen lines of Perl.

<span id="a few words about vectors">A Few Words About Vectors</span>
=====================================================================

Vector-space search engines use the notion of a **term space**, where each document is represented as a vector in a high-dimensional space. There are as many dimensions as there are unique words in the entire collection. Because a document's position in the term space is determined by the words it contains, documents with many words in common end up close together, while documents with few shared words end up far apart.

To search our collection, we project a query into this term space and calculate the distance from the query vector to all the document vectors in turn. Those documents that are within a certain threshold distance get added to our result set. If all this sounds like gobbledygook to you, then don't worry - it will become clearer when we write the code.

The vector-space data model gives us a search engine with several useful features:

-   Searches take place in RAM, there is no disk or database access
-   Queries can be arbitrarily long
-   Users don't have to bother with Boolean logic or regular expressions
-   It's trivially easy to do 'find similar' searches on returned documents
-   You can set up a 'saved results' basket, and do similarity searches on the documents in it
-   You get to talk about 'vector spaces' and impress your friends

<span id="getting down to business">Getting Down to Business</span>
===================================================================

The easiest way to understand the vector model is with a concrete example.

Let's say you have a collection of 10 documents, and together they contain 50 unique words. You can represent each document as a vector by counting how many times a word appears in the document, and moving that distance along the appropriate axis. So if Document A contains the sentence "cats like chicken", then you find the axis for `cat`, move along one unit, and then do the same for `like` and `chicken`. Since the other 47 words don't appear in your document, you don't move along the corresponding axes at all.

Plot this point and draw a line to it from the origin, and you have your **document vector**. Like any vector, it has a magnitude (determined by how many times each word occurs), and a direction (determined by which words appeared, and their relative abundance).

There are two things to notice here:

The first is that we throw away all information word order, and there is no guarantee that the vector will be unique. If we had started with the sentence "chickens like cats" (ignoring plurals for the moment), then we would have ended up with an identical document vector, even though the documents are not the same.

This may seem to be a big limitation, but it turns out that word order in natural language contains little information about content - you can infer most of what a document is about by studying the word list. Bad news for English majors, good news for us.

The second thing to notice is that with three non-zero values out of a possible 50, our document vector is sparse. This will hold true for any natural language collection, where a given document will contain only a tiny proportion of all the possible words in the language. This makes it possible to build in-RAM search engines even for large collections, although the details are outside the scope of this article. The point is, you can scale this model up quite far before having to resort to disk access.

To run a vector-space search engine, we need to do the following:

1.  Assemble a document collection
2.  Create a term space and map the documents into it
3.  Map an incoming query into the same term space
4.  Compare the query vector to the stored document vectors
5.  Return a list of nearest documents, ranked by distance

Now let's see how to implement these steps in Perl.

<span id="building the search engine">Building the Search Engine</span>
=======================================================================

We'll make things easy by starting with a tiny collection of four documents, each just a few words long:

            "The cat in the hat"

            "A cat is a fine pet."

            "Dogs and cats make good pets."

            "I haven't got a hat."

Our first step is to find all the unique words in the document set. The easiest way to do this is to convert each document into a word list, and then combine the lists together into one. Here's one (awful) way do it:


            sub get_words { 
                    my ( $text ) = @_;
                    return map { lc $_ => 1 }
                           map { /([a-z\-']+)/i } 
                           split /\s+/s, $text;
            }

The subroutine splits a text string on whitespace, takes out all punctuation except hyphens and apostrophes, and converts everything to lower case before returning a hash of words.

The curious `do` statement is just a compact way of creating a lookup hash. `%doc_words` will end up containing our word list as its keys, and its values will be the number of times each word appeared.

If we run this 'parser' on all four documents in turn, then we get a master word list:

            a
            and
            cat
            cats
            dogs
            fine
            good
            got
            hat
            haven't
            i
            in
            is
            make
            pet
            pets
            the

Notice that many of the words in this list are junk words - pronouns, articles, and other grammatical flotsam that's not useful in a search context. A common procedure in search engine design is to strip out words like these using a **stop list**. Here's the same subroutine with a rudimentary stop list added in, filtering out the most common words:


            our %stop_hash;
            our @stop_words = qw/i in a to the it have haven't was but is be from/;
            foreach @stop_words {$stop_hash{$_}++ };


            sub get_words {


                    # Now with stop list action!


                    my ( $text ) = @_;
                    return map { $_ => 1 }
                           grep { !( exists $stop_hash{$_} ) }
                           map lc,
                           map { /([a-z\-']+)/i } 
                           split /\s+/s, $text;
            }

A true stop list would be longer, and tailored to fit our document collection. You can find a real stop list in the `DATA` section of [Listing 1](/media/_pub_2003_02_19_engine/VectorSpace.pm), along with a complete implementation of the search engine described here. Note that because of Perl's fast hash lookup algorithm, we can have a copious stop list without paying a big price in program speed. Because word frequencies in natural language obey a power-law distribution, getting rid of the most common words removes a disproportionate amount of bulk from our vectors.

Here is what our word list looks after we munge it with the stop list:

            cat
            cats
            dogs
            fine
            good
            got
            hat
            make
            pet
            pets

We've narrowed the list down considerably, which is good. But notice that our list contains a couple of variants ("cat" and "cats", "pet" and "pets"), that differ only in number. Also note that someone who searches on 'dog' in our collection won't get any matches, even though 'dogs' in the plural form is a valid hit. That's bad.

This is a common problem in search engine design, so of course there is a module on the CPAN to solve it. The bit of code we need is called a **stemmer**, a set of heuristics for removing suffixes from English words, leaving behind a common root. The stemmer we can get from CPAN uses the **Porter stemming algorithm**, which is an imperfect but excellent way of finding word stems in English.

            use Lingua::Stem;

We'll wrap the stemmer in our own subroutine, to hide the clunky Lingua::Stem syntax:

            sub stem {
                    my ( $word) = @_;
                    my $stemref = Lingua::Stem::stem( $word );
                    return $stemref->[0];
            }

And here's how to fold it in to the `get_words` subroutine:

            return map { stem($_) => 1 }
                   grep { !( exists $stop_hash{$_} ) }
                   map lc,
                   map { /([a-z\-']+)/i } 
                   split /\s+/s, $text;

Notice that we apply our stop list before we stem the words. Otherwise, a valid word like `beings` (which stems to `be`) would be caught by the overzealous stop list. It's easy to make little slips like this in search algorithm design, so be extra careful.

With the stemmer added in, our word list now looks like this:

            cat
            dog
            fine
            good
            got
            hat
            make
            pet

Much better! We have halved the size of our original list, while preserving all of the important content.

Now that we have a complete list of **content words**, we're ready for the second step - mapping our documents into the term space. Because our collection has a vocabulary of eight content words, each of our documents will map onto an eight-dimensional vector.

Here is one example:

            # A cat is a fine pet



            $vec = [ 1, 0, 1, 0, 0, 0, 1 ];

The sentence "A cat is a fine pet" contains three content words. Looking at our sorted list of words, we find `cat`, `fine`, and `pet` at positions one, three, and eight respectively, so we create an anonymous array and put ones at those positions, with zeroes everywhere else.

If we wanted to go in the opposite direction, then we could take the vector and look up the non-zero values at the appropriate position in a sorted word list, getting back the content words in the document (but no information about word order).

The problem with using Perl arrays here is that they won't scale. Perl arrays eat lots of memory, and there are no native functions for comparing arrays to one another. We would have to loop through our arrays, which is slow.

A better data way to do it is to use the PDL module, a set of compiled C extensions to Perl made especially for use with matrix algebra. You can find it on the CPAN. PDL stands for "Perl Data Language", and it is a powerful language indeed, optimized for doing math operations with enormous multidimensional matrices. All we'll be using is a tiny slice of its functionality, the equivalent of driving our Ferrari to the mailbox.

It turns out that a PDL vector (or "piddle") looks similar to our anonymous array:


            use PDL;
            my $vec = piddle [ 1, 0, 1, 0, 0, 0, 1 ];


            > print $vec

            [1 0 0 1 0 0 0 1]

We give the piddle constructor the same anonymous array as an argument, and it converts it to a smaller data structure, requiring less storage.

Since we already know that most of our values in each document vector will be zero (remember how sparse natural language is), passing full-length arrays to the piddle constructor might get a little cumbersome. So instead we'll use a shortcut to create a zero-filled piddle, and then set the non-zero values explicitly. For this we have the `zeroes` function, which takes the size of the vector as its argument:

            my $num_words = 8;
            my $vec = zeroes $num_words;



            > print $vec

            [0 0 0 0 0 0 0 0 0]

To set one of the zero values to something else, we'll have to use the obscure PDL syntax:

            my $value = 3;
            my $offset = 4;



            index( $vec, $offset ) .= $value;

            > print $vec;

            [0 0 0 3 0 0 0 0 0]

Here we've said "take this vector, and set the value at position 4 to 3".

This turns out to be all we need to create a document vector. Now we just have to loop through each document's word list, and set the appropriate values in the corresponding vector. Here's a subroutine that does the whole thing:

            # $word_count is the total number of words in collection
            # %index is a lookup hash of word to its position in the master list



            sub make_vector {
                    my ( $doc ) = @_;
                    my %words = get_words( $doc );  
                    my $vector = zeroes $word_count;


                    foreach my $w ( keys %words ) {
                            my $value = $words{$w};
                            my $offset = $index{$w};
                            index( $vector, $offset ) .= $value;
                    }
                    return $vector;
            }

Now that we can generate a vector for each document in our collection, as well as turn an incoming query into a query vector (by feeding the query into the `make_vector` subroutine), all we're missing is a way to calculate the distance between vectors.

There are many ways to do this. One of the simplest (and most intuitive) is the **cosine measure**. Our intuition is that document vectors with many words in common will point in roughly the same direction, so the angle between two document vectors is a good measure of their similarity. Taking the cosine of that angle gives us a value from zero to one, which is handy. Documents with no words in common will have a cosine of zero; documents that are identical will have a cosine of one. Partial matches will have an intermediate value - the closer that value is to one, the more relevant the document.

The formula for calculating the cosine is this:

            cos  = ( V1 * V2 ) / ||V1|| x ||V2||

Where V2 and V2 are our vectors, the vertical bars indicate the 2-norm, and the `*` indicates the inner product. You can take the math on faith, or look it up in any book on linear algebra.

With PDL, we can express that relation easily:

            sub cosine {
                    my ($vec1, $vec2 ) = @_;
                    my $n1 = norm $vec1;
                    my $n2 = norm $vec2;
                    my $cos = inner( $n1, $n2 );    # inner product
                    return $cos->sclr();  # converts PDL object to Perl scalar
            }

We can normalize the vectors to unit length using the `norm` function, because we're not interested in their absolute magnitude, only the angle between them.

Now that we have a way of computing distance between vectors, we're almost ready to run our search engine. The last bit of the puzzle is a subroutine to take a query vector and compare it against all of the document vectors in turn, returning a ranked list of matches:

            sub get_cosines {
                    my ( $query_vec ) = @_;
                    my %cosines;
                    while ( my ( $id, $vec ) = each  %document_vectors ) {
                            my $cosine = cosine( $vec, $query_vec );
                            next unless $cosine > $threshold;
                            $cosines{$id} = $cosine;
                    }
                    return %cosines;
            }

This gives us back a hash with document IDs as its keys, and cosines as its values. We'll call this subroutine from a `search` subroutine that will be our module's interface with the outside world:

            sub search {
                    my ( $query ) = @_;
                    my $query_vec = make_vector( $query );
                    my %results = get_cosines( $query_vec );
                    return %results;
            }

All that remains is to sort the results by the cosine (in descending order), format them, and display them to the user.

You can find an object-oriented implementation of this code in [Listing 1](/media/_pub_2003_02_19_engine/VectorSpace.pm), complete with built-in stop list and some small changes to make the search go faster (for the curious, we normalize the document vectors before storing them, to save having to do it every time we run the `cosine` subroutine).

Once we've actually written the code, using it is straightforward:

        use Search::VectorSpace;



        my @docs = get_documents_from_somewhere();


        my $engine = Search::VectorSpace->new( docs => \@docs );


        $engine->build_index();
        $engine->set_threshold( 0.8 );


        while ( my $query = <> ) {
            my %results = $engine->search( $query );
            foreach my $result ( sort { $results{$b} <=> $results{$a} }
                                 keys %results ) {
                    print "Relevance: ", $results{$result}, "\n";
                    print $result, "\n\n";
            }


            print "Next query?\n";
        }

And there we have it, an instant search engine, all in Perl.

<span id="making it better">Making It Better</span>
===================================================

There are all kinds of ways to improve on this basic model. Here are a few ideas to consider:

**<span id="item_Better_parsing">Better parsing</span>**  
Our `get_words` subroutine is rudimentary - the code equivalent of a sharpened stick. For one thing, it will completely fail on text containing hyperlinks, acronyms or XML. It also won't recognize proper names or terms that contain more than one word ( like "Commonwealth of Independent States"). You can make the parser smarter by stripping out HTML and other markup with a module like `HTML::TokeParser`, and building in a part-of-speech tagger to find proper names and noun phrases (look for our own Lingua::Tagger::En, coming soon on the CPAN).

**<span id="item_Non%2DEnglish_collections">Non-English Collections</span>**  
Perl has great Unicode support, and the vector model doesn't care about language, so why limit ourselves to English? As long as you can write a parser, you can adapt the search to work with any language.

Most likely you will need a special stemming algorithm. This can be easy as pie for some languages (Chinese, Italian), and really hard for others (Arabic, Russian, Hungarian). It depends entirely on the morphology of the language. You can find published stemming algorithms online for several Western European languages, including German, Spanish and French.

**<span id="item_Similarity_search">Similarity Search</span>**  
It's easy to add a "find similar" feature to your search engine. Just use an existing document vector as your query, and everything else falls into place. If you want to do a similarity search on multiple documents, then add the vectors together.

**<span id="item_Term_weighting">Term Weighting</span>**  
**Term weighting** is a fancy way of saying "some words are more important than others". Done properly, it can greatly improve search results.

You calculate weights when building document vectors. **Local weighting** assigns values to words based on how many times they appear in a single document, while **global weighting** assigns values based on word frequency across the entire collection. The intuition is that rare words are more interesting than common words (global weighting), and that words that appear once in a document are not as relevant as words that occur multiple times (local weighting).

**<span id="item_Incorporating_metadata">Incorporating Metadata</span>**  
If your documents have metadata descriptors (dates, categories, author names), then you can build those in to the vector model. Just add a slot for each category, like you did for your keywords, and apply whatever kind of weighting you desire.

**<span id="item_Exact_phrase_matching">Exact Phrase Matching</span>**  
You can add arbitrary constraints to your result set by adding a chain of filters to your result set. An easy way to do exact phrase matching is to loop through your result set with a regular expression. This kind of post-processing is also a convenient way to sort your results by something other than relevance.

<span id="further reading">Further Reading</span>
=================================================

There's a vast body of material available on search engine design, but little of it is targeted at the hobbyist or beginner. The following are good places to start:

**<span id="item_http%3A%2F%2Fhotwired%2Elycos%2Ecom%2Fwebmonkey%2F"></span><http://hotwired.lycos.com/webmonkey/code/97/16/index2a.html?collection=perl>**  
This Webmonkey article dates back to 1997, but it's still the best tutorial on writing a reverse index search engine in Perl.

**<span id="item_http%3A%2F%2Fmoskalyuk%2Ecom%2Fsoftware%2Fperl%2Fs"></span><http://moskalyuk.com/software/perl/search/kiss.htm>**  
An example of a simple keyword search engine - no database, just a deep faith in Perl's ability to parse files quickly.

**<span id="item_http%3A%2F%2Fwww%2Emovabletype%2Eorg%2Fdownload%2E"></span><http://www.movabletype.org/download.shtml>**  
Movable Type is a popular weblog application, written in Perl. The search engine lives in MT::App::Search, and supports several advanced features. It's not pretty, but it's real production code.

**<span id="item_http%3A%2F%2Fjakarta%2Eapache%2Eorg%2Flucene%2Fdoc"></span><http://jakarta.apache.org/lucene/docs/index.html>**  
Lucene is a Java-based keyword search engine, part of the Apache project. It's a well-designed, open-source search engine, intended for larger projects. The documentation discusses some of the challenges of implementing a large search engine; it's worth reading even if you don't know Java.

**<span id="item_http%3A%2F%2Fmitpress%2Emit%2Eedu%2Fcatalog%2Fitem"></span><http://mitpress.mit.edu/catalog/item/default.asp?ttype=2&tid=3391>**  
*Foundations of Statistical Natural Language Processing*, MIT Press (hardcover textbook). Don't be put off by the title - this book is a fantastic introduction to all kinds of issues in text search, and includes a thorough discussion of vector space models.

**<span id="item_http%3A%2F%2Fwww%2Enitle%2Eorg%2Flsi%2Fintro%2F"></span><http://www.nitle.org/lsi/intro/>**  
An introduction to **latent semantic indexing**, the vector model on steroids. The document is aimed at nontechnical readers, but gives some more background information on using vector techniques to search and visualize data collections.

The adventurous can also download some Perl code for latent semantic indexing at <http://www.nitle.org/lsi.php.> Both the code and the article come from my own work for the National Institute for Technology and Liberal Education.
