{
   "tags" : [
      "data-aggregation",
      "data-warehousing",
      "enterprise-perl",
      "large-perl-systems",
      "perl-rdf",
      "perl-xml",
      "sax-machines",
      "officebusiness"
   ],
   "thumbnail" : "/images/_pub_2005_05_05_aggregation/111-massive_data.gif",
   "date" : "2005-05-05T00:00:00-08:00",
   "categories" : "data",
   "image" : null,
   "title" : "Massive Data Aggregation with Perl",
   "slug" : "/pub/2005/05/05/aggregation.html",
   "description" : " This article is a case study of the use of Perl and XML/RDF technologies to channel disparate sources of data into a semi-structured repository. This repository helped to build structured OLAP warehouses by mining an RDF repository with SAX...",
   "authors" : [
      "fred-moyer"
   ],
   "draft" : null
}



This article is a case study of the use of [Perl](http://www.perl.org/) and [XML](http://www.w3.org/XML/)/[RDF](http://www.w3.org/RDF/) technologies to channel disparate sources of data into a semi-structured repository. This repository helped to build structured [OLAP](http://en.wikipedia.org/wiki/OLAP) warehouses by mining an RDF repository with [SAX machines](https://metacpan.org/XML::SAX::Machines). Channels of data included user-contributed datasets, data from FTP and HTTP remote-based repositories, and data from other intra-enterprise based assets. We called the system the 'Kitchen Sync', but one of the project's visionaries best described it as akin to a device that accepts piles of random coins and returns them sorted for analysis. This system collected voter data and was the primary data collection point in a national organization for the presidential campaign during the 2004 election.

### Introduction

My initial question was why anyone would want to store data in XML/RDF formats. It's verbose, it lacks widely accepted query interfaces (such as SQL), and it generally requires more work than a database. XML, in particular, is a great messaging interface, but a poor persistence medium.

Eventually, I concluded that this particular implementation did benefit from the use of XML and RDF as messaging protocols. The messaging interface involved the use of SAX machines to parse a queue of XML and RDF files. The XML files contained the metadata for what we called polls, and the RDF files contained data from those polls. We had a very large buffer, from which cron-based processes frequently constructed data warehouses for analysis.

### Hindsight and Realizations

The difficulty of this project was in the gathering of requirements and vendor interfacing. When implementing application workflow, it is critical to use a programming language that doesn't get in the way and allows you to do what you want--and that is where Perl really shined. A language that allows for quick development is an asset, especially in a rushed environment where projects are due "yesterday". The code samples here are not examples of how to write great object-oriented Perl code. They are real world examples of the code used to get things done in this project.

For example, when a voter-data vendor changed its poll format, our data collection spiders stopped returned data and alerted our staff immediately. In just minutes, we adapted our SAX machine to the vendor's new format and we had our data streams back up and running. It would have taken hours or days to call the vendor about the change and engage in a technical discussion to get them to do things our way. Instead, Perl allowed us to adapt to their ways quickly and efficiently.

### Project Goals

The architects of this project specified several goals and metrics for the application. The main goals--with the penultimate objective being to accumulate as much data as possible before election day--were to:

-   Develop a web-based application for defining metadata of polls, and uploading sets of poll data to the system.

    The application had to give the user the ability to define sets of questions and answers known as polls. Poll metadata could contain related data contained in documents of standard business formats (*.doc*, *.pdf*). The users also needed an easy method, one that minimized possible errors, to upload data to the system.

-   Meet requirements of adding 50 million new records per day.

    That metric corresponds to approximately 578 records per second. Assuming a non-linear load distribution over time, peak transaction requirements were likely to be orders of magnitude higher than the average of 578 per second.

-   Develop a persistent store for RDF and XML data representing polls and poll data.

    The web application had to generate XML documents from poll definitions and RDF documents from uploaded poll data. We stored the poll data in RDF. We needed an API to manage these documents.

-   Develop a mechanized data collection system for the retrieval of data from FTP- and HTTP-based data repositories.

    The plan was to assimilate data sources into our organization from several commercial and other types of vendors. Most vendors had varying schemas and formats for their data. We wanted to acquire as much data as possible before the election to gauge voter support levels and other key metrics crucial to winning a political election.

### Web Application

When I started this project, I had been using [mod\_perl2](http://perl.apache.org/docs/2.0/index.html) extensively in prototyping applications and also as a means of finding all of the cool new features. Mod\_perl2 had proven itself stable enough to use in production, so I implemented a Model-View-Controller application design pattern using a native mod\_perl2 and an [libapreq2](http://httpd.apache.org/apreq/docs/libapreq2/)-enabled [Apache server](http://httpd.apache.org/). I adopted the controller design patterns from recipes in the [Modperl Cookbook](http://www.modperlcookbook.org/). The model classes subclassed [Berkeley DBXML](http://www.sleepycat.com/products/xml.shtml) and [XML::LibXML]({{<mcpan "XML::LibXML" >}}) for object methods and persistence. We used [Template Toolkit]({{<mcpan "Template::Toolkit" >}}) to implement views. (I will present more about the specifics of the persistence layer later in this article.)

Of primary importance with the web application component of the system was ease of use. If the system was not easy to use, then we would likely receive less data as a result of user frustration. The component of the web application that took extended transaction processing time was the poll data upload component.

If the user uploads a 10MB file on a 10Kbps upstream connection (common for residential DSL lines), the transaction would take approximately twenty minutes. On a 100Kbps upstream connection (business grade DSL), the transaction would take two minutes--certainly much longer than most unsuspecting users would wait before clicking on the browser refresh button.

To prevent the user from accidentally corrupting the lengthy upload process, I created a monitoring browser window which opened via the following [JavaScript](http://www.mozilla.org/js/) call when the user clicked the upload button.

    <input type=submit name='submit' value='Upload'
        onClick="window.open('/ksync/dataset/monitor', 'Upload',
           'width=740,height=400')">

The server forked off a child process which read the upload status from a [BerkeleyDB](http://www.sleepycat.com/products/db.shtml) database. The parent process used a [libapreq](http://httpd.apache.org/apreq/) [UPLOAD\_HOOK](http://httpd.apache.org/apreq/docs/libapreq2/group__apreq__xs__request.html#item_upload_hook)-based approach to measure the amount of data uploaded, and to write that plus a few other metrics to the BerkeleyDB database. The following is a snippet of code from the upload handler:

    <Location /ksync/poll/data/progress>
        PerlResponseHandler KSYNC::Apache::Data::Upload->progress
    </Location>

    sub progress : method {
        my ( $self, $r ) = @_;

        # We deal with commas and tabs as delimiters currently
        my $delimiter;

        # Create a BerkeleyDB to keep track of upload progress
        my $db = _init_status_db( DB_CREATE );

        # Get the specifics of the poll we're getting data for
        my $poll = $r->pnotes('SESSION')->{'poll'};

        # Generate a unique identifier for files based on the poll
        my $id = _file_id($poll);

        # Store any data which does not validate according to the poll schema
        my $invalid = IO::File->new();
        my $ivfn = join '', $config->get('data_root'), '/invalid/', $id, '.txt';
        $invalid->open("> $ivfn");

        # Set the rdf filename
        my $gfn = join '', $config->get('data_root'), '/valid/', $id, '.rdf';

        # Create an RDF document object to store the data
        my $rdf = KSYNC::Model::Poll::Data::RDF->new(
                    $gfn,
                    $poll,
                    $r->pnotes('SESSION')->{'creator'},
                    DateTime->now->ymd,
        );

        # Get the poll questions for to make sure the answers are valid
        my $questions = $poll->questions;

        # Create a data structure to hold the answers to validate against.
        my @valid_answers = _valid_answers($questions);

        # And a data structure to hold the validation results
        my $question_data = KSYNC::Model::Poll::validation_results($questions);

        # Set progress store parameters
        my $length              = 0;
        my $good_lines_total    = 0;
        my $invalid_lines_total = 0;
        my $began;              # Boolean to determine if we've started parsing data
        my $li                  = 1;    # Starting line number

        # The subroutine to process uploaded data
        my $fragment;
        my $upload_hook = sub {
            my ( $upload, $data, $data_len, $hook_data ) = @_;

            if ( !$began ) {   # If this is the first set check the array length

                # Chop up the stream
                my @lines = split "\n", $data;

                # Determine the delimiter for this line
                $delimiter = _delimiter(@lines);

                unless ( ( split( /$delimiter/, $lines[0] ) ) ==
                    scalar( @{$question_data} ) + 1 )
                {
                    $db->db_put( 'done', '1' );

                    # The dataset isn't valid, so throw an exception
                    KSYNC::Apache::Exception->throw('Invalid Dataset!');
                }
            }

            # Mark the start up the upload
            $began = 1;

            # Validate the data against the poll answers we've defined
            my ( $good_lines, $invalid_lines );

            ( $good_lines, $invalid_lines, $question_data, $li, $fragment ) =
              KSYNC::Model::Poll::Data::validate( \@valid_answers,
                                                  $data,
                                                  $question_data,
                                                  $li,
                                                  $delimiter,
                                                  $fragment );

            # Keep up the running count of good and invalid lines
            $good_lines_total     += scalar( @{$good_lines} );
            $invalid_lines_total  += scalar( @{$invalid_lines} );

            # Increment the number of bytes processed
            $length += length($data);

            # Update the status for the monitor process
            $db->db_put(
                         valid     => $good_lines_total,
                         invalid   => $invalid_lines_total,
                         bytes     => $length,
                         filename  => $upload->filename,
                         filetype  => $upload->type,
                         questions => $question_data,
                       );

            # And store the data we've collected
            $rdf->write( $good_lines ) if scalar( @{$good_lines} );

            # Write out any invalid data points to a separate file
            _write_txt( $invalid, $invalid_lines ) if scalar( @{$invalid_lines} );
        };

        my $req = Apache::Request->new(
            $r,
            POST_MAX    => 1024 * 1024 * 1024,    # One Gigabyte
            HOOK_DATA   => 'Note',
            UPLOAD_HOOK => $upload_hook,
            TEMP_DIR    => $config->get('temp_dir'),
        );

        my $upload = eval { $req->upload( scalar +( $req->upload )[0] ) };
        if ( ref $@ and $@->isa("Apache::Request::Error") ) {

            # ... handle Apache::Request::Error object in $@
            $r->headers_out->set( Location => 'https://'
                  . $r->construct_server
                  . '/ksync/poll/data/upload/aborted' );
            return Apache::REDIRECT;
        }

        # Finish up
        $invalid->close;
        $rdf->save;

        # Set status so the progress window will close
        $db->db_put('done', 1');
        undef $db;

        # Send the user to the summary page
        $r->headers_out->set(
          Location => join('',
                           'https://',
                           $r->construct_server,
                           '/poll/data/upload/summary',
                          )
        );
        return Apache::REDIRECT;
    }

During the upload process, the users saw a status window which refreshed every two seconds and had a pleasant animated GIF to enhance their experience, as well as several metrics on the status of the upload. One user uploaded a file that took 45 minutes because of a degraded network connection, but the uploaded file had no errors.

The system converted [CSV](http://en.wikipedia.org/wiki/Comma-separated_values) files that users uploaded into RDF and saved them to the RDF store during the upload process. Because of the use of the UPLOAD\_HOOK approach for processing uploaded data, the mod\_perl-enabled Apache processes never grew in size or leaked memory as a result of handling the upload content.

### Poll and Poll Data Stores

Several parties involved raised questions about the use of XML and RDF as persistence mediums. Why not use a relational database? Our primary reasons for deciding against a relational database were that we had several different schemas and formats of incoming data, and we needed to be able to absorb huge influxes of data in very short time periods.

Consider how a relational database could have handled the variation in schemas and formats. Creating vendor-specific drivers to handle each format would have been straightforward. To handle the variations in schema, we could have normalized each data stream and its attributes so that we could store all the data in source, object, attribute, and value tables. The problem with that approach is that you get one really big table with all the values, which becomes more difficult to manage as time goes on. Another possible approach, which I have used in the past, is to create separate tables for each data stream to fit the schema, and then use the power of left, right, and outer joins to extract the needed information. It scales much better than the first approach but it is not as well suited for data mining as warehouses are.

With regard to absorbing a lot of data very quickly, transactional relational databases have limitations when you insert or update data in a table with many rows. Additionally, the insert and update transactions are not asynchronous. When inserting or updating a record, the transaction will not complete until the indexes associated with the indexed fields of that record have updated. This slows down as the database grows in size.

We wanted the transactions between users, machines, and the Kitchen Sync to be as asynchronous as possible. Our ability to take in data in RDF format would not degrade with increasing amounts of data already taken in before warehousing for analysis. Data exchange challenges between vendors and us included a few large transactions in RDF format per data set, and how the length of the transaction time depended solely on the speed of the network connection between the vendor and our data center.

With the decision to use XML for storing poll metadata and RDF for storing poll data in place, we turned our attention to the specifics of the persistence layer. We stored the poll objects in XML, as shown in this example:

    <?xml version="1.0"?>
    <poll>
        <creator>Fred Moyer</creator>
        <date>2005-03-01</date>
        <vendor>Voter Data Inc.</vendor>
        <location>https://www.voterdatainc.com/poll/1234</location>
        <questions>
            <question>
                <name>Who is buried in Grant's Tomb?</name>
                <answers>
                    <answer>
                        <name>Ulysses Grant</name>
                        <value>0</value>
                    </answer>
                    <answer>
                        <name>John Kerry</name>
                        <value>1</value>
                    </answer>
                    <answer>
                        <name>George Bush</name>
                        <value>2</value>
                    </answer>
                    <answer>
                        <name>Alfred E.  Neumann</name>
                        <value>3</name>
                    </answer>
                </answers>
            </question>
        </questions>
        <media>
            <pdf>
                <name>Name of a PDF file describing this poll</name>
                <raw>The raw contents of the PDF file</raw>
                <text>The text of the PDF file, generated with XPDF libs</text>
            </pdf>
        </media>
    </poll>

We also needed an API to manage those documents. We chose [Berkeley DBXML](http://www.sleepycat.com/products/xml.shtml) because of its simple but effective API and its ability to scale to terabyte size if needed. We created a poll class which subclassed the Sleepycat and XML::LibXML modules and provided some Perlish methods for manipulating polls.

    package KSYNC::Model::Poll;

    use strict;
    use warnings;

    use base qw(KSYNC::Model);
    use SleepyCat::DbXml qw(simple);
    use XML::LibXML;
    use KSYNC::Exception;

    my $ACTIVITY_LOC = 'data/poll.dbxml';

    BEGIN {
        # Initialize the DbXml database
        my $container = XmlContainer->new($ACTIVITY_LOC);
    }

    # Call base class constructor KSYNC::Model->new
    sub new {
        my ($class, %args) = @_;

        my $self = $class->SUPER::new(%args);
        return $self;
    }

    # Transform the poll object into an xml document
    sub as_xml {
        my ($self, $id) = @_;

        my $dom = XML::LibXML::Document->new();
        my $pi = $dom->createPI( 'xml-styleshet',
                                 'href="/css/poll.xsl" type="text/xsl"' );
        $dom->appendChild($pi);
        my $element = XML::LibXML::Element->new('Poll');

        $element->appendTextChild('Type',        $self->type);
        $element->appendTextChild('Creator',     $self->creator);
        $element->appendTextChild('Description', $self->description);
        $element->appendTextChild('Vendor',      $self->vendor);
        $element->appendTextChild('Began',       $self->began);
        $element->appendTextChild('Completed',   $self->completed);

        my $questions = XML::LibXML::Element->new('Questions');

        for my $question ( @{ $self->{question} } ) {
            $questions->appendChild($question->as_element);
        }

        $element->appendChild($questions);

        $dom->setDocumentElement($element);
        return $dom;
    }

    sub save {
        my $self = shift;

        # Connect to the DbXml databae
        $container->open(Db::DB_CREATE);

        # Create a new document for storage from xml serialization of $self
        my $doc = XmlDocument->new();
        $doc->setContent($self->as_xml);

        # Save, throw an exception if problems happen
        eval { $container->putDocument($doc); };
        KSYNC::Exception->throw("Could not add document: $@") if $@;

        # Return the ID of the newly added document
        return $doc->getID();
    }

We chose RDF as the format for poll data because the format contains links to resources that describe the namespaces of the document, making the document self-describing. The availability of standardized namespaces such as [Dublin Core](http://dublincore.org/) gave us predefined tags such as `dc:date` and `dc:creator`. We added our own namespaces for representation of poll data. Depending on what verbosity of data the vendors kept, we could add `dc:date` tags to different portions of the document to provide historical references. We constructed our URLs in a [REST](http://en.wikipedia.org/wiki/REST) format for all web-based resources.

    <?xml version="1.0" encoding="UTF-8"?>
    <rdf:RDF
        xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:ourparty="http://www.ourparty.org/xml/schema#">

        <rdf:Description rdf:about="http://www.ourparty.org/poll/1234">
            <dc:date>2004-10-14</dc:date>
                <dc:creator>fmoyer@plusthree.com</dc:creator>
            </rdf:Description>

            <rdf:Bag>
            <rdf:li ourparty:id="6372095736" ourparty:question="1"
                ourparty:answer="1" dc:date="2005-03-01" />
            <rdf:li ourparty:id="2420080069" ourparty:question="2"
                ourparty:answer="3" dc:date="2005-03-02" />
        </rdf:Bag>
    </rdf:RDF>

We used [SAX machines]({{<mcpan "XML::SAX::Machines" >}}) as drivers to generate summary models of RDF files and [LibXML]({{<mcpan "LibXML" >}}) streaming parsers to traverse the RDF files. We stacked drivers by using [pipelined SAX machines]({{<mcpan "XML::SAX::Pipeline" >}}) and constructed SAX drivers for the different vendor data schemas. Cron-based machines scanned the RDF store, identified new poll data, and processed them into summary XML documents which we served to administrative users via XSLT transformations. Additionally, we used the SAX machines to create denormalized SQL warehouses for data mining.

An example SAX driver for Voter Data, Inc. RDF poll data:

    package KSYNC::SAX::Voterdatainc;

    use strict;
    use warnings;

    use base qw(KSYNC::SAX);

    my %NS = (
        rdf      => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
        dc       => 'http://purl.org/dc/elements/1.1/',
        ourparty => 'http://www.ourparty.org/xml/schema#',
    );

    my $VENDOR = 'Voter Data, Inc.';

    sub new {
        my $class = shift;

        # Call the super constructor to create the driver
        my $self = $class->SUPER::new(@_, { vendor => $VENDOR });

        return $self;
    }

    sub start_element {
        my ($self, $data) = @_;

        # Process rdf:li elements
        if ( $data->{Name} eq 'rdf:li' ) {

            # Grab the data
            my $id      = $data->{Attributes}{ "{$NS{ourparty}}id" }{Value};
            my $answer  = $data->{Attributes}{ "{$NS{ourparty}}answer" }{Value};
            my $creator = $data->{Attributes}{ "{$NS{dc}}creator" }{Value};
            my $date    = $data->{Attributes}{ "{$NS{dc}}date" }{Value};

            # Map the data to a common response
            $self->add_response({ vendor        => $VENDOR,
                                  voter_id      => $id,
                                  support_level => $answer,
                                  creator       => $creator,
                                  date          => $date,
                               });

            # Call the base class start_element method to do something with the data
            $self->SUPER::start_element($data);
    }

    1;

We stored RDF documents compressed in bzip2 format, because bzip2 compression algorithm is especially efficient at compressing repeating element data. As shown below in the SAX machine example, using `bzcat` as the intake to a pipeline parser allowed decompression of the bzip2 documents for parsing and creating a summary of a poll data set.

    #!/usr/bin/env perl

    use strict;
    use warnings;

    use KSYNC::SAX::Voterdatainc;
    use XML::SAX::Machines qw(Pipeline);

    # The poll data
    my $rdf = 'data/voterdatainc/1759265.rdf.bz2';

    # Create a vendor specific driver
    my $driver = KSYNC::SAX::Voterdatainc->new();

    # Create a driver to add the data to a data warehouse handle
    my $dbh = KSYNC::DBI->connect();
    my $warehouser = KSYNC::SAX::DBI->new(
                        source => 'http://www.voterdatainc/ourparty/poll.xml',
                        dbh    => $dbh,
                    );

    # Create a parser which uncompresses the poll data set, summarizes it, and
    # outputs data to a filter which warehouses the denormalized data
    my $parser = Pipeline(
                    "bzcat $rdf |" =>
                    $driver        =>
                    $warehouser    =>
    ;

    # Parse the poll data
    $parser->parse();

    # Summarize the poll data
    print "Average support level:  ",   $driver->average_support_level, "\n";
    print "Starting date:  ",         $driver->minimum_date, "\n";
    print "Ending date:  ",       $driver->maximum_date, "\n";

Between the polls, the XML Schema dictionaries, and the RDF files, we know who the polls contacted, what they saw, and how they responded. A major benefit of keeping the collected information in RDF format is the preservation of historical information. We constructed SQL warehouses to analyze changes in voter support levels over time. This was critical for measuring the effect of events such as presidential debates on voter interest and support.

Using RDF also provided us with the flexibility to map new data sources as needed. If a vendor collected some information which we had not processed before, they would add an `about` tag such as `<rdf:Description rdf:about="http://www.datavendor.com/ourparty/poll5.xml" />` , which we would map to features of our SAX machines as needed.

We added some hooks to the SAX machines to match certain URIs and then process selected element data. Late in the campaign, when early voting started, we were able to quickly modify our existing SAX machines to collect early voting data from the data streams and produce SQL warehouses for analysis.

### Mechanization of Data Collection

A major focus of the application was retrieving data from remote sources. Certain vendors used our secure FTP site to send us data, but most had web and FTP sites to which they posted the information. We needed a way to collect data from those servers. Some vendors were able to provide data to us in XML and RDF formats, but for the most part, we would receive data in CSV, TSV, or some form of XML. Each vendor generally had supplementary data beyond the normal voter data fields which we also wanted to capture. Using that additional data was not an immediate need, but by storing it in RDF format we could extract it and generate SQL warehouses whenever necessary.

We developed a part of the application known as the spider and created a database table containing information on the data source authentication, protocol, and data structure details. A factory class `KSYNC::Model::Spider` read the data source entries and constructed spider objects for each data source. These spiders used [Net::FTP]({{<mcpan "Net::FTP" >}}) and [LWP]({{<mcpan "LWP" >}}) to retrieve poll data, and processed the data using the appropriate `KSYNC::SAX` machine. To add a new data source to our automated collection system, an entry in the database configured the spider, and if the new data source had data in a format that we did not support, we added a SAX machine for that data source.

An example of spider usage:

    package KSYNC::Model::Spider;

    use strict;
    use warnings;

    use Carp 'croak';
    use base 'KSYNC::Model';

    sub new {
        my ($class, %args) = @_;

        # Create an FTP or HTTP spider based on the type specified in %args
        my $spider_pkg = $class->_factory($args{type});
        my $self = $spider_pkg->new(%args);

        return $self;
    }

    sub _factory {
        my ($class, $type) = @_;

        # Create the package name for the spider type
        my $pkg = join '::', $class, $type;

        # Load the package
        eval "use $pkg";
        croak("Error loading factory module: $@") if $@;

        return $pkg;
    }

    1;

    package KSYNC::Model::Spider::FTP;

    use Net::FTP;
    use KSYNC::Exception;

    sub new {
        my ($class, %args) = @_;

        my $self = { %args };

        # Load the appropriate authentication package via Spider::Model::Auth
        # factory class
        $self->{auth} = Spider::Model::Auth->new(%{$args{auth}});

        return bless $self, $class;
    }

    sub authenticate {
        my $self = shift;

        # Login
        eval { $self->ftp->login($self->auth->username, $self->auth->password); };

        # Throw an exception if problems occurred
        KSYNC::Exception->throw("Cannot login ", $self->ftp->message) if $@;
    }

    sub crawl {
        my $self = shift;

        # Set binary retrieval mode
        $self->ftp->binary;

        # Find new poll data
        my @datasets = $self->_find_new();

        # Process that poll data
        foreach my $dataset (@datasets) {
            eval { $self->_process($dataset); };
            $self->error("Could not process poll data $dataset->id", $@) if $@;
        }
    }

    sub ftp {
        croak("Method Not Implemented!") if @_ > 1;
        $_[0]->{ftp} ||= Net::FTP->new($self->auth->host);
    }

    1;

    #!/usr/bin/env perl

    use strict;
    use warnings;

    use KSYNC::Model::Spider;
    use KSYNC::Model::Vendor;

    # Retrieve a vendor so we can grab their latest data
    my $vendor = KSYNC::Model::Vendor->retrieve({
      name => 'Voter Data, Inc.',
    });

    # Construct a spider to crawl their site
    my $spider = KSYNC::Model::Spider->new({ type => $vendor->type });

    # Login
    $spider->login();

    # Grab the data
    $spider->crawl();

    # Logout
    $spider->logout();

    1;

### Conclusions

In this project, getting things done was of paramount importance. Perl allowed us to deal with the complexities of the business requirements and the technical details of data schemas and formats without presenting additional technical obstacles, as programming languages occasionally do. The [CPAN](http://www.cpan.org), [mod\_perl](http://perl.apache.org), and [libapreq](http://httpd.apache.org/apreq) provided the components that allowed us to quickly build an application to deal with complex, semi-structured data on an enterprise scale. From creating a user friendly web application to automating data collection and SQL warehouse generation, Perl was central to the success of this project.

### Credits

Thanks to the following people who made this possible and contributed to this project: Thomas Burke, Charles Frank, Lyle Brooks, Lina Brunton, Aaron Ross, Alan Julson, Marc Schloss, and Robert Vadnais.

Thanks to [Plus Three LP](http://www.plusthree.com/) for sponsoring work on this project.
