{
   "categories" : "cpan",
   "thumbnail" : "/images/what-s-new-on-cpan---june-2018/thumb_Perl_Onion_usax300.png",
   "title" : "What's new on CPAN - June 2018",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "amex",
      "microsoft",
      "elasticsearch",
      "devel-callparser",
      "opengl",
      "gameboy",
      "mattermost",
      "tl-1",
      "aws",
      "rpi",
      "sendgrid",
      "ynab"
   ],
   "image" : "/images/what-s-new-on-cpan---june-2018/Perl_Onion_usax300.png",
   "date" : "2018-07-04T10:00:00",
   "description" : "A curated look at June's new CPAN uploads",
   "draft" : false
}


It's the Fourth of July holiday here in the US, so this month's cover image has been given a USA-style makeover. Below you'll find my curated list of June's new CPAN uploads for your reading and programming pleasure. Enjoy!

### APIs & Apps
* Grep Microsoft Office documents with [App::Greple::msdoc]({{<mcpan "App::Greple::msdoc" >}})
* [App::JC::Client]({{<mcpan "App::JC::Client" >}}) is a small command line client for JIRA
* [App::ReportPrereqs]({{<mcpan "App::ReportPrereqs" >}}) prints a nicely formatted report on distribution / project dependencies using the cpanfile
* [AWS::XRay]({{<mcpan "AWS::XRay" >}}) provides an interface to the request tracing service
* [Email::SendGrid::V3]({{<mcpan "Email::SendGrid::V3" >}}) is a class for emailing via the SendGrid v3 Web API
* A base class for Mattermost bots: [Net::Mattermost::Bot]({{<mcpan "Net::Mattermost::Bot" >}})
* Access OpenGL prototyping tools using [OpenGL::Sandbox]({{<mcpan "OpenGL::Sandbox" >}})
* Use the You Need A Budget API with [WWW::YNAB]({{<mcpan "WWW::YNAB" >}})


### Config & Devops
* Extract the version of Perl a module declares with [Module::Extract::DeclaredVersion]({{<mcpan "Module::Extract::DeclaredVersion" >}})
* Get module permissions from MetaCPAN API using [PAUSE::Permissions::MetaCPAN]({{<mcpan "PAUSE::Permissions::MetaCPAN" >}})


### Data
* [Elasticsearch::Model]({{<mcpan "Elasticsearch::Model" >}}) is a replacement for ElasticSearchX::Model that works with Elasticsearch v6+
* [Finance::AMEX::Transaction]({{<mcpan "Finance::AMEX::Transaction" >}}) parses AMEX transaction files: EPRAW, EPPRC, EPTRN, CBNOT, GRRCN


### Development & Version Control
* Devel::CallParser has been patched to fix RT#110623 as an alt distribution: [Alt::Devel::CallParser::ButWorking]({{<mcpan "Alt::Devel::CallParser::ButWorking" >}})
* [Class::XSConstructor]({{<mcpan "Class::XSConstructor" >}}) is a wow-fast (but limited) constructor in XS, See also [MooX::XSConstructor]({{<mcpan "MooX::XSConstructor" >}})
* Embed Tiny C code in your Perl program using [FFI::TinyCC::Inline]({{<mcpan "FFI::TinyCC::Inline" >}})
* [Perl::Critic::TooMuchCode]({{<mcpan "Perl::Critic::TooMuchCode" >}}) provides critic policies for unused imports, constants and other detritus


### Hardware
* Wow, get a Perl interface to the Gameboy Advance with [Device::GBA]({{<mcpan "Device::GBA" >}})
* Manage and monitor the Synaccess NP-05B networked power strip with [Device::Power::Synaccess::NP05B]({{<mcpan "Device::Power::Synaccess::NP05B" >}}). See also [App::np05bctl]({{<mcpan "App::np05bctl" >}})
* Control a FeelTech FY32xx signal generator using [Electronics::SigGen::FY3200]({{<mcpan "Electronics::SigGen::FY3200" >}})
* [Net::TL1UDP]({{<mcpan "Net::TL1UDP" >}}) provides a Transaction Language 1 (TL-1) UDP interface
* [RPi::GPIOExpander::MCP23017]({{<mcpan "RPi::GPIOExpander::MCP23017" >}}) interface with the MCP23017 GPIO Expander Integrated Circuit over I2C


### Web
* [Dancer2::Plugin::Showterm]({{<mcpan "Dancer2::Plugin::Showterm" >}}) is a Dancer2 port of [showterm](http://showterm.io/)
* [MojoX::ConfigAppStart]({{<mcpan "MojoX::ConfigAppStart" >}}) can start Mojo apps using Config::App

