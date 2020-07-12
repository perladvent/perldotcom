{
   "categories" : "cpan",
   "title" : "What's new on CPAN - February 2020",
   "tags" : ["gimp","recaptcha","sendgrid","neo4j","mosmix","git","rundeck","zydeco","raycast","kelp","plack","var-mystic","test-arrow"],
   "authors" : [
      "david-farrell"
   ],
   "date" : "2020-03-12T00:46:47",
   "description" : "Lot's of new distributions were added to CPAN in February: Git, Windows, a new OO framework, an alternative PerlIO and more feature.",
   "image" : "/images/156/18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png",
   "thumbnail" : "/images/156/thumb_18F30D70-C0E3-11E4-AB33-E3A60EA848F6.png",
   "draft" : false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [API::GitForge]({{< mcpan "API::GitForge" >}}) is a generic interface to APIs of sites like GitHub, GitLab etc.
* Build GIMP from its git repo using [App::gimpgitbuild]({{< mcpan "App::gimpgitbuild" >}})
* Use reCAPTCHA API version v3 with [Captcha::reCAPTCHA::V3]({{< mcpan "Captcha::reCAPTCHA::V3" >}})
* Work with the Windows Credential Manager using [credsman]({{< mcpan "credsman" >}})
* Send email via the SendGrid v3 Web API with [Email::SendGrid::V3]({{< mcpan "Email::SendGrid::V3" >}})
* [Git::Annex]({{< mcpan "Git::Annex" >}}) is a Perl interface for git-annex repositories
* [Gtk3::WebKit2]({{< mcpan "Gtk3::WebKit2" >}}) provides WebKit2 bindings for Perl
* [Neo4j::Bolt]({{< mcpan "Neo4j::Bolt" >}}) can communicate with a Neo4j server agent using Bolt protocol
* Control Windows Notepad++ app with code using [Win32::Mechanize::NotepadPlusPlus]({{< mcpan "Win32::Mechanize::NotepadPlusPlus" >}})
* [OPCUA::Open62541]({{< mcpan "OPCUA::Open62541" >}}) is a wrapper for the open62541 [OPC UA library](https://en.wikipedia.org/wiki/OPC_Unified_Architecture)
* Query Rundeck's REST API with [RundeckAPI]({{< mcpan "RundeckAPI" >}})
* [Weather::MOSMIX]({{< mcpan "Weather::MOSMIX" >}}) downloads and parses the German weather service's forecast data


Config & Devops
---------------
* [Mojo::File::Share]({{< mcpan "Mojo::File::Share" >}}) aims to provide better local share directory support with Mojo::File
* [Net::DNS::DomainController::Discovery]({{< mcpan "Net::DNS::DomainController::Discovery" >}}) can discover Microsoft Active Directory domain controllers via DNS
* [Pb]({{< mcpan "Pb" >}}) is a workflow system made from Perl and bash


Data
----
* [Jasonify]({{< mcpan "Jasonify" >}}) is Just Another Serialized Object Notation library
* Create PDFs with [Mxpress::PDF]({{< mcpan "Mxpress::PDF" >}})


Development & Version Control
-----------------------------
* Set default PerlIO layers with [open::layers]({{< mcpan "open::layers" >}}), an alternative to the open pragma
* [Git::Repository::Plugin::Diff]({{< mcpan "Git::Repository::Plugin::Diff" >}}) adds a diff method to Git::Repository
* [LooksLike]({{< mcpan "LooksLike" >}}) provides more precise alternatives to looks_like_number
* Have a role fire a callback when its applied via [Role::Hooks]({{< mcpan "Role::Hooks" >}})
* [Test::Arrow]({{< mcpan "Test::Arrow" >}}) is an Object-Oriented testing library with a fun syntax
* Mock method behavior with queued subs using [Test::Ratchet]({{< mcpan "Test::Ratchet" >}})
* [Timer::Milestones]({{< mcpan "Timer::Milestones" >}}) is an easy-to-use code timing module
* Track changes to scalars (in color!) with [Var::Mystic]({{< mcpan "Var::Mystic" >}})
* [XS::Manifesto]({{< mcpan "XS::Manifesto" >}}) describes an approach for creating shared XS code
* [Zydeco]({{< mcpan "Zydeco" >}}) is a new OO framework


Science & Mathematics
---------------------
* Get Raycast field-of-view and related routines using [Game::RaycastFOV]({{< mcpan "Game::RaycastFOV" >}})
* [Math::Spiral]({{< mcpan "Math::Spiral" >}}) returns an endless stream of X, Y offset coordinates which represent a spiral shape
* Add numbers with fewer numerical errors using [Math::Summation]({{< mcpan "Math::Summation" >}})


Web
---
* Manage an ecosystem of Plack organisms under Kelp with [Kelp::Module::Symbiosis]({{< mcpan "Kelp::Module::Symbiosis" >}})
* [Plack::Middleware::HealthCheck]({{< mcpan "Plack::Middleware::HealthCheck" >}}) adds a health check endpoint for your Plack app
* Control an embedded WebKit2 engine with [WWW::WebKit2]({{< mcpan "WWW::WebKit2" >}})


