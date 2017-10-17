{
   "categories" : "cpan",
   "image" : "/images/181/88AAA022-2639-11E5-B854-07139DAABC69.png",
   "slug" : "181/2015/7/9/What-s-new-on-CPAN---June-2015",
   "date" : "2015-07-09T13:17:10",
   "tags" : [
      "catalyst",
      "dancer",
      "mojo",
      "selenium",
      "solr",
      "slack",
      "dx",
      "hipchat",
      "ditaa",
      "bonusly",
      "zendesk",
      "old_site"
   ],
   "title" : "What's new on CPAN - June 2015",
   "description" : "Our monthly curated guide to CPAN's newest modules",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ]
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

### Module of the month

[Class::Storage](https://metacpan.org/pod/Class::Storage) is a module for serializing blessed references (objects). Once serialized, an object can be transmitted via JSON, XML, YAML or saved in a data store. Serializing objects can also make IPC easier: coroutines, threads and other processes can pass text but blessed references are often an issue.

Module author Peter Valdemar Mørch has pulled together excellent documentation. A welcome addition to CPAN, check out the acknowledgements [section](https://metacpan.org/pod/Class::Storage#ACKNOWLEDGEMENTS) for some interesting background on the module. For an alternative approach, you might be interested in [Object::Serializer](https://metacpan.org/pod/Object::Serializer). For non-readable serializers, checkout [Storable](https://metacpan.org/pod/Storable) and the newer and faster [Sereal](https://metacpan.org/pod/Sereal).

**Important** - when working with object serializers like Class::Storage, only deserialize trusted data, as malicious code can be injected into the data, and when the data is deserialized, the code will be executed automatically. See for example this bug [report](https://rt.cpan.org/Public/Bug/Display.html?id=105772) (*Thanks to Reini Urban for the reminder*).

### APIs & Apps

-   [API::Zendesk](https://metacpan.org/pod/API::Zendesk) provides a Perl interface for the customer support app
-   Painlessly install libsvm, the support vector machine library using [Alien::LIBSVM](https://metacpan.org/pod/Alien::LIBSVM)
-   Use Slack? Of course you do. Check out [AnyEvent::SlackRTM](https://metacpan.org/pod/AnyEvent::SlackRTM)
-   Develop your first Slack bot with [Bot::Backbone::Service::SlackChat](https://metacpan.org/pod/Bot::Backbone::Service::SlackChat)!
-   [Interchange::Search::Solr](https://metacpan.org/pod/Interchange::Search::Solr) let's you use Solr search with Perl
-   Be popular, send your co-workers Bonusly with [WebService::Bonusly](https://metacpan.org/pod/WebService::Bonusly)
-   [WebDriver::Tiny](https://metacpan.org/pod/WebDriver::Tiny) is an all-new implementation of a Selenium webdriver API for Perl

### Config & DevOps

-   [Config::App](https://metacpan.org/pod/Config::App) implements "cascading configurations" - looks like a convenient way to have context-specific configurations without resorting to Perl code
-   Quickly rind files on your Mac using [Mac::FindFile](https://metacpan.org/pod/Mac::FindFile)
-   [Perl::Critic::Freenode](https://metacpan.org/pod/Perl::Critic::Freenode) is a compilation of policies recommended by the folks on the \#perl channel on freenode IRC
-   Include ditaa diagrams in pod with [Pod::Weaver::Plugin::Ditaa](https://metacpan.org/pod/Pod::Weaver::Plugin::Ditaa)

### Data

-   Extract data from your Zoom 5341J cable modem with [Device::CableModem::Zoom5341J](https://metacpan.org/pod/Device::CableModem::Zoom5341J)
-   [Log::Dispatch::HipChat](https://metacpan.org/pod/Log::Dispatch::HipChat) will send your log messages to HipChat
-   Moving averages are easy to implement, and easy to get wrong. The next time you need one, consider [Math::SMA](https://metacpan.org/pod/Math::SMA)
-   If you're working with 35mm film and DX codes, you might like [Photography::DX](https://metacpan.org/pod/Photography::DX)

### Development and Version Control

-   When stuck in Git merge conflict hell, sometimes it's easier to say "I'm right". [App::Git::Workflow::Command::Take](https://metacpan.org/pod/App::Git::Workflow::Command::Take) let's you tell Git to merge your changes. You win!
-   If you have a load of Git repos that you'd like to execute a command against, you might like [App::Multigit](https://metacpan.org/pod/App::Multigit)
-   [Assert::Conditional](https://metacpan.org/pod/Assert::Conditional) from Tom Christiansen let's you conditionally compile assertions into your Perl programs, ala C's assert.h. Wow
-   Daemonize *anything* with [JIP::Daemon](https://metacpan.org/pod/JIP::Daemon)

### Text & Language

-   [Acme::Unicodify](https://metacpan.org/pod/Acme::Unicodify) can convert ASCII text into Unicode-esque characters
-   [Crypt::RS14\_PP](https://metacpan.org/pod/Crypt::RS14_PP) is a pure Perl implementation of the RS14 encryption algorithm
-   Convert HTML into FreeStyleWiki markup using [HTML::WikiConverter::FreeStyleWiki](https://metacpan.org/pod/HTML::WikiConverter::FreeStyleWiki)
-   Awesome! detect the language with [Lingua::Identify::CLD2](https://metacpan.org/pod/Lingua::Identify::CLD2)
-   [Text::Hogan](https://metacpan.org/pod/Text::Hogan) is a Perl clone of hogan.js, the JavaScript template engine. Supports pre-compilation!

### Science and Mathematics

-   [Algorithm::BloomFilter](https://metacpan.org/pod/Algorithm::BloomFilter) is a simple, superfast bloom filter implementation written in XS
-   Not a new module, but it is new to CPAN, [App::Chart](https://metacpan.org/pod/App::Chart) the visual charting library is useful
-   [BioX::Workflow](https://metacpan.org/pod/BioX::Workflow) is an "opinionated template based workflow writer", hailing from the Bioinformatics World, but not just for BioX
-   The Longest Common Subsequence algorithm is used for diffing text, among other uses. [LCS::XS](https://metacpan.org/pod/LCS::XS) is a supercharged version, written in XS

### Web

-   Extract all of the supported URLs from your Catalyst app using [Catalyst::Plugin::ActionPaths](https://metacpan.org/pod/Catalyst::Plugin::ActionPaths) (disclosure, I'm the module author)
-   [Dancer::Plugin::Piwik](https://metacpan.org/pod/Dancer::Plugin::Piwik) helps you integrate Pwik analytics with a Dancer app
-   Use MongoDB with Minion, the job queue application using [Minion::Backend::MongoDB](https://metacpan.org/pod/Minion::Backend::MongoDB)
-   [Mojo::Reactor::UV](https://metacpan.org/pod/Mojo::Reactor::UV) let's you use the C library, libuv as the backend event loop for your Mojo application
-   Rapidly expand shortened URLs with [WWW::Expand::More](https://metacpan.org/pod/WWW::Expand::More). Cool!

Updated to include other example serializer modules and deserialization warning - 2015-07-09

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
