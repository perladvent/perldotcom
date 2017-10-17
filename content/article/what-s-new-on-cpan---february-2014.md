{
   "categories" : "cpan",
   "description" : "A curated look at last month's new CPAN uploads",
   "slug" : "74/2014/3/3/What-s-new-on-CPAN---February-2014",
   "draft" : false,
   "date" : "2014-03-03T04:10:36",
   "tags" : [
      "module",
      "news",
      "old_site"
   ],
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - February 2014",
   "image" : null
}


*Welcome to "What's new on CPAN" - a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!*

### APIs

-   Interact with AWS Simple Queue Services using: [AWS::SQS::Simple](https://metacpan.org/pod/AWS::SQS::Simple)
-   [Dokuwiki::RPC::XML::Client](https://metacpan.org/pod/Dokuwiki::RPC::XML::Client) is a client for DokuWiki
-   Access the CampBX bitcoin trading platform using [Finance::CampBX](https://metacpan.org/pod/Finance::CampBX)
-   InfluxDB is a time series database, [InfluxDB](https://metacpan.org/pod/InfluxDB) provides a Perl API.
-   Sync files between machines using using BitTorrent Sync and [Net::BitTorrentSync](https://metacpan.org/pod/Net::BitTorrentSync)
-   [WebService::ImKayac::Simple](https://metacpan.org/pod/WebService::ImKayac::Simple) is a message sender for im.kayac, the notification service
-   Manage workflow jobs using [CA::WAAE](https://metacpan.org/pod/CA::WAAE) - an interface for CA's Workflow Automation product

### Apps

-   Buid static web sites with [App::Dapper](https://metacpan.org/pod/App::Dapper)
-   Prettify JSON, YAML and Perl data and translate into other languages with [pretty](https://metacpan.org/pod/distribution/App-pretty/bin/pretty)

### Bots

-   Fly the Parrot AR.Drone using [UAV::Pilot::ARDrone](https://metacpan.org/pod/UAV::Pilot::ARDrone)

### Data

-   [Gnuplot::Builder](https://metacpan.org/pod/Gnuplot::Builder) is an OO library for the gnuplot
-   Share data efficiently between processes using [Hash::SharedMem](https://metacpan.org/pod/Hash::SharedMem)
-   [Image::Quantize](https://metacpan.org/pod/Image::Quantize) will quantize image data into 256 or fewer colours
-   Build JSON under memory constraints with [JSON::Builder](https://metacpan.org/pod/JSON::Builder)
-   Generate random Japanese names using [Mock::Person::JP](https://metacpan.org/pod/Mock::Person::JP)

### Development & System Administration

Find all CPAN modules that reference a particular CPAN module with [CPAN::ReverseDependencies](https://metacpan.org/pod/CPAN::ReverseDependencies)

[warnings::MaybeFatal](https://metacpan.org/pod/warnings::MaybeFatal) will turn warnings FATAL at compile time only

[IPC::PrettyPipe](https://metacpan.org/pod/IPC::PrettyPipe) facilitates debugging and execution piped commands.

A whole host of new Dist::Zilla validation plugins:

-   Check for plugins performing actions outside of the appropriate phase with [Dist::Zilla::Plugin::VerifyPhases](https://metacpan.org/pod/Dist::Zilla::Plugin::VerifyPhases)
-   [Dist::Zilla::Plugin::Test::DiagINC](https://metacpan.org/pod/Dist::Zilla::Plugin::Test::DiagINC) helps you find the @INC dependencies for a specific test failure
-   Check for clean namespaces: [Dist::Zilla::Plugin::Test::CleanNamespaces](https://metacpan.org/pod/Dist::Zilla::Plugin::Test::CleanNamespaces)
-   [Dist::Zilla::Plugin::Breaks](https://metacpan.org/pod/Dist::Zilla::Plugin::Breaks) tracks breaking module versions as metadata and [Dist::Zilla::Plugin::Test::CheckBreaks](https://metacpan.org/pod/Dist::Zilla::Plugin::Test::CheckBreaks) tests for breaks

### Fun

-   Obfuscate text in the style of the Zalgo meme: [Acme::Zalgo](https://metacpan.org/pod/Acme::Zalgo)
-   [SudokuTrainer](https://metacpan.org/pod/SudokuTrainer) helps detect successful Sudoku strategies

### Maths & Science

-   [AI::FANN::Evolving](https://metacpan.org/pod/AI::FANN::Evolving) is an evolving artificial neural implementation class for the Fast Artificial Neural Network library.

### Security

-   [Crypt::Curve25519](https://metacpan.org/pod/Crypt::Curve25519) will generate a shared secret using an elliptic-curve Diffie-Hellman function, for message encryption.
-   [Crypt::Lucifer](https://metacpan.org/pod/Crypt::Lucifer) is an implementation of IBM's Lucifer block cipher from the 1970s.
-   Enable ScryptKDF in DBIx::Class with [DBIx::Class::EncodedColumn::Crypt::Scrypt](https://metacpan.org/pod/DBIx::Class::EncodedColumn::Crypt::Scrypt)

### Testing

-   [Test::Cucumber::Tiny](https://metacpan.org/pod/Test::Cucumber::Tiny) is a lightweight, plaintext-driven testing framework
-   Conveniently manage the state of DBIx::Class test data with [DBIx::Class::EasyFixture](https://metacpan.org/pod/DBIx::Class::EasyFixture)
-   [Test::DiagINC](https://metacpan.org/pod/Test::DiagINC) will list all (deep) dependencies on test failure
-   Create a temporary instance of MongoDb for testing with [Test::mongod](https://metacpan.org/pod/Test::mongod)

### Web

[HTTP::Entity::Parser](https://metacpan.org/pod/HTTP::Entity::Parser) is a PSGI compliant HTTP entity parser

Add a timeout and retry feature to HTTP::Tiny using [HTTP::Retry](https://metacpan.org/pod/HTTP::Retry)

Make Catalyst user notification handling easier with [Catalyst::Plugin::SimpleMessage](https://metacpan.org/pod/Catalyst::Plugin::SimpleMessage)

[Catalyst::Plugin::Session::Store::CHI](https://metacpan.org/pod/Catalyst::Plugin::Session::Store::CHI) let's you use the [CHI](https://metacpan.org/pod/CHI) module as the session store.

[Plack::Middleware::LightProfile](https://metacpan.org/pod/Plack::Middleware::LightProfile) is a simple profiler for Plack applications.

Dump the Apache server scoreboard when full with [Apache2::ScoreboardDumper](https://metacpan.org/pod/Apache2::ScoreboardDumper)

New Mojolicious modules:

-   [Mojo::FriendFeed](https://metacpan.org/pod/Mojo::FriendFeed) is a non blocking FriendFeed listener
-   Run a generic TCP server with [Mojo::Server::TCP](https://metacpan.org/pod/Mojo::Server::TCP)
-   Defer template rendering with [MojoX::Renderer::IncludeLater](https://metacpan.org/pod/MojoX::Renderer::IncludeLater) a template post-processor
-   [Mojolicious::Plugin::VHost](https://metacpan.org/pod/Mojolicious::Plugin::VHost) adds virtual hosts to Mojolicious

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F74%2F2014%2F3%2F3%2FWhat-s-new-on-CPAN-February-2014&text=What%27s+new+on+CPAN+-+February+2014&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F74%2F2014%2F3%2F3%2FWhat-s-new-on-CPAN-February-2014&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
