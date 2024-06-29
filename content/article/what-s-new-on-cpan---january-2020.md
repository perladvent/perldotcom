{
   "tags" : ["prometheus", "abuse-ipdb", "mailgun", "toml", "fidonet", "libshout", "systemd", "mojolicious"],
   "categories" : "cpan",
   "authors" : [
      "david-farrell"
   ],
   "description" : "A curated look at January's new CPAN uploads",
   "title" : "What's new on CPAN - January 2020",
   "date" : "2020-02-10T01:28:47",
   "thumbnail" : "/images/213/thumb_AF57B300-5234-11E5-B481-F86745487EAA.png",
   "image" : "/images/213/AF57B300-5234-11E5-B481-F86745487EAA.png",
   "draft": false
}


Welcome to "What's new on CPAN", a curated look at last month's new CPAN uploads for your reading and programming pleasure. Enjoy!

APIs & Apps
-----------
* [App::geoip]({{< mcpan "App::geoip" >}}) show geological data based on hostname or IP addresses
* [App::url]({{< mcpan "App::url" >}}) format a URL according to a sprintf-like template
* Push metrics to prometheus exporter with [Net::Prometheus::Pushgateway]({{< mcpan "Net::Prometheus::Pushgateway" >}})
* [Shout]({{< mcpan "Shout" >}}) is a thin wrapper around libshout, the live streaming library
* Report bad actors to AbuseDB via their v2 API: [WebService::AbuseIPDB]({{< mcpan "WebService::AbuseIPDB" >}})
* [WebService::Mailgun]({{< mcpan "WebService::Mailgun" >}}) is an API client for Mailgun


Config & Devops
---------------
* Clear the terminal using [Term::Clear]({{< mcpan "Term::Clear" >}})


Data
----
* Return an endless stream of distinct RGB colors with [Chart::Colors]({{< mcpan "Chart::Colors" >}})
* [File::BackupCopy]({{< mcpan "File::BackupCopy" >}}) makes backing up files easier
* Calculate the mean and variance of a set (Welford's algorithm) using [Math::StdDev]({{< mcpan "Math::StdDev" >}})
* [TOML::Tiny]({{< mcpan "TOML::Tiny" >}}) is a minimal, pure perl TOML parser and serializer


Development & Version Control
-----------------------------
* Express yourself through moo with [MooX::Pression]({{< mcpan "MooX::Pression" >}})
* [Object::Adhoc]({{< mcpan "Object::Adhoc" >}}) can mint objects without the hassle of defining a class first
* [Sub::HandlesVia]({{< mcpan "Sub::HandlesVia" >}}) provies another way to define `handles_via` in Moo/Moose/Mouse


Web
---
* Detect User-Agents using [Duadua]({{< mcpan "Duadua" >}})
* [FTN::Crypt]({{< mcpan "FTN::Crypt" >}}) can encrypt/decrypt Fido Technology Nets netmail
* [Mojolicious::Plugin::Systemd]({{< mcpan "Mojolicious::Plugin::Systemd" >}}) lets you configure your mojo app with systemd
* The Mozilla Public Suffix List: [Net::PublicSuffixList]({{< mcpan "Net::PublicSuffixList" >}})

