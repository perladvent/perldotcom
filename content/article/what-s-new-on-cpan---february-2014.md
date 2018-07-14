{
   "categories" : "cpan",
   "description" : "A curated look at last month's new CPAN uploads",
   "slug" : "74/2014/3/3/What-s-new-on-CPAN---February-2014",
   "draft" : false,
   "date" : "2014-03-03T04:10:36",
   "tags" : [
      "module",
      "news"
   ],
   "authors" : [
      "david-farrell"
   ],
   "title" : "What's new on CPAN - February 2014",
   "image" : null
}


*Welcome to "What's new on CPAN" - a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!*

### APIs

-   Interact with AWS Simple Queue Services using: [AWS::SQS::Simple]({{<mcpan "AWS::SQS::Simple" >}})
-   [Dokuwiki::RPC::XML::Client]({{<mcpan "Dokuwiki::RPC::XML::Client" >}}) is a client for DokuWiki
-   Access the CampBX bitcoin trading platform using [Finance::CampBX]({{<mcpan "Finance::CampBX" >}})
-   InfluxDB is a time series database, [InfluxDB]({{<mcpan "InfluxDB" >}}) provides a Perl API.
-   Sync files between machines using using BitTorrent Sync and [Net::BitTorrentSync]({{<mcpan "Net::BitTorrentSync" >}})
-   [WebService::ImKayac::Simple]({{<mcpan "WebService::ImKayac::Simple" >}}) is a message sender for im.kayac, the notification service
-   Manage workflow jobs using [CA::WAAE]({{<mcpan "CA::WAAE" >}}) - an interface for CA's Workflow Automation product

### Apps

-   Buid static web sites with [App::Dapper]({{<mcpan "App::Dapper" >}})
-   Prettify JSON, YAML and Perl data and translate into other languages with [pretty]({{<mcpan "App::pretty" >}})

### Bots

-   Fly the Parrot AR.Drone using [UAV::Pilot::ARDrone]({{<mcpan "UAV::Pilot::ARDrone" >}})

### Data

-   [Gnuplot::Builder]({{<mcpan "Gnuplot::Builder" >}}) is an OO library for the gnuplot
-   Share data efficiently between processes using [Hash::SharedMem]({{<mcpan "Hash::SharedMem" >}})
-   [Image::Quantize]({{<mcpan "Image::Quantize" >}}) will quantize image data into 256 or fewer colours
-   Build JSON under memory constraints with [JSON::Builder]({{<mcpan "JSON::Builder" >}})
-   Generate random Japanese names using [Mock::Person::JP]({{<mcpan "Mock::Person::JP" >}})

### Development & System Administration

Find all CPAN modules that reference a particular CPAN module with [CPAN::ReverseDependencies]({{<mcpan "CPAN::ReverseDependencies" >}})

[warnings::MaybeFatal]({{<mcpan "warnings::MaybeFatal" >}}) will turn warnings FATAL at compile time only

[IPC::PrettyPipe]({{<mcpan "IPC::PrettyPipe" >}}) facilitates debugging and execution piped commands.

A whole host of new Dist::Zilla validation plugins:

-   Check for plugins performing actions outside of the appropriate phase with [Dist::Zilla::Plugin::VerifyPhases]({{<mcpan "Dist::Zilla::Plugin::VerifyPhases" >}})
-   [Dist::Zilla::Plugin::Test::DiagINC]({{<mcpan "Dist::Zilla::Plugin::Test::DiagINC" >}}) helps you find the @INC dependencies for a specific test failure
-   Check for clean namespaces: [Dist::Zilla::Plugin::Test::CleanNamespaces]({{<mcpan "Dist::Zilla::Plugin::Test::CleanNamespaces" >}})
-   [Dist::Zilla::Plugin::Breaks]({{<mcpan "Dist::Zilla::Plugin::Breaks" >}}) tracks breaking module versions as metadata and [Dist::Zilla::Plugin::Test::CheckBreaks]({{<mcpan "Dist::Zilla::Plugin::Test::CheckBreaks" >}}) tests for breaks

### Fun

-   Obfuscate text in the style of the Zalgo meme: [Acme::Zalgo]({{<mcpan "Acme::Zalgo" >}})
-   [SudokuTrainer]({{<mcpan "SudokuTrainer" >}}) helps detect successful Sudoku strategies

### Maths & Science

-   [AI::FANN::Evolving]({{<mcpan "AI::FANN::Evolving" >}}) is an evolving artificial neural implementation class for the Fast Artificial Neural Network library.

### Security

-   [Crypt::Curve25519]({{<mcpan "Crypt::Curve25519" >}}) will generate a shared secret using an elliptic-curve Diffie-Hellman function, for message encryption.
-   [Crypt::Lucifer]({{<mcpan "Crypt::Lucifer" >}}) is an implementation of IBM's Lucifer block cipher from the 1970s.
-   Enable ScryptKDF in DBIx::Class with [DBIx::Class::EncodedColumn::Crypt::Scrypt]({{<mcpan "DBIx::Class::EncodedColumn::Crypt::Scrypt" >}})

### Testing

-   [Test::Cucumber::Tiny]({{<mcpan "Test::Cucumber::Tiny" >}}) is a lightweight, plaintext-driven testing framework
-   Conveniently manage the state of DBIx::Class test data with [DBIx::Class::EasyFixture]({{<mcpan "DBIx::Class::EasyFixture" >}})
-   [Test::DiagINC]({{<mcpan "Test::DiagINC" >}}) will list all (deep) dependencies on test failure
-   Create a temporary instance of MongoDb for testing with [Test::mongod]({{<mcpan "Test::mongod" >}})

### Web

[HTTP::Entity::Parser]({{<mcpan "HTTP::Entity::Parser" >}}) is a PSGI compliant HTTP entity parser

Add a timeout and retry feature to HTTP::Tiny using [HTTP::Retry]({{<mcpan "HTTP::Retry" >}})

Make Catalyst user notification handling easier with [Catalyst::Plugin::SimpleMessage]({{<mcpan "Catalyst::Plugin::SimpleMessage" >}})

[Catalyst::Plugin::Session::Store::CHI]({{<mcpan "Catalyst::Plugin::Session::Store::CHI" >}}) let's you use the [CHI]({{<mcpan "CHI" >}}) module as the session store.

[Plack::Middleware::LightProfile]({{<mcpan "Plack::Middleware::LightProfile" >}}) is a simple profiler for Plack applications.

Dump the Apache server scoreboard when full with [Apache2::ScoreboardDumper]({{<mcpan "Apache2::ScoreboardDumper" >}})

New Mojolicious modules:

-   [Mojo::FriendFeed]({{<mcpan "Mojo::FriendFeed" >}}) is a non blocking FriendFeed listener
-   Run a generic TCP server with [Mojo::Server::TCP]({{<mcpan "Mojo::Server::TCP" >}})
-   Defer template rendering with [MojoX::Renderer::IncludeLater]({{<mcpan "MojoX::Renderer::IncludeLater" >}}) a template post-processor
-   [Mojolicious::Plugin::VHost]({{<mcpan "Mojolicious::Plugin::VHost" >}}) adds virtual hosts to Mojolicious

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F74%2F2014%2F3%2F3%2FWhat-s-new-on-CPAN-February-2014&text=What%27s+new+on+CPAN+-+February+2014&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F74%2F2014%2F3%2F3%2FWhat-s-new-on-CPAN-February-2014&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
